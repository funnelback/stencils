package com.funnelback.stencils.hook.noresults

import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

import com.funnelback.common.config.CollectionId
import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchTransaction

class NoResultsHookLifecycleTest {

    def hook
    def config
    def transaction
    
    @Before
    void before() {
        hook = new NoResultsHookLifecycle()
        config = Mockito.mock(Config.class)
        
        transaction = new SearchTransaction()
        transaction.question = Mockito.mock(SearchQuestion.class)
        
        Mockito.when(transaction.question.collection).thenReturn(new Collection(new CollectionId("client~mock"), config))
        Mockito.when(config.value(NoResultsHookLifecycle.NO_RESULTS_QUERY_KEY, NoResultsHookLifecycle.DEFAULT_NO_RESULTS_QUERY)).thenReturn("no-results-query")
    }
    
    @Test
    void testExtraSearch() {
        transaction.extraSearchesQuestions[NoResultsHookLifecycle.NO_RESULTS_EXTRA_SEARCH] = new SearchQuestion()
        
        hook.extraSearches(transaction)
        
        Assert.assertEquals("no-results-query", transaction.extraSearchesQuestions[NoResultsHookLifecycle.NO_RESULTS_EXTRA_SEARCH].query)
    }

    @Test
    void testNoExtraSearch() {
        hook.extraSearches(transaction)
        
        Assert.assertNull(transaction.extraSearchesQuestions[NoResultsHookLifecycle.NO_RESULTS_EXTRA_SEARCH])
    }
    
    @Test
    void testOtherExtraSearch() {
        transaction.extraSearchesQuestions["another-extra-search"] = new SearchQuestion()
        
        // Should not cause a no_results extra search to appear
        testNoExtraSearch()
    }

}
