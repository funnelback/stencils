<#ftl encoding="utf-8" />


<#--
	Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
	Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
	Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>
<#--
	Description: Custom view used for project specific logic. This file will be created for each new project.
-->

<#assign StencilsLibrariesPrefix = "/web/templates/modernui/stencils-libraries/" >
<#assign StencilsThirdpartyResourcesPrefix = "${SearchPrefix}stencils-resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${StencilsLibrariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import the main macros used to put together this project -->
<#import "project.controller.ftl" as project_controller/>

<#-- Import Stencils -->
<#assign stencils=["core","base", "tabs"] />
	<#--
		The following code imports and assigns stencil namespaces automatically eg. core_view and core_controller.
		The code expects that the controller files are located under $SEARCH_HOME/web/templates/modernui/stencils-libraries/
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
	- Copy base.controller.ftl from  $SEARCH_HOME/web/templates/modernui/stencils-libraries/ and store it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
	- Change 'stencils = ["core", "base"]' to 'stencils = ["core"]'
	- Add '<#import "base.controller.ftl" as base_controller>' to the top of your file
	- Add '<#import "base.view.ftl" as base_view>' to the top of your file
-->

<#--
	Prints the markup to include the CSS dependencies for this project.
 -->
<#macro CSS>

</#macro>

<#--
	Prints the markup to include the JavaScript dependencies for this project.
 -->
<#macro JS>

</#macro>

<#--
	Responsible for determining how the results pane
	are to be displayed
-->
<#macro Results>
	<!--- project.view.ftl :: Results -->
	<#-- Display the tab menu -->
	<@tabs_view.TabMenu />
	<hr />

	<#-- Display the results of the select tab-->
	<@tabs_controller.TabPane facet="Tabs">
		<#-- All Results tab -->
		<@tabs_controller.IsTabSelected code="1" value="All Results">
			<@AllResultsPane />
		</@tabs_controller.IsTabSelected>

		<#-- Funnelback Site tab -->
		<@tabs_controller.IsTabSelected code="10" value="Funnelback Site">
			<@FunnelbackSitePane />
		</@tabs_controller.IsTabSelected>

		<#-- Current Docs tab -->
		<@tabs_controller.IsTabSelected code="11" value="Current Docs">
			<@FunnelbackSitePane />
		</@tabs_controller.IsTabSelected>

		<#-- Previous versions tab -->
		<@tabs_controller.IsTabSelected code="12" value="Previous Versions">
			<@FunnelbackSitePane />
		</@tabs_controller.IsTabSelected>

		<#-- The default tab when no tab has been selected -->
		<@tabs_controller.NoTabSelected name="Tabs">
			<@AllResultsPane />
		</@tabs_controller.NoTabSelected>
	</@tabs_controller.TabPane>

</#macro>

<#-- Represents the items which are to displayed when the All Results tab is selected -->
<#macro AllResultsPane>
	<!--- project.view.ftl :: AllResultsPane -->
	<section id="search-main" class="row"  data-ng-show="isDisplayed('results')">
		<div class="col-md-<@core_controller.FacetedSearch>9 col-md-push-3</@core_controller.FacetedSearch><@core_controller.FacetedSearch negate=true>12</@core_controller.FacetedSearch>">
			<@core_view.QueryHistory />
			<@core_view.SearchHistory />
			<@core_view.Scope />
			<@core_view.Count />
			<@core_view.Blending />
			<@core_view.CuratorExhibits />
			<@core_view.Spelling />
			<@core_view.NoResultSummary />
			<@core_view.EntityDefinition />
			<@core_view.CuratorExhibitsList />
			<@core_view.BestBets />
			<@core_view.Results />
			<@core_view.Pagination />
			<@core_view.ContextualNavigation />

			<@tabs_view.TabPreview extraSearchName="current_docs" code="11" value="Current Docs" />
		</div>
		<#-- Only show the "Date" facet -->
		<@core_view.Facets names=["Date", "Author"] />
	</section>
</#macro>

<#-- Represents the items which are to displayed when the Funnelback Site tab is selected -->
<#macro FunnelbackSitePane>
	<!--- project.view.ftl :: FunnelbackSitePane -->
	<section id="search-main" class="row"  data-ng-show="isDisplayed('results')">
		<div class="col-md-<@core_controller.FacetedSearch>9 col-md-push-3</@core_controller.FacetedSearch><@core_controller.FacetedSearch negate=true>12</@core_controller.FacetedSearch>">
			<@core_view.QueryHistory />
			<@core_view.SearchHistory />
			<@core_view.Scope />
			<@core_view.Count />
			<@core_view.Blending />
			<@core_view.CuratorExhibits />
			<@core_view.Spelling />
			<@core_view.NoResultSummary />
			<@core_view.EntityDefinition />
			<@core_view.CuratorExhibitsList />
			<@core_view.BestBets />
			<@core_view.Results />
			<@core_view.Pagination />
			<@core_view.ContextualNavigation />
		</div>
		<#-- Only show the "Date" facet -->
		<@core_view.Facets names=["Date", "Author"] />
	</section>
</#macro>

<#-- Represents the items which are to displayed when the Current Docs tab is selected -->
<#macro CurrentDocsPane>
	<!--- project.view.ftl :: CurrentDocsPane -->
	<section id="search-main" class="row"  data-ng-show="isDisplayed('results')">
		<div class="col-md-<@core_controller.FacetedSearch>9 col-md-push-3</@core_controller.FacetedSearch><@core_controller.FacetedSearch negate=true>12</@core_controller.FacetedSearch>">
			<@core_view.QueryHistory />
			<@core_view.SearchHistory />
			<@core_view.Scope />
			<@core_view.Count />
			<@core_view.Blending />
			<@core_view.CuratorExhibits />
			<@core_view.Spelling />
			<@core_view.NoResultSummary />
			<@core_view.EntityDefinition />
			<@core_view.CuratorExhibitsList />
			<@core_view.BestBets />
			<@core_view.Results />
			<@core_view.Pagination />
			<@core_view.ContextualNavigation />
		</div>
		<#-- Only show the "Date" facet -->
		<@core_controller.Facets names=["Date", "Author"] />
	</section>
</#macro>

<#-- Represents the items which are to displayed when the Previous version tab is selected -->
<#macro PreviousVersionsPane>
	<!--- project.view.ftl :: PreviousVersionsPane -->
	<section id="search-main" class="row"  data-ng-show="isDisplayed('results')">
		<div class="col-md-<@core_controller.FacetedSearch>9 col-md-push-3</@core_controller.FacetedSearch><@core_controller.FacetedSearch negate=true>12</@core_controller.FacetedSearch>">
			<@core_view.QueryHistory />
			<@core_view.SearchHistory />
			<@core_view.Scope />
			<@core_view.Count />
			<@core_view.Blending />
			<@core_view.CuratorExhibits />
			<@core_view.Spelling />
			<@core_view.NoResultSummary />
			<@core_view.EntityDefinition />
			<@core_view.CuratorExhibitsList />
			<@core_view.BestBets />
			<@core_view.Results />
			<@core_view.Pagination />
			<@core_view.ContextualNavigation />
		</div>
		<#-- Only show the "Date" facet -->
		<@core_view.Facets names=["Date", "Author"] />
	</section>
</#macro>

</#escape>