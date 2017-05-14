package com.funnelback.stencils.freemarker.method

import freemarker.template.SimpleHash
import freemarker.template.SimpleScalar
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class LinkifyMethodTest {

    def method

    @Before
    void before() {
        method = new LinkifyMethod()
    }

    @Test
    void testMissingParameters() {
        try {
            method.exec([])
            Assert.fail("Should have failed with no content")
        } catch (e) {
        }
    }

    @Test
    void testNoUrls() {
        Assert.assertEquals(
                "content no urls",
                method.exec([new SimpleScalar("content no urls")]))
    }

    @Test
    void testUrls() {
        Assert.assertEquals(
                "content <a href=\"http://example.org/with\">http://example.org/with</a> some <a href=\"https://www.example.org/links.html\">https://www.example.org/links.html</a> ...",
                method.exec([new SimpleScalar("content http://example.org/with some https://www.example.org/links.html ...")]))
    }

    @Test
    void testNonHttpUrl() {
        Assert.assertEquals(
                "FTP link: ftp://example.org/directory/",
                method.exec([new SimpleScalar("FTP link: ftp://example.org/directory/")]))
    }

    @Test
    void testAttributes() {
        Assert.assertEquals(
                "content <a class=\"tag\" target=\"_blank\" random=\"value\" href=\"http://example.org/with\">http://example.org/with</a> "
                + "some <a class=\"tag\" target=\"_blank\" random=\"value\" href=\"https://www.example.org/links.html\">https://www.example.org/links.html</a> ...",
                method.exec([
                        new SimpleScalar("content http://example.org/with some https://www.example.org/links.html ..."),
                        new SimpleHash([
                                "class": "tag",
                                "target": "_blank",
                                "random": "value"
                        ])
                ]))

    }

}
