package com.funnelback.stencils.workflow.autocompletion

import com.funnelback.common.config.GlobalOnlyConfig
import com.funnelback.stencils.util.OSUtils

/**
 * Generates auto completion file from CSV data, for
 * a given profile
 *
 * @author nguillaumin@funnelback.com
 */
class CSVAutoCompletionGenerator {

    /** Size of a page of results to get the completions */
    static final PAGE_SIZE = 100

    /** Name of the file to save the CSV data into */
    static final CSV_FILENAME = "auto-completion.csv"

    /** Name of the template generating the CSV data */
    static final CSV_TEMPLATE = "auto-completion"

    /** Query to use to get all documents */
    static final DEFAULT_QUERY = "!genautocompletion"

    /** Jetty public port to request */
    def final searchPort

    /** SEARCH_HOME */
    def final searchHome

    CSVAutoCompletionGenerator(File searchHome) {
        this.searchHome = searchHome
        searchPort = new GlobalOnlyConfig(searchHome).value("jetty.search_port")
    }

    /**
     * Generate a CSV file from a profile and build an auto completion file with it
     * @param collection Collection to query
     * @param profile Profile to query
     * @param view View to query
     * @param queryOption What query to use, defaults to {@link #DEFAULT_QUERY}
     */
    public void generateAutoCompletions(String collection, String profile, String view, Optional<String> queryOption) {
        def csvFile = generateCSVCompletions(collection, profile, view, queryOption)
        generateAutocFile(csvFile, collection, profile, view)
    }

    /**
     * Generate CSV completion data from a profile. The profile is expected to have a custom template
     * named {@link #CSV_TEMPLATE}.
     * @param collection Collection to query
     * @param profile Profile to query
     * @param view View to query
     * @param queryOption Optional query to use. Will default to {@link #DEFAULT_QUERY}
     * @return Generated CSV file
     */
    private File generateCSVCompletions(String collection, String profile, String view, Optional<String> queryOption) {
        def targetFile = getCSVFile(collection, profile)
        // Always delete the file first, since we'll be appending to it,
        // we don't want to append to the already existing file
        targetFile.delete()

        def data = null
        def startRank = 0

        // Paginate over the result set to get all the data
        // Stop when we don't get any results back anymore
        print "Requesting all results by pages of ${PAGE_SIZE}. This may take a while: "

        // Put a sanity limit on the number of results that can
        // be retrieved, in case the check for blank data fails
        // at least we won't go into an infinite loop
        while (data != "" && startRank < 5_000_000) {
            def url = getURL(collection, profile, view, startRank, PAGE_SIZE-1, queryOption.orElse(DEFAULT_QUERY))
            data = url.text.trim()

            targetFile.append(data + System.getProperty("line.separator"))
            startRank += PAGE_SIZE
            
            // Print a dot in the log to indicate progress
            print "."
        }

        println ""
        println "Requested ${startRank / PAGE_SIZE} pages of ${PAGE_SIZE} results"
        println "Wrote ${targetFile.length()} bytes to ${targetFile.absolutePath}"

        return targetFile
    }

    /**
     * @return Path to the generated CSV file
     */
    private File getCSVFile(String collection, String profile) {
        return new File("${searchHome}/conf/${collection}/${profile}/${CSV_FILENAME}")
    }

    /**
     * @return URL to query to get CSV data
     */
    private URL getURL(String collection, String profile, String view, int startRank, int numRanks, String query) {
        return new URL([
                "http://localhost:${searchPort}/s/search.html",
                "?collection=${collection}",
                "&profile=${profile}",
                "&view=${view}",
                "&form=${CSV_TEMPLATE}",
                "&query=${URLEncoder.encode(query, "UTF-8")}",
                "&start_rank=${startRank}",
                "&num_ranks=${numRanks}"
        ].join(""))
    }

    /**
     * Generate a <code>.autoc</code> file from a CSV file.
     * @param csvFile CSV file to use
     * @param collection Collection
     * @param profile Profile
     * @param view View to write the generated file into
     * @throws IllegalStateException If build_autoc fails
     */
    private void generateAutocFile(File csvFile, String collection, String profile, String view) throws IllegalStateException {
        def executableSuffix = new OSUtils().executableSuffix
        def cmd = [
                new File("${searchHome}/bin/build_autoc${executableSuffix}").absolutePath,
                new File("${searchHome}/data/${collection}/${view}/idx/index").absolutePath,
                "-collection", collection,
                "-profile", profile,
                csvFile.absolutePath
        ]

        println "Running ${cmd.join(" ")}"
        def process = cmd.execute()
        process.inputStream.eachLine() { println "  |${it}" }
        process.errorStream.eachLine() { println "  |${it}" }

        def exitValue = process.waitFor()

        if (exitValue != 0) {
            throw new IllegalStateException("Failed to run build_autoc (${cmd.join(" ")}), exit code: ${exitValue}")
        }
    }

}
