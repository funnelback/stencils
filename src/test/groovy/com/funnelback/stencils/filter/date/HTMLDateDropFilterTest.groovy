package com.funnelback.stencils.filter.date

import com.funnelback.filter.api.DocumentType
import com.funnelback.filter.api.mock.MockDocuments
import com.funnelback.filter.api.mock.MockFilterContext
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter

@RunWith(Parameterized.class)
class HTMLDateDropFilterTest {

    def amount
    def unit
    def numDocs

    HTMLDateDropFilterTest(amount, unit, numDocs) {
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

        def dateFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy")

        // Build our fake documents
        def docs = [now, future, pastWeek, pastMonth].collect() { date ->
            """<html>
                <head>
                    <title>Doc</title>
                    <meta name="created_date" content="${dateFormat.format(date)}">
                </head>
                <body>
                    Lorem Ipsum...
                </body>
                </html>"""
        }.collect() { doc ->
            MockDocuments.mockEmptyStringDoc()
                    .cloneWithURI(new URI("https://www.example.org"))
                    .cloneWithStringContent(
                    DocumentType.MIME_HTML_TEXT,
                    doc)
        }

        // Configure collection.cfg
        def context = MockFilterContext.emptyContext
        context.setConfigValue(HTMLDateDropFilter.CHRONO_AMOUNT, amount.toString())
        context.setConfigValue(HTMLDateDropFilter.CHRONO_UNIT, unit)
        context.setConfigValue(HTMLDateDropFilter.JSOUP_SELECTOR, "meta[name=created_date]")
        context.setConfigValue(HTMLDateDropFilter.JSOUP_SELECTOR_ATTRIBUTE, "content")
        context.setConfigValue(HTMLDateDropFilter.DOCUMENT_DATE_FORMAT, "dd/MM/yyyy")

        // Filter all our docs
        def output = []
        docs.each() { doc ->
            output += new HTMLDateDropFilter().filterAsStringDocument(doc, context).filteredDocuments
        }

        Assert.assertEquals("Invalid number of documents returned for ${amount} ${unit}", numDocs, output.size())
    }

}
