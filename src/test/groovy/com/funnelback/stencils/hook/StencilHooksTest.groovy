package com.funnelback.stencils.hook

import com.funnelback.publicui.search.model.collection.Collection.Hook
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import org.junit.Assert
import org.junit.Test

class StencilHooksTest {

    @Test
    void testHookMethodForPhase() {
        Assert.assertEquals("preProcess", StencilHooks.hookMethodForHook(Hook.pre_process));
        Assert.assertEquals("preDatafetch", StencilHooks.hookMethodForHook(Hook.pre_datafetch));        
    }
    
    @Test(expected=IllegalArgumentException.class)
    void testHookMethodForPhaseNoPhase() {
        StencilHooks.hookMethodForHook(null)
    }
    
    @Test(expected=IllegalStateException.class)
    void testApplyNullPhase() {
        new StencilHooks().apply(new SearchTransaction(), null)
    }
    
    @Test(expected=IllegalArgumentException.class)
    void testApplyNullTransaction() {
        new StencilHooks().apply(null, Hook.pre_process)
    }
    
    @Test(expected=IllegalStateException.class)
    void testDetectHookPhase() {
        // We can only test it fails as we can't simulate easily
        // the fact that we're called from a hook script
        StencilHooks.detectHook();
    }

    @Test
    void testSetupCustomDataNoResponse() {
        StencilHooks.setupCustomData(null)

        def transaction = new SearchTransaction()
        Assert.assertNull(transaction.response)
        StencilHooks.setupCustomData(transaction)
    }

    @Test
    void testSetupCustomData() {
        def transaction = new SearchTransaction(null, new SearchResponse())
        StencilHooks.setupCustomData(transaction)

        Assert.assertEquals(1, transaction.response.customData.size())
        Assert.assertEquals([:], transaction.response.customData[StencilHooks.STENCILS_FREEMARKER_METHODS])
    }
}
