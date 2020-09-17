package com.funnelback.stencils.hook.core

import com.funnelback.common.config.CollectionId
import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.padre.ResultPacket
import com.funnelback.publicui.search.model.padre.ResultsSummary
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.google.common.collect.ArrayListMultimap
import com.google.common.collect.ListMultimap
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class PagingHookLifecycleTest {

    def hook
    def config
    SearchTransaction transaction
    def summary

    @Before
    void before() {
        hook = new PagingHookLifecycle()
        config = Mockito.mock(Config.class)

        Mockito.when(config.valueAsInt(PagingHookLifecycle.NUM_PAGES_KEY, PagingHookLifecycle.NUM_PAGES_DEFAULT))
                .thenReturn(PagingHookLifecycle.NUM_PAGES_DEFAULT)

        transaction = new SearchTransaction(new SearchQuestion(), new SearchResponse())
        transaction.question.collection = new Collection(new CollectionId("client~collection"), config)
        ListMultimap<String, String> qs = ArrayListMultimap.create()
        qs.put("param", "value")
        transaction.question.setQueryStringMap(qs)

        summary = new ResultsSummary()
        transaction.response.resultPacket = new ResultPacket()
        transaction.response.resultPacket.resultsSummary = summary
    }

    @Test
    void testFirstPage() {
        summary.totalMatching = 422
        summary.prevStart = null
        summary.nextStart = 11
        summary.currStart = 1
        summary.currEnd = 10
        summary.numRanks = 10

        hook.postDatafetch(transaction)

        Assert.assertEquals(
                new PagingControls([
                        firstUrl   : urlWithStartRank(),
                        previousUrl: null,
                        nextUrl    : urlWithStartRank(11),
                        pages      : [
                                pageWith(1, null, true),
                                pageWith(2, 11, false),
                                pageWith(3, 21, false),
                                pageWith(4, 31, false),
                                pageWith(5, 41, false),
                        ]
                ]),
                transaction.response.customData[PagingHookLifecycle.STENCILS_PAGING])
    }

    @Test
    void testMiddlePage() {
        summary.totalMatching = 422
        summary.prevStart = 61
        summary.nextStart = 81
        summary.currStart = 71
        summary.currEnd = 80
        summary.numRanks = 10

        hook.postDatafetch(transaction)

        Assert.assertEquals(
                new PagingControls([
                        firstUrl   : urlWithStartRank(),
                        previousUrl: urlWithStartRank(61),
                        nextUrl    : urlWithStartRank(81),
                        pages      : [
                                pageWith(6, 51, false),
                                pageWith(7, 61, false),
                                pageWith(8, 71, true),
                                pageWith(9, 81, false),
                                pageWith(10, 91, false),
                        ]
                ]),
                transaction.response.customData[PagingHookLifecycle.STENCILS_PAGING])
    }

    @Test
    void testLastPage() {
        summary.totalMatching = 422
        summary.prevStart = 411
        summary.nextStart = null
        summary.currStart = 421
        summary.currEnd = 422
        summary.numRanks = 10

        hook.postDatafetch(transaction)

        Assert.assertEquals(
                new PagingControls([
                        firstUrl   : urlWithStartRank(),
                        previousUrl: urlWithStartRank(411),
                        nextUrl    : null,
                        pages      : [
                                pageWith(41, 401, false),
                                pageWith(42, 411, false),
                                pageWith(43, 421, true),
                        ]
                ]),
                transaction.response.customData[PagingHookLifecycle.STENCILS_PAGING])
    }

    @Test
    void testConfigureNumPages() {
        summary.totalMatching = 422
        summary.prevStart = 61
        summary.nextStart = 81
        summary.currStart = 71
        summary.currEnd = 80
        summary.numRanks = 10

        Mockito.when(config.valueAsInt(PagingHookLifecycle.NUM_PAGES_KEY, PagingHookLifecycle.NUM_PAGES_DEFAULT))
                .thenReturn(9)

        hook.postDatafetch(transaction)

        Assert.assertEquals(
                new PagingControls([
                        firstUrl   : urlWithStartRank(),
                        previousUrl: urlWithStartRank(61),
                        nextUrl    : urlWithStartRank(81),
                        pages      : [
                                pageWith(4, 31, false),
                                pageWith(5, 41, false),
                                pageWith(6, 51, false),
                                pageWith(7, 61, false),
                                pageWith(8, 71, true),
                                pageWith(9, 81, false),
                                pageWith(10, 91, false),
                                pageWith(11, 101, false),
                                pageWith(12, 111, false),
                        ]
                ]),
                transaction.response.customData[PagingHookLifecycle.STENCILS_PAGING])
    }

    @Test
    void testNumRanksZero() {
        summary.totalMatching = 0
        summary.prevStart = 0
        summary.nextStart = 0
        summary.currStart = 0
        summary.currEnd = 0
        summary.numRanks = 0

        hook.postDatafetch(transaction)

        Assert.assertEquals(
                new PagingControls([
                        firstUrl   : urlWithStartRank(),
                        previousUrl: null,
                        nextUrl    : null,
                        pages      : []
                ]),
                transaction.response.customData[PagingHookLifecycle.STENCILS_PAGING])
    }

    @Test
    void testPageWhenStartRankInUrl() {
        ListMultimap<String, String> qs = transaction.question.getQueryStringMapCopy()
        qs.put(PagingHookLifecycle.START_RANK, 11.toString())
        transaction.question.setQueryStringMap(qs)

        summary.totalMatching = 422
        summary.prevStart = 1
        summary.nextStart = 21
        summary.currStart = 11
        summary.currEnd = 20
        summary.numRanks = 10

        hook.postDatafetch(transaction)

        Assert.assertEquals(
                new PagingControls([
                        firstUrl   : urlWithStartRank(),
                        previousUrl: urlWithStartRank(),
                        nextUrl    : urlWithStartRank(21),
                        pages      : [
                                pageWith(1, null, false),
                                pageWith(2, 11, true),
                                pageWith(3, 21, false),
                                pageWith(4, 31, false),
                                pageWith(5, 41, false),
                        ]
                ]),
                transaction.response.customData[PagingHookLifecycle.STENCILS_PAGING])
    }

    private Page pageWith(number, startRank, selected) {
        return new Page([number: number, url: urlWithStartRank(startRank), selected: selected])
    }

    private String urlWithStartRank(startRank) {
        def url = ["param=value"]
        if (startRank) {
            url << PagingHookLifecycle.START_RANK + "=" + startRank.toString()
        }
        return "?" + url.join("&")
    }

}
