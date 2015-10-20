<#ftl encoding="utf-8" />
<#---
	This contains views which can be used specifically for no results.

		<h2>Table of Contents</h2>
		<ul>
			<li><strong>Configuration:</strong> Configuration options for noresult Stencil.</li>
		</ul>
-->
<#escape x as x?html>
<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign noresultResourcesPrefix = "/stencils/resources/noresult/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${librariesPrefix}noresult/controllers/noresult.controller.ftl" as noresult_controller/>

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core","base","noresult"] />
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
	<!-- noresult.view.ftl.view.ftl :: CSS -->
	<link rel="stylesheet" href="${noresultResourcesPrefix}css/noresult.css">
</#macro>

<#---
	JavaScript dependencies
-->
<#macro JS>
	<!-- noresult.view.ftl.view.ftl :: JS -->
	<#-- <script src="${noresultResourcesPrefix}js/noresult.js"></script> -->
</#macro>
<#-- @end --><#-- /Configuration -->
<#-- ###################  Views ####################### -->

<#macro Content>
	<@core_view.NoResultSummary />
	<@noresult_controller.NoResult>

		<@core_view.QueryHistory />

		<h2>Have you tried?</h2>

		<@core_view.Blending />
		<@core_view.CuratorExhibits />
		<@core_view.Spelling />

		<@core_view.EntityDefinition />
		<@core_view.CuratorExhibitsList />
		<@core_view.BestBets />

		<@core_view.Results />
		<@core_view.Pagination />
		<@core_view.ContextualNavigation />
	</@noresult_controller.NoResult>
</#macro>

<#macro Aside>
	<@noresult_controller.NoResult>
		<#--
		 	Do not use facets for now as this will not work as intended see
			https://jira.cbr.au.funnelback.com/browse/FUNNELAPPS-183
		-->
		<@core_view.Facets />
	</@noresult_controller.NoResult>
</#macro>


</#escape>
