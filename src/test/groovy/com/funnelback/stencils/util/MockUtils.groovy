package com.funnelback.stencils.util

import com.funnelback.publicui.search.model.padre.Result

/**
 * Mock utilities for testing
 * 
 * @author nguillaumin@funnelback.com
 *
 */
class MockUtils {

    /**
     * Mock a search result with the given metadata
     * @param metadataMap Metadata to assign to the result
     * @return Result
     */
    static Result mockResult(Map metadataMap) {
        def result = new Result()
        metadataMap.forEach({ k, v -> result.getListMetadata().put(k, v) })
        return result
    }

}
