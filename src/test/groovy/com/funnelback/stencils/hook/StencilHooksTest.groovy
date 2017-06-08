package com.funnelback.stencils.hook

import com.funnelback.publicui.search.model.collection.Collection.Hook
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import org.junit.Assert
import org.junit.Assume
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

    @Test
    void testInjectQueryStringMapFromQSMapCopy() {
        def transaction = new SearchTransaction(new SearchQuestion(), null)
        Assume.assumeTrue("Test only valid for 15.10+", transaction.question.hasProperty('queryStringMap') != null)

        transaction.question.queryStringMap = [ "param" : [ "value1", "value2" ]]
        StencilHooks.injectQueryStringMap(transaction)

        Assert.assertEquals([ "param" : [ "value1", "value2" ]], transaction.question.customData[StencilHooks.QUERY_STRING_MAP_KEY])
    }

    @Test
    void testInjectQueryStringMapAlreadyPresent() {
        def transaction = new SearchTransaction(new SearchQuestion(), null)
        Assume.assumeTrue("Test only valid for 15.10+", transaction.question.hasProperty('queryStringMap') != null)

        transaction.question.queryStringMap = [ "param" : [ "value1", "value2" ]]
        transaction.question.customData[StencilHooks.QUERY_STRING_MAP_KEY] = ["already": "present"]
        StencilHooks.injectQueryStringMap(transaction)

        Assert.assertEquals([ "already": "present" ], transaction.question.customData[StencilHooks.QUERY_STRING_MAP_KEY])
    }

    @Test
    void testInjectQueryStringMapExtraSearch() {
        def transaction = new SearchTransaction(new SearchQuestion(), null)
        transaction.question.questionType = SearchQuestion.SearchQuestionType.EXTRA_SEARCH
        StencilHooks.injectQueryStringMap(transaction)

        Assert.assertFalse(transaction.question.customData.containsKey(StencilHooks.QUERY_STRING_MAP_KEY))
    }

}
