package com.funnelback.stencils.hook.core

import com.funnelback.publicui.search.model.padre.Collapsed
import com.funnelback.publicui.search.model.padre.Result
import com.funnelback.publicui.search.model.padre.ResultPacket
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.freemarker.method.LinkifyMethod
import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.stencils.hook.facebook.FacebookHookLifecycle
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class CoreHookLifecycleTest {

    def hook
    def transaction

    @Before
    void before() {
        hook = new CoreHookLifecycle()

        transaction = new SearchTransaction()
        transaction.question = Mockito.mock(SearchQuestion.class)
        Mockito.when(transaction.question.profile).thenReturn("profile-id")

        def questionCustomDataMap = [
                "queryStringMap": [
                        "collection": ["meta-collection"],
                        "start_rank": ["12"],
                        "duplicate_start_rank": ["32"],
                        "query": ["CGI query"]
                ],
        ]
        Mockito.when(transaction.question.customData).thenReturn(questionCustomDataMap)

        def responseCustomDataMap = [:]
        responseCustomDataMap[StencilHooks.STENCILS_FREEMARKER_METHODS] = [:]
        transaction.response = Mockito.mock(SearchResponse.class)
        Mockito.when(transaction.response.customData).thenReturn(responseCustomDataMap)


        def result = new Result()
        result.collection = "collection1"
        result.liveUrl = 'http://example.org/live-url'
        result.indexUrl = 'http://example.org/index-url'

        def collapsedResult = new Result()
        collapsedResult.collection = "collection2"
        collapsedResult.liveUrl = 'http://example.org/collapsed/live-url'
        collapsedResult.indexUrl = 'http://example.org/collapsed/index-url'
        collapsedResult.collapsed = new Collapsed("signature", 42, "column")

        def results = [
                result,
                collapsedResult
        ]

        Mockito.when(transaction.response.resultPacket).thenReturn(Mockito.mock(ResultPacket.class))
        Mockito.when(transaction.response.resultPacket.results).thenReturn(results)
        Mockito.when(transaction.response.resultPacket.query).thenReturn("the query")
    }


    @Test
    void test() {
        hook.postDatafetch(transaction)

        Assert.assertTrue(transaction.response.customData[StencilHooks.STENCILS_FREEMARKER_METHODS]["linkify"] instanceof LinkifyMethod)

        def result = transaction.response.resultPacket.results[0]
        Assert.assertEquals(2, result.customData.size())
        Assert.assertEquals(result.customData["stencilsCoreExploreUrl"], "?collection=meta-collection&query=explore%3Ahttp%3A%2F%2Fexample.org%2Flive-url")
        Assert.assertEquals(result.customData["stencilsCoreOptimiseUrl"], "/a/#/collection1:profile-id/analyse/seo-auditor/the%20query/http:%252F%252Fexample.org%252Findex-url")

        def collapsedResult = transaction.response.resultPacket.results[1]
        Assert.assertEquals(2, result.customData.size())
        Assert.assertEquals(collapsedResult.customData["stencilsCoreExploreUrl"], "?collection=meta-collection&query=explore%3Ahttp%3A%2F%2Fexample.org%2Fcollapsed%2Flive-url")
        Assert.assertEquals(collapsedResult.customData["stencilsCoreOptimiseUrl"], "/a/#/collection2:profile-id/analyse/seo-auditor/the%20query/http:%252F%252Fexample.org%252Fcollapsed%252Findex-url")
        Assert.assertEquals(collapsedResult.customData["stencilsCoreCollapsedUrl"], "?collection=meta-collection&query=CGI+query&s=%3F%3Asignature&fmo=on&collapsing=off")
    }
}
