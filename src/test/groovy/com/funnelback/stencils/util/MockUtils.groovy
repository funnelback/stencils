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
     * @param metaData Metadata to assign to the result
     * @return Result
     */
    static Result mockResult(Map metaData) {
        def result = new Result()
        result.metaData << metaData
        
        return result
    }
    
}
