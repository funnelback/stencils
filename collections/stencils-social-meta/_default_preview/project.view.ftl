<#ftl encoding="utf-8" />
<#---
	This contains the views specific to this project.
-->
<#escape x as x?html>
<#--
	##############################################################
			TABLE OF CONTENTS
			C. Configuration
			V. Views
				V. General
        V. Results
        V. Result

	##############################################################
 -->

<#-- ################### C. Configuration ####################### -->

<#assign StencilsLibrariesPrefix = "/web/templates/modernui/stencils-libraries/" >
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
<#assign stencils = ["core", "base", "twitter", "facebook", "flickr", "youtube"] />
<#-- Import Stencils -->
	<#--
	The following code imports and assigns stencil namespaces automatically eg. core_view and core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/web/templates/modernui/stencils-libraries/
	and the view files located under $SEARCH_HOME/conf/\$COLLECTION_NAME/<profile>/
	-->
<@stencils_utilities.ImportStencils stencils=stencils>
	<@stencils_utilities.imports?interpret />
</@stencils_utilities.ImportStencils>

<#-- Assign the names of custom collections to the corresponding social media repository for each project. -->
<#assign collectionNameFacebook = "stencils-facebook-custom" >
<#assign collectionNameTwitter = "stencils-twitter-custom" >
<#assign collectionNameFlickr = "stencils-flickr-custom" >
<#assign collectionNameYoutube = "stencils-youtube-custom" >

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
<#-- @begin V. General -->
<#macro Modals>
	<!-- project.view.ftl :: ResultsModals -->
	<#-- Modals for results -->
	<@core_controller.Results>
		<#if core_controller.result.class.simpleName == "TierBar">
		<#else>
			<@ResultModal />
		</#if>
	</@core_controller.Results>
</#macro>
<#-- @end --><#-- /V.General -->

<#-- @begin V. Results -->
<#---
	Creates a select box that allows the user to change the results view.
 -->
<#macro ResultsViewSelectors>
	<#-- If search return at least one result show result selectors. -->
	<#if (response.resultPacket.resultsWithTierBars)!?has_content>
	<!-- project.view.ftl :: ResultsViewSelectors -->
	<div class="row" style="margin-bottom:0.5em">
		<div class="col-md-12">
			<div class="pull-right">
				<@base_view.ResultsViewSelectorView />
				<@base_view.ResultsViewSelectorColumns />
				<@base_view.ResultsViewSelectorLimit />
				<@base_view.ResultsViewSelectorSort />
			</div>
		</div>
	</div>
	</#if>
</#macro>

<#---
	Results wrapper format.
-->
<#macro Results>
	<!-- project.view.ftl :: Results -->
	<ol id="search-results" class="list-unstyled stencils-core-results" start="${response.resultPacket.resultsSummary.currStart}">
		<@core_controller.Results>
			<#if core_controller.result.class.simpleName == "TierBar">
				<#-- A tier bar -->
				<#if core_controller.result.matched != core_controller.result.outOf>
					<li class="search-tier"><h3 class="text-muted">Results that match ${core_controller.result.matched} of ${core_controller.result.outOf} words</h3></li>
				<#else>
					<li class="search-tier"><h3 class="hidden">Fully-matching results</h3></li>
				</#if>
				<#-- Print event tier bars if they exist -->
				<#if core_controller.result.eventDate??>
					<h2 class="fb-title">Events on ${core_controller.result.eventDate?date}</h2>
				</#if>
			<#else>
				<li data-fb-result=${core_controller.result.indexUrl}>
						<@ResultsViewList/>
						<@ResultsViewGrid/>
				</li>
			</#if>
		</@core_controller.Results>
	</ol>
</#macro>

<#---
	View for Results layout as list view.
-->
<#macro ResultsViewList>
	<@base_controller.IfDefCGIEquals name="resultsView" value="list" trueIfEmpty=true>
	<!-- project.view.ftl :: ResultsViewList -->
		<li data-fb-result=${core_controller.result.indexUrl}>
			<@Result />
		</li>
	</@base_controller.IfDefCGIEquals>
