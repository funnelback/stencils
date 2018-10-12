package com.funnelback.stencils.workflow.instagram

import com.funnelback.common.config.NoOptionsConfig
import com.funnelback.common.io.store.RawBytesRecord
import com.funnelback.common.io.store.bytes.RawBytesStoreFactory
import com.google.common.collect.ArrayListMultimap
import groovy.json.JsonOutput
import groovy.json.JsonSlurper
import groovy.util.logging.Log4j2

import java.time.Instant
import java.time.ZoneOffset
import java.time.format.DateTimeFormatter

/**
 * Helper class to fetch Instagram posts
 *
 * It doesn't do much, just take a list of Instagram API tokens and fetches
 * all the posts associated with them, using pagination.
 *
 * It doesn't deal with authentication as there's no way to programatically
 * authenticate to the Instagram API. The authentication must be done
 * manually once to retrieve an access token (See relevant Funnelback Community
 * article)
 *
 * @author nguillaumin@funnelback.com
 */
@Log4j2
class InstagramGather {

    /** Base URL for the instagram API */
    static final INSTAGRAM_API_URL = "https://api.instagram.com/v1/users/self/media/recent/?access_token="

    /** Name of the collection parameter holding the list of tokens */
    static final STENCILS_INSTAGRAM_ACCESS_TOKENS = "stencils.instagram.access-tokens"

    /** Collection config */
    final config

    /** Store to save our records */
    final store

    /**
     * @param searchHome Funnelback installation directory
     * @param collectionName Collection to gather
     */
    InstagramGather(File searchHome, String collectionName) {
        config = new NoOptionsConfig(searchHome, collectionName)
        store = new RawBytesStoreFactory(config)
                .withFilteringEnabled(true)
                .newStore()
    }

    /**
     * Gather all Instagram posts
     */
    void gather() {
        store.open()

        // Prepare a list of metadata that will be associated with each record
        def metadata = ArrayListMultimap.create()
        metadata.put("Content-Type", "application/json")

        def accessTokens = config.value(STENCILS_INSTAGRAM_ACCESS_TOKENS)
        if (!accessTokens) {
            throw new IllegalStateException("Missing required collection parameter ${STENCILS_INSTAGRAM_ACCESS_TOKENS}")
        }

        def fetched = 0

        try {
            accessTokens.tokenize(",").eachWithIndex() { accessToken, i ->

                log.info("Fetching posts with token #{} ({})", i, accessToken)
                def url = INSTAGRAM_API_URL + accessToken

                while (url && !config.updateStopped) {
                    def response = new JsonSlurper().parse(url.toURL())

                    // Loop over the retrieved posts
                    response["data"].each() { post ->

                        // The post date is a timestamp that PADRE doesn't support
                        // Convert it to an ISO date and store it in a separate field
                        def postDate = Instant.ofEpochSecond(post.created_time.toInteger()).atOffset(ZoneOffset.UTC)
                        post.created_time_iso = postDate.format(DateTimeFormatter.ISO_INSTANT)

                        def record = new RawBytesRecord(
                                JsonOutput.toJson(post).getBytes("UTF-8"),
                                post.link)

                        store.add(record, metadata)
                        fetched++

                        log.info("Stored {}", post.link)
                    }

                    // Get next page of posts, may be null if there's no more posts
                    url = response.pagination.next_url

                    config.progressMessage = "Fetched ${fetched} posts"
                }
            }
        } finally {
            store.close()
        }

        log.info("Stored {} Instagram posts with {} access tokens", fetched, accessTokens.tokenize(",").size())
    }

}
