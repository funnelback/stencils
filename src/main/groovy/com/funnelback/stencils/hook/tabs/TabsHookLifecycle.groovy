package com.funnelback.stencils.hook.tabs

import com.funnelback.publicui.search.model.transaction.Facet
import com.funnelback.publicui.search.model.transaction.facet.FacetDisplayType
import com.funnelback.publicui.utils.QueryStringUtils
import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.stencils.hook.facets.FacetsHookLifecycle
import com.funnelback.stencils.hook.facets.StencilCategoryValue
import com.funnelback.stencils.hook.facets.StencilFacet
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
 * a fake "All" value for the Tabs, copies the "selected" status of
 * the tab from the main search into the FACETED_NAVIGATION extra search,
 * updates the selectUrl of the tabs to ensure all facet constraints are reset,
 * and populates the custom map with the name of the currently selected tab</p>
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

    /** Key where the selected tab will be stored in the customData map */
    static final String SELECTED_TAB = "stencilsTabsSelectedTab"

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
                    .collect { it.trim() }
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
     * <ul>
     *  <li>Fix the Tab selectUrl to reset any facet constraints</li>
     *  <li>Inject a fake "All" value in the Stencils tab facet</li>
     *  <li>Copy the "selected" status from the main search into the extra search</li>
     * </ul>
     *
     * <p>The first is is needed so that constraints specific to a tab (e.g. "Course type = On Campus") is not preserved
     * when switching to another tab (e.g. "People") as it is likely to return zero results</p>
     *
     * <p>The second is convenient so that the "All" tab is just present as a regular tab, without
     * having to assign any gscope or metadata to it</p>
     *
     * <p>For details about the third, see {@link #copySelectedStatusToExtraSearchFacet()}</p>
     *
     * @param transaction
     */
    @Override
    void postProcess(SearchTransaction transaction) {
        if (transaction.question.hasProperty("customData")
            && transaction?.response?.customData[FacetsHookLifecycle.STENCILS_FACETS]) {
            transaction?.response?.customData[FacetsHookLifecycle.STENCILS_FACETS]
                    .find() { facet -> facet.name == TABS_FACET_NAME }
                    .each() { tabFacet ->

                // Inject dummy "All" value
                // We need to do it first so that any facet constraints in its URLs
                // will be reset by the next section
                tabFacet.values << getAllValue(transaction)

                // For all values of the extra search, update the select URL
                // to make sure all facets constraints are reset when switching tabs
                tabFacet.values.each() { value ->
                    def qs = QueryStringUtils.toMap(value.selectUrl)
                    // Remove any facet parameter (f.<something>), except the one
                    // for the current tab
                    qs = DatamodelUtils.filterQueryStringParameters(qs, {k, v ->
                        !k.startsWith("f.") || k == value.queryStringParamName
                    })
                    value.selectUrl = QueryStringUtils.toString(qs, true)
                }

                copySelectedStatusToExtraSearchFacet(tabFacet, transaction)
            }
        }

        // All tab is selected by default
        transaction.response.customData[SELECTED_TAB] = transaction.question.collection.configuration.value(ALL_TAB_LABEL_KEY, ALL_TAB_DEFAULT_LABEL)

        // Find out if a tab was actually selected, and inject it to the data model
        if (transaction?.response?.customData[FacetsHookLifecycle.STENCILS_FACETS_SELECTED_VALUES]) {
            transaction.response.customData[FacetsHookLifecycle.STENCILS_FACETS_SELECTED_VALUES]
                .find() { selectedValue -> selectedValue.facetName == TABS_FACET_NAME}
                .each() { selectedTabValue ->
                    // This may run multiple times in theory, but in practice there's only
                    // one tab selected at all times
                    transaction.response.customData[SELECTED_TAB] = selectedTabValue.value

                    // Remove the selected tab from the general selected facet list, so that
                    // it will not show in the "Refined by: ..." section
                    transaction.response.customData[FacetsHookLifecycle.STENCILS_FACETS_SELECTED_VALUES].remove(selectedTabValue)
                }
        } else if (transaction.question.hasProperty("funnelbackVersion")
                && (transaction.question.funnelbackVersion.major > 15
                || (transaction.question.funnelbackVersion.major == 15 && transaction.question.funnelbackVersion.minor >= 12))
                && transaction?.response?.facets) {

            // v15.12 has enhanced facets that supports Tabs directly, so we can
            // get the selected one from the data model

            // ...then locate the first Tab style facet and pick the first
            // selected value as the current tab
            transaction.response.facets
                    .find() { facet -> facet.guessedDisplayType == FacetDisplayType.TAB }
                    .collect() { facet -> facet.allValues }
                    .flatten()
                    .find() { value -> value.selected }
                    .each() { value ->
                transaction.response.customData[SELECTED_TAB] = value.label
            }
        }
    }

    /**
     * Get a dummy "all" value for the tabs facet, showing all documents
     *
     * @param transaction SearchTransaction needed to build the "all" value
     * @return Dummy "all" StencilCategoryValue
     */
    StencilCategoryValue getAllValue(SearchTransaction transaction) {
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
        def qs = DatamodelUtils.getQueryStringMapCopy(transaction.question.customData[StencilHooks.QUERY_STRING_MAP_KEY])
        qs = DatamodelUtils.filterQueryStringParameters(qs, { key, value -> !key.startsWith("f.${TABS_FACET_NAME}|") })
        // Remove unwanted parameters
        FacetsHookLifecycle.PARAMETERS_TO_REMOVE.each() { parameter -> qs.remove(parameter) }

        allValue.selectUrl = QueryStringUtils.toString(qs, true)
        allValue.unselectUrl = allValue.selectUrl

        return allValue
    }

    /**
     * <p>Copy the "selected" status of a tab from the main search to the FACETED_NAVIGATION extra search</p>
     *
     * <p>This is needed as the extra search runs without any constraints (to get full counts), so no tab will
     * be marked "selected", but we want to know their "selected" status so that we can display them differently
     * in the front-end.</p>
     *
     * <p>To do so find the tabs facet in the main search, and for every value that's selected, also select it
     * in the extra search</p>
     *
     * @param facet Facet from the main search to get selected values from
     * @param transaction Transaction containing the extra search to copy selected status on
     */
    void copySelectedStatusToExtraSearchFacet(StencilFacet facet, SearchTransaction transaction) {
        def fnExtraSearch = transaction?.extraSearches[SearchTransaction.ExtraSearches.FACETED_NAVIGATION.toString()]
        if (fnExtraSearch) {
            def extraSearchFacets = fnExtraSearch?.response?.customData[FacetsHookLifecycle.STENCILS_FACETS]
            if (extraSearchFacets) {

                // We have our Stencils facets from the extra search. Locate the facet that has the same
                // name as the one we want to update
                extraSearchFacets.find() { extraFacet -> extraFacet.name == facet.name }
                .each() { extraFacet ->

                    // For all values of the main search facets, locate the corresponding
                    // value from the extra search, and copy the "selected" status
                    facet.values.each() { value ->
                        extraFacet.values.find() { extraValue -> extraValue.queryStringParam == value.queryStringParam}
                        .each() { extraValue ->
                            extraValue.selected = value.selected
                        }
                    }
                }
            }
        }
    }
}
