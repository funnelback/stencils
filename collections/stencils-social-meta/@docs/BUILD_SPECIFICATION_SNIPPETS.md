Build Specification Snippets
=================

This page contains shorts snippets which can be fed into the build specification document.

## Template files
**&lt; NOTE: This fits in the build specification v0.1 under 7.2.4 Template files&gt;**<br>
Funnelback uses templates to allow administrators to customise their search interface. It supports changes to the appearance of the search page, as well as advanced search and inclusion of metadata/XML fields in result summaries.
<br>
Classic UI templates are .form files and are served via IIS.  The Classic UI is accessed from http://cbr50es01p/search/search.cgi?collection=casa-internal&form=<FORMNAME>
<br>
Modern UI templates are .ftl (Freemarker) files and are served via Funnelback’s Jetty web server. The Modern UI is accessed from http://cbr50es01p:8080/s/search.html?collection=casa-internal&form=<FORMNAME>
<br>
<FORMNAME> is the name of the template.  Eg. for casa.form, casa.ftl replace <FORMNAME> with casa.
 form=<FORMNAME> can be omitted from the URL if using the simple.form/ftl template.
<br>
Template files can be edited from the administration interface. See: https://docs.funnelback.com/13.0/search_forms.html

This project uses the following Modern UI Stencils templates;

| File | Description |
| -------- | ---------- |
| simple.ftl | Main index template, that pulls in all other templates. |
| project.view.ftl | Views specific to this project. |
| project.controller.ftl | Controllers specific to this project. |
| base.view.ftl | Views for common search components. |
| base.controller.ftl | Controllers for common search components.  |
| core.view.ftl | Views for core search components. |
| core.controller.ftl | Controllers for core search components. |
| social.view.ftl | Views specific to social media components. |
| social.controller.ftl | Controllers specific to social media components. |
| facebook.view.ftl | Views specific to Facebook components. |
| facebook.controller.ftl | Controllers specific to Facebook components. |
| twitter.view.ftl | Views specific to Twitter components. |
| twitter.controller.ftl | Controllers specific to Twitter components. |
| flickr.view.ftl | Views specific to Flickr components. |
| flickr.controller.ftl | Controllers specific to Flickr components. |
| youtube.view.ftl | Views specific to YouTube components. |
| youtube.controller.ftl | Controllers specific to YouTube components. |



## Faceted Navigation
**&lt; NOTE: This fits in the build specification v0.1 under 7.2.8 Faceted Navigation&gt;**<br>
<This is only required for collections that are queried>
Faceted navigation is presented for all search results.  The facets allow a user to filter the search results based on structured data present in the indexed content.  Facets currently defined are based on metadata values.
Further information on faceted navigation: https://docs.funnelback.com/13.0/faceted_navigation.html


| Facet | Data source | Description
| -------- | ---------- | ---------- |
| Facet - "Collection" | Gscope | Coresponds to the collection to which the item belongs (Facebook, Twitter, Flickr and Youtube.) |
| Sub Facet -"Facebook Type" | Metadata (stencilsFacebookType) | Facebook content type e.g Post, Event and Page.|
| Facet - "Author" | Metadata (a) |Content author.|
| Facet - "Published date" |Metadata (d)| Content Published date. <br>_**NOTE** Flickr pictures, Facebook events and Facebook Pages do not have a published date metadata._|

## Metadata / XML field mappings
**&lt; NOTE: This fits in the build specification v0.1 under 7.2.12 Metadata / XML field mappings&gt;**<br>
The table below details the mappings used by Funnelback for metadata and XML fields.  The metadata class letters used by Funnelback correspond to those that are used in the templates or metadata searches.  The // indicates an X-Path or database field name.

### Facebook
**&lt;Get table from here [Facebook Stencil](https://gitlab.squiz.net/stencils/stencils-facebook-meta/blob/master/@docs/BUILD_SPECIFICATION_SNIPPETS.md) &gt;**

### Twitter
**&lt;Get table from here [Twitter Stencil](https://gitlab.squiz.net/stencils/stencils-twitter-meta/blob/master/@docs/BUILD_SPECIFICATION_SNIPPETS.md)) &gt;**

### Flickr
**&lt;Get table from here [Flickr Stencil](https://gitlab.squiz.net/stencils/stencils-flickr-meta/blob/master/@docs/BUILD_SPECIFICATION_SNIPPETS.md) &gt;**

### YouTube
**&lt;Get table from here [YouTube Stencil](https://gitlab.squiz.net/stencils/stencils-youtube-meta/blob/master/@docs/BUILD_SPECIFICATION_SNIPPETS.md) &gt;**
