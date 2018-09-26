package com.funnelback.stencils.filter.social

import com.funnelback.common.filter.FilterException
import com.funnelback.filter.api.FilterContext
import com.funnelback.filter.api.FilterResult
import com.funnelback.filter.api.documents.NoContentDocument
import com.funnelback.filter.api.documents.StringDocument
import com.funnelback.filter.api.filters.PreFilterCheck
import com.funnelback.filter.api.filters.StringDocumentFilter
import com.funnelback.socialmedia.twitter.TwitterXmlRecord
import groovy.util.logging.Log4j2

import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit

/**
 * Filter to drop social media records that are older than a certain date.
 *
 * Usually social media posts or tweets that are too old (older than a year say)
 * are not very useful to have in search and count towards the license limit.
 * This filter will "drop" any document that is older than a certain date. The date
 * interval is configured in <code>collection.cfg</code>
 *
 * @author nguillaumin@funnelback.com
 */
@Log4j2
class SocialDateFilter implements StringDocumentFilter {

    static final CONFIG_PREFIX = "stencils.filter.social.drop"
    static final CHRONO_UNIT = "${CONFIG_PREFIX}.unit"
    static final CHRONO_AMOUNT = "${CONFIG_PREFIX}.amount"

    /** Slurper to parse the social media record */
    def xmlSlurper = new XmlSlurper()

    /** Current date we will be comparing to */
    def now = ZonedDateTime.now()

    /** Date format for Twitter */
    static final def TWITTER_DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S z")

    @Override
    PreFilterCheck canFilter(NoContentDocument noContentDocument, FilterContext filterContext) {
        // Only filter XML records
        if (noContentDocument.documentType.XML) {
            return PreFilterCheck.ATTEMPT_FILTER
        }

        log.warn("Skipping filtering for {}, type: {}. Only XML type is supported", noContentDocument.URI, noContentDocument.documentType)
        return PreFilterCheck.SKIP_FILTER
    }

    @Override
    FilterResult filterAsStringDocument(StringDocument stringDocument, FilterContext filterContext) {
        // Ensure we have our configuration settings
        if (!filterContext.getConfigValue(CHRONO_UNIT).isPresent()
            || !filterContext.getConfigValue(CHRONO_AMOUNT).isPresent()) {
            throw new FilterException("Missing configuration parameters ${CHRONO_UNIT} or ${CHRONO_AMOUNT}")
        }

        // Compute the minimum date for the social media records
        def chronoUnit = ChronoUnit.valueOf(filterContext.getConfigValue(CHRONO_UNIT).get().toUpperCase())
        def chronoAmount = filterContext.getConfigValue(CHRONO_AMOUNT).get().toInteger()
        def minDate = now.minus(chronoAmount, chronoUnit)

        // Parse our social media XML record
        def xml = xmlSlurper.parseText(stringDocument.contentAsString)
        def output = stringDocument

        // Find the date, depending of the social media platform
        def date = null
        switch (xml.name()) {
            case TwitterXmlRecord.class.name:
                date = ZonedDateTime.parse(xml.createdDate.text(), TWITTER_DATE_FORMAT)
                break
        }

        // Check if date is in range
        if (date != null && date.isBefore(minDate)) {
            output = []
            log.info("Dropping {} ({} is older than than {} {}: {})", stringDocument.URI, date, chronoAmount, chronoUnit.name().toLowerCase(), minDate)
        } else {
            log.debug("Keeping {} ({} is after {})", stringDocument.URI, date, minDate)
        }

        return FilterResult.of(output)
    }
}
