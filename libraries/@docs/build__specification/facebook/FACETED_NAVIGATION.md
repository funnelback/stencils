Faceted Navigation
=======================

**&lt; NOTE: This fits in the build specification v0.1 under 7.2.8 Faceted Navigation&gt;**<br>
<This is only required for collections that are queried>
Faceted navigation is presented for all search results.  The facets allow a user to filter the search results based on structured data present in the indexed content.  Facets currently defined are based on metadata values.
Further information on faceted navigation: https://docs.funnelback.com/13.0/faceted_navigation.html


| Facet | Data source | Description
| -------- | ---------- | ---------- |
| Facet - "Facebook Type" | Metadata (stencilsFacebookType) | Facebook content type e.g Post, Event and Page.|
| Facet - "Author" | Metadata (a) |Content author.|
| Facet - "Published date" | Metadata (d)| Content Published date.|
| Facet - "Location" (Country)| Metadata (stencilsFacebookPostCountry, stencilsFacebookEventVenueCountry, stencilsFacebookPageCountry)| Location of content.|
| Sub Facet - "Location" level 2 (State) | Metadata (stencilsFacebookPostState, stencilsFacebookEventVenueState, stencilsFacebookPageState)| Location of content.|
| Sub Facet - "Location" level 3 (City) | Metadata (stencilsFacebookPostCity, stencilsFacebookEventVenueCity, stencilsFacebookPageCity)| Location of content.|
