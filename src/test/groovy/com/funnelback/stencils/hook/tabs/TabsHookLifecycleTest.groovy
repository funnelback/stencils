package com.funnelback.stencils.hook.tabs

import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.padre.ResultPacket
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.search.model.transaction.SearchQuestion.SearchQuestionType

class TabsHookLifecycleTest {

    def hook
    def transaction
    def config
    def resultPacket
    
    @Before
    void before() {
        hook = new TabsHookLifecycle()
        
        config = Mockito.mock(Config.class)
        resultPacket = new ResultPacket()
        
        transaction = new SearchTransaction()
        transaction.question = Mockito.mock(SearchQuestion.class)
        transaction.response = Mockito.mock(SearchResponse.class)
        
        Mockito.when(transaction.question.collection).thenReturn(new Collection("mock", config))
        Mockito.when(transaction.response.resultPacket).thenReturn(resultPacket)
    }
    
    @Test
    void testGscopes() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.SEARCH)
        Mockito.when(config.hasValue(TabsHookLifecycle.GSCOPE_KEY)).thenReturn(true)
        Mockito.when(config.value(TabsHookLifecycle.GSCOPE_KEY)).thenReturn(" 1 ,12 , 23,")
        
        hook.postDatafetch(transaction)
        
        Assert.assertEquals(3, transaction.response.resultPacket.GScopeCounts.size())
        Assert.assertEquals(0, transaction.response.resultPacket.GScopeCounts[1])
        Assert.assertEquals(0, transaction.response.resultPacket.GScopeCounts[12])
        Assert.assertEquals(0, transaction.response.resultPacket.GScopeCounts[23])
    }
    
    @Test
    void testGscopesNoValue() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.SEARCH)
        Mockito.when(config.hasValue(TabsHookLifecycle.GSCOPE_KEY)).thenReturn(false)
        
        hook.postDatafetch(transaction)
        Assert.assertEquals(0, transaction.response.resultPacket.GScopeCounts.size())
    }

    @Test
    void testMetadata() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.SEARCH)
        Mockito.when(config.valueKeys()).thenReturn([
            TabsHookLifecycle.METADATA_KEY_PREFIX + "author.1",
            TabsHookLifecycle.METADATA_KEY_PREFIX + "author.2",
            TabsHookLifecycle.METADATA_KEY_PREFIX + "subject.1"
        ] as Set)
        
        Mockito.when(config.value(TabsHookLifecycle.METADATA_KEY_PREFIX + "author.1")).thenReturn("Shakespeare")
        Mockito.when(config.value(TabsHookLifecycle.METADATA_KEY_PREFIX + "author.2")).thenReturn("Rousseau")
        Mockito.when(config.value(TabsHookLifecycle.METADATA_KEY_PREFIX + "subject.1")).thenReturn("Java")
        
        hook.postDatafetch(transaction)

        Assert.assertEquals(3, transaction.response.resultPacket.rmcs.size())
        
        Assert.assertEquals(0, transaction.response.resultPacket.rmcs["author:Shakespeare"])
        Assert.assertEquals(0, transaction.response.resultPacket.rmcs["author:Rousseau"])
        Assert.assertEquals(0, transaction.response.resultPacket.rmcs["subject:Java"])
    }

    @Test
    void testMetadataNoValue() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.SEARCH)
        Mockito.when(config.valueKeys()).thenReturn([
            TabsHookLifecycle.METADATA_KEY_PREFIX + "author.1",
            TabsHookLifecycle.METADATA_KEY_PREFIX + "author.2",
            TabsHookLifecycle.METADATA_KEY_PREFIX + "subject.1"
        ] as Set)
        
        Mockito.when(config.value(TabsHookLifecycle.METADATA_KEY_PREFIX + "author.1")).thenReturn("")
        Mockito.when(config.value(TabsHookLifecycle.METADATA_KEY_PREFIX + "author.2")).thenReturn(null)
        Mockito.when(config.value(TabsHookLifecycle.METADATA_KEY_PREFIX + "subject.1")).thenReturn(null)
        
        hook.postDatafetch(transaction)

        Assert.assertEquals(0, transaction.response.resultPacket.rmcs.size())
    }

    @Test
    void testWithContentAuditorQuestionType() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.CONTENT_AUDITOR)
        
        hook.postDatafetch(transaction)
        
        Mockito.verifyZeroInteractions(config)
    }
    
    @Test
    void testWithExtraSearchQuestionType() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.EXTRA_SEARCH)
        
        hook.postDatafetch(transaction)
        
        // Config should have been read
        Mockito.verify(config).hasValue(Mockito.any())

    }

}
