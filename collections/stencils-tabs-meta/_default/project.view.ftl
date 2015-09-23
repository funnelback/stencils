<#ftl encoding="utf-8" />
<#--
	 By: Gioan Tran
	Description: Custom controller used for project specific logic. This file will be created for each new project.
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
<#assign stencils = ["core", "tabs"] />

<#--
	The following code imports and assigns stencil namespaces automatically eg. core_view and core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/
	and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/

	Note: The full path has been added to ensure that the correct folder is being picked up
-->
<#list stencils as stencil>
	<#assign controller = "/share/stencils/libraries/${stencil}.controller.ftl" stencilNamespaceController="${stencil?lower_case}_controller" />
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
	- Copy base.controller.ftl from  $SEARCH_HOME/share/stencils/libraries/ and store it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
	- Change 'stencils = ["core", "base"]' to 'stencils = ["core"]'
	- Add '<#import "base.controller.ftl" as base_controller>' to the top of your file
	- Add '<#import "base.view.ftl" as base_view>' to the top of your file
-->

<#-- Import the main macros used to put together this project -->
<#import "/conf/${question.collection.id}/${question.profile}/project.controller.ftl" as project_controller/>

<#macro Results>
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
	<section id="search-main" class="row"  data-ng-show="isDisplayed('results')">
		<div class="col-md-<@s.FacetedSearch>9 col-md-push-3</@s.FacetedSearch><@s.FacetedSearch negate=true>12</@s.FacetedSearch>">
			<@core_controller.QueryHistory />
			<@core_controller.SearchHistory />
			<@core_controller.Scope />
			<@core_controller.Count />
			<@core_controller.Blending />
			<@core_controller.CuratorExhibits />
			<@core_controller.Spelling />
			<@core_controller.NoResultSummary />
			<@core_controller.EntityDefinition />
			<@core_controller.CuratorExhibitsList />
			<@core_controller.BestBets />
			<@core_controller.Results />
			<@core_controller.Pagination />
			<@core_controller.ContextualNavigation />

			<@tabs_view.TabPreview extraSearchName="current_docs" code="11" value="Current Docs" />
		</div>
		<#-- Only show the "Date" facet -->
		<@core_controller.Facets names=["Date", "Author"] />
	</section>
</#macro>

<#-- Represents the items which are to displayed when the Funnelback Site tab is selected -->
<#macro FunnelbackSitePane>
	<section id="search-main" class="row"  data-ng-show="isDisplayed('results')">
		<div class="col-md-<@s.FacetedSearch>9 col-md-push-3</@s.FacetedSearch><@s.FacetedSearch negate=true>12</@s.FacetedSearch>">
			<@core_controller.QueryHistory />
			<@core_controller.SearchHistory />
			<@core_controller.Scope />
			<@core_controller.Count />
			<@core_controller.Blending />
			<@core_controller.CuratorExhibits />
			<@core_controller.Spelling />
			<@core_controller.NoResultSummary />
			<@core_controller.EntityDefinition />
			<@core_controller.CuratorExhibitsList />
			<@core_controller.BestBets />
			<@core_controller.Results />
			<@core_controller.Pagination />
			<@core_controller.ContextualNavigation />
		</div>
		<#-- Only show the "Date" facet -->
		<@core_controller.Facets names=["Date", "Author"] />
	</section>
</#macro>

<#-- Represents the items which are to displayed when the Crrent Docs tab is selected -->
<#macro CurrentDocsPane>
	<section id="search-main" class="row"  data-ng-show="isDisplayed('results')">
		<div class="col-md-<@s.FacetedSearch>9 col-md-push-3</@s.FacetedSearch><@s.FacetedSearch negate=true>12</@s.FacetedSearch>">
			<@core_controller.QueryHistory />
			<@core_controller.SearchHistory />
			<@core_controller.Scope />
			<@core_controller.Count />
			<@core_controller.Blending />
			<@core_controller.CuratorExhibits />
			<@core_controller.Spelling />
			<@core_controller.NoResultSummary />
			<@core_controller.EntityDefinition />
			<@core_controller.CuratorExhibitsList />
			<@core_controller.BestBets />
			<@core_controller.Results />
			<@core_controller.Pagination />
			<@core_controller.ContextualNavigation />
		</div>
		<#-- Only show the "Date" facet -->
		<@core_controller.Facets names=["Date", "Author"] />
	</section>
</#macro>

<#-- Represents the items which are to displayed when the Previous version tab is selected -->
<#macro PreviousVersionsPane>
	<section id="search-main" class="row"  data-ng-show="isDisplayed('results')">
		<div class="col-md-<@s.FacetedSearch>9 col-md-push-3</@s.FacetedSearch><@s.FacetedSearch negate=true>12</@s.FacetedSearch>">
			<@core_controller.QueryHistory />
			<@core_controller.SearchHistory />
			<@core_controller.Scope />
			<@core_controller.Count />
			<@core_controller.Blending />
			<@core_controller.CuratorExhibits />
			<@core_controller.Spelling />
			<@core_controller.NoResultSummary />
			<@core_controller.EntityDefinition />
			<@core_controller.CuratorExhibitsList />
			<@core_controller.BestBets />
			<@core_controller.Results />
			<@core_controller.Pagination />
			<@core_controller.ContextualNavigation />
		</div>
		<#-- Only show the "Date" facet -->
		<@core_controller.Facets names=["Date", "Author"] />
	</section>
</#macro>

</#escape>