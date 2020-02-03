package com.funnelback.stencils.filter.xml

import com.funnelback.common.filter.FilterException
import com.funnelback.filter.api.DocumentType
import com.funnelback.filter.api.filters.PreFilterCheck
import com.funnelback.filter.api.mock.MockDocuments
import com.funnelback.filter.api.mock.MockFilterContext
import org.junit.Assert
import org.junit.Test

import java.nio.charset.StandardCharsets

class XmlDocumentSplitterPreFilterTest {

    @Test
    void testNotXml() {
        def mockDoc = MockDocuments.mockEmptyStringDoc()
                .cloneWithURI(new URI("https://www.example.com"))
                .cloneWithStringContent(DocumentType.MIME_APPLICATION_JSON_TEXT, "")
        def context = MockFilterContext.emptyContext
        context.setConfigValue(XmlDocumentSplitter.SPLIT_BY_XPATH, "/fake_xpath")
        def result = new XmlDocumentSplitter().canFilter(mockDoc, context)

        Assert.assertEquals("Non XML documents should not be filtered", PreFilterCheck.SKIP_FILTER, result)
    }

    @Test()
    void testMissingXPath() {
        def mockDoc = MockDocuments.mockEmptyStringDoc()
                .cloneWithURI(new URI("https://www.example.com"))
                .cloneWithStringContent(DocumentType.MIME_XML_TEXT, "")

        def result = new XmlDocumentSplitter().canFilter(mockDoc, MockFilterContext.emptyContext)
        Assert.assertEquals("Configuration missing XPath should not be filtered", PreFilterCheck.SKIP_FILTER, result)
    }

}
