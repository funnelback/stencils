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

    /** Default num_ranks to use when not provided */
    static final DEFAULT_NUMRANKS = 10_000

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
     * @param numRanksOption How many results to retrieve, defaults to {@link #DEFAULT_NUMRANKS}
     * @param queryOption What query to use, defaults to {@link #DEFAULT_QUERY}
     */
    public void generateAutoCompletions(String collection, String profile, String view, Optional<Integer> numRanksOption, Optional<String> queryOption) {
        def csvFile = generateCSVCompletions(collection, profile, view, numRanksOption, queryOption)
        generateAutocFile(csvFile, collection, profile, view)
    }

    /**
     * Generate CSV completion data from a profile. The profile is expected to have a custom template
     * named {@link #CSV_TEMPLATE}.
     * @param collection Collection to query
     * @param profile Profile to query
     * @param view View to query
     * @param numRanksOption Optional num_ranks value to use. Will default to {@link #DEFAULT_NUMRANKS}
     * @param queryOption Optional query to use. Will default to {@link #DEFAULT_QUERY}
     * @return Generated CSV file
     */
    private File generateCSVCompletions(String collection, String profile, String view, Optional<Integer> numRanksOption, Optional<String> queryOption) {
        def targetFile = getCSVFile(collection, profile)
        def url = getURL(collection, profile, view, numRanksOption.orElse(DEFAULT_NUMRANKS).toInteger(), queryOption.orElse(DEFAULT_QUERY))

        println "Requesting URL: ${url}"
        targetFile.withOutputStream { os ->
            url.withInputStream { is ->
                os << is
            }
        }

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
    private URL getURL(String collection, String profile, String view, int numRanks, String query) {
        return new URL([
                "http://localhost:${searchPort}/s/search.html",
                "?collection=${collection}",
                "&profile=${profile}",
                "&view=${view}",
                "&form=${CSV_TEMPLATE}",
                "&query=${URLEncoder.encode(query, "UTF-8")}",
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
