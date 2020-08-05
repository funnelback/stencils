package com.funnelback.stencils.gather

import com.funnelback.common.config.Config
import com.funnelback.common.io.store.RawBytesRecord
import com.funnelback.common.io.store.RawBytesStore
import com.funnelback.common.io.store.bytes.RawBytesStoreFactory
import com.funnelback.socialmedia.utils.ConfigFactory
import com.google.common.collect.ArrayListMultimap
import groovy.json.JsonOutput
import groovy.json.JsonSlurper

class InstagramCustomGather {

    Config config
    RawBytesStore store
    String userAccessToken
    def CONFIG_KEYS = [
        'ACCESS_TOKEN': 'stencils.instagram.user-access-token',
        'MEDIA_FIELDS': 'stencils.instagram.media-fields',
    ]
    String MEDIA_FIELDS_DEFAULT_VALUE = 'media_type,media_url,timestamp,caption,permalink,thumbnail_url,username'
    JsonSlurper jsonSlurper = new JsonSlurper()

    /**
     * Initialize the InstagramCustomGather class variables
     * @param searchHome
     * @param collection
     * @return instance of InstagramCustomGather to be called in a chain
     */
    InstagramCustomGather init(File searchHome, String collection) {
        config = ConfigFactory.createNoOptionsConfigWithLogging(searchHome, collection)
        userAccessToken = config.value(CONFIG_KEYS['ACCESS_TOKEN'])
        if (!userAccessToken) {
            throw new RuntimeException("Configuration key ${CONFIG_KEYS['ACCESS_TOKEN']} must be set.")
        }
        store = new RawBytesStoreFactory(config).withFilteringEnabled(true).newStore()

        return this
    }

    /**
     * Refresh the user access token
     * Long-lived tokens have a life of 60 days before expiring, there are no never-expiring tokens
     * Refresh the token via API and write the new value to the collection configuration
     */

    InstagramCustomGather refreshToken(File searchHome, String collection) {
        URL refreshUrl = new URL("https://graph.instagram.com/refresh_access_token?grant_type=ig_refresh_token&access_token=${userAccessToken}")
        def response
        try {
            response = jsonSlurper.parse(refreshUrl)
        } catch (Exception exception) {
            println "Error refreshing access token.\n"
            throw exception
        }
        if (response?.access_token) {
            println "Old token: ${userAccessToken}"
            userAccessToken = response.access_token
            println "New token: ${userAccessToken}"
            def collectionCfg = new File(searchHome, "conf/${collection}/collection.cfg")
            def configText = collectionCfg.text
            def pattern = ~/(?m)^instagram\.user-access-token=(.+)$/
            def matcher = configText =~ pattern
            if (matcher.find()) {
                collectionCfg.text = configText.replaceAll(pattern, "instagram.user-access-token=${userAccessToken}")
            }
        } else {
            throw new RuntimeException("Refreshing access token failed.\nResponse:\n${JsonOutput.toJson(response)}")
        }
        return this
    }

    void gather() {
        // Allow configuration of the media fields to request and fallback on a default value
        String userMediaFields = config.value(CONFIG_KEYS['MEDIA_FIELDS'], MEDIA_FIELDS_DEFAULT_VALUE)

        URL myMediaEdge = new URL("https://graph.instagram.com/me/media?fields=${userMediaFields}&access_token=${userAccessToken}")

        // Open store to add records
        store.open()
        def numRecords = 0

        // try-finally to ensure the store is closed
        try {
            // Loop for possible pagination
            for (;;) {
                // Check if an update stop was requested
                if (config.isUpdateStopped()) {
                    throw new RuntimeException('Collection update stopped')
                }
                
                // HTTP GET request and parse response JSON
                def myMediaEdgeResponse = jsonSlurper.parse(myMediaEdge)

                numRecords += myMediaEdgeResponse.data.size()
                // Iterate through response data and add JSON records to the store
                myMediaEdgeResponse.data.each { userMediaData ->
                    String url = userMediaData.permalink
                    byte[] bytes = JsonOutput.toJson(userMediaData).getBytes('UTF-8')

                    RawBytesRecord record = new RawBytesRecord(bytes, url)
                    ArrayListMultimap<String,String> metadata = ArrayListMultimap.create()
                    store.add(record, metadata)
                }
                config.setProgressMessage("Gathered ${numRecords} posts...")

                // Stop if there is no "next" URL
                if (!myMediaEdgeResponse?.paging?.next) {
                    break
                }
                // Assign the next URL in the pagination
                myMediaEdge = new URL(myMediaEdgeResponse.paging.next)
            }
        } finally {
            // Ensure the store is closed
            store.close()
        }
        
        config.setProgressMessage("Finished gathering user media, gathered ${numRecords} records.")
    }

    // main method is run when the custom gather is started
    static void main(String[] args) {
        File searchHome = new File(args[0])
        String collection = args[1]
        new InstagramCustomGather()
            .init(searchHome, collection)
            .refreshToken(searchHome, collection)
            .gather()
    }
}
