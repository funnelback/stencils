<#ftl encoding="utf-8" />
<#---
	Result Collapsing is the ability to collapse similar results
	into one, when displayed on the search results page.

		<h2>Table of Contents</h2>
		<ul>
			<li><strong>Configuration:</strong> Configuration options for Collapsed Result Stencil.</li>
			<li><strong>Result Collapsing:</strong> ...</li>
		</ul>
-->
<#escape x as x?html>
<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign collapsedresultResourcesPrefix = "/stencils/resources/collapsedresult/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${librariesPrefix}collapsedresult/controllers/collapsedresult.controller.ftl" as collapsedresult_controller/>

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
	<!-- collapsedresult.view.ftl.view.ftl :: CSS -->
	<#-- <link rel="stylesheet" href="${collapsedresultResourcesPrefix}css/collapsedresult.css"> -->
</#macro>

<#---
	JavaScript dependencies
-->
<#macro JS>
	<!-- collapsedresult.view.ftl.view.ftl :: JS -->
	<#-- <script src="${collapsedresultResourcesPrefix}js/collapsedresult.js"></script> -->
</#macro>
<#-- @end --><#-- /Configuration -->
<#-- ###################  Views ####################### -->
<#-- @begin Result Collapsing  -->
<#---
	View for Collapsed Results
  -->
<#macro Results>
<!--  collapsedresult.view.ftl::CollapsedResults -->
<#-- ResultCollaspe Generate the result collapsing link -->
	<@collapsedresult_controller.Collapsed>
	<div class="search-collapsed row" id="search-collapsed-modal-${core_controller.result.rank}">

		<h5>
			<a data-toggle="collapse" data-parent="#search-collapsed-modal-${core_controller.result.rank}" href="#collapseOne-modal-${core_controller.result.rank}" class="btn btn-default">
				<span class="glyphicon glyphicon-expand text-muted"></span>&nbsp;
				<small>
				<!-- Message for exact count -->
				<@collapsedresult_controller.CollapsedHasExactCount>
					<@collapsedresult_controller.CollapsedCount /> very similar results
				</@collapsedresult_controller.CollapsedHasExactCount>

				<!-- Alternative message for approximate count -->
				<@collapsedresult_controller.CollapsedHasExactCount negate=true>
					About <@collapsedresult_controller.CollapsedCount /> very similar results
				</@collapsedresult_controller.CollapsedHasExactCount>
				</small>
			</a>
		</h5>

		<div id="collapseOne-modal-${core_controller.result.rank}" class="panel-collapse collapse">
			<div class="list-group ">
				<@Result />
			</div>

			<@collapsedresult_controller.ResultsHasMoreResults>
			<div class="pull-right" style="margin-top:0.5em">
				<a class="search-collapsed  btn btn-default" href="<@collapsedresult_controller.CollapsedUrl />">See all similar results</a>
			</div>
			</@collapsedresult_controller.ResultsHasMoreResults>
		</div>
	</div>
	</@collapsedresult_controller.Collapsed>
</#macro>
<#---
	View of a collapsed result
	-->
<#macro Result>
<!--  collapsedresult.view.ftl::CollaspedResult -->
	<@collapsedresult_controller.Results>
	<a class="list-group-item col-md-3" data-mh="collapsed-result" href="${collapsedresult_controller.result.clickTrackingUrl}" title="${collapsedresult_controller.result.liveUrl}">
		<#-- ResultTitle -->
		<h6 class="list-group-item-heading">
			<@core_controller.boldicize>
				<@core_controller.Truncate length=70>${collapsedresult_controller.result.title!}</@core_controller.Truncate>
			</@core_controller.boldicize>
		</h6>
		<#-- ResultSummary - Metadata summary based on fields mapped to the description metadata field "c" -->
		<#if collapsedresult_controller.result.metaData["c"]??>
		<p class="list-group-item-text small text-muted">
			<@core_controller.boldicize>
			<@core_controller.Truncate length=70>

					${collapsedresult_controller.result.metaData["c"]!}

			</@core_controller.Truncate>
			<#-- /ResultSummary -->
			</@core_controller.boldicize>
		</p>
		</#if>
	</a>
	</@collapsedresult_controller.Results>
</#macro>
<#-- @end -->
<#--  / Catgegory - Result Collapsing -->
</#escape>
