# CSV Auto-completion Workflow helpers

This package provides support for working with CSV auto-completion files.

## CSV Auto-completion partializer

This script provides support for "partializing" completion triggers from CSV file, in a similar fashion of the
`-partials` option from `build_autoc` for organic query completion.

It reads an input CSV file and will generate an output CSV with additional rows for each trigger words, in order for
the completions to match each individual word. An optional stop words file can be provided to stop specific trigger
words to be generated.

### Configuration

Call the workflow in the `collection.cfg` file:

```
post_index_command=$GROOVY_COMMAND $SEARCH_HOME/share/stencils/src/main/groovy/com/funnelback/stencils/workflow/autocompletion/partializeCSVAutoCompletion.groovy -i /path/to/input.csv -o /path/to/output.csv
```

## CSV Auto-completion Workflow

This script provides support for creating CSV auto-completion based on a FreeMarker template.

This is usually used with the Concierge / Multi-Channel completion to generate structured completion for various data sources (courses, staff, events, ...).

The workflow script will:
* Query the specified collection on the specified profile (e.g. `auto-completion`)
* The `auto-completion` profile is expected to have a template `auto-completion.ftl` generating CSV completions
* The output of this template will be saved in a CSV file under `conf/$COLLECTION/$PROFILE/auto-completion.csv`
* `build_autoc` is then called on this CSV file to generate a `.autoc` file for the profile

The concierge then needs to be configured to hit the specific profile on the specified collection for each channel.

### Configuration

* Create a profile `auto-completion` on the collection by creating the folders `conf/$COLLECTION/auto-completion`, `conf/$COLLECTION/auto-completion_preview`
* Create a FTL template in this profile named `auto-completion.ftl`: `conf/$COLLECTION/auto-completion/auto-completion.ftl`. This template should generate CSV data
* Edit the `collection.cfg` file:

```
stencils.auto-completion.triggers=title,firstName,lastName
stencils.auto-completion.action-type=Q
ui.modern.form.auto-completion.content_type=text/plain
post_index_command=$GROOVY_COMMAND $SEARCH_HOME/share/stencils/src/main/groovy/com/funnelback/stencils/workflow/autocompletion/generateCSVAutoCompletion.groovy -c $COLLECTION_NAME -p auto-completion -v $CURRENT_VIEW
```

- The triggers configure which metadata fields in the results will be used as completion trigger
- The action type configures what to do when a suggestion is clicked on. The default (`U`) will navigate to the suggestion URL. `Q` will run a search with the suggestion title.
- `text/plain` is not strictly needed but is nice to have when testing the template. `$COLLECTION_NAME` and `$CURRENT_VIEW` will be automatically expanded by Funnelback

* Update the collection. After the update a file named `data/$COLLECTION/live/idx/index.autoc_auto-completion` should have been created (and same for "events")
* Configure the concierge to hit the collection, on the `auto-completion` profile for the desired channel.

See [generateCSVAutoCompletion.groovy](generateCSVAutoCompletion.groovy) for more details.
