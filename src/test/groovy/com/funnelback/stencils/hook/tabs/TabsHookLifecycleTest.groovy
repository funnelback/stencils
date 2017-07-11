package com.funnelback.stencils.hook.tabs

import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.padre.ResultPacket
import com.funnelback.publicui.search.model.padre.ResultsSummary
import com.funnelback.publicui.search.model.transaction.Facet
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchQuestion.SearchQuestionType
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.stencils.hook.facets.FacetsHookLifecycle
import com.funnelback.stencils.hook.facets.StencilCategoryValue
import com.funnelback.stencils.hook.facets.StencilFacet
import com.funnelback.stencils.hook.facets.StencilSelectedFacetValue
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

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
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS] = [new StencilFacet([
                name  : "Tabs",
                values: []
        ])]

        questionCustomData = [:]
        questionCustomData[StencilHooks.QUERY_STRING_MAP_KEY] = [
                "param": ["value"],
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
        Assert.assertEquals("Select URL should not contain f.Tabs parameter", "?param=value", value.selectUrl)
        Assert.assertEquals("Unselect URL should not contain f.Tabs parameter", "?param=value", value.selectUrl)
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
        Assert.assertEquals("Count should be set to zero when totalMatching is not available", 0, value.count)
        Assert.assertEquals("unused=unused", value.queryStringParam)
        Assert.assertEquals("unused", value.constraint)
        Assert.assertEquals("All tab should not be selected as another tab is", false, value.selected)
        Assert.assertEquals("Select URL should not contain f.Tabs parameter", "?param=value", value.selectUrl)
        Assert.assertEquals("Unselect URL should not contain f.Tabs parameter", "?param=value", value.selectUrl)
    }

    @Test
    void testPostProcessExtraSearchSelectedStatusAreCopied() {
        Mockito.when(config.value(Mockito.eq(TabsHookLifecycle.ALL_TAB_LABEL_KEY), Mockito.any()))
                .thenReturn("Custom All Label")

        // Inject tabs in our main search, but with zero counts
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS] = [new StencilFacet([
                name  : "Tabs",
                values: [
                        new StencilCategoryValue(new Facet.CategoryValue("data1", "label1", 0, "param1=value", "constraint2", true)),
                        new StencilCategoryValue(new Facet.CategoryValue("data2", "label2", 0, "param2=value", "constraint2", false)),
                ]
        ])]
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[0].selectUrl = "?param=value"
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[0].unselectUrl = "?param=value"
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[1].selectUrl = "?param=value"
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[1].unselectUrl = "?param=value"

        // Inject tabs in our extra search, with some counts
        def extraResponse = new SearchResponse()
        extraResponse.customData[FacetsHookLifecycle.STENCILS_FACETS] = [new StencilFacet([
                name  : "Tabs",
                values: [
                        new StencilCategoryValue(new Facet.CategoryValue("data1", "label1", 1, "param1=value", "constraint2", false)),
                        new StencilCategoryValue(new Facet.CategoryValue("data2", "label2", 2, "param2=value", "constraint2", true)),
                ]
        ])]

        transaction.extraSearches[SearchTransaction.ExtraSearches.FACETED_NAVIGATION.toString()] = new SearchTransaction(null, extraResponse)

        hook.postProcess(transaction)

        Assert.assertTrue(
                "Value 0 selected status 'true' should have been copied from the main search",
                extraResponse.customData[FacetsHookLifecycle.STENCILS_FACETS][0].values[0].selected)
        Assert.assertFalse(
                "Value 1 selected status 'false' should have been copied from the main search",
                extraResponse.customData[FacetsHookLifecycle.STENCILS_FACETS][0].values[1].selected)
    }

    @Test
    void testPostProcessTabsUrlsAreUpdated() {
        Mockito.when(config.value(Mockito.eq(TabsHookLifecycle.ALL_TAB_LABEL_KEY), Mockito.any()))
                .thenReturn("Custom All Label")

        // Inject tabs in our main search, but with zero counts
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS] = [new StencilFacet([
                name  : "Tabs",
                values: [
                        new StencilCategoryValue(new Facet.CategoryValue("1", "Tab1", 0, "f.Tabs|1=Tab1", "1", false)),
                        new StencilCategoryValue(new Facet.CategoryValue("2", "Tab2", 0, "f.Tabs|2=Tab2", "2", false)),
                ]
        ])]
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[0].selectUrl = "f.Tabs|1=Tab1&other=value&f.Tabs|3=Tab3&f.Location|X=Sydney"
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[0].unselectUrl = "other=value"
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[1].selectUrl = "f.Tabs|2=Tab2&other=value&f.Type|f=PDF"
        responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[1].unselectUrl = "other=value"


        hook.postProcess(transaction)

        Assert.assertEquals(
                "Value 1 selectUrl should only have a single 'f.<something>' parameter for itself",
                "?other=value&f.Tabs%7C1=Tab1",
                responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[0].selectUrl)
        Assert.assertEquals(
                "Value 2 selectUrl should only have a single 'f.<something>' parameter for itself",
                "?other=value&f.Tabs%7C2=Tab2",
                responseCustomData[FacetsHookLifecycle.STENCILS_FACETS][0].values[1].selectUrl)
    }

    @Test
    void testSelectedTab() {
        transaction.response.customData[FacetsHookLifecycle.STENCILS_FACETS_SELECTED_VALUES] = [
                new StencilSelectedFacetValue([
                        facetName  : "Tabs",
                        value      : "Courses",
                        unselectUrl: "CoursesUrl"
                ]),
                new StencilSelectedFacetValue([
                        facetName  : "Format",
                        value      : "PDF",
                        unselectUrl: "PDFUrl"
                ]),
                new StencilSelectedFacetValue([
                        facetName  : "State",
                        value      : "QLD",
                        unselectUrl: "QLDUrl"
                ])
        ]

        hook.postProcess(transaction)

        Assert.assertEquals(
                "The Courses facet should have been marked as selected",
                "Courses",
                transaction.response.customData[TabsHookLifecycle.SELECTED_TAB])

        Assert.assertEquals(
                "The selected tab should have been removed from the list of selected facets",
                2,
                transaction.response.customData[FacetsHookLifecycle.STENCILS_FACETS_SELECTED_VALUES].size())

        Assert.assertFalse(
                "No facet named 'Tabs' should be present in the list of selected facets",
                transaction.response.customData[FacetsHookLifecycle.STENCILS_FACETS_SELECTED_VALUES]
                        .any() { value ->
                    value.facetName == "Tabs"
                })

    }

    @Test
    void testSelectedTabNoTab() {
        Mockito.when(config.value(Mockito.eq(TabsHookLifecycle.ALL_TAB_LABEL_KEY), Mockito.any()))
                .thenReturn("Custom All Label")
        hook.postProcess(transaction)

        Assert.assertEquals(
                "The All facet should have been marked as selected",
                "Custom All Label",
                transaction.response.customData[TabsHookLifecycle.SELECTED_TAB])
    }


}
