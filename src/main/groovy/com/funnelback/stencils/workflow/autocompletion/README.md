# CSV Auto-completion Workflow

This package provides support for creating CSV auto-completion based on a FreeMarker template.

This is usually used with the Concierge / Multi-Channel completion to generate structured completion for various data sources (courses, staff, events, ...).

The workflow script will:
* Query the specified collection on the specified profile (e.g. `auto-completion`)
* The `auto-completion` profile is expected to have a template `auto-completion.ftl` generating CSV completions
* The output of this template will be saved in a CSV file under `conf/$COLLECTION/$PROFILE/auto-completion.csv`
* `build_autoc` is then called on this CSV file to generate a `.autoc` file for the profile

The concierge then needs to be configured to hit the specific profile on the specified collection for each channel.

## Configuration

* Create a profile `auto-completion` on the collection by creating the folders `conf/$COLLECTION/auto-completion`, `conf/$COLLECTION/auto-completion_preview`
* Create a FTL template in this profile named `auto-completion.ftl`: `conf/$COLLECTION/auto-completion/auto-completion.ftl`. This template should generate CSV data
* Edit the `collection.cfg` file:

```
ui.modern.form.auto-completion.content_type=text/plain
post_index_command=$GROOVY_COMMAND -cp "$SEARCH_HOME/share/stencils/src/main/groovy" $SEARCH_HOME/share/stencils/src/main/groovy/com/funnelback/stencils/workflow/autocompletion/generateCSVAutoCompletion.groovy -c $COLLECTION_NAME -p auto-completion -v $CURRENT_VIEW
```

`text/plain` is not strictly needed but is nice to have when testing the template. `$COLLECTION_NAME` and `$CURRENT_VIEW` will be automatically expanded by Funnelback

* Update the collection. After the update a file named `data/$COLLECTION/live/idx/index.autoc_auto-completion` should have been created (and same for "events")
* Configure the concierge to hit the collection, on the `auto-completion` profile for the desired channel.

See [generateCSVAutoCompletion.groovy](generateCSVAutoCompletion.groovy) for more details.