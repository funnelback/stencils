<#ftl encoding="utf-8" />
<#-- Replace **template** with new stencil name and remove this comment  -->
<#---
	<ENTER_DESCRIPTION_PURPOSE_FOR_FILE>

		<h2>Table of Contents</h2>
		<ul>
			<li><strong>Configuration:</strong> Configuration options for **template** Stencil.</li>
			<li><strong>...:</strong> ...</li>
		</ul>
-->
<#escape x as x?html>
<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign **template**ResourcesPrefix = "/stencils/resources/**template**/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${librariesPrefix}**template**/controllers/**template**.controller.ftl" as **template**_controller/>

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core"] />
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
	<!-- **template**.view.ftl.view.ftl :: CSS -->
	<link rel="stylesheet" href="${**template**ResourcesPrefix}css/**template**.css">
</#macro>

<#---
	JavaScript dependencies
-->
<#macro JS>
	<!-- **template**.view.ftl.view.ftl :: JS -->
	<script src="${**template**ResourcesPrefix}js/**template**.js"></script>
</#macro>
<#-- @end --><#-- /Configuration -->
<#-- ###################  Views ####################### -->
<#-- @begin  ... -->

<#-- @end --><#-- / Category - ... -->
</#escape>
