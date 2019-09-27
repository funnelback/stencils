package com.funnelback.stencils.filter.xml

import com.funnelback.filter.api.DocumentType
import com.funnelback.filter.api.documents.BytesDocument
import com.funnelback.filter.api.documents.StringDocument
import com.funnelback.filter.api.mock.MockDocuments
import com.funnelback.filter.api.mock.MockFilterContext
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import java.nio.charset.Charset
import java.nio.charset.StandardCharsets

@RunWith(Parameterized.class)
class XmlElementHtmlWrapperFilterTest {

    def xml
    def xPath
    def expected

    XmlElementHtmlWrapperFilterTest(String xml, String xPath, String expected) {
        this.xml = xml
        this.xPath = xPath
        this.expected = expected
    }

    @Parameterized.Parameters
    static Collection<Object[]> data() {
        return [
                [   "<root>   <description>ABC</description></root>",
                    "//description",
                    "<root>   <description>&lt;html&gt;ABC&lt;/html&gt;</description></root>"
                ],
                [
                    "<root>   <description>ABC</description></root>",
                    "//nonexistent",
                    "<root>   <description>ABC</description></root>"
                ],
                [   "<root>   <withEncodedChars>&amp;__</withEncodedChars></root>",
                    "//withEncodedChars",
                    "<root>   <withEncodedChars>&lt;html&gt;&amp;__&lt;/html&gt;</withEncodedChars></root>"
                ],
                [   "<root>   <empty></empty></root>",
                    "/root/empty",
                    "<root>   <empty>&lt;html&gt;&lt;/html&gt;</empty></root>"
                ],
        ]
        .collect() { it as Object[] }
    }


    @Test
    void test() {
        def mockDoc = MockDocuments.mockEmptyByteDoc()
                .cloneWithURI(new URI("https://www.example.org"))
                .cloneWithContent(
                    DocumentType.MIME_XML_TEXT,
                    Optional.of(StandardCharsets.UTF_8),
                    xml.bytes)

        def context = MockFilterContext.emptyContext
        context.setConfigValue(XmlElementHtmlWrapperFilter.CONFIG_KEY_XPATH, xPath)

        def result = new XmlElementHtmlWrapperFilter().filterAsBytesDocument(mockDoc, context)

        Assert.assertEquals("1 document should have been returned", 1, result.filteredDocuments.size())

        def resultDoc = (BytesDocument) result.filteredDocuments.first()

        Assert.assertEquals("Filtered document should be of XML type", DocumentType.MIME_XML_TEXT, resultDoc.documentType)
        Assert.assertEquals(
                '<?xml version="1.0" encoding="UTF-8"?>' + expected.replaceAll(System.lineSeparator(), ""),
                new String(resultDoc.copyOfContents).replaceAll(System.lineSeparator(), ""))
    }
}
