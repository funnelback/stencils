Functional Specification Snippets
=================

This page contains shorts snippets which can be fed into the functional specification document.

For snippets not detailed here check for further details in the following functional specification's;
+ [Core Stencil](https://gitlab.squiz.net/stencils/stencils-core-meta/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md)
+ [Core Stencil - Panels Variation](https://gitlab.squiz.net/stencils/stencils-core_panels-meta/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md)
+ [Facebook Stencil](https://gitlab.squiz.net/stencils/stencils-facebook-meta/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md)
+ [Twitter Stencil](https://gitlab.squiz.net/stencils/stencils-twitter-meta/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md)
+ [Flickr Stencil](https://gitlab.squiz.net/stencils/stencils-flickr-meta/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md)
+ [YouTube Stencil](https://gitlab.squiz.net/stencils/stencils-youtube-meta/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md)

## Metadata
See each of the sub collection for metadata indexed and descriptions;
+ [stencils-facebook-custom](https://gitlab.squiz.net/stencils/stencils-facebook-custom/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md#metadata)
+ [stencils-twitter-custom](https://gitlab.squiz.net/stencils/stencils-twitter-custom/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md#metadata)
+ [stencils-youtube-custom](https://gitlab.squiz.net/stencils/stencils-youtube-custom/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md#metadata)
+ [stencils-flickr-custom](https://gitlab.squiz.net/stencils/stencils-flickr-custom/blob/master/@docs/FUNCTIONAL_SPECIFICATION_SNIPPETS.md#metadata)

## Repository overview
**&lt;Summarise the coverage.  Do not get bogged down in product-specific details – this details the repositories NOT the collections.  This will often mirror the collection structure but there may be operational reasons why you wish to separate them. Eg.&gt;**<br>
The search will cover content from a number of repositories.  These repositories are a mixture of restricted and public access content.  The repositories will be fully crawled (where possible).<br>
An interface providing the ability to search across all included repositories will be provided.

| ID | Repository | Description | Access Method | Size / Crawl Limits | Update Schedule |
| ----------- | ------ | ----------- | ------------- | ------------------- | --------------- |
| REP-1 | Facebook | Collect Facebook posts, events and pages from the source detailed within included content for social networks | Facebook gatherer | None | Daily |
| REP-2 | Twitter | Collect Twitter tweets from the source detailed within included content for social networks | Twitter gatherer | None | Daily |
| REP-3 | Flickr | Collect Flickr pictures from the source detailed within included content for social networks | Flickr gatherer | None | Daily |
| REP-4 | Youtube | Collect Youtube videos from the source detailed within included content for social networks | Youtube gatherer | None | Daily |

## Social Networks
**&lt; NOTE: This fits in the functional specification v0.1 after or replacing 4.Public Websites &gt;**

### Included Content
This section here details the social media content which is to be crawled by Funnelback.

| Social Network | Content to include |
| ----------- | ------ |
| Facebook | Facebook Pages;<ul><li>**&lt; INSERT NAMES OF FACEBOOK PAGES &gt;**</li></ul>Facebook Posts;<ul><li>**&lt; INSERT NAMES OF FACEBOOK USERS &gt;**</li></ul> Facebook Events;<ul><li>**&lt; INSERT NAMES OF FACEBOOK USERS &gt;**</li></ul> |
| Twitter | Twitter tweets;<ul><li>**&lt; INSERT NAMES OF TWITTER USERS &gt;**</li></ul>|
| Flickr | Flickr pictures from group;<ul><li>**&lt; INSERT NAMES OF FLICKR GROUPS &gt;**</li></ul>Flickr pictures from users or organistaions;<ul><li>**&lt; INSERT NAMES OF FLICKR USERS ORGANISATIONS &gt;**</li></ul>|
| YouTube | YouTube Videos by channel;<ul><li>**&lt; INSERT NAMES OF YOUTUBE CHANNELS &gt;**</li></ul>|

**&lt; NOTE: There is various limitations for each social media custom collection and what and how content is crawled depending on the version of funnelback. It is update to the implementor to understand these limitations before changing the business logic for crawling. &gt;**

#### Included content types
The following social media content types will be included in the funnelback index.
	+ Facebook Post
	+ Facebook Event
	+ Facebook Page
	+ Twitter tweet
	+ Flickr picture
	+ YouTube videos

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
| Facet - "Collection" | This determined by the content source. The categories are; Facebook, Twitter, Flickr and Youtube. The category Facebook has a child facet for facebook content type, its categories are; Post, Event and Page.|
| Facet - "Author" | This determined by the author metadata.|
| Facet - "Published date" | This determined by the published date metadata. <br>_**NOTE** Flickr pictures, Facebook events and Facebook Pages do not have a published date metadata._|

## Search results template display logic

Within the search results different display templates can be used for each result based on predefined set of business rules.

The following describes business rules for result template display logic;

| Result Template | Display Logic |
| -------- | ---------- |
| Facebook Post | Content source is 'Facebook', and content type is 'Post'.|
| Facebook Event | Content source is 'Facebook', and content type is 'Event'.|
| Facebook Page | Content source is 'Facebook', and content type is 'Page'.|
| Twitter tweet | Content source is 'Twitter'. |
| Flickr picture | Content source is 'Flickr'. |
| YouTube Video | Content source is 'Youtube'. |
