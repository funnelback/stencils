package com.funnelback.stencils.filter.xml

import com.funnelback.common.filter.FilterException
import com.funnelback.filter.api.DocumentType
import com.funnelback.filter.api.FilterContext
import com.funnelback.filter.api.FilterResult
import com.funnelback.filter.api.documents.BytesDocument
import com.funnelback.filter.api.documents.NoContentDocument
import com.funnelback.filter.api.filters.BytesDocumentFilter
import com.funnelback.filter.api.filters.PreFilterCheck
import com.funnelback.stencils.util.XmlUtils
import groovy.util.logging.Log4j2

import javax.xml.parsers.DocumentBuilderFactory
import javax.xml.transform.OutputKeys
import javax.xml.transform.TransformerFactory
import javax.xml.transform.dom.DOMSource
import javax.xml.transform.stream.StreamResult
import javax.xml.xpath.XPathConstants
import javax.xml.xpath.XPathFactory

/**
 * Filter to wrap a specific XML element into &lt;html&gt; tags
 *
 * This is necessary for PADRE to parse the content of the element as HTML
 * and interpret HTML tags, rather than raw text. Expected to be used when
 * mapping an XML tag to an inner HTML document.
 *
 * The element to wrap is configured via XPath in <code>collection.cfg</code>
 *
 * @author nguillaumin@funnnelback.com
 */
@Log4j2
class XmlElementHtmlWrapperFilter implements BytesDocumentFilter {

    /** XPath of the element to wrap, from <code>collection.cfg</code> */
    static final String CONFIG_KEY_XPATH = "stencils.filter.xml.html_wrapper.xpath"

    /** DocumentBuilder to parse our XML */
    def documentBuilder = new XmlUtils().getSecureDocumentBuilder()
    /** XPath to evaluate the XPath expression */
    def xPath = XPathFactory.newInstance().newXPath()
    /** Transformer to serialize the XML object back into a String */
    def transformer = TransformerFactory.newInstance().newTransformer()

    XmlElementHtmlWrapperFilter() {
        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
        transformer.setOutputProperty(OutputKeys.METHOD, "xml");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
    }

    @Override
    PreFilterCheck canFilter(NoContentDocument noContentDocument, FilterContext filterContext) {
        // Only attempt to filter XML content
        if (noContentDocument.documentType.equals(DocumentType.MIME_XML_TEXT)) {
            // Ensure we have the settings we need
            if (filterContext.getConfigValue(CONFIG_KEY_XPATH).isPresent()) {
                return PreFilterCheck.ATTEMPT_FILTER
            } else {
                throw new FilterException("Missing configuration ${CONFIG_KEY_XPATH}")
            }
        }

        log.info("Unsupported document type {} for {}. Only XML can be processed by this filter",
                noContentDocument.documentType, noContentDocument.URI)
        return PreFilterCheck.SKIP_FILTER
    }

    @Override
    FilterResult filterAsBytesDocument(BytesDocument document, FilterContext filterContext) {
        def xPathExpression = filterContext.getConfigValue(CONFIG_KEY_XPATH).get()
        document.contentAsInputStream().withStream() { is ->
            def doc = documentBuilder.parse(is)

            def nodeList = (org.w3c.dom.NodeList) xPath.evaluate(
                    xPathExpression,
                    doc, XPathConstants.NODESET)

            nodeList.each() { node ->
                node.textContent = "<html>${node.textContent}</html>"
            }

            if (nodeList.length > 0) {
                log.info("Wrapped ${nodeList.length} x '${xPathExpression}' elements in HTML tags")
            }

            def bos = new ByteArrayOutputStream()
            transformer.transform(new DOMSource(doc), new StreamResult(bos))

            return FilterResult.of(document.cloneWithContent(document.documentType, document.charset, bos.toByteArray()))
        }
    }
}
