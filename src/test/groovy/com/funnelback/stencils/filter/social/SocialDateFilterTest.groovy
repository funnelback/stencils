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
        def docs = [now, future, pastWeek, pastMonth].collect() { date ->
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

        // Configure collection.cfg
        def context = MockFilterContext.emptyContext
        context.setConfigValue(SocialDateFilter.CHRONO_AMOUNT, amount.toString())
        context.setConfigValue(SocialDateFilter.CHRONO_UNIT, unit)

        // Filter all our docs
        def output = []
        docs.each() { doc ->
            output += new SocialDateFilter().filterAsStringDocument(doc, context).filteredDocuments
        }

        Assert.assertEquals("Invalid number of documents returned for ${amount} ${unit}", numDocs, output.size())
    }

}