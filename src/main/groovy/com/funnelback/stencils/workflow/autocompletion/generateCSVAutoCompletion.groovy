/**
 * Script to generate auto-completion file from CSV data, itself generated from a CSV template
 *
 * Usually called as a workflow script, passing the name of the collection to query, the profile to query
 * and the view. The profile is expected to have a template named 'auto-completion.csv'
 *
 * post_index_command=$GROOVY_COMMAND
 *  $SEARCH_HOME/share/stencils/src/main/groovy/com/funnelback/stencils/workflow/autocompletion/generateCSVAutoCompletion.groovy \
 *   -c $COLLECTION_NAME \
 *   -p auto-completion \
 *   -v $CURRENT_VIEW
 *
 * @author nguillaumin@funnelback.com
 * @author lnowak@funnelback.com
 *
 */
package com.funnelback.stencils.workflow.autocompletion

def searchHomeEnv = System.getenv("SEARCH_HOME")
if (!searchHomeEnv) {
    throw new IllegalStateException("the SEARCH_HOME environment variable must be defined")
}
def searchHome = new File(searchHomeEnv)

def cli = new CliBuilder(usage: getClass().name)
cli.with {
    header = """
Generate profile-style CSV autocompletions.
This will hit the designed collection & profile on the ${CSVAutoCompletionGenerator.CSV_TEMPLATE} template and
save the output in \${collection}/\${profile}/${CSVAutoCompletionGenerator.CSV_FILENAME}.
build_autoc will then be called on this CSV file, with the profile name.
"""
    h longOpt: "help", "Get this help message"
    c longOpt: "collection", required: true, argName: "collection", args: 1, type: String.class, "Collection to query"
    p longOpt: "profile", required: true, argName: "view", args: 1, type: String.class, "Profile to query"
    v longOpt: "view", required: true, argName: "view", args: 1, type: String.class, "View to query (e.g. offline or live)"
    n longOpt: "numRanks", argName: "numRanks", args: 1, type: Integer.class, "How many results to retrieve (num_ranks), defaults to ${CSVAutoCompletionGenerator.DEFAULT_NUMRANKS}"
}
def options = cli.parse(args)
if (!options) {
    throw new IllegalStateException("Missing required options")
}
if (options.h) {
    cli.usage()
    return
}

new CSVAutoCompletionGenerator(searchHome)
        .generateAutoCompletions(
        options.c,
        options.p,
        options.v,
        Optional.ofNullable(options.n ? options.n : null))
