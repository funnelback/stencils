package com.funnelback.stencils.filter.social


import com.funnelback.filter.api.DocumentType
import com.funnelback.filter.api.mock.MockDocuments
import com.funnelback.filter.api.mock.MockFilterContext
import com.funnelback.stencils.filter.xml.XmlElementHtmlWrapperFilter
import org.junit.Assert
import org.junit.Test
import org.xml.sax.SAXParseException

import java.nio.charset.StandardCharsets

class SocialDateFilterXXETest {

    @Test
    void testNotVulnerableToXXE() {
        def tempFile = File.createTempFile(SocialDateFilterXXETest.class.name, ".tmp");
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
            context.setConfigValue(SocialDateFilter.CHRONO_AMOUNT, "1")
            context.setConfigValue(SocialDateFilter.CHRONO_UNIT, "YEARS")
//            context.setConfigValue(XmlElementHtmlWrapperFilter.CONFIG_KEY_XPATH, "//description")

            new SocialDateFilter().filter(mockDoc, context)

            Assert.fail("Should have thrown an exception for unsupported XML")
        } catch (SAXParseException e) {
            // Good - that's what we expect
        } finally {
            tempFile.delete();
        }
    }

}
