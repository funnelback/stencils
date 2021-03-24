package com.funnelback.stencils.filter.social

import com.funnelback.filter.api.DocumentType
import com.funnelback.filter.api.mock.MockDocuments
import com.funnelback.filter.api.mock.MockFilterContext
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import java.time.ZonedDateTime

/**
 * Test for this is a bit tricky as it's based on date ranges
 * relative to "now". So we dynamically generate test documents
 * from "now" and test them
 */
@RunWith(Parameterized.class)
class SocialDateFilterTest {

    def amount
    def unit
    def numDocs

    SocialDateFilterTest(amount, unit, numDocs) {
        this.amount = amount
        this.unit = unit
        this.numDocs = numDocs
    }

    @Parameterized.Parameters
    static Collection<Object[]> data() {
        // Indicate how many of the dynamically generated docs should be
        // returned depending on the interval configured in collection.cfg
        return [
                [1, "DAYS", 2],
                [2, "WEEKS", 3],
                [1, "YEARS", 4]
        ]
        .collect() { it as Object[] }
    }

    @Test
    void test() {

        def now = ZonedDateTime.now()
        def future = now.plusDays(3)
        def pastWeek = now.minusWeeks(1).minusHours(1)
        def pastMonth = now.minusMonths(1).minusHours(1)

        // Build our fake Tweets
        def tweets = [now, future, pastWeek, pastMonth].collect() { date ->
            """<com.funnelback.socialmedia.twitter.TwitterXmlRecord>
                <createdDate>${SocialDateFilter.TWITTER_DATE_FORMAT.format(date)}</createdDate>
            </com.funnelback.socialmedia.twitter.TwitterXmlRecord>"""
        }.collect() { tweet ->
            MockDocuments.mockEmptyStringDoc()
                    .cloneWithURI(new URI("https://www.example.org"))
                    .cloneWithStringContent(
                    DocumentType.MIME_XML_TEXT,
                    tweet)
        }

        // Build our fake Facebook events
        def fbEvents = [now, future, pastWeek, pastMonth].collect() { date -> 
            """<FacebookXmlRecord>
                <eventStartTime>${SocialDateFilter.FACEBOOK_DATE_FORMAT_EVENT.format(date)}</eventStartTime>
                <type>EVENT</type>
            </FacebookXmlRecord>"""
        }.collect() { event ->
            MockDocuments.mockEmptyStringDoc()
                .cloneWithURI(new URI("https://www.example.org"))
                .cloneWithStringContent(DocumentType.MIME_XML_TEXT, event)
        }

        // Build our fake Facebook posts
        def fbPosts = [now, future, pastWeek, pastMonth].collect() { date -> 
            """<FacebookXmlRecord>
                <postCreatedTime>${SocialDateFilter.FACEBOOK_DATE_FORMAT_POST.format(date)}</postCreatedTime>
                <type>POST</type>
            </FacebookXmlRecord>"""
        }.collect() { post ->
            MockDocuments.mockEmptyStringDoc()
                .cloneWithURI(new URI("https://www.example.org"))
                .cloneWithStringContent(DocumentType.MIME_XML_TEXT, post)
        }

        // Build fake Instagram posts
        def instagramPosts = [now, future, pastWeek, pastMonth].collect { date ->
            """<?xml version="1.0" encoding="utf-8"?>
              <json>
                <media_type>IMAGE</media_type>
                <caption>Happy Veterans Day from FLC.</caption>
                <permalink>https://www.instagram.com/p/R5TpikKcqb/</permalink>
                <timestamp>${SocialDateFilter.INSTAGRAM_DATE_FORMAT.format(date)}</timestamp>
              </json>"""
        }.collect { post ->
            MockDocuments.mockEmptyStringDoc()
                .cloneWithURI(new URI("https://www.example.org"))
                .cloneWithStringContent(DocumentType.MIME_XML_TEXT, post)
        }

        // Configure collection.cfg
        def context = MockFilterContext.emptyContext
        context.setConfigValue(SocialDateFilter.CHRONO_AMOUNT, amount.toString())
        context.setConfigValue(SocialDateFilter.CHRONO_UNIT, unit)

        def instagramContext = MockFilterContext.emptyContext
        instagramContext.setConfigValue(SocialDateFilter.CHRONO_AMOUNT, amount.toString())
        instagramContext.setConfigValue(SocialDateFilter.CHRONO_UNIT, unit)
        instagramContext.setConfigValue(SocialDateFilter.RECORD_TYPE, "instagram")

        // Filter all our docs
        def tweetsOutput = []
        def fbEventsOutput = []
        def fbPostsOutput = []
        def instagramPostsOutput = []
        tweets.each() { tweet ->
            tweetsOutput += new SocialDateFilter().filterAsStringDocument(tweet, context).filteredDocuments
        }
        fbEvents.each() { event ->
            fbEventsOutput += new SocialDateFilter().filterAsStringDocument(event, context).filteredDocuments
        }
        fbPosts.each() { post ->
            fbPostsOutput += new SocialDateFilter().filterAsStringDocument(post, context).filteredDocuments
        }
        instagramPosts.each { post ->
            instagramPostsOutput += new SocialDateFilter().filterAsStringDocument(post, instagramContext).filteredDocuments
        }

        Assert.assertEquals("Invalid number of tweets returned for ${amount} ${unit}", numDocs, tweetsOutput.size())
        Assert.assertEquals("Invalid number of facebook events returned for ${amount} ${unit}", numDocs, fbEventsOutput.size())
        Assert.assertEquals("Invalid number of facebook posts returned for ${amount} ${unit}", numDocs, fbPostsOutput.size())
        Assert.assertEquals("Invalid number of instagram posts returned for ${amount} ${unit}", numDocs, instagramPostsOutput.size())
    }

}