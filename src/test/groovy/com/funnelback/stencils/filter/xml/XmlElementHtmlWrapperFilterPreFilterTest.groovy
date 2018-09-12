package com.funnelback.stencils.filter.xml

import com.funnelback.common.filter.FilterException
import com.funnelback.filter.api.DocumentType
import com.funnelback.filter.api.filters.PreFilterCheck
import com.funnelback.filter.api.mock.MockDocuments
import com.funnelback.filter.api.mock.MockFilterContext
import org.junit.Assert
import org.junit.Test

import java.nio.charset.StandardCharsets

class XmlElementHtmlWrapperFilterPreFilterTest {

    @Test
    void testNotXml() {
        def mockDoc = MockDocuments.mockEmptyByteDoc()
                .cloneWithURI(new URI("https://www.example.org"))
                .cloneWithContent(
                DocumentType.MIME_APPLICATION_JSON_TEXT,
                Optional.of(StandardCharsets.UTF_8),
                new byte[0])

        def result = new XmlElementHtmlWrapperFilter().canFilter(mockDoc, MockFilterContext.emptyContext)

        Assert.assertEquals("Non XML documents should not be filtered", PreFilterCheck.SKIP_FILTER, result)
    }

    @Test(expected = FilterException.class)
    void testMissingXPath() {
        def mockDoc = MockDocuments.mockEmptyByteDoc()
                .cloneWithURI(new URI("https://www.example.org"))
                .cloneWithContent(
                DocumentType.MIME_XML_TEXT,
                Optional.of(StandardCharsets.UTF_8),
                new byte[0])

        def result = new XmlElementHtmlWrapperFilter().canFilter(mockDoc, MockFilterContext.emptyContext)
    }

}
