package com.funnelback.stencils.util

import org.junit.Assert;
import org.xml.sax.SAXException
import org.xml.sax.SAXParseException

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import org.junit.Test;

class XmlUtilsTest {

    @Test
    public void testPermittedXml() throws IOException, SAXException {
        String xml = ("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" +
                "<root><description>ABC</description></root>");

        new XmlUtils().getSecureDocumentBuilder().parse(new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)));
    }

    @Test
    public void testXXEDefense() throws IOException, SAXException {
        def tempFile = File.createTempFile(XmlUtilsTest.class.name, ".tmp");
        try {
            tempFile.write("xyzzy")

            String xml = ("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" +
                    "<!DOCTYPE foo [  <!ELEMENT foo ANY ><!ENTITY xxe SYSTEM \"" + tempFile.toURI() + "\" >]>" +
                    "<root><description>&xxe;ABC</description></root>");

            new XmlUtils().getSecureDocumentBuilder().parse(new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)));

            Assert.fail("Should have thrown an exception for unsupported XML")
        } catch (SAXParseException e) {
            // Good - that's what we expect
        } finally {
            tempFile.delete()
        }
    }
}