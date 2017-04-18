package com.funnelback.stencils.hook.facebook

import com.funnelback.stencils.freemarker.method.HashtagifyMethod

import freemarker.template.SimpleScalar
import freemarker.template.TemplateModelException

/**
 * FreeMarker method to convert hashtags into Facebook links
 *
 * @author nguillaumin@funnelback.com
 */

class HashtagifyFacebookMethod extends HashtagifyMethod {

    /** Use protocol-less URL for http(s) compatibility */
    static String FACEBOOK_HASHTAG_BASE_URL = "//facebook.com/hashtag/"

    @Override
    Object exec(List args) throws TemplateModelException {
        
        if (args.size() < 2) {
            // Content only, no custom attributes
            return super.exec([args[0], new SimpleScalar(FACEBOOK_HASHTAG_BASE_URL)])
        } else {
            // Pass custom attributes along
            return super.exec([args[0], new SimpleScalar(FACEBOOK_HASHTAG_BASE_URL), args[1]])
        }
    }

}
