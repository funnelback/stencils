# Core Stencil

The Core Stencil augments the basic data model with useful data:

* `response.customData.stencilsMethods` contains additional FreeMarker methods
* Each `response.result` `customData` map is augmented with additional fields

## FreeMarker methods

A `linkify` method is provided to convert URL-looking strings into proper links in result summaries. For example a summary such as:

```
Checkout our new site: http://funnelback.com!
```

...will be converted to

```
Checkout our new site: <a href="http://funnelback.com/">http://funnelback.com/</a>!
```

To make use of this method in FreeMarker:

```
<p>${response.customData.stencilsMethods.linkify(result.metaData.c!)}</p>
```

## Augmented data

The following fields are added to the result `customData` map:

* `stencilsCoreExploreUrl`: Link to the explore query for this result
* `stencilsCoreCollapsedUrl`: Link to the collapsed results for this result
* `stencilsCoreOptimiseUrl`: List to the SEO Auditor for this result and query

Having these URLs in the data model means that they can be used in FreeMarker as-is, without having to manually build them:

```
<a href="${result.customData["stencilsCoreExploreUrl"]!}">Explore similar documents</a>
```

## Contextual Navigation

The Core Stencil will update the Contextual Navigation data model to remove the "site" category if it only contains one site.
This is usually not very useful and is cumbersome to do in FreeMarker.

## Paging

The Core stencil will add `stencilsPaging` to the response `customData` containing paging information for the current search
(URL to the previous/next page, and list of pages surrounding the current one).