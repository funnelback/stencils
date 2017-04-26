package com.funnelback.stencils.freemarker.method

import org.junit.Assert
import org.junit.Before
import org.junit.Test

import freemarker.template.SimpleHash
import freemarker.template.SimpleScalar

class HashtafiyMethodTest {

    def method
    
    @Before
    void before() {
        method = new HashtagifyMethod()
    }

    @Test
    void testMissingParameters() {
        try {
            method.exec([])
            Assert.fail("Should have failed with no content")
        } catch (e) {
        }

        try {
            method.exec([new SimpleScalar("content")])
            Assert.fail("Should have failed with no base url")
        } catch (e) {
        }
    }

    @Test
    void testNoHashtags() {
        Assert.assertEquals(
            "content no hashtag",
            method.exec([new SimpleScalar("content no hashtag"), new SimpleScalar("//example.org/tag/")]))

    }

    @Test
    void testHashtags() {
        Assert.assertEquals(
            "content <a href=\"//example.org/tag/with\">#with</a> <a href=\"//example.org/tag/hashtags\">#hashtags</a>",
            method.exec([new SimpleScalar("content #with #hashtags"), new SimpleScalar("//example.org/tag/")]))
    }

    @Test
    void testAttributes() {
        Assert.assertEquals(
            "content <a class=\"tag\" target=\"_blank\" random=\"value\" href=\"//example.org/tag/with\">#with</a> "
            + "<a class=\"tag\" target=\"_blank\" random=\"value\" href=\"//example.org/tag/hashtags\">#hashtags</a>",
            method.exec([
                new SimpleScalar("content #with #hashtags"),
                new SimpleScalar("//example.org/tag/"),
                new SimpleHash([
                    "class": "tag",
                    "target": "_blank",
                    "random": "value"
                ])
            ]))
        
    }
}