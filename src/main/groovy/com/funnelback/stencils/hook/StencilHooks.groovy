package com.funnelback.stencils.hook

import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.stencils.hook.core.ContextualNavigationHookLifecycle
import com.funnelback.stencils.hook.core.CoreHookLifecycle
import com.funnelback.stencils.hook.core.PagingHookLifecycle
import com.funnelback.stencils.hook.facets.FacetRenameHookLifecycle
import com.funnelback.stencils.hook.facets.FacetsCustomSortHookLifecycle
import com.funnelback.stencils.hook.facets.FacetsHookLifecycle
import org.codehaus.groovy.reflection.ReflectionUtils
import org.springframework.web.context.request.RequestContextHolder

import com.funnelback.common.config.Files
import com.funnelback.publicui.search.model.collection.Collection.Hook
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.hook.facebook.FacebookHookLifecycle
import com.funnelback.stencils.hook.noresults.NoResultsHookLifecycle
import com.funnelback.stencils.hook.people.PeopleHookLifecycle
import com.funnelback.stencils.hook.support.HookLifecycle
import com.funnelback.stencils.hook.tabs.TabsHookLifecycle

import groovy.util.logging.Log4j2

/**
 * <p>Entry point for Stencil hooks.</p>
 * 
 * <p>To be called by individual hook scripts inside
 * collections with <code>new StencilHooks().apply(transaction, hook)</code>
 * 
 * @author nguillaumin@funnelback.com
 *
 */
@Log4j2
class StencilHooks {
    
    /** Name of the <code>collection.cfg</code> setting containing the list of stencils to enable */
    public static final String STENCILS_KEY = "stencils"

    /** Name of the key in the <code>customData</code> hash that will hold custom FreeMarker methods */
    public static final String STENCILS_FREEMARKER_METHODS = "stencilsMethods"
    
    /**
     * Key to use to store the query string parameter map
     * inside the response customData.
     */
    public static final String QUERY_STRING_MAP_KEY = "queryStringMap"
    
    /** List of all the stencil hooks to run */
    private static final List<HookLifecycle> HOOKS = [
        new CoreHookLifecycle(),
        new PagingHookLifecycle(),
        new ContextualNavigationHookLifecycle(),
        new FacetsHookLifecycle(),
        new TabsHookLifecycle(),
        // FacetsCustomSort needs to run after Tabs, as Tabs injects an "All" value in the facets,
        // which are then sorted
        new FacetsCustomSortHookLifecycle(),
        new FacetRenameHookLifecycle(),
        new NoResultsHookLifecycle(),
        new PeopleHookLifecycle(),
        new FacebookHookLifecycle()
    ]
    
    /**
     * Apply the hook to a search transaction, passing an
     * explicit hook to run on
     * @param transaction Search transaction to apply the hook to
     * @param currentHook Name of the hook to apply. May be null, in which case
     * it will attempt to automatically detect the current hook
     */
    void apply(SearchTransaction transaction, Hook currentHook) {        
        if (transaction == null) {
            throw new IllegalArgumentException("transaction must not be null")
        }
        if (currentHook == null) {
            currentHook = StencilHooks.detectHook();
        }
        
        injectQueryStringMap(transaction)
        setupCustomData(transaction)
        
        HOOKS.each { hook ->
            log.trace("Attempting to run {} on hook {}", currentHook, hook.class.name)
            
            // Dynamically invoke the method name
            // for this hook
            def methodName = hookMethodForHook(currentHook)
            if (hook.metaClass.respondsTo(hook, methodName, SearchTransaction.class)) {
                hook."${methodName}"(transaction)
            } else {
                throw new IllegalStateException("No ${methodName}(${SearchTransaction.class.name}) method defined on ${hook.class}")
            }            
        }
    }
    
    /**
     * Converts a hook name (e.g. <code>pre_process</code>)
     * into the name of the method to call (e.g.
     * <code>preProcess</code>)
     * 
     * @param hook Hook name
     * @return Method to call
     */
    static String hookMethodForHook(Hook hook) {
        def parts = []
        
        if (hook == null) {
            throw new IllegalArgumentException("Hook script must not be null")
        }
        
        hook.name().split("_").eachWithIndex { part, i ->
            if (i == 0) {
                parts << part
            } else {
                parts << part.substring(0, 1).capitalize() + part.substring(1)
            }
        }
        
        parts.join("")
    }

