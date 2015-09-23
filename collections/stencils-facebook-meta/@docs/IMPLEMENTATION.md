Implementation - Getting Started
=================
This page contains the steps required in order to implement the Facebook Stencil into a project.

The Facebook Stencil is an extension of features within the [Core Stencil's Panel variation](https://gitlab.squiz.net/stencils/stencils-core_panels_meta/tree/master), with the main distinction being that results formats for social media are used. It integrates the components defined in the Facebook to produce a singular search application.

## Dependencies
### Stencils
The following Stencils are in order for the Social Media Stencil to function;
+ [Base](https://gitlab.squiz.net/stencils/stencils-core-meta/tree/master)
+ [Core](https://gitlab.squiz.net/stencils/stencils-core-meta/tree/master)
+ Facebook

### Key Collection Files

The following are the key files required in your collection. Required / Affected / Key Files
* [faceted_navigation.cfg](faceted_navigation.cfg)
* [project.view.ftl](/_default_preview/project.view.ftl)
* [project.controller.ftl](/_default_preview/project.controller.ftl)
* [facebook.view.ftl](/_default_preview/facebook.view.ftl)

The following are existing files within your collection that have been modified for this stencil.
* [collection.cfg](collection.cfg)
* [simple.ftl](/_default_preview/simple.ftl)

## Configurations
In order to implement the Facebook Stencil, please refer to the following:

### [collection.cfg](/collection.cfg)
Update the following settings in your collection.cfg as these settings will be overridden when cloning the stencils files from github;
```ini
collection=stencils-facebook-meta
collection_group=Stencils
service_name=Stencils - Facebook - Meta
```

The key settings within the collection.cfg that are required are for this stencils are;
```ini
query_processor_options= -SM=both -SF=[a,c,d,stencilsFacebookPostID,stencilsFacebookEventID,stencilsFacebookPageID,stencilsFacebookPostUserID,stencilsFacebookEventUserID,stencilsFacebookPageAbout,stencilsFacebookPageCategory,stencilsFacebookEventEndDateTime,stencilsFacebookPostLink,stencilsFacebookPageFounded,stencilsFacebookPostLinkCaption,stencilsFacebookPostLinkDescription,stencilsFacebookPostThumbnailUrl,stencilsFacebookPostIconURL,stencilsFacebookEventLocation,stencilsFacebookPageMission,stencilsFacebookPagePhone,stencilsFacebookEventVenueState,stencilsFacebookPageState,stencilsFacebookPostState,stencilsFacebookPageProducts,stencilsFacebookEventPrivacy,stencilsFacebookEventVenuePostCode,stencilsFacebookPagePostcode,stencilsFacebookPostPostcode,stencilsFacebookEventVenueStreet,stencilsFacebookPageStreet,stencilsFacebookPostStreet,stencilsFacebookType,stencilsFacebookEventVenueCountry,stencilsFacebookPageCountry,stencilsFacebookPostCountry,stencilsFacebookEventVenueCity,stencilsFacebookPageCity,stencilsFacebookPostCity,stencilsFacebookPostLatLong,stencilsFacebookEventStartDateTime]
ui.modern.full_facets_list=true
ui.modern.session=true
```
### Create custom collection(s) for Facebook
1. Setup a new facebook custom collection and use [stencils-facebook-custom](https://gitlab.squiz.net/stencils/stencils-facebook-custom/tree/master) from gitlab as your starting template.
2. Configure [custom_gather.groovy](https://gitlab.squiz.net/stencils/stencils-facebook-custom/blob/master/custom_gather.groovy) as defined [below](#custom_gather-groovy).
3. Run collection update.
4. Assign custom collection(s) to the project's [meta.cfg](/meta.cfg) file.
  + _**NOTE:** Override/Remove the existing 'stencils-*' entries from meta.cfg_

#### [custom_gather.groovy](https://gitlab.squiz.net/stencils/stencils-facebook-custom/blob/master/custom_gather.groovy)
Set a new appId and appSecret specific for your project. (**Do not use existing one set as it's for development only**).

```Groovy
/**
* Your app id and app secret.
*
* You are going to need this to access pages which require you to log in to view them.
* To get this you will first need a Facebook account. You will then need to go to
* https://developers.facebook.com/apps and create an app, this will give you your
* app Id and app secret.
*/
String appId = "1444644072494648";
String appSecret = "569a0c7d7a4759e67be94ecb86b833ec";
```
Define which Facebook profile to crawl events, posts and pages format.

```Groovy
/**
* You should add your profiles to crawl here.
*/
List<String> profiles = [
    "AusINSArchitects"
    ,"australianmarketinginstitute"
    ,"AustralianInstituteOfCoaching"
    ,"AustInstituteCreativeDesign"
    ,"AIPPOfficial"
    ,"CertifiedHero"
    ,"aimcomau"
    ,"melbuni"
    ,"latrobe"
    ,"Australian.Catholic.University"
    ,"swinburneuniversityoftechnology"
    ,"RMITuniversity"
];
```
Define what content types you want to crawl for those profiles.
```Groovy
//Comment out any of the queries below to exclude crawling page, posts or event content type for a profile.
profiles.each {
    queries.push( new FacebookQueryPage(facebookClientApp, it) );
    queries.push( new FacebookQueryPost(facebookClientApp, it + "/posts" ) )
    queries.push( new FacebookQueryEvent(facebookClientApp, it + "/events") );
}
```

### Results
#### Manage which result formats are used.
Within the [project.view.ftl](/_default_preview/project.view.ftl) the following result types have been defined to display;
+ Facebook Post
+ Facebook Event
+ Facebook Page


```html
<#---
	Defines which result format should be used.
 -->
<#macro Result>
    <@facebook_controller.ResultIsTypeOf type="post">
      <@facebook_view.ResultPost />
    </@facebook_controller.ResultIsTypeOf>

    <@facebook_controller.ResultIsTypeOf type="page">
      <@facebook_view.ResultPage />
    </@facebook_controller.ResultIsTypeOf>

    <@facebook_controller.ResultIsTypeOf type="event">
      <@facebook_view.ResultEvent />
    </@facebook_controller.ResultIsTypeOf>
</#macro>
```
#### Edit the result formats
See the following macros in [facebook.view.ftl](/_default_preview/facebook.view.ftl);
+ ResultPost & ResultPostModal.
+ ResultEvent & ResultEventModal.
+ ResultPage & ResultPageModal.

### Facets
Facets have been predefined for Facebook content type, location, author and published date.
