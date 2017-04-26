package com.funnelback.stencils.freemarker.method

import freemarker.template.TemplateHashModelEx
import freemarker.template.TemplateMethodModelEx
import freemarker.template.TemplateModelException
import freemarker.template.TemplateScalarModel

/**
 * FreeMarker method to convert hashtags into links
 *
 * @author nguillaumin@funnelback.com
 */
class HashtagifyMethod implements TemplateMethodModelEx {

    /**
     * Convert hashtags present in a String into links
     * @param args 0:text to replace, 1:base URL to prepend to links,
     *  2 (optional): Additional attributes for the <coda>&lt;a&gt;</code> tag.
     * @return Converted String
     * @throws TemplateModelException
     */
    @Override
    Object exec(List args) throws TemplateModelException {
        
        if (args.size() < 2) {
            throw new TemplateModelException("The base URL to link to must be provided")
        }
        
        def text = ((TemplateScalarModel) args[0]).asString
        def baseUrl = ((TemplateScalarModel) args[1]).asString

        def linkAttributes = " "
        if (args.size() > 2) {
            def hash = ((TemplateHashModelEx) args[2])

            // Can't use Groovy each() here as the FreeMarker iterator
            // does not implement the Java iterator interface :(
            for (def i = hash.keys().iterator(); i.hasNext();)  {
                def key = ((TemplateScalarModel) i.next()).asString
                linkAttributes += "${key}=\"${hash.get(key)}\" "
            }
        }

        return text.replaceAll("#(.+?)\\b", "<a${linkAttributes}href=\"${baseUrl}\$1\">#\$1</a>")

    }

}
