Metadata / XML field mappings - Facebook
===============================

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
