<#ftl encoding="utf-8" />
<#---
	Contains the presentation components required to display jira results.

	<p>
		This file aims to store the client specific markup required for implementing tabs.
		It aims to represent the <em> view </em> aspect of Model-View-Control for the tab stencil.
		It also contains out-of-the-box markup which can be used as a basis for further
		customisations.
	</p>
-->

<#--
	Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
	Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
	Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign jiraResourcesPrefix = "/stencils/resources/jira/v1.0.0/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import the main macros used to put together this app -->
<#import "/share/stencils/libraries/tabs/controllers/tabs.controller.ftl" as tabs_controller/>

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


<#--
	If for any reason you need to modify a controller (not recommended as it will no longer be upgraded as part of the stencils release cycle), you can remove the stencil from the stencils array, take a copy of the controller and move it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/. You will then need to import it using the following:

	<#import "<stencil name>.controller.ftl" as <stencil name>_controller>
	<#import "<stencil name>.view.ftl" as <stencil name>_view>

	e.g. If you are using the core and base stencil but you want to override the base.controller.ftl

	You will need to:
	- Copy base.controller.ftl from  $SEARCH_HOME/share/stencils/libraries/ and store it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
	- Change 'stencils = ["core", "base"]' to 'stencils = ["core"]'
	- Add '<#import "base.controller.ftl" as base_controller>' to the top of your file
	- Add '<#import "base.view.ftl" as base_view>' to the top of your file
-->

<#---
	Prints the markup to include the CSS dependencies suggested by this stencil.
 -->
<#macro CSS>
	<!-- jira.view.ftl :: CSS -->
	<link rel="stylesheet" href="${jiraResourcesPrefix}css/core.css">
</#macro>

<#---
	Prints the markup to include the JavaScript dependencies suggested by this Stencil.
 -->
<#macro JS>
	<!-- jira.view.ftl :: JS -->
	<script src="${jiraResourcesPrefix}js/core.js"></script>
</#macro>

<#macro Result>
	<#-- Title -->
	<h4>
		<a href="${core_controller.result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="${core_controller.result.title}">
			<@core_controller.boldicize><@core_controller.Truncate length=70>${core_controller.result.title}</@core_controller.Truncate></@core_controller.boldicize>
		</a>
	</h4>

	<#-- Status labels -->
	<#if core_controller.result.metaData["stencilsIssueStatus"]??>
		<#switch core_controller.result.metaData["stencilsIssueStatus"]>
			<#case "Open">
				<span class="label label-danger">Open</span>
				<#break>
			<#case "In Progress">
				<span class="label label-warning">In Progress</span>
				<#break>
			<#case "Reopened">
				<span class="label label-info">Reopened</span>
				<#break>
			<#case "Resolved">
				<span class="label label-success">Resolved</span>
				<#break>
			<#case "Closed">
				<span class="label label-default">Closed</span>
				<#break>
		</#switch>
	</#if>

	<cite class="text-success">
		<@core_controller.boldicize>
		Jira &raquo;
			${core_controller.result.metaData["stencilsProjectName"]!} &raquo;
			${core_controller.result.metaData["stencilsID"]!}
		</@core_controller.boldicize>
		<div class="btn-group text-success">
			<a href="#" class="dropdown-toggle" data-toggle="dropdown" title="More actions&hellip;">
				<small class="glyphicon glyphicon-chevron-down text-success"></small>
			</a>
			<ul class="dropdown-menu">
				<#if core_controller.result.cacheUrl??>
					<li>
						<a href="${core_controller.result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="Cached version of ${core_controller.result.title} (${core_controller.result.rank})">
							Cached
						</a>
					</li>
				</#if>
				<li><@core_controller.Explore /></li>
				<@core_controller.AdminUIOnly>
					<li><@core_controller.Optimise /></li>
				</@core_controller.AdminUIOnly>
			</ul>
		</div>
	</cite>

	<p>
		<#-- Date -->
		<small>
			<span class="text-muted">
				${core_controller.result.date?date?string("d MMM yyyy")}
				&ndash;
				<#if core_controller.result.metaData.a??>${core_controller.result.metaData["a"]}:</#if>
			</span>
		</small>

		<#-- Result summary -->
		<#if core_controller.result.summary?exists && core_controller.result.summary != "">
			<span class="fb-summary">
				<@core_controller.boldicize>
					<@core_controller.Truncate length=200>${core_controller.result.summary}</@core_controller.Truncate>
				</@core_controller.boldicize>
			</span>
		</#if>
	</p>
	<#-- Assignee -->
	<!-- <#if core_controller.result.metaData["M"]??>
		<dl class="dl-horizontal text-muted small">
			<dt><small>Assignee:</small></dt>
			<dd><small>${core_controller.result.metaData["M"]}</small></dd>
		</dl>
	</#if> -->
</#macro>

</#escape>
