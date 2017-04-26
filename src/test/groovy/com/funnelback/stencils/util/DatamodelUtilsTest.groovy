package com.funnelback.stencils.util

import org.junit.Assert
import org.junit.Test

class DatamodelUtilsTest {

    @Test
    public void testGetQueryStringMapCopy() {
        def testMap = Collections.unmodifiableMap([
            "key1": ["value-1", "value-2"],
            "key2": ["value-A"]
        ])
        
        def copyMap = DatamodelUtils.getQueryStringMapCopy(testMap)
        
        Assert.assertNotSame("The copy should not be the same instance as the source",
            testMap, copyMap)
        
        Assert.assertEquals("The copy should be identical to the source", 
            testMap, copyMap)
        
        // Adding an entry should be allowed on the copy
        copyMap["new-entry"] = ["new-value"]
        
        // Modifying an existing entry should be allowed on the copy
        copyMap["key1"] << "value-3"

        Assert.assertEquals("Copy should have been updated", [
            "key1": ["value-1", "value-2", "value-3"],
            "key2": ["value-A"],
            "new-entry": ["new-value"]
        ], copyMap)
    }

    @Test
    public void testGetQueryStringMapCopyEmptyOrNull() {
        Assert.assertEquals([:], DatamodelUtils.getQueryStringMapCopy(null));
        Assert.assertEquals([:], DatamodelUtils.getQueryStringMapCopy([:]));
    }
    
}
