# Stencil Groovy sources

This folder contains Groovy sources for the Stencils: Public UI hook scripts, custom filters and workflow scripts.

* The `main` folder contains the sources
* The `test` folder contains unit tests for the various features

Please consider writing unit tests for every new implemented feature.
 
# Hook scripts

To make use of these hook scripts, the collection hook scripts need to reference a global Stencil hook that will trigger the relevant code. This allows making use of the Stencil hooks without having to copy the code into every collection.

To call the global Stencil hook, use this one-liner inside a collection `hook_*.groovy` files:

```
new com.funnelback.stencils.hook.StencilHooks().apply(transaction, binding.hasVariable("hook") ? hook : null)
```

The `bind.hasVariable()` part is for compatibility with older versions of Funnelback which didn't pass a `hook` variable indicating which hook is currently running (pre/post datafetch, pre/post process, etc.).

:warning: Note that different hooks run in different phases (pre_process, post_datafetch, etc.). Check the individual hook code to find out which phase the hooks are using, or alternatively add the one-liner in every hook script file (it will have no side effect if no hook is triggered).

Once added to the hook scripts, edit `collection.cfg` to indicate which hook should run for the collection via the `stencils` parameter:

```
stencils=facebook,facets
```

See the individual hook documentation below to find out which ones need to be manually enabled.

## Available hook scripts

Hook scripts are provided to support the various Stencils:

* [Core](main/groovy/com/funnelback/stencils/hook/core/README.md)
* [Facebook](main/groovy/com/funnelback/stencils/hook/facebook/README.md)
* [Facets](main/groovy/com/funnelback/stencils/hook/facets/README.md)
* [No results](main/groovy/com/funnelback/stencils/hook/noresults/README.md)
* [People](main/groovy/com/funnelback/stencils/hook/people/README.md)
* [Tabs](main/groovy/com/funnelback/stencils/hook/tabs/README.md)

# Filters

To make use of the filters, modify the collection configuration, depending of the type of filter:

* `filter.classes` for regular filters (Groovy class `extends ScriptFilterProvider`)
* `filter.jsoup.classes` for Jsoup filters (Groovy class `implements IJSoupFilter`)

Use the full class name when specifying it in the parameter, e.g.:

```
filter.classes=...:com.funnelback.stencils.filter.scraper.MetadataScraperFilter
```

## Available filters

* [Metadata scraper](main/groovy/com/funnelback/stencils/filter/scraper/README.md): Scrape metadata from web pages with CSS Selectors. :warning: Note that this filter is available in Funnelback as standard since v15.8, using the native product filter is preferred.
* [Title prefix / suffix remover](main/groovy/com/funnelback/stencils/filter/title/README.md): Remove SEO prefixes and suffixes from titles (e.g. "Apply to FBU | Funnelback University")
* [XML element HTML wrapper](main/groovy/com/funnelback/stencils/filter/xml/README.md): Wrap specific XML tag in `<html>...</html>` tags for PADRE to index them as inner documents
* [Social media Date filter](main/groovy/com/funnelback/stencils/filter/social/README.md): Filter out social media posts by date
* [HTML document date filter](main/groovy/com/funnelback/stencils/filter/date/README.md): Filter out HTML documents by date
* [Content-Length extraction](main/groovy/com/funnelback/stencils/filter/metadata/README.md): Inject the correct file size as metadata for larger documents

# Workflow scripts

To use the Stencil workflow scripts, call the relevant script from the collection workflow commands, e.g.:

```
post_index_command=$GROOVY_COMMAND $SEARCH_HOME/share/stencils/src/main/groovy/com/funnelback/stencils/workflow/.../myWorkflow.goovy -arg1 X -arg2 Y
```

## Available workflow scripts

* [CSV Autocompletion Workflow](main/groovy/com/funnelback/stencils/workflow/autocompletion/README.md): Generic workflow to generate CSV auto-completion for profiles
* [Instagram Gathering](main/groovy/com/funnelback/stencils/workflow/instagram/README.md): Helper class to gather Instagram content

# Web utilities

General web utility classes are provided. Please consult the documentation of each utility class.

## Available utilities

* [X-Forwarded-For altering servlet filter](main/groovy/com/funnelback/stencils/web/request/README.md): Remove the first or last value from the X-Forwarded-For header