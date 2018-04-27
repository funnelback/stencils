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

                    if (triggerWords.trim().split("\\s").length > 1) {
                        // If the trigger words is a phrase, insert the original
                        // record as-is so that it will match the phrase.
                        // For example "What is chocolate" should match the partial
                        // query "what is cho". If we were not copying the record
                        // as is it would only match "chocolate" because the leading
                        // stop words would have been eliminated ("what" and "is")
                        printer.printRecord(record)
                    }

                    // Split our words on space
                    def triggerList = triggerWords.trim().split("\\s")
                    // Canonicalize the trigger: Remove punctuation, convert to lower case
                    .collect() { it.trim().replaceAll("\\W", "").toLowerCase() }
                    // Ignore empty triggers (e.g. consecutive spaces or triggers containing only punctuation)
                    .findAll() { it != "" }

                    // At this point we have a list of words like "what is chocolate powder"
                    // We need to generate new records with:
                    // - what is chocolate powder
                    // - is chocolate powder
                    // - chocolate powder
                    // - chocolate
                    // .. while eliminating the stopwords, so in practice:
                    // - chocolate powder
                    // - chocolate

                    for (def j=0; j< triggerList.size(); j++) {
                        def word = triggerList[j]

                        // Skip leading stopwords
                        if (stopWords.contains(word)) {
                            continue
                        }

                        def newRecord = [ triggerList.subList(j, triggerList.size()).join(" ") ]

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
