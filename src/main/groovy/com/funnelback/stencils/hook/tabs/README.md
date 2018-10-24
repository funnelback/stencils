# Pre-select a tab by default

The tab hook can be used to pre-select a tab by default, either when there is no "All results" tab,
or when the default tab should not be "All results".

## Usage

Call the Stencils hook in your `hook_pre_process.groovy` script, and configure the tab to pre-select in
`collection.cfg`:

```
stencils.tabs.default_selected=Courses
```

# Tabs Stencil Public UI Hooks (pre v15.12)

:warning: This applies only pre-15.12, as Tabs are natively supported since 15.12.

The Tab Stencil relies on faceted navigation to support tabbed search.

The tabs are just a specific facet (Usually named "Tabs") that is displayed like horizontal tabs as opposite to a regular facet on the left-hand side.

Contrary to regular facets, all tabs are usually always displayed even if they contain zero results. This is to prevent a jarring user experience if the actual tabs being displayed were to change depending on the result set. To achieve this the Tab Stencil inject zero gscope counts and/or zero metadata counts if values are missing from the result packet.

## Configuration

The tabs rely on the built-in `FACETED_NAVIGATION` extra search to be triggered to obtain counts for each tab. To enable this extra search, set `ui.modern.full_facets_list=true`.

### Populating zero-result gscope facets

Use `stencils.tabs.full_facet.gscope=...` to populate zero gscope counts for the designated gscope numbers.

```
stencils.tabs.full_facet.gscope=1,5,12
```

This will cause gscope counts for 1, 5, 12 to be set to zero if they were not returned by PADRE (i.e. no documents matching these gscopes). This is used when tabs are based of gscopes to force the tabs to always be displayed even if they are empty.

### Populating zero-count result metadata counts (RMC)

Use `stencils.tabs.full_facet.metadata.<metadata name>.<marker>=<value>` to populate a zero-count RMC for the metadata `<metadata name>` with the value `<value>`.

Typical usage for tabs is:

```
stencils.tabs.full_facet.metadata.tabs.1=all
stencils.tabs.full_facet.metadata.tabs.2=courses
stencils.tabs.full_facet.metadata.tabs.3=events
stencils.tabs.full_facet.metadata.tabs.4=people
stencils.tabs.full_facet.metadata.tabs.5=social media
```

This will cause a zero-count RMC to be injected for the `tabs` metadata for "all", "courses", "events", ..., if any of these RMC is not returned by PADRE (i.e. zero documents with `tabs=courses` in the result set). This is when tabs are based on metadata to force the tabs to always be displayed even if they are empty.

Note: The `<marker>` is just an arbitrary string to differentiate the values, and can be set to anything (e.g. `stencils.tabs.full_facet.metadata.tabs.whatever=all`).