Social Networks
====================
**&lt; NOTE: This fits in the functional specification v0.1 after or replacing 4.Public Websites &gt;**

## Included Content
This section here details the social media content which is to be crawled by Funnelback.

| Social Network | Content to include |
| ----------- | ------ |
| Facebook | Facebook Pages;<ul><li>**&lt; INSERT NAMES OF FACEBOOK PAGES &gt;**</li></ul>Facebook Posts;<ul><li>**&lt; INSERT NAMES OF FACEBOOK USERS &gt;**</li></ul> Facebook Events;<ul><li>**&lt; INSERT NAMES OF FACEBOOK USERS &gt;**</li></ul> |
| Twitter | Twitter tweets;<ul><li>**&lt; INSERT NAMES OF TWITTER USERS &gt;**</li></ul>|
| Flickr | Flickr pictures from group;<ul><li>**&lt; INSERT NAMES OF FLICKR GROUPS &gt;**</li></ul>Flickr pictures from users or organistaions;<ul><li>**&lt; INSERT NAMES OF FLICKR USERS ORGANISATIONS &gt;**</li></ul>|
| YouTube | YouTube Videos by channel;<ul><li>**&lt; INSERT NAMES OF YOUTUBE CHANNELS &gt;**</li></ul>|

**&lt; NOTE: There is various limitations for each social media custom collection and what and how content is crawled depending on the version of funnelback. It is update to the implementor to understand these limitations before changing the business logic for crawling. &gt;**

### Included content types
The following social media content types will be included in the funnelback index.
	+ Facebook Post
	+ Facebook Event
	+ Facebook Page
	+ Twitter tweet
	+ Flickr picture
	+ YouTube videos

## Excluded content
This section details the content which is to be explicitly ignored by Funnelback.
Any URLs that contain any of the listed patterns as substrings will be excluded by the web crawler.  This will also prevent the web crawler accessing any links that are linked from an excluded page (if there is no other method of browsing to the page).

**&lt; NOTE: There is various limitations for each social media custom collection and what and how content is crawled depending on the version of funnelback. It is update to the implementor to understand these limitations before changing the business logic for crawling. &gt;**

| Social Network | Content to exclude |
| ----------- | ------ |
| ... | ... |
