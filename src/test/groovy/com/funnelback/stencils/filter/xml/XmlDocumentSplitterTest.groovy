package com.funnelback.stencils.filter.xml

import com.funnelback.filter.api.DocumentType
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
class XmlDocumentSplitterTest {

    def xml
    def xPath
    def expectedDocs
    def urlNode

    XmlDocumentSplitterTest(String xml, String xPath, int expectedDocs, String urlNode) {
        this.xml = xml
        this.xPath = xPath
        this.expectedDocs = expectedDocs
        this.urlNode = urlNode
    }

    @Parameterized.Parameters
    static Collection<Object[]> data() {
        return [
                // Absolute X-Paths
                ["""<products>
                        <product>
                            <name>Braided 4K HDMI to HDMI Cable 3-Foot</name>
                            <price>5.94</price>
                            <image_url>https://www.example.com/products/images/hdmi-3foot</image_url>
                            <url>https://www.example.com/products/hdmi-3foot</url>
                            <description>Meets the latest HDMI standards (4K video at 60 Hz, 2160p, 48 bit/px color depth); supports bandwidth up to 18 Gbps; backwards compatible with earlier versions</description>
                        </product>
                        <product>
                            <name>USB 2.0 Printer Type Cable 16-Feet</name>
                            <price>6.44</price>
                            <image_url>https://www.example.com/products/images/usb-a-b-16foot</image_url>
                            <url>https://www.example.com/products/usb-a-b-16foot</url>
                            <description>One 16-foot-long high-speed multi-shielded USB 2.0 A-Male to B-Male cable. Connects mice, keyboards, and speed-critical devices, such as external hard drives, printers, and cameras to your computer</description>
                        </product>
                        <product>
                            <name>USB 3.0 Cable, Type A to Type A, 16-Feet</name>
                            <price>5.99</price>
                            <image_url>https://www.example.com/products/images/usb-a-a-16foot</image_url>
                            <url>https://www.example.com/products/usb-a-a-16foot</url>
                            <description>USB 3.0 A Extension. High performance USB 3.0 Male to Male cable connects USB host computers with USB 3.0 type A port to USB peripherals</description>
                        </product>
                    </products>""",
                    "/products/product",
                    3,
                    "/product/url",
                ],
                // relative X-Paths
                ["""<products>
                        <product>
                            <name>Braided 4K HDMI to HDMI Cable 3-Foot</name>
                            <price>5.94</price>
                            <image_url>https://www.example.com/products/images/hdmi-3foot</image_url>
                            <url>https://www.example.com/products/hdmi-3foot</url>
                            <description>Meets the latest HDMI standards (4K video at 60 Hz, 2160p, 48 bit/px color depth); supports bandwidth up to 18 Gbps; backwards compatible with earlier versions</description>
                        </product>
                        <product>
                            <name>USB 2.0 Printer Type Cable 16-Feet</name>
                            <price>6.44</price>
                            <image_url>https://www.example.com/products/images/usb-a-b-16foot</image_url>
                            <url>https://www.example.com/products/usb-a-b-16foot</url>
                            <description>One 16-foot-long high-speed multi-shielded USB 2.0 A-Male to B-Male cable. Connects mice, keyboards, and speed-critical devices, such as external hard drives, printers, and cameras to your computer</description>
                        </product>
                        <product>
                            <name>USB 3.0 Cable, Type A to Type A, 16-Feet</name>
                            <price>5.99</price>
                            <image_url>https://www.example.com/products/images/usb-a-a-16foot</image_url>
                            <url>https://www.example.com/products/usb-a-a-16foot</url>
                            <description>USB 3.0 A Extension. High performance USB 3.0 Male to Male cable connects USB host computers with USB 3.0 type A port to USB peripherals</description>
                        </product>
                    </products>""",
                    "//product",
                    3,
                    "//url",
                ],
        ]
        .collect() { it as Object[] }
    }

    @Test
    void test() {
        def mockDoc = MockDocuments.mockEmptyStringDoc()
                .cloneWithURI(new URI("https://www.example.com"))
                .cloneWithStringContent(DocumentType.MIME_XML_TEXT, xml)

        def context = MockFilterContext.emptyContext
        context.setConfigValue(XmlDocumentSplitter.SPLIT_BY_XPATH, xPath)
        context.setConfigValue(XmlDocumentSplitter.URL_NODE, urlNode)

        def result = new XmlDocumentSplitter().filterAsStringDocument(mockDoc, context)

        Assert.assertEquals("${expectedDocs} document should have been returned", expectedDocs, result.filteredDocuments.size())

        def firstDoc = result.filteredDocuments.first()

        Assert.assertEquals("Filtered document should be of XML type", DocumentType.MIME_XML_TEXT, firstDoc.documentType)
        Assert.assertEquals("https://www.example.com/products/hdmi-3foot", firstDoc.getURI().toString())
    }
}
