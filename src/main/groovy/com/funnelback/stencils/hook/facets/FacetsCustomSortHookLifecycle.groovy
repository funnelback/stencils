package com.funnelback.stencils.hook.facets

import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.hook.support.HookLifecycle
import groovy.util.logging.Log4j2

/**
 * <p>Hook functions to sort Facets in a custom order defined in configuration</p>
 *
 * <p>Each sort value needs to be defined in its own key:</p>
 *
 * <ul>
 *  <li>stencils.faceted_navigation.custom_sort.FacetName.1=Value1</li>
 *  <li>stencils.faceted_navigation.custom_sort.FacetName.2=Value2</li>
 * </ul>
 *
 * <p>Sort keys are not converted to numbers so that non-numeric sort keys can be used
 * (e.g. <code>FacetName.thefirst</code>, <code>FacetName.thesecond</code>. As a result the sort is
 * respecting the natural order of the keys (e.g. <code>Facet.100</code> would be sorted before
 * <code>Facet.11</code>)
 */
@Log4j2
class FacetsCustomSortHookLifecycle implements HookLifecycle {

    /** Prefix for keys holding the custom sort order */
    static final String CUSTOM_SORT_PREFIX = "stencils.faceted_navigation.custom_sort"

    @Override
    void postProcess(SearchTransaction transaction) {
        // Only apply to the main search
        if (SearchQuestion.SearchQuestionType.SEARCH == transaction.question.questionType) {
            transaction?.response?.getFacets().each { facet ->
                // Find our custom sort order from configuration for particular facet

                def sortArray = transaction.question.getCurrentProfileConfig().getRawKeys()
                        .stream()
                        .findAll() { key -> key.startsWith("${CUSTOM_SORT_PREFIX}.${facet.name}.") }
                        .sort()
                        .collect() { key -> transaction.question.getCurrentProfileConfig().get(key) }

                // If there's a custom sort, sort the values accordingly
                if (sortArray) {
                    facet.getAllValues().sort() { a, b ->
                        return sortArray.indexOf(a.label) <=> sortArray.indexOf(b.label)
                    }
                }
            }
        }
    }
}
