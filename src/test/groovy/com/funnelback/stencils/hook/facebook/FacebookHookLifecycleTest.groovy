package com.funnelback.stencils.hook.facebook

import java.text.SimpleDateFormat

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
import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.stencils.util.MockUtils

import freemarker.template.TemplateMethodModelEx

class FacebookHookLifecycleTest {

    def hook
    def config
    def transaction
    def results

    @Before
    void before() {
        hook = new FacebookHookLifecycle()
        config = Mockito.mock(Config.class)

        transaction = new SearchTransaction()
        transaction.question = Mockito.mock(SearchQuestion.class)

        results = [
            MockUtils.mockResult([
                "stencilsFacebookType": "POST",
                "stencilsFacebookPostUserID": "user-id",
                "c": "description #tag"
            ]),
            MockUtils.mockResult([
                "stencilsFacebookType": "EVENT",
                "stencilsFacebookEventUserID": "event-user-id",
                "stencilsFacebookEventStartDateTime": "2015-01-02 12:34:56.7 PST",
                "stencilsFacebookEventEndDateTime": "invalid-end-date"
            ]),
            MockUtils.mockResult([
                "stencilsFacebookType": "PAGE",
                "stencilsFacebookPageID": "page-id",
            ]),
            // Non Facebook result
            MockUtils.mockResult(["author": "Shakespeare"])
        ]

        def customData = [ (StencilHooks.STENCILS_FREEMARKER_METHODS) : [:] ]
        
        transaction.response = Mockito.mock(SearchResponse.class)
        Mockito.when(transaction.response.resultPacket).thenReturn(Mockito.mock(ResultPacket.class))
        Mockito.when(transaction.response.resultPacket.results).thenReturn(results)
        Mockito.when(transaction.response.customData).thenReturn(customData)

        Mockito.when(config.value(StencilHooks.STENCILS_KEY, "")).thenReturn("facebook")
        Mockito.when(transaction.question.collection).thenReturn(new Collection("mock", config))
    }

    @Test
    void testStencilDisabled() {
        Mockito.when(config.value(StencilHooks.STENCILS_KEY, "")).thenReturn("something,else")

        hook.postDatafetch(transaction)

        Mockito.verifyZeroInteractions(transaction.response.resultPacket)
        
        results.each { result ->
            Assert.assertTrue(result.customData.isEmpty())
        }
        
        Assert.assertTrue(transaction.response.customData[StencilHooks.STENCILS_FREEMARKER_METHODS].isEmpty())
    }

    @Test
    void test() {
        hook.postDatafetch(transaction)

        Assert.assertEquals([
            "stencilsFacebookProfileUrl": "//www.facebook.com/user-id",
            "stencilsFacebookProfileImageUrl": "//graph.facebook.com/user-id/picture"
        ],
        results[0].customData)
        
        Assert.assertEquals([
            "stencilsFacebookProfileUrl": "//www.facebook.com/event-user-id",
            "stencilsFacebookProfileImageUrl": "//graph.facebook.com/event-user-id/picture",
            "stencilsFacebookEventStartDate": new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS z").parse("2015-01-02 12:34:56.700 PST"),
            "stencilsFacebookEventEndDate": "invalid-end-date",
            "stencilsFacebookEventIsPast": true
        ],
        results[1].customData)

        Assert.assertEquals([
            "stencilsFacebookPageImageUrl": "//graph.facebook.com/page-id/picture"
        ],
        results[2].customData)
        
        Assert.assertTrue(results[3].customData.isEmpty())
        
        Assert.assertTrue(transaction.response.customData[StencilHooks.STENCILS_FREEMARKER_METHODS]["facebookHashtagify"] instanceof TemplateMethodModelEx)

    }


    @Test
    void testGenerateProfileForId() {
        Assert.assertNull(FacebookHookLifecycle.generateUrlForId(null))
        Assert.assertEquals("", FacebookHookLifecycle.generateUrlForId(""))
        Assert.assertEquals("//www.facebook.com/12345", FacebookHookLifecycle.generateUrlForId("12345"))
        Assert.assertEquals("//www.facebook.com/abcde", FacebookHookLifecycle.generateUrlForId("abcde"))
    }

    @Test
    void testGenerateImageUrlForId() {
        Assert.assertNull(FacebookHookLifecycle.generateImageUrlForId(null))
        Assert.assertEquals("", FacebookHookLifecycle.generateImageUrlForId(""))
        Assert.assertEquals("//graph.facebook.com/12345/picture", FacebookHookLifecycle.generateImageUrlForId("12345"))
        Assert.assertEquals("//graph.facebook.com/abcde/picture", FacebookHookLifecycle.generateImageUrlForId("abcde"))
    }

    @Test
    void testParseFacebookDateTime() {
        Assert.assertNull(FacebookHookLifecycle.parseFacebookDateTime(null))
        Assert.assertEquals("", FacebookHookLifecycle.parseFacebookDateTime(""))
        Assert.assertEquals("invalid date", FacebookHookLifecycle.parseFacebookDateTime("invalid date"))
        Assert.assertEquals(
                new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS z").parse("2015-01-02 12:34:56.700 PST"),
                FacebookHookLifecycle.parseFacebookDateTime("2015-01-02 12:34:56.7 PST"))
    }
    
    @Test
    void testEventIsPast() {
        Assert.assertFalse(FacebookHookLifecycle.isEventPast(null, null))
        Assert.assertFalse(FacebookHookLifecycle.isEventPast("", ""))
        Assert.assertFalse(FacebookHookLifecycle.isEventPast("invalid", "invalid"))
        
        def pastDate = Calendar.getInstance()
        pastDate.add(Calendar.YEAR, -1)
        
        def futureDate = Calendar.getInstance()
        futureDate.add(Calendar.YEAR, 1)
        
        Assert.assertTrue(FacebookHookLifecycle.isEventPast(pastDate.time, "invalid"))
        Assert.assertFalse(FacebookHookLifecycle.isEventPast(futureDate.time, "invalid"))

        Assert.assertTrue(FacebookHookLifecycle.isEventPast("invalid", pastDate.time))
        Assert.assertFalse(FacebookHookLifecycle.isEventPast("invalid", futureDate.time))
        
        Assert.assertTrue(FacebookHookLifecycle.isEventPast(pastDate.time, pastDate.time))
        Assert.assertFalse(FacebookHookLifecycle.isEventPast(futureDate.time, futureDate.time))
        
        // Event in progress
        Assert.assertFalse(FacebookHookLifecycle.isEventPast(pastDate.time, futureDate.time))
    }
}
