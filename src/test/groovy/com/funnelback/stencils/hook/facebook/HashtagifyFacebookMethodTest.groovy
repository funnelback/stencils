package com.funnelback.stencils.hook.facebook

import org.junit.Assert
import org.junit.Before
import org.junit.Test

import freemarker.template.SimpleHash
import freemarker.template.SimpleScalar

class HashtafiyMethodTest {

    def method
    
    @Before
    void before() {
        method = new HashtagifyFacebookMethod()
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
    void testNoHashtags() {
        Assert.assertEquals(
            "content no hashtag",
            method.exec([new SimpleScalar("content no hashtag")]))

    }

    @Test
    void testHashtags() {
        Assert.assertEquals(
            "content <a href=\"//facebook.com/hashtag/with\">#with</a> <a href=\"//facebook.com/hashtag/hashtags\">#hashtags</a>",
            method.exec([new SimpleScalar("content #with #hashtags")]))
    }

    @Test
    void testAttributes() {
        Assert.assertEquals(
            "content <a class=\"tag\" target=\"_blank\" random=\"value\" href=\"//facebook.com/hashtag/with\">#with</a> "
            + "<a class=\"tag\" target=\"_blank\" random=\"value\" href=\"//facebook.com/hashtag/hashtags\">#hashtags</a>",
            method.exec([
                new SimpleScalar("content #with #hashtags"),
                new SimpleHash([
                    "class": "tag",
                    "target": "_blank",
                    "random": "value"
                ])
            ]))
        
    }
}