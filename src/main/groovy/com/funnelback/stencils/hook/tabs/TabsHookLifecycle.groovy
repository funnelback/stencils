package com.funnelback.stencils.hook.tabs

import com.funnelback.publicui.search.model.transaction.Facet
import com.funnelback.publicui.utils.QueryStringUtils
import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.stencils.hook.facets.FacetsHookLifecycle
import com.funnelback.stencils.hook.facets.StencilCategoryValue
import com.funnelback.stencils.util.DatamodelUtils
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
 * <p>When the Facets Stencils is used, this hook also injects
 * a fake "All" value for the Tabs</p>
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

    /** Key holding the label for the "All" tab */
    static final String ALL_TAB_LABEL_KEY = "stencils.tabs.all.label"

    /** Default label to use for the "All" tab */
    static final String ALL_TAB_DEFAULT_LABEL = "All"

    /** Name of the facet containing the tabs */
    static final String TABS_FACET_NAME = "Tabs"

    /**
     * Force empty GScope / RMC to appear
     *
     * @param transaction
     */
    @Override
    void postDatafetch(SearchTransaction transaction) {
        def questionType = transaction.question.questionType
        
        // Only run on main search and extra searches
        if (transaction?.response?.resultPacket
            && (SearchQuestionType.SEARCH.equals(questionType)
            || SearchQuestionType.EXTRA_SEARCH.equals(questionType))    ) {
            
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

    /**
     * Inject a fake "All" value in the Stencils tab facet
     *
     * @param transaction
     */
    @Override
    void postProcess(SearchTransaction transaction) {
        if (transaction?.response?.customData[FacetsHookLifecycle.STENCILS_FACETS]) {
            transaction?.response?.customData[FacetsHookLifecycle.STENCILS_FACETS]
                    .find() { facet -> facet.name == TABS_FACET_NAME }
                    .each() { tabFacet ->
                // The "All" value is selected when no other tabs are selected
                def selected = !transaction.question.selectedFacets.contains(TABS_FACET_NAME)

                // Build a fake "All" facet value
                def allValue = new StencilCategoryValue(new Facet.CategoryValue(
                        "all",
                        transaction.question.collection.configuration.value(ALL_TAB_LABEL_KEY, ALL_TAB_DEFAULT_LABEL),
                        // Set the count to the total number of results, since the All value should match all documents
                        transaction?.response?.resultPacket?.resultsSummary?.totalMatching ?: 0,
                        "unused=unused",
                        "unused",
                        selected))

                // Selecting and unselecting the all value mean the same thing: show all results
                // So set both the select + unselect URL to a URL that doesn't contain any Tab facet constraint
                def qs = DatamodelUtils.getQueryStringMapCopy(transaction.response.customData[StencilHooks.QUERY_STRING_MAP_KEY])
                qs = DatamodelUtils.filterQueryStringParameters(qs, { key, value -> !key.startsWith("f.${TABS_FACET_NAME}|") })

                allValue.selectUrl = QueryStringUtils.toString(qs, true)
                allValue.unselectUrl = allValue.selectUrl

                tabFacet.values << allValue
            }
        }
    }
}
