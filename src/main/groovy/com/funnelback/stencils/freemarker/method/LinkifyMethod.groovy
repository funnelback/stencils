package com.funnelback.stencils.freemarker.method

import freemarker.template.TemplateHashModelEx
import freemarker.template.TemplateMethodModelEx
import freemarker.template.TemplateModelException
import freemarker.template.TemplateScalarModel

/**
 * FreeMarker method to convert URLs into links
 *
 * @author nguillaumin@funnelback.com
 */
class LinkifyMethod implements TemplateMethodModelEx {

    @Override
    Object exec(List args) throws TemplateModelException {
        if (args.size() < 1) {
            throw new TemplateModelException("The URL to link must be provided")
        }

        def url = ((TemplateScalarModel) args[0]).asString

        def linkAttributes = " "
        if (args.size() > 1) {
            def hash = ((TemplateHashModelEx) args[1])

            // Can't use Groovy each() here as the FreeMarker iterator
            // does not implement the Java iterator interface :(
            for (def i = hash.keys().iterator(); i.hasNext();)  {
                def key = ((TemplateScalarModel) i.next()).asString
                linkAttributes += "${key}=\"${hash.get(key)}\" "
            }
        }

        return url.replaceAll("(https?://[\\S]+)", "<a${linkAttributes}href=\"\$1\">\$1</a>")
    }
}
