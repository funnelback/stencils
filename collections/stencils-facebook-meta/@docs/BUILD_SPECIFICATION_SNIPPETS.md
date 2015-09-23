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
| facebook.view.ftl | Views specific to Facebook components. |
| facebook.controller.ftl | Controllers specific to Facebook components. |

## Faceted Navigation
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

## Metadata / XML field mappings
**&lt; NOTE: This fits in the build specification v0.1 under 7.2.12 Metadata / XML field mappings&gt;**<br>
The table below details the mappings used by Funnelback for metadata and XML fields.  The metadata class letters used by Funnelback correspond to those that are used in the templates or metadata searches.  The // indicates an X-Path or database field name.

Facebook Post;

| Metadata Class | Metadata / XML Field /  HTTP Header | Repository | Description |
| -------------- | ----------------------------------- | ---------- | ----------- |
| a | /FacebookXmlRecord/postFrom/name<br>/FacebookXmlRecord/eventOwner/name | custom-facebook | Content author. |
| d | /FacebookXmlRecord/postCreatedTime | custom-facebook |  Published date. |
| c | /FacebookXmlRecord/postMessage<br>/FacebookXmlRecord/eventDescription<br>/FacebookXmlRecord/page/description | custom-facebook | Post message or content description. |
| t | /FacebookXmlRecord/page/name | custom-facebook | Name of the page. |
| stencilsFacebookType | /FacebookXmlRecord/type | custom-facebook | Content type for facebook |
| stencilsFacebookPostID |/FacebookXmlRecord/postId | custom-facebook | Facebook ID for post. |
| stencilsFacebookUserID | /FacebookXmlRecord/postFrom/id | custom-facebook | Facebook ID of post author. |
| stencilsFacebookPostLink | /FacebookXmlRecord/postLink | custom-facebook | URL posted within post message content. |
| stencilsFacebookPostLinkCaption | /FacebookXmlRecord/postLinkCaption | custom-facebook | Caption for URL posted within post message content. |
| stencilsFacebookPostLinkDescription | /FacebookXmlRecord/postLinkDescription | custom-facebook | Description for URL posted within post message content. |
| stencilsFacebookPostThumbnailUrl | /FacebookXmlRecord/postPictureURL | custom-facebook |Thumbnail image of picture attached to post message. |
| stencilsFacebookPostStreet | /FacebookXmlRecord/postLocation/street | custom-facebook | Posted from location street. |
| stencilsFacebookPostCity | /FacebookXmlRecord/postLocation/city | custom-facebook | Posted from location city. |
| stencilsFacebookPostState | /FacebookXmlRecord/postLocation/state | custom-facebook | Posted from location state. |
| stencilsFacebookPostPostcode | /FacebookXmlRecord/postLocation/zip | custom-facebook |Posted from Location Post code. |
| stencilsFacebookPostCountry | /FacebookXmlRecord/postLocation/country | custom-facebook | Posted from location country. |
| stencilsFacebookPostLatlong |/FacebookXmlRecord/postLocation/latLong| custom-facebook |  Geo-coordinates |
| stencilsFacebookEventID | /FacebookXmlRecord/eventId | custom-facebook | Facebook ID for event. |
| stencilsFacebookEventUserID | /FacebookXmlRecord/eventOwner/id | custom-facebook | Facebook ID of event author. |
| stencilsFacebookEventStartDateTime | /FacebookXmlRecord/eventStartTime | custom-facebook |  Event start datetime. |
| stencilsFacebookEventEndDateTime | /FacebookXmlRecord/eventEndTime | custom-facebook | Event end datetime. |
| stencilsFacebookEventLocation | /FacebookXmlRecord/eventLocation | custom-facebook | Venue Name of event location. |
| stencilsFacebookEventVenueCity | /FacebookXmlRecord/eventVenue/city | custom-facebook | City of event location. |
| stencilsFacebookEventVenueStreet | /FacebookXmlRecord/eventVenue/street | custom-facebook | Street of event location. |
| stencilsFacebookEventVenueState | /FacebookXmlRecord/eventVenue/state | custom-facebook | State of event location. |
| stencilsFacebookEventVenuePostCode | /FacebookXmlRecord/eventVenue/zip | custom-facebook | Post code of event location. |
| stencilsFacebookEventVenueCountry | /FacebookXmlRecord/eventVenue/country | custom-facebook | Country of event location. |
| stencilsFacebookEventPrivacy | /FacebookXmlRecord/eventPrivacy | custom-facebook | Event privacy information. |
| stencilsFacebookPageID | /FacebookXmlRecord/page/id | custom-facebook | Facebook ID for page. |
| stencilsFacebookPageAbout | /FacebookXmlRecord/page/about | custom-facebook | Attribute for 'About' section page information. |
| stencilsFacebookPageCategory | /FacebookXmlRecord/page/category | custom-facebook | Attribute for 'Category' section page information. |
| stencilsFacebookPageFounded | /FacebookXmlRecord/page/founded | custom-facebook | Attribute for 'Founded' section page information. |
| stencilsFacebookPageMission | /FacebookXmlRecord/page/mission | custom-facebook | Attribute for 'Mission' section page information. |
| stencilsFacebookPagePhone | /FacebookXmlRecord/page/phone | custom-facebook | Attribute for 'Phone' section page information. |
| stencilsFacebookPageProducts| /FacebookXmlRecord/page/products | custom-facebook | Attribute for 'Products' section page information. |
| stencilsFacebookPageStreet | /FacebookXmlRecord/page/location/street |  custom-facebook | Street location for page. |
| stencilsFacebookPageCity | /FacebookXmlRecord/page/location/city | custom-facebook | City location for page. |
| stencilsFacebookPageState | /FacebookXmlRecord/page/location/state | custom-facebook | State location for page.|
| stencilsFacebookPagePostcode | /FacebookXmlRecord/page/location/zip | custom-facebook | Post code location for page.|
| stencilsFacebookPageCountry | /FacebookXmlRecord/page/location/country | custom-facebook | Country location for page. |
