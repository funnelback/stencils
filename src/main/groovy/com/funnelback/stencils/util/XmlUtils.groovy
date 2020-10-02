package com.funnelback.stencils.util;

import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.ByteArrayInputStream;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;

public class XmlUtils {
    public DocumentBuilder getSecureDocumentBuilder() {
        try {
            DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
            documentBuilderFactory.setNamespaceAware(true);

            Collection<String> XML_FEATURES_TO_DISABLE = Collections.unmodifiableList(Arrays.asList(
                // Features from https://xerces.apache.org/xerces-j/features.html
                "http://xml.org/sax/features/external-general-entities",
                "http://xml.org/sax/features/external-parameter-entities",
                "http://apache.org/xml/features/validation/schema",
                "http://apache.org/xml/features/nonvalidating/load-dtd-grammar",
                "http://apache.org/xml/features/nonvalidating/load-external-dtd",

                // Features from https://xerces.apache.org/xerces2-j/features.html
                "http://apache.org/xml/features/xinclude/fixup-base-uris"
            ));

            documentBuilderFactory.setExpandEntityReferences(false);

            // Set the validating off because it can be mis-used to pull a validation document
            // that is malicious or from the local machine
            documentBuilderFactory.setValidating(false);

            documentBuilderFactory.setXIncludeAware(false);

            documentBuilderFactory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
            documentBuilderFactory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);

            documentBuilderFactory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
            documentBuilderFactory.setAttribute(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");

            // https://owasp.trendmicro.com/main#!/codeBlocks/disableXmlExternalEntities has this
            // though set to false, but I think it's only possible to set if we have some additional
            // xerces and jaxp-api stuff on the classpath for it to be available/relevant
            // As it is, it throws `ParserConfigurationException: Feature 'X' is not recognized.`
            //
            // https://stackoverflow.com/a/58522022/797 is the closest I found to discussion of it.
            //
            //documentBuilderFactory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");

            for (String feature : XML_FEATURES_TO_DISABLE) {
                documentBuilderFactory.setFeature(feature, false);
            }

            DocumentBuilder result = documentBuilderFactory.newDocumentBuilder();

            result.setEntityResolver(new NoOpEntityResolver());

            return result;
        } catch (ParserConfigurationException e) {
            throw new RuntimeException(e);
        }
    }

    private static class NoOpEntityResolver implements EntityResolver {
        public InputSource resolveEntity(String publicId, String systemId) {
            return new InputSource(new ByteArrayInputStream([] as byte[]));
        }
    }
}
