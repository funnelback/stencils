package com.funnelback.stencils.filter.date

import com.funnelback.common.filter.FilterException
import com.funnelback.filter.api.FilterContext
import com.funnelback.filter.api.FilterResult
import com.funnelback.filter.api.documents.NoContentDocument
import com.funnelback.filter.api.documents.StringDocument
import com.funnelback.filter.api.filters.PreFilterCheck
import com.funnelback.filter.api.filters.StringDocumentFilter
import groovy.util.logging.Log4j2
import org.jsoup.Jsoup

import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit

/**
 * Filter to drop HTML documents that are older than the configured
 * retention period.
 *
 * @author nguillaumin@funnelback.com
 */
@Log4j2
class HTMLDateDropFilter implements StringDocumentFilter {

    static final CONFIG_PREFIX = "stencils.filter.date.drop"
    static final JSOUP_SELECTOR = "${CONFIG_PREFIX}.jsoup_selector"
    static final JSOUP_SELECTOR_ATTRIBUTE = "${CONFIG_PREFIX}.jsoup_selector.attribute"
    static final DOCUMENT_DATE_FORMAT = "${CONFIG_PREFIX}.document_date_format"
    static final CHRONO_UNIT = "${CONFIG_PREFIX}.unit"
    static final CHRONO_AMOUNT = "${CONFIG_PREFIX}.amount"

    /** Current date we will be comparing to */
    def now = LocalDate.now()

    @Override
    PreFilterCheck canFilter(NoContentDocument noContentDocument, FilterContext filterContext) {
        // Only work with HTML documents
        if (noContentDocument.documentType.HTML) {
            return PreFilterCheck.ATTEMPT_FILTER
        }

        log.debug("Skipping filtering for {}, type: {}. Only HTML type is supported", noContentDocument.URI, noContentDocument.documentType)
        return PreFilterCheck.SKIP_FILTER
    }

    @Override
    FilterResult filterAsStringDocument(StringDocument stringDocument, FilterContext filterContext) {
        // Ensure we have our configuration settings
        if (!filterContext.getConfigValue(CHRONO_UNIT).isPresent()
                || !filterContext.getConfigValue(CHRONO_AMOUNT).isPresent()
                || !filterContext.getConfigValue(JSOUP_SELECTOR).isPresent()
                || !filterContext.getConfigValue(DOCUMENT_DATE_FORMAT).isPresent()) {
            throw new FilterException("Missing required configuration parameters: " +
                    [CHRONO_UNIT, CHRONO_AMOUNT, JSOUP_SELECTOR, DOCUMENT_DATE_FORMAT].join(", "))
        }

        // Compute the minimum date to keep
        def chronoUnit = ChronoUnit.valueOf(filterContext.getConfigValue(CHRONO_UNIT).get().toUpperCase())
        def chronoAmount = filterContext.getConfigValue(CHRONO_AMOUNT).get().toInteger()
        def minDate = now.minus(chronoAmount, chronoUnit)

        // Parse our HTML document into JSOUP and select the element containing the date
        def jsoup = Jsoup.parse(stringDocument.getContentAsString(), stringDocument.getURI().toString());
        def element = jsoup.select(filterContext.getConfigValue(JSOUP_SELECTOR).get()).first()
        if (element) {
            def docDateString = element.text()

            // Extract the value if the date is stored in an attribute (e.g. <meta name="date" content="01/02/2013">)
            if (filterContext.getConfigValue(JSOUP_SELECTOR_ATTRIBUTE).isPresent()) {
                docDateString = element.attr(filterContext.getConfigValue(JSOUP_SELECTOR_ATTRIBUTE).get())
            }

            // Get date format from the configuration
            def dateFormat = filterContext.getConfigValue(DOCUMENT_DATE_FORMAT).get()
            def dateTimeFormatter = DateTimeFormatter.ofPattern(dateFormat)

            // Attempt to parse the date, which can have time information (as opposite to just be a date)
            // and may have timezone information too. Java distinguishes all of this and we can't know in
            // advance if the date format will contain a time and a timezeone or not, so we need to try all
            // variants...
            def docDate = null
            try {
                docDate = ZonedDateTime.parse(docDateString, dateTimeFormatter).toLocalDate()
            } catch (e1) {
                log.debug("Failed to parse {} into a ZoneDateTime ({}). Will attempt LocalDateTime", docDateString, e1.message)
                try {
                    docDate = LocalDateTime.parse(docDateString, dateTimeFormatter).toLocalDate()
                } catch (e2) {
                    log.debug("Failed to parse {} into a LocalDateTime ({}). Will attempt LocalDate", docDateString, e2.message)
                    try {
                        docDate = LocalDate.parse(docDateString, dateTimeFormatter)
                    } catch (e3) {
                        log.warn("Failed to parse {} into a LocalDate with pattern '{}': {}", docDateString, e2.message, dateFormat)
                    }
                }
            }

            if (docDate && docDate.isBefore(minDate)) {
                log.info("Dropping {} ({} is older than than {} {}: {})",
                        stringDocument.URI, docDate, chronoAmount, chronoUnit.name().toLowerCase(), minDate)
                return FilterResult.delete()
            }
        }

        return FilterResult.of(stringDocument)
    }
}

