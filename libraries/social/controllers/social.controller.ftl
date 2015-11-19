<#ftl encoding="utf-8" />
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
<#assign stencils=["core"] />

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
	Get facebook componeont collections defined in colleciton.cfg to be used.
 -->
<#macro ConfigFacebookCollections><#compress>
<#if question.collection.configuration.value("stencils.social.collections.facebook")?? >
${question.collection.configuration.value("stencils.social.collections.facebook")}
</#if>
</#compress></#macro>

<#---
	Get Twitter componeont collections defined in colleciton.cfg to be used.
 -->
<#macro ConfigTwitterCollections><#compress>
<#if question.collection.configuration.value("stencils.social.collections.twitter")?? >
${question.collection.configuration.value("stencils.social.collections.twitter")}
</#if>
</#compress></#macro>

<#---
	Get Flickr componeont collections defined in colleciton.cfg to be used.
 -->
<#macro ConfigFlickrCollections><#compress>
<#if question.collection.configuration.value("stencils.social.collections.flickr")?? >
${question.collection.configuration.value("stencils.social.collections.flickr")}
</#if>
</#compress></#macro>

<#---
	Get YouTube componeont collections defined in colleciton.cfg to be used.
 -->
<#macro ConfigYoutubeCollections><#compress>
<#if question.collection.configuration.value("stencils.social.collections.youtube")?? >
${question.collection.configuration.value("stencils.social.collections.youtube")}
</#if>
</#compress></#macro>

</#escape>
