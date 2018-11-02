# Facets Stencil Public UI Hooks (pre v15.12)

:warning: This applies only pre-15.12, as this type of facets is natively supported since 15.12.

The Facets Stencils provides:

* An alternative facets data model stored in `response.customData.stencilsFacets`
* An alternative list of selected facet values stored in `response.customData.stencilsFacetsSelectedValues`
* Support for manually sorting facet values of the alternative data model via `collection.cfg`

## Configuration

Set `stencils=facets` in `collection.cfg`.

This will trigger the generation of the alternative data model and list of selected values.

### Custom sort

To configure the custom sort, use `stencils.faceted_navigation.custom_sort.<facet name>.<order>=<value>`.

For example to sort a `Tabs` facet and force the order ["All", "Staff", "Events", "Social"], use the following configuration:

```
stencils.faceted_navigation.custom_sort.Tabs.1=All
stencils.faceted_navigation.custom_sort.Tabs.2=Staff
stencils.faceted_navigation.custom_sort.Tabs.3=Events
stencils.faceted_navigation.custom_sort.Tabs.4=Social
```

Note that the `<order>` can be any arbitrary string and doesn't have to be a number (e.g. `stencils.faceted_navigation.custom_sort.Tabs.A=...`). As a consequence sorting is done alphabetically, so `100` will be sorted before `11`.
