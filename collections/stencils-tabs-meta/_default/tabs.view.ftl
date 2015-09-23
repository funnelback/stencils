<#ftl encoding="utf-8" />
<#--
	 Funnelback App: Tabs
	 By: Gioan Tran
	 Description:
		This file aims to store the client specific markup required for implementations.
		It also contains out of the box markup which can be used as a basis for further
		customisations.

		In order to use the stencil layout, facets which represents the tabs needs to be created.
		The following also needs to be added to the collection.cfg file: ui.modern.full_facets_list=true
-->

<#--
	Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
	Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
	Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Stencils which are to be included -->
<#assign stencils = ["core"] />

<#--
	The following code imports and assigns stencil namespaces automatically eg. core and core_view.
	The code expects that the controller files are located under $SEARCH_HOME/web/templates/modernui/stencils-libraries/
	and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/

	Note: The full path has been added to ensure that the correct folder is being picked up
-->
<#list stencils as stencil>
	<#assign controller = "/web/templates/modernui/stencils-libraries/${stencil}.controller.ftl" stencilNamespaceController="${stencil?lower_case}_controller" />
	<#assign view ="/conf/${question.collection.id}/${question.profile}/${stencil}.view.ftl" stencilNamespaceView="${stencil?lower_case}_view" />
	<@'<#import controller as ${stencilNamespaceController}>'?interpret />
	<@'<#import view as ${stencilNamespaceView}>'?interpret />
</#list>

<#--
	If for any reason you need to modify a controller (not recommended as it will no longer be upgraded as part of the stencils release cycle), you can remove the stencil from the stencils array, take a copy of the controller and move it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/. You will then need to import it using the following:

	<#import "<stencil name>.controller.ftl" as <stencil name>_controller>
	<#import "<stencil name>.view.ftl" as <stencil name>_view>

	e.g. If you are using the core and base stencil but you want to override the base.controller.ftl

	You will need to:
	- Copy base.controller.ftl from  $SEARCH_HOME/web/templates/modernui/stencils-libraries/ and store it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
	- Change 'stencils = ["core", "base"]' to 'stencils = ["core"]'
	- Add '<#import "base.controller.ftl" as base_controller>' to the top of your file
	- Add '<#import "base.view.ftl" as base_view>' to the top of your file
-->

<#-- Import the main macros used to put together this app -->
<#import "/web/templates/modernui/stencils-libraries/tabs.controller.ftl" as tabs_controller/>

<#--
	The following functions are generic layout code which can be copied and customised
	to suit individual implementations.

	Note: Before the tab layout can be used, you must enable the full facet list by addition the following to collection.cfg

	ui.modern.full_facets_list=true

	It is also best practice to hide the facet group which has been used to populate the tabs from the list of available facets
--->

<#-- Sample implementation of tabs which can be customised -->
<#macro TabMenu>
	<@tabs_controller.TabSearch>
		<div class="btn-group" data-input="pagetype">
			<@tabs_controller.Tabs name="Tabs">
				<@tabs_controller.Tab>
					<button type="button" class="btn btn-default remove-outline <@tabs_controller.IsActive>active</@tabs_controller.IsActive> <@tabs_controller.IsDisabled>disabled</@tabs_controller.IsDisabled>">
						<a href="<@tabs_controller.Url />" alt="<@tabs_controller.Name />" title="<@tabs_controller.Name />">
							<@tabs_controller.Name /> <span class="text-muted"> (<@tabs_controller.Count />) </span>
						</a>
					</button>
				</@tabs_controller.Tab>
			</@tabs_controller.Tabs>
		</div>
	</@tabs_controller.TabSearch>
</#macro>

<#-- Sample implementation of tabs which is useful for an A-Z listing -->
<#macro AZListing>
	<@tabs_controller.TabSearch>
		<ul class="pagination">
			<@tabs_controller.Tabs name="Tabs">
				<@tabs_controller.Tab>
					<li class="<@tabs_controller.IsActive>active</@tabs_controller.IsActive> <@tabs_controller.IsDisabled>disabled</@tabs_controller.IsDisabled>">
						<a href="<@tabs_controller.Url />" alt="<@tabs_controller.Name />" title="<@tabs_controller.Name /> (<@tabs_controller.Count />)">
							<@tabs_controller.Name />
						</a>
					</li>
				</@tabs_controller.Tab>
			</@tabs_controller.Tabs>
		</ul>
	</@tabs_controller.TabSearch>
</#macro>

<#-- Sample implementation of showing an extra search as a tab preview -->
<#macro TabPreview extraSearchName code value>
	<@tabs_controller.Preview extraSearchName=extraSearchName>
		<div class="well">
			<h3>More results for '<strong>'<@s.QueryClean />'</strong> </h3>

			<#-- Display results for the extra search -->
			<@core_controller.Results />

			<#-- Provides a link which provides more results from the extra search -->
			<@tabs_controller.PreviewMoreLinkArea>
				<a href="<@tabs_controller.PreviewMoreLink code=code value=value />"> <span class="glyphicon glyphicon-plus"></span> More results from this collection</a>
			</@tabs_controller.PreviewMoreLinkArea>
		</div>
	</@tabs_controller.Preview>
</#macro>

</#escape>