package com.funnelback.stencils.hook.facets

import com.funnelback.publicui.search.model.transaction.Facet
import com.funnelback.publicui.search.model.transaction.Facet.Category
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.utils.QueryStringUtils
import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.stencils.hook.support.HookLifecycle
import com.funnelback.stencils.util.ConfigUtils
import com.funnelback.stencils.util.DatamodelUtils
import groovy.util.logging.Log4j2

/**
 * <p>Hook functions for the Facets stencil</p>
 *
 * <p>These build a new, simpler data model for faceted navigation
 * where all the category values have been flattened, and they all contain
 * URLs to select / unselect the facet or value to avoid having to compute it in
 * FreeMarker</p>
 *
 * <p>They also provide a list of currently selected values, useful to build
 * a breadcrumb</p>
 *
 * @author nguillaumin@funnelback.com
 */
@Log4j2
class FacetsHookLifecycle implements HookLifecycle {

    /** Name of the Facets stencil */
    static final String FACETS_STENCIL = "facets"

    /**
     * Key where the stencils facets will be stored in the custom data map
     */
    static final String STENCILS_FACETS = "stencilsFacets"

    /**
     * Key where the stencils selected facet values will be stored din the custom data map
     */
    static final String STENCILS_FACETS_SELECTED_VALUES = STENCILS_FACETS + "SelectedValues"

    /**
     * This needs to run as postProcess as we need the built-in Faceted Navigation node to have
     * been populated
     * @param transaction Search transaction
     */
    @Override
    void postProcess(SearchTransaction transaction) {
        if (transaction.question.hasProperty("customData")
            && ConfigUtils.isStencilEnabled(transaction.question.collection.configuration, FACETS_STENCIL)
                && transaction?.response?.facets) {

            def stencilsFacets = transaction.response.facets.collect() { facet ->
                // Get all categories for this facet, recursively
                def categories = facet.categories.collect() { category -> [category, getCategories(category)] }.flatten()

                // Get all values for all categories...
                def values = categories.collect() { category ->
                    category.values.collect() { value ->
                        //  ...and augment them "Stencil-style" \o/
                        getStencilCategoryValue(
                                transaction.question.customData[StencilHooks.QUERY_STRING_MAP_KEY],
                                category,
                                value)
                    }
                }.flatten()

                // Return an augmented Stencil facet, with our augmented values
                return getStencilFacet(
                        transaction.question.customData[StencilHooks.QUERY_STRING_MAP_KEY],
                        facet,
                        values)
            }

            // Insert new facets in data model
            transaction.response.customData[STENCILS_FACETS] = stencilsFacets
            // Insert list of currently selected facets
            transaction.response.customData[STENCILS_FACETS_SELECTED_VALUES] = getSelectedFacetValues(transaction.question.customData[StencilHooks.QUERY_STRING_MAP_KEY], transaction.question.selectedCategoryValues)
        }

    }

    /**
     * Get the list of currently selected facet values
     * @param queryString Map representing the query string
     * @param selectedCategoryValues Map representing the currently selected category values, usually from
     * question.selectedCategoryValues
     * @return List of selected facet values
     */
    List<StencilSelectedFacetValue> getSelectedFacetValues(Map<String, List<String>> queryString, Map<String, List<String>> selectedCategoryValues) {
        return selectedCategoryValues.collect() { key, values ->
            // For each of our selected category values...
            return values.collect() { value ->
                // Get facet name from query string parameter name
                // f.Location|X -> Location
                def facetName = key.replaceAll(/^f\./, "").replaceAll(/\|.+$/, "")

                // Generate a URL to unselect this specific value
                def unselectUrlQs = DatamodelUtils.getQueryStringMapCopy(queryString)
                DatamodelUtils.removeQueryStringFacetValue(unselectUrlQs, key, value)

                return new StencilSelectedFacetValue([
                        facetName  : facetName,
                        value      : value,
                        unselectUrl: QueryStringUtils.toString(unselectUrlQs, true)
                ])
            }
        }
        .flatten()  // Each facet can have multiple selected values, so flatten it to get a single list
    }

