Implementation - Getting Started
=================
This page contains the steps required in order to implement the Social Media Stencil into a project.

The Social Media Stencil is an extension of features within the [Core Stencil's Panel variation](https://gitlab.squiz.net/stencils/stencils-core_panels_meta/tree/master), with the main distinction being that results formats for social media are used. It integrates the components defined in the Facebook, Twitter, Flickr and YouTube Stencils to produce a singular search application.

## Dependencies
### Stencils
The following Stencils are in order for the Social Media Stencil to function;
+ Base
+ Core
+ Facebook
+ Twitter
+ Flickr
+ YouTube

### Key Collection Files

The following are the key files required in your collection. Required / Affected / Key Files
* [faceted_navigation.cfg](faceted_navigation.cfg)
* [project.view.ftl](/_default_preview/project.view.ftl)
* [project.controller.ftl](/_default_preview/project.controller.ftl)
* [social.view.ftl](/_default_preview/social.view.ftl)
* [facebook.view.ftl](/_default_preview/facebook.view.ftl)
* [twitter.view.ftl](/_default_preview/twitter.view.ftl)
* [flickr.view.ftl](/_default_preview/flickr.view.ftl)
* [youtube.view.ftl](/_default_preview/youtube.view.ftl)

The following are existing files within your collection that have been modified for this stencil.
* [collection.cfg](collection.cfg)
* [simple.ftl](/_default_preview/simple.ftl)

## Configurations
In order to implement the Social Media Stencil, please refer to the following:

### Collection Configurations [collection.cfg](/collection.cfg)
Set the follow to correspond to your current project, as these settings will be overidden when cloning the stencils files from github;
```ini
collection=stencils-social-meta
collection_group=Stencils
service_name=Stencils - Social - Meta
```

The key settings within the collection config that are required are for this stencils to work are;
```ini
query_processor_options= -SM=both -SF=[a,c,d,stencilsFacebookPostID,stencilsFacebookEventID,stencilsFacebookPageID,stencilsFacebookPostUserID,stencilsFacebookEventUserID,stencilsFacebookPageAbout,stencilsFacebookPageCategory,stencilsFacebookEventEndDateTime,stencilsFacebookPostLink,stencilsFacebookPageFounded,stencilsFacebookPostLinkCaption,stencilsFacebookPostLinkDescription,stencilsFacebookPostThumbnailUrl,stencilsFacebookPostIconURL,stencilsFacebookEventLocation,stencilsFacebookPageMission,stencilsFacebookPagePhone,stencilsFacebookEventVenueState,stencilsFacebookPageState,stencilsFacebookPostState,stencilsFacebookPageProducts,stencilsFacebookEventPrivacy,stencilsFacebookEventVenuePostCode,stencilsFacebookPagePostcode,stencilsFacebookPostPostcode,stencilsFacebookEventVenueStreet,stencilsFacebookPageStreet,stencilsFacebookPostStreet,stencilsFacebookType,stencilsFacebookEventVenueCountry,stencilsFacebookPageCountry,stencilsFacebookPostCountry,stencilsFacebookEventVenueCity,stencilsFacebookPageCity,stencilsFacebookPostCity,stencilsFacebookPostLatLong,stencilsFacebookEventStartDateTime,stencilsFlickrPhotoID,stencilsFlickrPhotoOwnerUserName,stencilsFlickrPhotoThumbNailUrl,stencilsFlickrPhotoSmallImage320Url,stencilsFlickrPhotoSmallImageSquareUrl,stencilsFlickrPhotoMediumImageUrl,stencilsFlickrPhotoMediumImage640Url,stencilsFlickrPhotoMediumImage800Url,stencilsFlickrPhotoLargeImageUrl,stencilsTwitterID,stencilsTwitterScreenName,stencilsTwitterProfileImageUrl,stencilsTwitterDisplayUrl,stencilsTwitterHashtag,stencilsTwitterPlaceName,stencilsTwitterCountry,stencilsTwitterPictureUrl,stencilsTwitterLatlong,stencilsYoutubeChannelTitle,stencilsYoutubeViewCount,stencilsYoutubeLikes,stencilsYoutubeDislikes,stencilsYoutubeCategory,stencilsYoutubeDurationInSeconds,stencilsYoutubeDurationPretty,stencilsYoutubeThumbNailUrl,stencilsYoutubeLatlong,stencilsYoutubeID,stencilsYoutubeEmbedHtml,stencilsYoutubeThumbNailUrlHigh,stencilsYoutubeThumbNailUrlUrlMed,stencilsYoutubeChannelID,stencilsYoutubeChannelUrl]
ui.modern.full_facets_list=true
ui.modern.session=true
```
### Custom collections and [meta.cfg](/meta.cfg.cfg)
1. Created custom collections for Facebook, Twitter, Flickr, YouTube.
 	*	Clone the following projects from gitlab as your starting templates;
	*	_**NOTE:** Following implementation instructions for each of these projects when cloning)_
		+ [stencils-facebook-custom](https://gitlab.squiz.net/stencils/stencils-facebook-custom/tree/master)
		+ [stencils-twitter-custom](https://gitlab.squiz.net/stencils/stencils-twitter-custom/tree/master)
		+ [stencils-youtube-custom](https://gitlab.squiz.net/stencils/stencils-youtube-custom/tree/master)
		+ [stencils-flickr-custom](https://gitlab.squiz.net/stencils/stencils-flickr-custom/tree/master)
2. Assign the newly created custom collections to the projectsr [meta.cfg](/meta.cfg) file.
	* _**NOTE:** Remove the existing 'stencils-*' entries from meta.cfg if meta.cfg is cloned from gitlab_

### Results
#### Manage which result formats are used.
Within the [project.view.ftl](/_default_preview/project.view.ftl) the following result types have been defined to display;
+ Facebook Post
+ Facebook Event
+ Facebook Page
+ Twitter Tweet
+ Flickr Picture
+ YouTube Video

The names of the custom collections corresponding to social media repository need to be defined. This will always change per project.
```html
<#assign collectionNameFacebook = "stencils-facebook-custom" >
<#assign collectionNameTwitter = "stencils-twitter-custom" >
<#assign collectionNameFlickr = "stencils-flickr-custom" >
<#assign collectionNameYoutube = "stencils-youtube-custom" >
```

The assigned collection names above are mapped into the macro below. Just remove or add any of the formats you wish to use.
```html
<#---
	Defines which result format should be used.
 -->
<#macro Result>
  <#-- Collection: stencils-facebook-custom -->
  <@base_controller.ResultIsCollection name=collectionNameFacebook >
    <@facebook_controller.ResultIsTypeOf type="post">
      <@facebook_view.ResultPost />
    </@facebook_controller.ResultIsTypeOf>

    <@facebook_controller.ResultIsTypeOf type="page">
      <@facebook_view.ResultPage />
    </@facebook_controller.ResultIsTypeOf>

    <@facebook_controller.ResultIsTypeOf type="event">
      <@facebook_view.ResultEvent />
    </@facebook_controller.ResultIsTypeOf>
  </@base_controller.ResultIsCollection>

  <#-- Collection: stencils-twitter-custom -->
  <@base_controller.ResultIsCollection name=collectionNameTwitter >
    <@twitter_view.Result />
  </@base_controller.ResultIsCollection>

  <#-- Collection: stencils-youtube-custom -->
  <@base_controller.ResultIsCollection name=collectionNameYoutube >
    <@youtube_view.Result />
  </@base_controller.ResultIsCollection>

  <#-- Collection: stencils-flickr-custom -->
  <@base_controller.ResultIsCollection name=collectionNameFlickr >
     <@flickr_view.Result />
  </@base_controller.ResultIsCollection>

</#macro>
```
#### Edit the result formats
Each variation of the result formats is managed by it's own Stencil's view, see the following files, looking specifically for any macros prefixed with 'Result';
* [facebook.view.ftl](/_default_preview/facebook.view.ftl)
* [twitter.view.ftl](/_default_preview/twitter.view.ftl)
* [flickr.view.ftl](/_default_preview/flickr.view.ftl)
* [youtube.view.ftl](/_default_preview/youtube.view.ftl)

_**NOTE:** For every result there is also a result modal view that is managed as it's own macro_

### Facets
Facets have been predefined for collection, author and published date.

#### By Collection
This facet setup has been achieved via GSCOPING each custom collection. See [Faceted navigation over meta collections](https://confluence.cbr.au.funnelback.com/display/KB/Faceted+navigation+over+meta+collections)

_**NOTE:** This means that the GSCOPEs 1-4 are now reserved._
The gscopes.cfg should be set should for all the custom collections sourced. This will be predifined if you have cloned the custom collections from gitlab as;
1. Facebook
2. Flickr
3. Twitter
4. YouTube
