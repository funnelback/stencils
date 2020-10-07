package com.funnelback.stencils.filter.xml

import com.funnelback.common.filter.FilterException
import com.funnelback.filter.api.DocumentType
import com.funnelback.filter.api.documents.BytesDocument
import com.funnelback.filter.api.filters.PreFilterCheck
import com.funnelback.filter.api.mock.MockDocuments
import com.funnelback.filter.api.mock.MockFilterContext
import org.junit.Assert
import org.junit.Test
import org.xml.sax.SAXParseException

import java.nio.charset.StandardCharsets

class XmlElementHtmlWrapperXXETest {

    @Test
    void testNotVulnerableToXXE() {
        def tempFile = File.createTempFile(XmlElementHtmlWrapperXXETest.class.name, ".tmp");
        try {
            tempFile.write("xyzzy")

            def mockDoc = MockDocuments.mockEmptyByteDoc()
                    .cloneWithURI(new URI("https://www.example.org"))
                    .cloneWithContent(
                            DocumentType.MIME_XML_TEXT,
                            Optional.of(StandardCharsets.UTF_8),
                            ("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" +
                                    "<!DOCTYPE foo [  <!ELEMENT foo ANY ><!ENTITY xxe SYSTEM \"" + tempFile.toURI() +  "\" >]>" +
                                    "<root>   <description>&xxe;ABC</description></root>").getBytes(StandardCharsets.UTF_8))

            def context = MockFilterContext.emptyContext
            context.setConfigValue(XmlElementHtmlWrapperFilter.CONFIG_KEY_XPATH, "//description")

            new XmlElementHtmlWrapperFilter().filter(mockDoc, context)

            Assert.fail("Should have thrown an exception for unsupported XML")
        } catch (SAXParseException e) {
            // Good - that's what we expect
        } finally {
            tempFile.delete();
        }
    }

}
