package com.funnelback.stencils.hook

import org.junit.Assert
import org.junit.Test

import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.publicui.search.model.collection.Collection.Hook
import com.funnelback.publicui.search.model.transaction.SearchTransaction

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
}
