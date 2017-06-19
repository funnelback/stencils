package com.funnelback.stencils.hook.core

import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.padre.ResultPacket
import com.funnelback.publicui.search.model.padre.ResultsSummary
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.hook.StencilHooks
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class PagingHookLifecycleTest {

    def hook
    def config
    def transaction
    def summary

    @Before
    void before() {
        hook = new PagingHookLifecycle()

        config = Mockito.mock(Config.class)

        Mockito.when(config.valueAsInt(PagingHookLifecycle.NUM_PAGES_KEY, PagingHookLifecycle.NUM_PAGES_DEFAULT))
                .thenReturn(PagingHookLifecycle.NUM_PAGES_DEFAULT)

        transaction = new SearchTransaction(new SearchQuestion(), new SearchResponse())
        transaction.question.collection = new Collection("collection", config)
        transaction.question.customData[StencilHooks.QUERY_STRING_MAP_KEY] = [
                "param": ["value"]
        ]

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
                        firstUrl   : "?param=value",
                        previousUrl: null,
                        nextUrl    : "?param=value&start_rank=11",
                        pages      : [
                                new Page([
                                        number  : 1,
                                        url     : "?param=value",
                                        selected: true
                                ]),
                                new Page([
                                        number  : 2,
                                        url     : "?param=value&start_rank=11",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 3,
                                        url     : "?param=value&start_rank=21",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 4,
                                        url     : "?param=value&start_rank=31",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 5,
                                        url     : "?param=value&start_rank=41",
                                        selected: false
                                ]),
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
                        firstUrl   : "?param=value",
                        previousUrl: "?param=value&start_rank=61",
                        nextUrl    : "?param=value&start_rank=81",
                        pages      : [
                                new Page([
                                        number  : 6,
                                        url     : "?param=value&start_rank=51",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 7,
                                        url     : "?param=value&start_rank=61",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 8,
                                        url     : "?param=value&start_rank=71",
                                        selected: true
                                ]),
                                new Page([
                                        number  : 9,
                                        url     : "?param=value&start_rank=81",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 10,
                                        url     : "?param=value&start_rank=91",
                                        selected: false
                                ]),
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
                        firstUrl   : "?param=value",
                        previousUrl: "?param=value&start_rank=411",
                        nextUrl    : null,
                        pages      : [
                                new Page([
                                        number  : 41,
                                        url     : "?param=value&start_rank=401",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 42,
                                        url     : "?param=value&start_rank=411",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 43,
                                        url     : "?param=value&start_rank=421",
                                        selected: true
                                ])
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
                        firstUrl   : "?param=value",
                        previousUrl: "?param=value&start_rank=61",
                        nextUrl    : "?param=value&start_rank=81",
                        pages      : [
                                new Page([
                                        number  : 4,
                                        url     : "?param=value&start_rank=31",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 5,
                                        url     : "?param=value&start_rank=41",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 6,
                                        url     : "?param=value&start_rank=51",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 7,
                                        url     : "?param=value&start_rank=61",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 8,
                                        url     : "?param=value&start_rank=71",
                                        selected: true
                                ]),
                                new Page([
                                        number  : 9,
                                        url     : "?param=value&start_rank=81",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 10,
                                        url     : "?param=value&start_rank=91",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 11,
                                        url     : "?param=value&start_rank=101",
                                        selected: false
                                ]),
                                new Page([
                                        number  : 12,
                                        url     : "?param=value&start_rank=111",
                                        selected: false
                                ]),
                        ]
                ]),
                transaction.response.customData[PagingHookLifecycle.STENCILS_PAGING])
    }

}
