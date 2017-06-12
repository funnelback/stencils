package com.funnelback.stencils.hook.tabs

import com.funnelback.publicui.search.model.padre.ResultsSummary
import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.stencils.hook.facets.FacetsHookLifecycle
import com.funnelback.stencils.hook.facets.StencilFacet
import com.funnelback.stencils.hook.facets.StencilFacetTest
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
    def questionCustomData
    def responseCustomData
    
    @Before
    void before() {
        hook = new TabsHookLifecycle()
        
        config = Mockito.mock(Config.class)

        resultPacket = new ResultPacket()
        resultPacket.resultsSummary = new ResultsSummary()
        resultPacket.resultsSummary.totalMatching = 42

        responseCustomData = [:]
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS] = [ new StencilFacet([
                name: "Tabs",
                values: []
        ]) ]

        questionCustomData = [:]
        questionCustomData[StencilHooks.QUERY_STRING_MAP_KEY] = [
                "param": [ "value" ],
        ]

        transaction = new SearchTransaction()
        transaction.question = Mockito.mock(SearchQuestion.class)
        transaction.response = Mockito.mock(SearchResponse.class)
        
        Mockito.when(transaction.question.collection).thenReturn(new Collection("mock", config))
        Mockito.when(transaction.question.customData).thenReturn(questionCustomData)
        Mockito.when(transaction.response.resultPacket).thenReturn(resultPacket)
        Mockito.when(transaction.response.customData).thenReturn(responseCustomData)
    }
    
    @Test
    void testPostDatafetchGscopes() {
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
    void testPostDatafetchGscopesNoValue() {
        Mockito.when(transaction.question.questionType).thenReturn(SearchQuestionType.SEARCH)
        Mockito.when(config.hasValue(TabsHookLifecycle.GSCOPE_KEY)).thenReturn(false)
        
        hook.postDatafetch(transaction)
        Assert.assertEquals(0, transaction.response.resultPacket.GScopeCounts.size())
    }

    @Test
    void testPostDatafetchMetadata() {
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
    void testPostDatafetchMetadataNoValue() {
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
        Mockito.verify(config).hasValue(Mockito.any())
    }

    @Test
    void testPostProcessNoTabSelectedLabel() {
        Mockito.when(config.value(Mockito.eq(TabsHookLifecycle.ALL_TAB_LABEL_KEY), Mockito.any()))
                .thenReturn("Custom All Label")

        hook.postProcess(transaction)

        Assert.assertEquals(
                "A value should have been added to the facet",
                1,
                responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values.size())

        def value = responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[0]
        Assert.assertEquals("all", value.data)
        Assert.assertEquals("Custom All Label", value.label)
        Assert.assertEquals("Count should be set to resultPacket totalMatching", 42, value.count)
        Assert.assertEquals("unused=unused", value.queryStringParam)
        Assert.assertEquals("unused", value.constraint)
        Assert.assertEquals("All tab should be selected as no other tabs are", true, value.selected)
        Assert.assertEquals("Select URL should not contain f.Tabs parameter","?param=value", value.selectUrl)
        Assert.assertEquals("Unselect URL should not contain f.Tabs parameter","?param=value", value.selectUrl)
    }

    @Test
    void testPostProcessTabSelected() {
        Mockito.when(config.value(Mockito.eq(TabsHookLifecycle.ALL_TAB_LABEL_KEY), Mockito.any()))
                .thenReturn("Custom All Label")
        // Inject selected facet
        Mockito.when(transaction.question.selectedFacets).thenReturn(["Tabs"] as Set)
        // Inject corresponding query string parameter for the selected facets
        questionCustomData[StencilHooks.QUERY_STRING_MAP_KEY]["f.Tabs|X"] = ["Tab1", "Tab2"]
        // Also test that when there's no totalMatching available it doesn't crash
        resultPacket.resultsSummary = null

        hook.postProcess(transaction)

        Assert.assertEquals(
                "A value should have been added to the facet",
                1,
                responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values.size())

        def value = responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[0]
        Assert.assertEquals("all", value.data)
        Assert.assertEquals("Custom All Label", value.label)
        Assert.assertEquals("Count should be set to zero when totalMatching is not available",0, value.count)
        Assert.assertEquals("unused=unused", value.queryStringParam)
        Assert.assertEquals("unused", value.constraint)
        Assert.assertEquals("All tab should not be selected as another tab is", false, value.selected)
        Assert.assertEquals("Select URL should not contain f.Tabs parameter","?param=value", value.selectUrl)
        Assert.assertEquals("Unselect URL should not contain f.Tabs parameter","?param=value", value.selectUrl)
    }


}