</#macro>

<#---
	View for Results layout as grid view.
-->
<#macro ResultsViewGrid>
	<@base_controller.IfDefCGIEquals name="resultsView" value="grid">
	<!-- project.view.ftl :: ResultsViewGrid -->
		<@base_controller.ResultsColumns>
			<@base_controller.ResultsColumnsIsOpen>
			<li class="row" data-results-column-rank="${base_controller.resultsColumnsIndex!}">
				<ol class="list-unstyled">
			</@base_controller.ResultsColumnsIsOpen>
					<#local cssColWidth = (12/base_controller.resultsColumnsNumber!1)?floor?c >
					<li data-fb-result=${core_controller.result.indexUrl} class="col-md-${cssColWidth!} columns-${base_controller.resultsColumnsNumber!}">
						<@Result />
					</li>
			<@base_controller.ResultsColumnsIsClosed>
				</ol>
			</li>
			</@base_controller.ResultsColumnsIsClosed>
		</@base_controller.ResultsColumns>
	</@base_controller.IfDefCGIEquals>
</#macro>

<#-- @end --><#-- /V. Results -->

<#-- @begin V. Result -->
<#---
	Defines which result format should be used.
 -->
<#macro Result>
<!-- project.view.ftl :: Result -->
  <#-- Collection: stencils-facebook-custom -->
  <@base_controller.ResultIsCollection name=collectionNameFacebook >
    <@facebook_controller.ResultIsTypeOf type="post">
      <@facebook_view.ResultPost />
    </@facebook_controller.ResultIsTypeOf>

    <@facebook_controller.ResultIsTypeOf type="page">
      <@facebook_view.ResultPage />
    </@facebook_controller.ResultIsTypeOf>

    <@facebook_controller.ResultIsTypeOf type="event">
      <@facebook_view.ResultEvent />
    </@facebook_controller.ResultIsTypeOf>
  </@base_controller.ResultIsCollection>

  <#-- Collection: stencils-twitter-custom -->
  <@base_controller.ResultIsCollection name=collectionNameTwitter >
    <@twitter_view.Result />
  </@base_controller.ResultIsCollection>

  <#-- Collection: stencils-youtube-custom -->
  <@base_controller.ResultIsCollection name=collectionNameYoutube >
    <@youtube_view.Result />
  </@base_controller.ResultIsCollection>

  <#-- Collection: stencils-flickr-custom -->
  <@base_controller.ResultIsCollection name=collectionNameFlickr >
     <@flickr_view.Result />
  </@base_controller.ResultIsCollection>

</#macro>

<#---
	Defines which result modal format should be used.
 -->
<#macro ResultModal>
<!-- project.view.ftl :: ResultModal -->

  <#-- Collection: stencils-facebook-custom -->
  <@base_controller.ResultIsCollection name=collectionNameFacebook >
    <@facebook_controller.ResultIsTypeOf type="post">
      <@facebook_view.ResultPostModal />
    </@facebook_controller.ResultIsTypeOf>

    <@facebook_controller.ResultIsTypeOf type="page">
      <@facebook_view.ResultPageModal />
    </@facebook_controller.ResultIsTypeOf>

    <@facebook_controller.ResultIsTypeOf type="event">
      <@facebook_view.ResultEventModal />
    </@facebook_controller.ResultIsTypeOf>
  </@base_controller.ResultIsCollection>

  <#-- Collection: stencils-twitter-custom -->
  <@base_controller.ResultIsCollection name=collectionNameTwitter >
    <@twitter_view.ResultModal />
  </@base_controller.ResultIsCollection>

  <#-- Collection: stencils-youtube-custom -->
  <@base_controller.ResultIsCollection name=collectionNameYoutube >
    <@youtube_view.ResultModal />
  </@base_controller.ResultIsCollection>

  <#-- Collection: stencils-flickr-custom -->
  <@base_controller.ResultIsCollection name=collectionNameFlickr >
     <@flickr_view.ResultModal />
  </@base_controller.ResultIsCollection>
</#macro>
<#-- @end --><#-- /V. Result -->

</#escape>
