package com.funnelback.stencils.util

/**
 * Utilities for the data model
 * 
 * @author nguillaumin@funnelback.com
 *
 */
class DatamodelUtils {

    /** Utility class = private constructor */
    private DatamodelUtils() { }

    /**
     * Make a non-shallow copy of the query string map. This is required
     * when wanting to use the map to build URLs, to avoid modifying the source
     * map.
     * 
     * @param queryStringMap map to copy
     * @return Copied map
     */
    public static Map getQueryStringMapCopy(Map queryStringMap) {
        return queryStringMap.collectEntries {
            e -> [e.key, new ArrayList(e.value)]
        }
    }

}
