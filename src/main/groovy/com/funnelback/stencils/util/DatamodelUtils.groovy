package com.funnelback.stencils.util

import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.utils.QueryStringUtils

/**
 * Utilities for the data model
 *
 * @author nguillaumin@funnelback.com
 *
 */
class DatamodelUtils {

    /** Utility class = private constructor */
    private DatamodelUtils() {}

    /**
     * Make a non-shallow copy of the query string map. This is required
     * when wanting to use the map to build URLs, to avoid modifying the source
     * map.
     *
     * @param queryStringMap map to copy
     * @return Copied map
     */
    public static Map getQueryStringMapCopy(Map queryStringMap) {
        if (queryStringMap == null) {
            // If we don't have a source map to copy, just return an empty
            // map. This may happen within extra searches, and it will still allow the
            // hook to works without crashing. The resulting URL may miss some parameters
            // the they can be re-added in the template if needed
            return [:]
        } else {
            return queryStringMap.collectEntries {
                e -> [e.key, new ArrayList(e.value)]
            }
        }
    }

    /**
     * <p>Remove a value from a query string, possibly removing the complete parameter
     * if no other values remain after the removal. Also applies the removal to the
     * <code>facetScope</code> value.</p>
     *
     * <p>For instance if it was called with <code>&param=A&param=B&other=C</code> to remove
     * the value "A" from "param", <code>param=B</code> would be retained. If the value "C"
     * was removed, then "other" would be removed from the query string</p>
     *
     * @param queryStringMap Map representing the query string
     * @param paramName Name of the parameter to remove the value from
     * @param paramValue Value to remove
     */
    static void removeQueryStringFacetValue(Map queryStringMap, String paramName, String paramValue) {
        removeValueAndPossiblyParameterFromMap(queryStringMap, paramName, paramValue)

        // Also remove value from the facetScope if it exists
        if (queryStringMap[SearchQuestion.RequestParameters.FACET_SCOPE]) {
            // Assume facetScope has only 1 value
            def facetScopeQs = QueryStringUtils.toMap(queryStringMap[SearchQuestion.RequestParameters.FACET_SCOPE][0])

            removeValueAndPossiblyParameterFromMap(facetScopeQs, paramName, paramValue)

            // If no parameters remain in facetScope, just remove it from the query string
            if (facetScopeQs.isEmpty()) {
                queryStringMap.remove(SearchQuestion.RequestParameters.FACET_SCOPE)
            } else {
                // Serialize it back
                queryStringMap[SearchQuestion.RequestParameters.FACET_SCOPE] = [QueryStringUtils.toString(facetScopeQs, false)]
            }
        }
    }

    /**
     * <p>Remove a value from a Map, and possibly the key as well if the value to remove
     * was the only one</p>
     *
     * @param queryStringMap Map to remove the value from
     * @param paramName Name of the parameter to remove the value from
     * @param paramValue Value to remove
     */
    static void removeValueAndPossiblyParameterFromMap(Map<String, List<String>> queryStringMap, String paramName, String paramValue) {
        if (queryStringMap.containsKey(paramName)) {
            // Remove the value if there's one. There may be multiple values for the
            // same name, when multiple values are selected (checkboxes)
            queryStringMap[paramName].remove(paramValue)
            if (!queryStringMap[paramName]) {
                // If it was the only value, remove the parameter entirely
                queryStringMap.remove(paramName)
            }
        }
    }

    /**
     * Filter a map representing a query string to retain some parameters only. Also applies the
     * filtering to the the facetScope parameter.
     *
     * @param queryStringMap Map representing the query string
     * @param retainClosure Closure to apply to select which parameters to retain. The name and values of the parameter
     * is passed. For example to remove all parameters for a given facet, use <code>{name, value -> !name.startsWith("f.Location|")}</code>
     */
    static Map<String, List<String, String>> filterQueryStringParameters(Map<String, List<String>> queryStringMap, Closure<Boolean> retainClosure) {
        def filtered = queryStringMap.findAll(retainClosure)
        if (filtered[SearchQuestion.RequestParameters.FACET_SCOPE]) {
            // Assume facetScope has only 1 value
            def facetScopeQs = QueryStringUtils.toMap(filtered[SearchQuestion.RequestParameters.FACET_SCOPE][0])
            facetScopeQs = facetScopeQs.findAll(retainClosure)
            if (facetScopeQs.isEmpty()) {
                filtered.remove(SearchQuestion.RequestParameters.FACET_SCOPE)
            } else {
                filtered[SearchQuestion.RequestParameters.FACET_SCOPE] = [ QueryStringUtils.toString(facetScopeQs, false) ]
            }
        }

        return filtered
    }

}
