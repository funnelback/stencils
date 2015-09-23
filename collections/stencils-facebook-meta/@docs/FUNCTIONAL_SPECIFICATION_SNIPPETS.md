Functional Specification Snippets
=================

This page contains shorts snippets which can be fed into the functional specification document.

For snippets not detailed here check for further details in the following functional specifications;
+ [Core Stencil](https://gitlab.squiz.net/stencils/stencils-core-meta/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md)
+ [Core Stencil - Panels Variation](https://gitlab.squiz.net/stencils/stencils-core_panels-meta/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md)


## Metadata
**&lt; NOTE: This fits in the functional specification v0.1 after or replacing 4.3 Metadata &gt;**<br>
The following metadata is indexed for the following Facebook content types.

Facebook Post;

| Field | Description |
| ----- | ----------- |
| Author | Name of the author of the post. |
| Post Message | Content of the post. |
| Post ID | Facebook ID for post. |
| User ID | Facebook ID of post author. |
| Link | URL posted within post message content. |
| Link Caption | Caption for URL posted within post message content. |
| Link Description | Description for URL posted within post message content. |
| Thumbnail Image | Thumbnail image of picture attached to post message. |
| Street | Posted from location street. |
| City | Posted from location city. |
| State | Posted from location state. |
| Post code | Posted from Location Post code. |
| Country | Posted from location country. |
| Latitude and Longitude | Posted from location geo-coordinates.  |

Facebook Event;

| Field | Description |
| ----- | ----------- |
| Author | Name of the author of the event. |
| Description | Description of event. |
| Event ID | Facebook ID for event. |
| User ID | Facebook ID of event author. |
| Start Date-time | Event start datetime. |
| End Date-time | Event end datetime. |
| Venue Name | Venue Name of event location. |
| City | City of event location. |
| Street | Street of event location. |
| State | State of event location. |
| Post code | Post code of event location. |
| Country | Country of event location. |
| Event Privacy | Event privacy information. |

Facebook Page;

| Metadata field | Description |
| ----------- | ------ |
| Title | Name of the page. |
| Description | Description of page. |
| Page ID | Facebook ID for page. |
| About | Attribute for 'About' section page information. |
| Category | Attribute for 'Category' section page information. |
| Founded | Attribute for 'Founded' section page information. |
| Mission | Attribute for 'Mission' section page information. |
| Phone | Attribute for 'Phone' section page information. |
| Founded | Attribute for 'Founded' section page information. |
| Products | Attribute for 'Products' section page information. |
| Street |  Street location for page. |
| City | City location for page. |
| State | State location for page.|
| Post code | Post code location for page.|
| Country | Country location for page. |

## Repository overview
**&lt;Summarise the coverage.  Do not get bogged down in product-specific details – this details the repositories NOT the collections.  This will often mirror the collection structure but there may be operational reasons why you wish to separate them. Eg.&gt;**<br>
The search will cover content from a number of repositories.  These repositories are a mixture of restricted and public access content.  The repositories will be fully crawled (where possible).<br>
An interface providing the ability to search across all included repositories will be provided.

| ID | Repository | Description | Access Method | Size / Crawl Limits | Update Schedule |
| ----------- | ------ | ----------- | ------------- | ------------------- | --------------- |
| REP-1 | Facebook | Collect Facebook posts, events and pages from the source detailed within included content for social networks | Facebook gatherer |

## Social Networks
**&lt; NOTE: This fits in the functional specification v0.1 after or replacing 4.Public Websites &gt;**

### Included Content
This section here details the social media content which is to be crawled by Funnelback.

| Social Network | Content to include |
| ----------- | ------ |
| Facebook | Facebook Pages;<ul><li>**&lt; INSERT NAMES OF FACEBOOK PAGES &gt;**</li></ul>Facebook Posts;<ul><li>**&lt; INSERT NAMES OF FACEBOOK USERS &gt;**</li></ul> Facebook Events;<ul><li>**&lt; INSERT NAMES OF FACEBOOK USERS &gt;**</li></ul> |

**&lt; NOTE: There is various limitations for each social media custom collection and what and how content is crawled depending on the version of funnelback. It is update to the implementor to understand these limitations before changing the business logic for crawling. &gt;**

#### Included content types
The following social media content types will be included in the funnelback index.
	+ Facebook Post
	+ Facebook Event
	+ Facebook Page

### Excluded content
This section details the content which is to be explicitly ignored by Funnelback.
Any URLs that contain any of the listed patterns as substrings will be excluded by the web crawler.  This will also prevent the web crawler accessing any links that are linked from an excluded page (if there is no other method of browsing to the page).

**&lt; NOTE: There is various limitations for each social media custom collection and what and how content is crawled depending on the version of funnelback. It is update to the implementor to understand these limitations before changing the business logic for crawling. &gt;**

| Social Network | Content to exclude |
| ----------- | ------ |
| ... | ... |

## Facet definitions
**&lt; NOTE: This fits in the functional specification v0.1 under 4.4.1 Facet definitions&gt;**

The following facets will be defined:

| Element | Description |
| ----------- | ------ |
| Facet - "Type" | The Facebook content type, its categories are; Post, Event and Page.|
| Facet - "Author" | This determined by the author metadata.|
| Facet - "Published date" | This determined by the published date metadata.|
| Facet - "Location" | Determined from Country and cascades down into sub facets for State then City.|

## Search results template display logic

Within the search results different display templates can be used for each result based on predefined set of business rules.

The following describes business rules for result template display logic;

| Result Template | Display Logic |
| -------- | ---------- |
| Facebook Post | Content type is 'Post'.|
| Facebook Event | Content type is 'Event'.|
| Facebook Page | Content type is 'Page'.|
