package com.funnelback.stencils.workflow.autocompletion

import org.apache.commons.csv.CSVFormat

/**
 * "Partialize" the trigger of an auto-completion CSV file
 *
 * @author nguillaumin@funnelback.com
 */
class CSVAutoCompletionsPartializer {

    /**
     * Partialize the trigger of the given input file, writing the resulting
     * CSV in the output file.
     *
     * @param stopWordsFile Optional file containing stop words to consider when generating
     * the additional triggers
     * @param input Path to the input CSV file
     * @param output Path to the output CSV File that will be benerated
     */
    public void partialize(Optional<File> stopWordsFile, File input, File output) {
        def stopWords = []
        stopWordsFile.ifPresent( { option -> stopWords = option.readLines() } )

        def processed = 0, generated = 0

        output.withWriter() { writer ->
            def printer = CSVFormat.EXCEL.print(writer)

            input.withReader() { reader ->
                def records = CSVFormat.EXCEL.withCommentMarker('#' as char).parse(reader)

                // Iterate over each row of the input file
                records.each() { record ->
                    def triggerWords = record.get(0)

                    // Split our words on space
                    triggerWords.trim().split("\\s")
                    // Canonicalize the trigger: Remove punctuation, convert to lower case
                    .collect() { it.trim().replaceAll("\\W", "").toLowerCase() }
                    // Ignore empty triggers (e.g. consecutive spaces or triggers containing only punctuation)
                    .findAll() { it != "" }
                    // Ensure it's not a stop word
                    .findAll() { ! stopWords.contains(it) }
                    .each { trigger ->
                        def newRecord = [ trigger ]

                        // Generate a row in the output CSV file by copying
                        // the rest of the column from the input CSV
                        for (def i=1; i<record.size(); i++) {
                            newRecord << record.get(i)
                        }

                        printer.printRecord(newRecord)
                        generated++
                    }

                    processed++
                }
            }
        }

        println "Processed ${processed} rows from ${input.absolutePath}. Generated ${generated} rows into ${output.absolutePath}"
    }
}
