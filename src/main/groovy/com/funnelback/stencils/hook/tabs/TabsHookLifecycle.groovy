package com.funnelback.stencils.hook.tabs

import groovy.util.logging.Log4j2

import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.search.model.transaction.SearchQuestion.SearchQuestionType
import com.funnelback.stencils.hook.support.HookLifecycle

/**
 * <p>Hook functions for the Tabs stencil.</p>
 * 
 * <p>Will force Gscope and Metadata based facet to appear
 * even if they have no value, as configured in the collection
 * config</p>
 * 
 * <p>It works by injecting counts of "0" in the result packet (gscope
 * or RMC counts)</p>
 * 
 * @author nguillaumin@funnelback.com
 *
 */
@Log4j2
class TabsHookLifecycle implements HookLifecycle {
    
    /** Key holding the Gscope numbers */
    static final String GSCOPE_KEY = "stencils.tabs.full_facet.gscope"
    
    /** Separator for the Gscope numbers */
    static final String GSCOPE_VALUE_SEPARATOR = ","

    /** Key holding the Metadata names */    
    static final String METADATA_KEY_PREFIX = "stencils.tabs.full_facet.metadata."
    
    /** Separator for metadata keys */
    static final String METADATA_KEY_SEPARATOR = "."
    
    @Override
    public void postDatafetch(SearchTransaction transaction) {
        def questionType = transaction.question.questionType
        
        // Only run on main search and extra searches
        if (SearchQuestionType.SEARCH.equals(questionType)
            || SearchQuestionType.EXTRA_SEARCH.equals(questionType)) {
            
            // Force Gscope facets to appear if configured
            if (transaction.question.collection.configuration.hasValue(GSCOPE_KEY)) {
                transaction.question.collection.configuration.value(GSCOPE_KEY)
                    .split(GSCOPE_VALUE_SEPARATOR)
                    .collect { it.toInteger() }
                    .each { gscope ->
                        if (transaction.response.resultPacket.GScopeCounts[gscope] == null) {
                            // Set count to zero
                            transaction.response.resultPacket.GScopeCounts[gscope] = 0
                        }
                    }
            }
            
            // Force Metadata facets to appear if configured
            transaction.question.collection.configuration.valueKeys()
                .findAll { it.startsWith(METADATA_KEY_PREFIX) }
                .findResults { key ->
                    def metadata = key.substring(METADATA_KEY_PREFIX.length(), key.lastIndexOf(METADATA_KEY_SEPARATOR))
                    def value = transaction.question.collection.configuration.value(key)
                    
                    if (value != null && !"".equals(value.trim())) {
                        "${metadata}:${value}"
                    }
                }
                .each { rmcItem ->
                    // rmcItem is in the form "metadata:value" (e.g. "author:shakespeare")
                    if (transaction.response.resultPacket.rmcs[rmcItem] == null) {
                        transaction.response.resultPacket.rmcs[rmcItem] = 0
                    }
                }
        }
    }
}