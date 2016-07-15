package com.funnelback.stencils.hook.people

import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.search.model.transaction.SearchQuestion.SearchQuestionType
import com.funnelback.stencils.hook.StencilHooks

class PeopleHookLifecycleTest {

    def hook
    def config
    def transaction
    
    @Before
    void before() {
        hook = new PeopleHookLifecycle()
        config = Mockito.mock(Config.class)
        
        transaction = new SearchTransaction()
        transaction.question = Mockito.mock(SearchQuestion.class)
        
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.SEARCH)
        Mockito.when(transaction.question.collection).thenReturn(new Collection("mock", config))
        
        Mockito.when(config.value(StencilHooks.STENCILS_KEY, "")).thenReturn("people")
    }
    
    @Test
    void testQueryShouldBeSetWhenThereIsNoQuery() {
        hook.preProcess(transaction)
        
        Mockito.verify(transaction.question).setQuery("!padrenullquery");
    }
    
    @Test
    void testExistingQueryShouldNotBeUpdated() {
        Mockito.when(transaction.question.query).thenReturn("a query")
        
        hook.preProcess(transaction)
        
        Mockito.verify(transaction.question, Mockito.never()).setQuery("!padrenullquery");
    }
    
    @Test
    void testQueryShouldNotBeSetOnExtraSearches() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.EXTRA_SEARCH)
        
        hook.preProcess(transaction)
        
        Mockito.verify(transaction.question, Mockito.never()).setQuery("!padrenullquery");
    }
    
    @Test
    void testStencilDisabled() {
        Mockito.when(config.value(StencilHooks.STENCILS_KEY, "")).thenReturn("something,else")
        
        hook.preProcess(transaction)
        
        Mockito.verify(transaction.question, Mockito.never()).setQuery("!padrenullquery");
    }
    
    
}
