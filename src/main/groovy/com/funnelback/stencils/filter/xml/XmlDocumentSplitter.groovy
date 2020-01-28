package com.funnelback.stencils.filter.xml

@Grapes([
  @Grab(group='us.codecraft', module='xsoup', version='0.3.1')
])

// URI
import java.net.URI

// XML serializing
import groovy.xml.XmlUtil

// Jsoup imports
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import org.jsoup.nodes.Document.OutputSettings
import org.jsoup.nodes.Document.OutputSettings.Syntax
import org.jsoup.nodes.Element
import org.jsoup.select.Elements

// XML imports
import org.jsoup.parser.Parser
import us.codecraft.xsoup.Xsoup
import us.codecraft.xsoup.XElements

// Test framework
import org.junit.*
import org.junit.Test

// Filter Framework
import com.funnelback.filter.api.*
import com.funnelback.filter.api.DocumentType
import com.funnelback.filter.api.documents.*
import com.funnelback.filter.api.filters.*
import com.funnelback.filter.api.mock.*

@groovy.util.logging.Log4j2
public class XmlDocumentSplitter implements StringDocumentFilter {
    
    static final CONFIG_PREFIX = "stencils.filter.xml"
    static final SPLIT_BY_XPATH = "${CONFIG_PREFIX}.split_by_xpath"
    static final URL_NODE = "${CONFIG_PREFIX}.url_node"
    @Override
    public PreFilterCheck canFilter(NoContentDocument document, FilterContext context) {
        String xmlNode = context.getConfigValue(SPLIT_BY_XPATH).orElse(null)
        String urlNode = context.getConfigValue(URL_NODE).orElse(null)
        if (!xmlNode) {
            log.error("collection.cfg key ${SPLIT_BY_XPATH} not set. Filter processing is skipped.")
            return PreFilterCheck.SKIP_FILTER
        }
        if (!urlNode) {
            log.warn("collection.cfg key ${URL_NODE} not set. A URL should be configured in 'XML Processing'.")
        }
        if(document.getDocumentType().isXML()) {
            return PreFilterCheck.ATTEMPT_FILTER
        }
        log.info("Document is not XML, skipping XmlDocumentSplitter filter.")
        return PreFilterCheck.SKIP_FILTER
    }

    @Override
    public FilterResult filterAsStringDocument(StringDocument document, FilterContext context) {
        // Parse the modified document with the XML Parser
        // Explicitly use output settings to maintain correct whitespace
        Document xmlDoc = Jsoup.parse(document.getContentAsString(), "", Parser.xmlParser())
        xmlDoc.outputSettings().syntax(Syntax.xml)
        xmlDoc.outputSettings(new OutputSettings().prettyPrint(false))

        ArrayList<FilterableDocument> docs = new ArrayList<>()

        // Assume split by xpath value is present because of the canFilter method
        String splitByXpath = context.getConfigValue(SPLIT_BY_XPATH).get()
        String urlNode = context.getConfigValue(URL_NODE).orElse(null)
        // If the urlNode is not configured, the indexer will assign a dummy URL during indexing
        // It is possible to still use the indexer XML Processing configuration to assign a URL

        for (Element element : Xsoup.select(xmlDoc, splitByXpath).getElements()) {
            // Get the content of the XML record including the outer tags
            String docContent = element.outerHtml()
            
            // Serialize the output to a standard XML format and parse again
            // This makes it not necessary to need a -forcexml indexer option or ForceXMLMime filter
            // because the standard XML header will be added
            String serializedXml = XmlUtil.serialize(new XmlSlurper().parseText(docContent))
            Document splitXmlDoc = Jsoup.parse(serializedXml, "", Parser.xmlParser())
            splitXmlDoc.outputSettings().syntax(Syntax.xml)
            splitXmlDoc.outputSettings(new OutputSettings().prettyPrint(false))
            // Clone the existing document with the new content
            def doc = document.cloneWithStringContent(document.getDocumentType(), serializedXml)
            if (urlNode) {
                // Assign the configured URL to the document
                String url = Xsoup.select(splitXmlDoc, urlNode).getElements().first().text()
                log.info("Record with '${url}' created.")
                doc = doc.cloneWithURI(URI.create(url))
            }

            docs.add(doc)
        }

        return FilterResult.of(docs)
    }

}
