# Facets Stencil Public UI Hooks

## Facet Rename

The Facet Rename Stencils provide a way to rename facet values easily via `profile.cfg`. A typical example
would be to rename the native "Past fortnight" category for date facets into the more US-friendly "Past 2 weeks".

### Configuration

The configuration is done in `profile.cfg` because faceted navigation is configured within a profile. Configure the 
facet to apply the rename to and the renamed value:

```
stencils.facets.rename.Date.Past fortnight=Past 2 weeks
stencils.facets.rename.Author.jdoe=John Doe
```

The facet name and value are case sensitive.

## Custom sort

The Facet Custom Sort Stencils provide a way to sort facet categories in specific order based on provided configuration. 

### Configuration

The configuration is done in `profile.cfg`  because faceted navigation is configured within a profile. To configure the custom sort, use `stencils.faceted_navigation.custom_sort.<facet name>.<order>=<value>`.

For example to sort a `Tabs` facet and force the order ["All", "Staff", "Events", "Social"], use the following configuration:

```
stencils.faceted_navigation.custom_sort.Tabs.1=All
stencils.faceted_navigation.custom_sort.Tabs.2=Staff
stencils.faceted_navigation.custom_sort.Tabs.3=Events
stencils.faceted_navigation.custom_sort.Tabs.4=Social
```

Note that the `<order>` can be any arbitrary string and doesn't have to be a number (e.g. `stencils.faceted_navigation.custom_sort.Tabs.A=...`). As a consequence sorting is done alphabetically, so `100` will be sorted before `11`.
