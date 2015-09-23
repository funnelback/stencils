<#ftl encoding="utf-8" />
<#---
	This contains the controllers specific to this project.
-->
<#escape x as x?html>
<#--
	##############################################################
			TABLE OF CONTENTS
			C. Configuration
			V. Views
				V. X

	##############################################################
 -->

<#-- ################### C. Configuration ####################### -->

<#assign StencilsLibrariesPrefix = "/share/stencils/libraries/" >
<#assign ProjectResourcesPrefix = "/s/resources/${question.collection.id}/${question.profile}/" >
<#assign StencilsThirdpartyResourcesPrefix = "${SearchPrefix}stencils-resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${StencilsLibrariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "project.controller.ftl" as project_controller/>

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils = [] />
<#-- Import Stencils -->
	<#--
	The following code imports and assigns stencil namespaces automatically eg. core_view and core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/
	and the view files located under $SEARCH_HOME/conf/\$COLLECTION_NAME/<profile>/
	-->
<@stencils_utilities.ImportStencils stencils=stencils>
	<@stencils_utilities.imports?interpret />
</@stencils_utilities.ImportStencils>

<#---
	Stylesheet dependencies.
 -->
<#macro CSS>
	<!-- project.view.ftl.view.ftl :: CSS -->
	<link rel="stylesheet" href="${ProjectResourcesPrefix}css/project.css">
</#macro>

<#---
	JavaScript dependencies.
 -->
<#macro JS>
	<!-- project.view.ftl.view.ftl :: JS -->
	<script src="${ProjectResourcesPrefix}js/project.js"></script>
</#macro>

<#-- ################### V. Views ####################### -->
<#-- @begin V. X -->
<#-- @end --><#-- /V. X -->

</#escape>
