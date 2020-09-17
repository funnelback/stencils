package com.funnelback.stencils.hook.tabs

import com.funnelback.publicui.search.model.collection.FacetedNavigationConfig
import com.funnelback.publicui.search.model.transaction.facet.FacetDisplayType
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.search.model.transaction.SearchQuestion.SearchQuestionType
import com.funnelback.stencils.hook.support.HookLifecycle
import groovy.util.logging.Log4j2

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
 * <p>When the Facets Stencils is used, this hook populates the custom map
 * with the name of the currently selected tab</p>
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

    /** Name of the facet containing the tabs */
    static final String TABS_FACET_NAME = "Tabs"

    /** Key where the selected tab will be stored in the customData map */
    static final String SELECTED_TAB = "stencilsTabsSelectedTab"

    /** Key storing the default tab to select */
    static final String DEFAULT_SELECTED_TAB_KEY = "stencils.tabs.default"

    /**
     * Pre-select a tab by default
     *
     * @param transaction
     */
    @Override
    void preProcess(SearchTransaction transaction) {
        // Only apply to the main search
        if (SearchQuestionType.SEARCH == transaction.question.questionType) {
            def defaultTab = transaction.question.getCurrentProfileConfig().get(DEFAULT_SELECTED_TAB_KEY)

            if (defaultTab) {
                // A tab need to be selected by default. Locate the tab configuration
                // So that we can find out which URL parameter is needed to select it
                Collection collectionConfig = transaction.question.collection as Collection
                FacetedNavigationConfig fnConfig = collectionConfig.getProfiles().get(transaction.question.getCurrentProfile()).getFacetedNavConfConfig()
                if (fnConfig) {
                    fnConfig.getFacetDefinitions()
                            // Find tab facet
                            .findAll {facet -> facet.name == TABS_FACET_NAME }
                            // Intersect the set of the facet URL parameters names, with the set of the current URL parameter names.
                            // The intersection should be empty if none of the facet URL parameter is present
                            .findAll { facet -> transaction.question.getInputParameters().keySet().intersect(facet.allQueryStringParamNames).empty }
                            // Access the categories defining the facet (i.e. each tab)
                            .collect { facet -> facet.getCategoryDefinitions() }
                            .flatten()
                             // Find the category definition for the tab we're attempting to select
                            .findAll { category -> category.data == defaultTab }
                            // Inject the appropriate URL parameter from the category definition to pre-select the category
                            .each { category -> transaction.question.getInputParameters().put(category.getQueryStringParamName(), category.getData()) }
                }
            }
        }
    }

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
            && (SearchQuestionType.SEARCH == questionType || SearchQuestionType.EXTRA_SEARCH == questionType)) {

            // Force Gscope facets to appear if configure
            def gscopeTabs = transaction.question.getCurrentProfileConfig().get(GSCOPE_KEY)
            if (gscopeTabs) {
                gscopeTabs
                    .split(GSCOPE_VALUE_SEPARATOR)
                    .collect { it.trim() }
                    .each { gscope ->
                        if (transaction.response.resultPacket.GScopeCounts[gscope] == null) {
                            // Set count to zero
                            transaction.response.resultPacket.GScopeCounts[gscope] = 0
                        }
                    }
            }

            // Force Metadata facets to appear if configured
            transaction.question.getCurrentProfileConfig().getRawKeys()
                .findAll { it.startsWith(METADATA_KEY_PREFIX) }
                .findResults { key ->
                    def metadata = key.substring(METADATA_KEY_PREFIX.length(), key.lastIndexOf(METADATA_KEY_SEPARATOR))
                    def value = transaction.question.getCurrentProfileConfig().get(key)

                    if (value != null && "" != value.trim()) {
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
     * Copy the "selected" status from the main search into the extra search
     *
     * @param transaction
     */
    @Override
    void postProcess(SearchTransaction transaction) {
        // Find out if a tab was actually selected, and inject it to the data model
        transaction.response.facets
            .find {facet -> facet.getGuessedDisplayType() == FacetDisplayType.TAB }
            .getAllValues()
            .find {category -> category.selected }
            .with {category -> transaction.response.customData.put(SELECTED_TAB, category.getLabel()) }
    }

}
