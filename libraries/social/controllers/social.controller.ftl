<#ftl encoding="utf-8" />
<#-- DEPRECATED - This file has been deprecated. Please avoid using this file going forward -->
<#---
	<p>Provides helpers for building Social Media components.</p>
	<p>This includes helpers for Social Media ... there is actually nothing useful in here for now.</p>
-->
<#escape x as x?html>

<#-- ################### Configuration ####################### -->
<#-- Import Utilities -->
<#import "/share/stencils/libraries/stencils.utilities.ftl" as stencils_utilities />

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core","base"] />

<#--
	The following code imports and assigns stencil namespaces automatically eg. core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/

 	Note: View files should not be imported to to the controller
-->
<@stencils_utilities.ImportStencilsControllers stencils=stencils>
	<@stencils_utilities.importsControllers?interpret />
</@stencils_utilities.ImportStencilsControllers>

<#-- ################### Controllers ####################### -->
<#---
	Constructor for setting up global configuration variables for social media.
	E.g. gets the collection names set for social compoent collections defined in the collection.cfg.
 -->
<#macro Config>
	<#assign configFacebookCollections in .namespace><@ConfigFacebookCollections /></#assign>
	<#assign configTwitterCollections in .namespace><@ConfigTwitterCollections /></#assign>
	<#assign configFlickrCollections in .namespace><@ConfigFlickrCollections /></#assign>
	<#assign configYoutubeCollections in .namespace><@ConfigYoutubeCollections /></#assign>

	<#nested>
</#macro>

<#---
	Get facebook componeont collections defined in colleciton.cfg to be used.\
	@return component collection config names. (comma separated )
 -->
<#macro ConfigFacebookCollections><#compress>
<#if question.getCurrentProfileConfig().get("stencils.social.collections.facebook")?? >
${question.getCurrentProfileConfig().get("stencils.social.collections.facebook")}
</#if>
</#compress></#macro>

<#---
	Display if component collection is defined as to Facebook in meta collection's collection.cfg
	@return <code>#nested</code>
 -->
<#macro ResultIsCollectionFacebook>
<#assign collections><@ConfigFacebookCollections /></#assign>
<@base_controller.ResultIsCollection name=collections >
	<#nested>
</@base_controller.ResultIsCollection>
</#macro>

<#---
	Get Twitter componeont collections defined in colleciton.cfg to be used.
	@return component collection config names. (comma separated )
 -->
<#macro ConfigTwitterCollections><#compress>
<#if question.getCurrentProfileConfig().get("stencils.social.collections.twitter")?? >
${question.getCurrentProfileConfig().get("stencils.social.collections.twitter")}
</#if>
</#compress></#macro>

<#---
	Display if component collection is defined as to Twitter in meta collection's collection.cfg
	@return <code>#nested</code>
 -->
<#macro ResultIsCollectionTwitter>
<#assign collections><@ConfigTwitterCollections /></#assign>
<@base_controller.ResultIsCollection name=collections >
	<#nested>
</@base_controller.ResultIsCollection>
</#macro>

<#---
	Get Flickr componeont collections defined in colleciton.cfg to be used.
	@return component collection config names. (comma separated )
 -->
<#macro ConfigFlickrCollections><#compress>
<#if question.getCurrentProfileConfig().get("stencils.social.collections.flickr")?? >
${question.getCurrentProfileConfig().get("stencils.social.collections.flickr")}
</#if>
</#compress></#macro>

<#---
	Display if component collection is defined as to Flickr in meta collection's collection.cfg
	@return <code>#nested</code>
 -->
<#macro ResultIsCollectionFlickr>
<#assign collections><@ConfigFlickrCollections /></#assign>
<@base_controller.ResultIsCollection name=collections >
	<#nested>
</@base_controller.ResultIsCollection>
</#macro>

<#---
	Get YouTube componeont collections defined in colleciton.cfg to be used.
	@return component collection config names. (comma separated )
 -->
<#macro ConfigYoutubeCollections><#compress>
<#if question.getCurrentProfileConfig().get("stencils.social.collections.youtube")?? >
${question.getCurrentProfileConfig().get("stencils.social.collections.youtube")}
</#if>
</#compress></#macro>

<#---
	Display if component collection is defined as to Twitter in meta collection's collection.cfg
	@return <code>#nested</code>
 -->
<#macro ResultIsCollectionYoutube>
<#assign collections><@ConfigYoutubeCollections /></#assign>
<@base_controller.ResultIsCollection name=collections >
	<#nested>
</@base_controller.ResultIsCollection>
</#macro>

</#escape>
