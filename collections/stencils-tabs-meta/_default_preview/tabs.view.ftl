<#ftl encoding="utf-8" />
<#---
	Contains the presentation components required to display search results within tabs.

	<p>
		This file aims to store the client specific markup required for implementing tabs.
		It aims to represent the <em> view </em> aspect of Model-View-Control for the tab stencil.
		It also contains out-of-the-box markup which can be used as a basis for further
		customisations.
	</p>

	<p>
		In order to use the tab stencil, facets which represents the tabs needs to be created.
		The following also needs to be added to the <code> collection.cfg </code> file:
		<code> ui.modern.full_facets_list=true </code>
	</p>

	<p>
		It is also best practice to hide the facet group which has been used to populate the
		tabs from the list of available facets
	</p>
-->

<#--
	Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
	Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
	Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#assign StencilsLibrariesPrefix = "/share/stencils/libraries/" >
<#assign StencilsThirdpartyResourcesPrefix = "${SearchPrefix}stencils-resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${StencilsLibrariesPrefix}stencils.utilities.ftl" as stencils_utilities />

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

</#macro>

<#---
	Prints the markup to include the JavaScript dependencies suggested by this Stencil.
 -->
<#macro JS>

</#macro>

<#---
	Displays the tabs available for the current search.

	<p>
		Sample implementation of tabs which can be customised
	</p>
-->
<#macro TabMenu>
	<!-- tabs.view.ftl :: TabMenu -->
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

<#---
	Displays the tabs available for the current search.

	<p>
		Sample implementation of tabs which can be used to display an A-Z listing
	</p>
-->
<#macro AZListing>
	<!-- tabs.view.ftl :: AZListing -->
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

<#---
	Displays a preview of the results from another tab.

	<p>
		By using an extra search, this implementation can be used
		to provide a preview of the results from another tab.
	</p>

	@requires TabPane

	@param code The code of the tab/facet preview e.g. for meta data based facets, it would be the metadata class such as <code> a </code>. For gscope based facets, it would be the gscope number such as <code> 11 </code>
	@param value The value of the tab/facet of the preview e.g. e.g. for meta data based facets, it would be the metadata value such as "funnelback". For gscope based facets, it would be the gscope label
-->
<#-- Sample implementation of showing an extra search as a tab preview -->
<#macro TabPreview extraSearchName code value>
	<!-- tabs.view.ftl :: TabPreview -->
	<@tabs_controller.Preview extraSearchName=extraSearchName>
		<div class="well">
			<h3>More results for '<strong>'<@core_controller.QueryClean />'</strong> </h3>

			<#-- Display results for the extra search -->
			<@core_view.Results />

			<#-- Provides a link which provides more results from the extra search -->
			<@tabs_controller.PreviewMoreLinkArea>
				<a href="<@tabs_controller.PreviewMoreLink code=code value=value />"> <span class="glyphicon glyphicon-plus"></span> More results from this collection</a>
			</@tabs_controller.PreviewMoreLinkArea>
		</div>
	</@tabs_controller.Preview>
</#macro>

</#escape>
