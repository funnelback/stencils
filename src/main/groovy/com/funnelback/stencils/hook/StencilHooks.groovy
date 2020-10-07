package com.funnelback.stencils.hook

import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.stencils.hook.core.ContextualNavigationHookLifecycle
import com.funnelback.stencils.hook.core.CoreHookLifecycle
import com.funnelback.stencils.hook.core.PagingHookLifecycle
import com.funnelback.stencils.hook.facets.FacetRenameHookLifecycle
import com.funnelback.stencils.hook.facets.FacetsCustomSortHookLifecycle

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
import com.funnelback.stencils.hook.extrasearch.ExtraSearchHookLifecycle

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
        new TabsHookLifecycle(),
        // FacetsCustomSort needs to run after Tabs, as Tabs injects an "All" value in the facets,
        // which are then sorted
        new FacetsCustomSortHookLifecycle(),
        new FacetRenameHookLifecycle(),
        new NoResultsHookLifecycle(),
        new PeopleHookLifecycle(),
        new FacebookHookLifecycle(),
        new ExtraSearchHookLifecycle()
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
 
