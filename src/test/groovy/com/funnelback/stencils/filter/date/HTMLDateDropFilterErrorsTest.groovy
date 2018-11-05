package com.funnelback.stencils.filter.date

import com.funnelback.filter.api.DocumentType
import com.funnelback.filter.api.mock.MockDocuments
import com.funnelback.filter.api.mock.MockFilterContext
import org.junit.Assert
import org.junit.Test

class HTMLDateDropFilterErrorsTest {

    @Test
    void test() {
        def context = MockFilterContext.emptyContext

        try {
            new HTMLDateDropFilter().filterAsStringDocument(MockDocuments.mockEmptyStringDoc(), context)
            Assert.fail("Should have reported missing parameters")
        } catch (e) { }

        try {
            context.setConfigValue(HTMLDateDropFilter.CHRONO_AMOUNT, "1")
            new HTMLDateDropFilter().filterAsStringDocument(MockDocuments.mockEmptyStringDoc(), context)
            Assert.fail("Should have reported missing parameters")
        } catch (e) { }

        try {
            context.setConfigValue(HTMLDateDropFilter.CHRONO_UNIT, "YEARS")
            new HTMLDateDropFilter().filterAsStringDocument(MockDocuments.mockEmptyStringDoc(), context)
            Assert.fail("Should have reported missing parameters")
        } catch (e) { }

        try {
            context.setConfigValue(HTMLDateDropFilter.JSOUP_SELECTOR, "meta[name=created_date]")
            new HTMLDateDropFilter().filterAsStringDocument(MockDocuments.mockEmptyStringDoc(), context)
            Assert.fail("Should have reported missing parameters")
        } catch (e) { }


        // All parameters are present now, so it should not fail
        context.setConfigValue(HTMLDateDropFilter.DOCUMENT_DATE_FORMAT, "dd/MM/yyyy")
        new HTMLDateDropFilter().filterAsStringDocument(MockDocuments.mockEmptyStringDoc(), context)
    }

    @Test
    void testNoDateInDoc() {
        def doc = MockDocuments.mockEmptyStringDoc()
                .cloneWithURI(new URI("https://www.example.org"))
                .cloneWithStringContent(
                DocumentType.MIME_HTML_TEXT,
                "<html><body>Test</body></html>")

        def context = MockFilterContext.emptyContext
        context.setConfigValue(HTMLDateDropFilter.CHRONO_AMOUNT, "1")
        context.setConfigValue(HTMLDateDropFilter.CHRONO_UNIT, "MONTHS")
        context.setConfigValue(HTMLDateDropFilter.JSOUP_SELECTOR, "span.date")
        context.setConfigValue(HTMLDateDropFilter.DOCUMENT_DATE_FORMAT, "dd/MM/yyyy")

        def output = new HTMLDateDropFilter().filterAsStringDocument(doc, context).filteredDocuments

        Assert.assertEquals("Only one doc (the original) should have been returned", 1, output.size())
        Assert.assertEquals("Original doc should have been returned", doc, output.first())
    }

    @Test
    void testFailureToParseDate() {
        def doc = MockDocuments.mockEmptyStringDoc()
                .cloneWithURI(new URI("https://www.example.org"))
                .cloneWithStringContent(
                DocumentType.MIME_HTML_TEXT,
                "<html><body>Test<span class='date'>INVALID DATE</span></body></html>")

        def context = MockFilterContext.emptyContext
        context.setConfigValue(HTMLDateDropFilter.CHRONO_AMOUNT, "1")
        context.setConfigValue(HTMLDateDropFilter.CHRONO_UNIT, "MONTHS")
        context.setConfigValue(HTMLDateDropFilter.JSOUP_SELECTOR, "span.date")
        context.setConfigValue(HTMLDateDropFilter.DOCUMENT_DATE_FORMAT, "dd/MM/yyyy")

        def output = new HTMLDateDropFilter().filterAsStringDocument(doc, context).filteredDocuments

        Assert.assertEquals("Only one doc (the original) should have been returned", 1, output.size())
        Assert.assertEquals("Original doc should have been returned", doc, output.first())
    }
}
