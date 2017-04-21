package com.funnelback.stencils.hook.facebook

import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter
import java.time.format.DateTimeParseException

import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.stencils.hook.support.HookLifecycle
import com.funnelback.stencils.util.ConfigUtils

import groovy.util.logging.Log4j2

/**
 * Hook functions for the Facebook Stencil
 * 
 * @author nguillaumin@funnelback.com
 */
@Log4j2
class FacebookHookLifecycle implements HookLifecycle {

    /** Name of the Facebook stencil */
    private static final String FACEBOOK_STENCIL = "facebook"

    /** Formatter for Facebook date+time */
    private static final DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S z")

    /**
     * <p>This hook:</p>
     * <ul>
     *  <li>Compute various URLs to the user id, user picture</li>
     *  <li>Parse Facebook formatted date+time into Date instances</li>
     *  <li>Check if the event already happened or not</li>
     * </ul> 
     */
    @Override
    void postDatafetch(SearchTransaction transaction) {
        if (ConfigUtils.isStencilEnabled(transaction.question.collection.configuration, FACEBOOK_STENCIL)
            && transaction.response.resultPacket?.results) {
            
            transaction.response.customData[StencilHooks.STENCILS_FREEMARKER_METHODS]["facebookHashtagify"] = new HashtagifyFacebookMethod()

            transaction.response.resultPacket.results.findAll { result ->
                return result.metaData["stencilsFacebookType"] != null
            }
            .each { result ->
                switch (result.metaData["stencilsFacebookType"].toLowerCase()) {
                    case "post":
                        result.customData["stencilsFacebookProfileUrl"] = generateUrlForId(result.metaData["stencilsFacebookPostUserID"])
                        result.customData["stencilsFacebookProfileImageUrl"] = generateImageUrlForId(result.metaData["stencilsFacebookPostUserID"])
                        break
                        
                    case "page":
                        result.customData["stencilsFacebookPageImageUrl"] = generateImageUrlForId(result.metaData["stencilsFacebookPageID"])
                        break
                        
                    case "event":
                        result.customData["stencilsFacebookProfileUrl"] = generateUrlForId(result.metaData["stencilsFacebookEventUserID"])
                        result.customData["stencilsFacebookProfileImageUrl"] = generateImageUrlForId(result.metaData["stencilsFacebookEventUserID"])
                        
                        def startDate = parseFacebookDateTime(result.metaData["stencilsFacebookEventStartDateTime"])
                        def endDate = parseFacebookDateTime(result.metaData["stencilsFacebookEventEndDateTime"])
                        result.customData["stencilsFacebookEventStartDate"] = startDate
                        result.customData["stencilsFacebookEventEndDate"] =  endDate
                        result.customData["stencilsFacebookEventIsPast"] = isEventPast(startDate, endDate)
                        
                        break
                }
            }
        }
    }

    /**
     * Generate a Facebook URL for an id
     * @param id Id to generate an URL for
     * @return URL, or the input value if it was null or empty string
     */
    static String generateUrlForId(String id) {
        if (!id) {
            return id
        }
        return "//www.facebook.com/${id}"
    }

    /**
     * Generate a Facebook Graph Image URL for an id
     * @param id Id to generate an URL for
     * @return URL, or the input value if it was null or empty string
     */
    static String generateImageUrlForId(String id) {
        if (!id) {
            return id
        }
        return "//graph.facebook.com/${id}/picture"
    }
    
    /**
     * Parse a Facebook event date+time into a Date instance
     * @param text Date to parse
     * @return Parsed date, or the input value if it couldn't be parsed
     */
    static Object parseFacebookDateTime(String text) {
        if (!text) {
            return text
        }
        
        try {
            return Date.from(ZonedDateTime.parse(text, DATETIME_FORMATTER).toInstant())
        } catch (DateTimeParseException e) {
            return text
        }
    }
    
    /**
     * Check if an event has already happened or not, accounting for
     * the start or end date being possibly invalid (missing, or Strings
     * because they were not correctly parsed)
     * 
     * @param startDate Event start date
     * @param endDate Event end date
     * @return true if the event already happened, false if not or if the date
     *  were invalid and couldn't be used
     */
    static boolean isEventPast(Object startDate, Object endDate) {
        def now = new Date()
        if (endDate && endDate instanceof Date) {
            return endDate.before(now)
        } else if (startDate && startDate instanceof Date) {
            return startDate.before(now)
        }
        
        // Both invalid dates, return false by default
        return false
    }
}