    /**
     * Attempts to detect the current Modern UI hook we're
     * running on by looking at the calling class    
     * @return Current Hook
     * @throws IllegalStateException if it's unable to detect the hook
     */
    static Hook detectHook() throws IllegalStateException {
        try {
            // "2" to get the grand-parent of the current method call
            // 1 = .apply(transaction)
            // 2 = calling hook script
            def callingClassName = ReflectionUtils.getCallingClass(2)?.name

            if (callingClassName != null
                && callingClassName.startsWith(Files.HOOK_PREFIX)) {
                return Hook.valueOf(callingClassName.substring(Files.HOOK_PREFIX.length()))
            }
        } catch (Exception e) {
        }
        
        throw new IllegalStateException("Could not detect the current hook name. Try passing it explicitly, e.g.: apply(transaction, Hook.pre_process)")
    }
    
    /**
     * <p>Attempt to inject the current query string as a Map, to cater
     * for versions &lt; 15.10 where it wasn't in the data model</p>
     * 
     * <p>The map is taken from the current request parameters. The current request
     * is provided by Spring and is thread bound, so it's not available for extra
     * searches which run in a different thread.</p>
     *
     * <p>Extra searches are always cloned from the main search so they will inherit
     * the map, however that requires this code to run in pre_process before the
     * extra searches are setup. Collections wanting to use it need to call the Stencils
     * hook in the pre_process hook.</p>
     * 
     * <p>The map will be put inside <code>question.customData['queryStringMap']</code></p>
     * 
     * @param transaction Transaction to inject the query string into
     */
    static void injectQueryStringMap(SearchTransaction transaction) {
        try {
            if (SearchQuestion.SearchQuestionType.EXTRA_SEARCH.equals(transaction.question.questionType)) {
                // Exit if we're running on an extra search. Extra searches are always cloned
                // from the main question, so we don't need to inject the query string map again
                return
            }

            if (!transaction.question.hasProperty("customData")) {
                // No customData field in the question. This is either
                // < 15.8
                // 15.8 before patch 15.8.0.17
                // 15.10 before patch 15.10.0.7
                log.warn("This version of Funnelback doesn't have a customData field on the SearchQuestion. "
                        + "The query string map will not be available resulting in some hooks not working properly. "
                        + "Make sure you use 15.8 or 15.10 with the latest patches, or 15.12+")
                return
            }

            if (transaction.question.customData[QUERY_STRING_MAP_KEY]) {
                // Query string map already has been injected, exit
                return
            }

            if (transaction.question.hasProperty("queryStringMapCopy")) {
                // 15.10 already has the query string map in the question. Copy it as-is
                transaction.question.customData[QUERY_STRING_MAP_KEY] = transaction.question.queryStringMapCopy
            } else {
                // 15.8 didn't have the query string map, so build it ourselves
                // Make it immutable as the version in the data model should not
                // be modified. There's a utility method in DatamodelUtils to make
                // a copy of it
                def params = Collections.unmodifiableMap(
                        RequestContextHolder.getRequestAttributes().getRequest()
                                .getParameterMap()
                        // Convert the String array into a List for convenience
                                .collectEntries { entry -> [entry.key, Arrays.asList(entry.value)] })

                transaction.question.customData[QUERY_STRING_MAP_KEY] = params
            }
        } catch (Exception e) {
            // Not much we can do unfortunately
            log.warn("Unable to extract query string parameter map from current request", e)
        }
    }

    /**
     * Pre-configure the response customData map that will be used by
     * the various hooks
     *
     * @param transaction Transaction to pre-configure the response for
     */
    static void setupCustomData(SearchTransaction transaction) {
        if (transaction?.response?.customData != null) {
            // Create an empty map to store custom FreeMarker methods
            if (!transaction.response.customData[STENCILS_FREEMARKER_METHODS]) {
                transaction.response.customData[STENCILS_FREEMARKER_METHODS] = [:]
            }
        }
    }
    
}
 
