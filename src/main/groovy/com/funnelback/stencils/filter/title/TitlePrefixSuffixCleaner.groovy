package com.funnelback.stencils.filter.title

import com.funnelback.common.filter.jsoup.FilterContext
import com.funnelback.common.filter.jsoup.IJSoupFilter
import com.funnelback.common.filter.jsoup.SetupContext
import groovy.util.logging.Log4j2

import java.util.regex.Pattern

/**
 * <p>A JSoup filter to remove prefixes and suffixes from document titles,
 * usually SEO-style suffixes like in "Products | Funnelback"</p>
 *
 * <p>The prefix / suffix regular expression patterns to remove are configured
 * in <code>collection.cfg</code></p>
 */
@Log4j2
class TitlePrefixSuffixCleaner implements IJSoupFilter {

    /** Name of the namespace for the config settings in collection.cfg */
    static final String CONFIG_KEY_NAMESPACE = "stencils.filter.title"

    /** Regular expression to strip prefixes */
    Pattern prefixPattern
    /** Regular expression to strip suffixes */
    Pattern suffixPattern

    @Override
    void setup(SetupContext setup) {
        def prefix = setup.getConfigSetting("${CONFIG_KEY_NAMESPACE}.strip-prefix")
        if (prefix) {
            prefixPattern = Pattern.compile(prefix)
        }

        def suffix = setup.getConfigSetting("${CONFIG_KEY_NAMESPACE}.strip-suffix")
        if (suffix) {
            suffixPattern = Pattern.compile(suffix)
        }

        log.info("Configured filter with prefix pattern '${prefixPattern}' and suffix pattern '${suffixPattern}'")
    }

    @Override
    void processDocument(FilterContext filterContext) {
        def title = filterContext.document.title()

        if (title && (prefixPattern || suffixPattern)) {
            if (prefixPattern) {
                title = prefixPattern.matcher(title).replaceAll("")
            }
            if (suffixPattern) {
                title = suffixPattern.matcher(title).replaceAll("")
            }

            filterContext.document.title(title)
        }
    }
}
