package com.funnelback.stencils.hook.tabs

import org.junit.Assert
import org.junit.Before
import org.junit.Test

import org.mockito.Mockito

import com.funnelback.stencils.hook.tabs.TabsHookLifecycle
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchQuestion.SearchQuestionType
import com.funnelback.publicui.search.model.transaction.SearchResponse

class TabsHookLifecycleTest {

    def hook
    def transaction
    
    @Before
    void before() {
        hook = new TabsHookLifecycle()
        
        transaction = new SearchTransaction()
        transaction.question = Mockito.mock(SearchQuestion.class)
        transaction.response = Mockito.mock(SearchResponse.class)
        
        hook.transaction = transaction
    }
    
    @Test
    void testPostProcessWithSearchQuestionType() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.SEARCH)
        def map = [:]
        Mockito.when(transaction.response.customData).thenReturn(map)
        
        hook.postDatafetch()
        
        Assert.assertEquals(42, map["test"])
    }

    @Test
    void testPostProcessWithContentAuditorQuestionType() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.CONTENT_AUDITOR)
        def map = [:]
        Mockito.when(transaction.response.customData).thenReturn(map)
        
        hook.postDatafetch()
        
        Assert.assertNull(map["test"])
    }

}
