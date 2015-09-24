<#ftl encoding="utf-8" />
<#---
	 <p>Provides views for Social media components.</p>
	 <p>These compontents include items such as ... well just not much at the moment.</p>
	 <p>This should generally not include to anything componets specific to a singluar social media source, these should be added to the invidual social media stencils.</p>

	 <h2>Table of Contents</h2>
	 <ul>
		 <li><strong>Configuration:</strong> Configuration options for Social Media Stencil.</li>
	 </ul>
-->
<#escape x as x?html>

<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign socialResourcesPrefix = "${SearchPrefix}stencils-resources/social/" >
<#assign thirdPartyResourcesPrefix = "${SearchPrefix}stencils-resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${librariesPrefix}social/controllers/social.controller.ftl" as social_controller/>

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core","base"] />
	<#--
	The following code imports and assigns stencil namespaces automatically eg. core_view and core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/
	and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
	-->
<@stencils_utilities.ImportStencils stencils=stencils>
	<@stencils_utilities.imports?interpret />
</@stencils_utilities.ImportStencils>

<#---
	Stylesheet dependencies
 -->
<#macro CSS>
	<!-- social.view.ftl :: CSS -->
	<link rel="stylesheet" href="${socialResourcesPrefix}css/stencils.social.css">
</#macro>

<#---
	JavaScript dependencies
 -->
<#macro JS>
	<!-- social.view.ftl :: JS -->
	<#-- This commented out because stencils.social.js is not required currently -->
	<#-- <script src="${socialResourcesPrefix}js/stencils.social.js"></script> -->
</#macro>
<#-- @end --><#-- /Configuration -->
<#-- ###################  Views ####################### -->

</#escape>
