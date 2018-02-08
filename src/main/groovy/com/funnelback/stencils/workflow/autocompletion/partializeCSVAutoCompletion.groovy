/**
 * Script to generate partial triggers for CSV auto-completion files
 *
 * It takes each row of a CSV completion files and split the triggers on spaces to generate alternative rows,
 * to allow for partial matching. It's similar to the <code>-partials</code> option for organic completions.
 *
 * post_index_command=$GROOVY_COMMAND \
 *  $SEARCH_HOME/share/stencils/src/main/groovy/com/funnelback/stencils/workflow/autocompletion/partializeCSVAutoCompletion.groovy \
 *   -i /path/to/input.csv \
 *   -o /path/to/output.csv
 *
 * @author nguillaumin@funnelback.com
 *
 */
package com.funnelback.stencils.workflow.autocompletion

def cli = new CliBuilder(usage: getClass().name)
cli.with {
    header = "Partialize CSV auto-completions." + System.getProperty("line.separator") +
            "This takes an input CSV file and generates and output CSV file with all possible variants for the triggers." + System.getProperty("line.separator") +
            "An optional stop words file can be passed to exclude specific words from the generated triggers."
    h longOpt: "help", "Get this help message"
    i longOpt: "input", required: true, argName: "inputFile", args: 1, type: File.class, "Input CSV file"
    o longOpt: "output", required: true, argName: "outputFile", args: 1, type: File.class, "Output CSV file"
    s longOpt: "stop-words", required: false, argName: "stopWordsFile", args: 1, type: File.class, "Optional stop words file to use"
}
def options = cli.parse(args)
if (!options) {
    throw new IllegalStateException("Missing required options")
}
if (options.h) {
    cli.usage()
    return
}

new CSVAutoCompletionsPartializer().partialize(
        Optional.ofNullable(options.s ? new File(options.s) : null),
        new File(options.i),
        new File(options.o))
