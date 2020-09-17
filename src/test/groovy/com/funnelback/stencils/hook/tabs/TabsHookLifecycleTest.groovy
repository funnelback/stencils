package com.funnelback.stencils.hook.tabs

import com.funnelback.common.config.CollectionId
import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.collection.ServiceConfig
import com.funnelback.publicui.search.model.padre.ResultPacket
import com.funnelback.publicui.search.model.padre.ResultsSummary
import com.funnelback.publicui.search.model.transaction.Facet
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchQuestion.SearchQuestionType
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.search.model.transaction.facet.FacetDisplayType

import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class TabsHookLifecycleTest {

    def hook
    SearchTransaction transaction
    ServiceConfig config

    @Before
    void before() {
        hook = new TabsHookLifecycle()

        def resultPacket = new ResultPacket()
        resultPacket.resultsSummary = new ResultsSummary()
        resultPacket.resultsSummary.totalMatching = 42

        config = Mockito.mock(ServiceConfig.class)
        def question = Mockito.mock(SearchQuestion.class)
        def response = Mockito.mock(SearchResponse.class)

        Mockito.when(question.questionType).thenReturn(SearchQuestionType.SEARCH)
        Mockito.when(question.collection).thenReturn(new Collection(new CollectionId("client~mock"), Mockito.mock(Config.class)))
        Mockito.when(question.getCurrentProfileConfig()).thenReturn(config)
        Mockito.when(response.resultPacket).thenReturn(resultPacket)
        Mockito.when(response.customData).thenReturn(new HashMap<String, Object>());

        transaction = new SearchTransaction(question, response)
    }

    @Test
    void testPostDatafetchGscopes() {
        Mockito.when(config.get(TabsHookLifecycle.GSCOPE_KEY)).thenReturn(" 1 ,12 , 23,")
        hook.postDatafetch(transaction)

        Assert.assertEquals(3, transaction.response.resultPacket.GScopeCounts.size())
        Assert.assertEquals(0, transaction.response.resultPacket.GScopeCounts.get(1))
        Assert.assertEquals(0, transaction.response.resultPacket.GScopeCounts.get(12))
        Assert.assertEquals(0, transaction.response.resultPacket.GScopeCounts.get(23))
    }

    @Test
    void testPostDatafetchGscopesNoValue() {
        hook.postDatafetch(transaction)
        Assert.assertEquals(0, transaction.response.resultPacket.GScopeCounts.size())
    }

    @Test
    void testPostDatafetchMetadata() {
        Mockito.when(config.getRawKeys()).thenReturn([
                TabsHookLifecycle.METADATA_KEY_PREFIX + "author.1",
                TabsHookLifecycle.METADATA_KEY_PREFIX + "author.2",
                TabsHookLifecycle.METADATA_KEY_PREFIX + "subject.1"
        ] as Set)
        Mockito.when(config.get(TabsHookLifecycle.METADATA_KEY_PREFIX + "author.1")).thenReturn("Shakespeare")
        Mockito.when(config.get(TabsHookLifecycle.METADATA_KEY_PREFIX + "author.2")).thenReturn("Rousseau")
        Mockito.when(config.get(TabsHookLifecycle.METADATA_KEY_PREFIX + "subject.1")).thenReturn("Java")

        hook.postDatafetch(transaction)

        Assert.assertEquals(3, transaction.response.resultPacket.rmcs.size())
        Assert.assertEquals(0, transaction.response.resultPacket.rmcs["author:Shakespeare"] as Integer)
        Assert.assertEquals(0, transaction.response.resultPacket.rmcs["author:Rousseau"] as Integer)
        Assert.assertEquals(0, transaction.response.resultPacket.rmcs["subject:Java"] as Integer)
    }

    @Test
    void testPostDatafetchMetadataNoValue() {
        Mockito.when(config.getRawKeys()).thenReturn([
                TabsHookLifecycle.METADATA_KEY_PREFIX + "author.1",
                TabsHookLifecycle.METADATA_KEY_PREFIX + "author.2",
                TabsHookLifecycle.METADATA_KEY_PREFIX + "subject.1"
        ] as Set)
        Mockito.when(config.get(TabsHookLifecycle.METADATA_KEY_PREFIX + "author.1")).thenReturn("")
        Mockito.when(config.get(TabsHookLifecycle.METADATA_KEY_PREFIX + "author.2")).thenReturn(null)
        Mockito.when(config.get(TabsHookLifecycle.METADATA_KEY_PREFIX + "subject.1")).thenReturn(null)

        hook.postDatafetch(transaction)

        Assert.assertEquals(0, transaction.response.resultPacket.rmcs.size())
    }

    @Test
    void testPostDatafetchWithContentAuditorQuestionType() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.CONTENT_AUDITOR)
        hook.postDatafetch(transaction)

        Mockito.verifyZeroInteractions(config)
    }

    @Test
    void testPostDatafetchWithExtraSearchQuestionType() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.EXTRA_SEARCH)
        hook.postDatafetch(transaction)

        // Config should have been read
        Mockito.verify(config).get(Mockito.any())
    }

    @Test
    void testSelectedTab() {
        Facet.CategoryValue category = Mockito.mock(Facet.CategoryValue.class)
        Mockito.when(category.selected).thenReturn(true)
        Mockito.when(category.label).thenReturn("Courses")
        Facet facet = Mockito.mock(Facet.class)
        Mockito.when(facet.getGuessedDisplayType()).thenReturn(FacetDisplayType.TAB)
        Mockito.when(facet.getAllValues()).thenReturn([category])
        Mockito.when(transaction.response.getFacets()).thenReturn([facet])

        hook.postProcess(transaction)

        Assert.assertEquals(
                "The Courses facet should have been marked as selected",
                "Courses",
                transaction.response.customData[TabsHookLifecycle.SELECTED_TAB])
    }

}
