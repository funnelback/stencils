package com.funnelback.stencils.hook.core

import com.funnelback.publicui.search.model.padre.Collapsed
import com.funnelback.publicui.search.model.padre.Result
import com.funnelback.publicui.search.model.padre.ResultPacket
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.freemarker.method.LinkifyMethod
import com.funnelback.stencils.hook.StencilHooks
import com.google.common.collect.ArrayListMultimap
import com.google.common.collect.ListMultimap
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class CoreHookLifecycleTest {

    def hook
    SearchTransaction transaction

    @Before
    void before() {
        hook = new CoreHookLifecycle()

        transaction = new SearchTransaction()
        transaction.question = Mockito.mock(SearchQuestion.class)
        Mockito.when(transaction.question.profile).thenReturn("profile-id")

        ListMultimap<String, String> qs = ArrayListMultimap.create()
        qs.put("collection", "client~meta-collection")
        qs.put("start_rank", "12")
        qs.put("duplicate_start_rank", "32")
        qs.put("query", "CGI query")
        Mockito.when(transaction.question.queryStringMapCopy).thenReturn(qs)

        Map<String, Object> responseCustomData = new HashMap()
        responseCustomData.put(StencilHooks.STENCILS_FREEMARKER_METHODS, [:])
        transaction.response = Mockito.mock(SearchResponse.class)
        Mockito.when(transaction.response.customData).thenReturn(responseCustomData)

        Result result = new Result()
        result.collection = "client~collection1"
        result.liveUrl = 'http://example.org/live-url'
        result.indexUrl = 'http://example.org/index-url'

        Result collapsedResult = new Result()
        collapsedResult.collection = "client~collection2"
        collapsedResult.liveUrl = 'http://example.org/collapsed/live-url'
        collapsedResult.indexUrl = 'http://example.org/collapsed/index-url'
        collapsedResult.collapsed = new Collapsed("signature", 42, "column")

        List<Result> results = [result, collapsedResult]
        Mockito.when(transaction.response.resultPacket).thenReturn(Mockito.mock(ResultPacket.class))
        Mockito.when(transaction.response.resultPacket.results).thenReturn(results)
        Mockito.when(transaction.response.resultPacket.query).thenReturn("the query")
    }

    @Test
    void test() {
        hook.postDatafetch(transaction)

        Assert.assertTrue(transaction.response.customData[StencilHooks.STENCILS_FREEMARKER_METHODS]["linkify"] instanceof LinkifyMethod)

        Result result = transaction.response.resultPacket.results[0]
        Assert.assertEquals(2, result.customData.size())
        Assert.assertEquals("?collection=client%7Emeta-collection&query=explore%3Ahttp%3A%2F%2Fexample.org%2Flive-url", result.customData["stencilsCoreExploreUrl"])
        Assert.assertEquals("/a/#/client~collection1:profile-id/analyse/seo-auditor/the%20query/http:%252F%252Fexample.org%252Findex-url", result.customData["stencilsCoreOptimiseUrl"])

        Result collapsedResult = transaction.response.resultPacket.results[1]
        Assert.assertEquals(2, result.customData.size())
        Assert.assertEquals("?collection=client%7Emeta-collection&query=explore%3Ahttp%3A%2F%2Fexample.org%2Fcollapsed%2Flive-url", collapsedResult.customData["stencilsCoreExploreUrl"])
        Assert.assertEquals("/a/#/client~collection2:profile-id/analyse/seo-auditor/the%20query/http:%252F%252Fexample.org%252Fcollapsed%252Findex-url", collapsedResult.customData["stencilsCoreOptimiseUrl"])
        Assert.assertEquals("?fmo=on&collection=client%7Emeta-collection&s=%3F%3Asignature&collapsing=off&query=CGI+query", collapsedResult.customData["stencilsCoreCollapsedUrl"])
    }

}