    /**
     * Get an augmented StencilCategoryValue from a regular CategoryValue
     * @param queryStringMap Map representing the query string
     * @param category Category the value belong to
     * @param value Value to augment
     * @return Augmented value
     */
    StencilCategoryValue getStencilCategoryValue(Map<String, List<String>> queryStringMap, Facet.Category category, Facet.CategoryValue value) {
        def stencilCategoryValue = new StencilCategoryValue(value)

        // Generate selection URL
        def selectUrlQs = DatamodelUtils.getQueryStringMapCopy(queryStringMap)
        selectUrlQs[stencilCategoryValue.queryStringParamName] = [stencilCategoryValue.queryStringParamValue]

        // Generate unselection URL
        def unselectUrlQs = DatamodelUtils.getQueryStringMapCopy(queryStringMap)
        // Remove this specific value from the URL
        DatamodelUtils.removeQueryStringFacetValue(unselectUrlQs, stencilCategoryValue.queryStringParamName, stencilCategoryValue.queryStringParamValue)

        // Also remove any other query string parameter used by any sub-categories of
        // the current category. This is for hierarchical facets, so that unselecting a parent
        // category also unselect all children
        getAllQueryStringParamNames(category).each() { paramName ->
            if (paramName != stencilCategoryValue.queryStringParamName) {
                unselectUrlQs = DatamodelUtils.filterQueryStringParameters(unselectUrlQs, {key, v -> key != paramName})
            }
        }

        stencilCategoryValue.selectUrl = QueryStringUtils.toString(selectUrlQs, true)
        stencilCategoryValue.unselectUrl = QueryStringUtils.toString(unselectUrlQs, true)

        return stencilCategoryValue
    }

    /**
     * Get an augmented StencilFacet from a regular Facet and StencilCategoryValues
     * @param queryStringMap Map representing the query string
     * @param facet Facet to augment
     * @param values Augmented values to assign to the facet
     * @return Augmented facet
     */
    StencilFacet getStencilFacet(Map<String, List<String>> queryStringMap, Facet facet, List<StencilCategoryValue> values) {
        def qs = DatamodelUtils.getQueryStringMapCopy(queryStringMap)

        // Remove all values for this facet from the query string
        def unselectAllQueryString = DatamodelUtils.filterQueryStringParameters(qs, {
            key, vals -> !key.startsWith("f." + facet.name + "|")
        })

        // If the query string still contains a facetScope after generating the unselect URL (because there are other facets
        // currently selected), generate the corresponding facetScope string
        def unselectAllFacetScope = null
        if (unselectAllQueryString[SearchQuestion.RequestParameters.FACET_SCOPE]) {
            unselectAllFacetScope = unselectAllQueryString[SearchQuestion.RequestParameters.FACET_SCOPE][0]
        }

        return new StencilFacet([
                name                 : facet.name,
                values               : values,
                unselectAllUrl       : QueryStringUtils.toString(unselectAllQueryString, true),
                unselectAllFacetScope: unselectAllFacetScope])
    }

    /**
     * Recursively get the list of all child categories for a category
     * @param c Category to traverse
     * @return List of all child categories
     */
    List<Category> getCategories(Category c) {
        return c.categories
                .collect() { child -> [child, getCategories(child)] }
                .flatten()
    }

    /**
     * Recursively retrieve all the query string parameters used by all sub categories
     * of a category. This is used when generating unselect URLs for facet values to ensure
     * that the URL also unselects any children category
     * @param category
     * @return List of query string parameter names used by this category + its sub-categories
     */
    List<String> getAllQueryStringParamNames(Facet.Category category) {
        def paramNames = [ category.queryStringParamName ]
        category.categories.each() { subCategory ->
            paramNames.addAll(getAllQueryStringParamNames(subCategory))
        }
        return paramNames
    }
}
