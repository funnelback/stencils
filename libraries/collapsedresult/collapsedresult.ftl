<#ftl encoding="utf-8" output_format="HTML" />

<#import "/share/stencils/libraries/core/controllers/core.controller.ftl" as core_controller />

<#-- @begin Result Collapsing  -->
<#--- View for Collapsed Results -->
<#macro Results result>
	<!--  collapsedresult.view.ftl::CollapsedResults -->
    <#if result.collapsed??>
	<div class="search-collapsed row" id="search-collapsed-modal-${result.rank}">

		<h5>
			<a data-toggle="collapse" data-parent="#search-collapsed-modal-${result.rank}" href="#collapseOne-modal-${result.rank}" class="btn btn-default">
				<span class="glyphicon glyphicon-expand text-muted"></span>&nbsp;
				<small>
					<#if response.resultPacket.resultsSummary.estimatedCounts>About </#if>
					${result.collapsed.count} very similar results
				</small>
			</a>
		</h5>

		<div id="collapseOne-modal-${result.rank}" class="panel-collapse collapse">
			<div class="list-group ">
				<@Result result=result />
			</div>

            <#if result.collapsed.count gt result.collapsed.results?size>
                <div class="pull-right" style="margin-top:0.5em">
                    <a class="search-collapsed  btn btn-default" href="${result.customData["stencilsCoreCollapsedUrl"]!}">See all similar results</a>
                </div>
            </#if>
		</div>
	</div>
    </#if>
</#macro>
<#---
	View of a collapsed result
	-->
<#macro Result result>
<!--  collapsedresult.view.ftl::CollaspedResult -->
    <#list result.collapsed.results![] as collapsedResult>
	<a class="list-group-item col-md-3" data-mh="collapsed-result" href="${collapsedResult.clickTrackingUrl}" title="${collapsedResult.liveUrl}">
		<#-- ResultTitle -->
		<h6 class="list-group-item-heading">
			<@core_controller.boldicize>
				<@core_controller.Truncate length=70>${collapsedResult.title!}</@core_controller.Truncate>
			</@core_controller.boldicize>
		</h6>
		<#-- ResultSummary - Metadata summary based on fields mapped to the description metadata field "c" -->
		<#if collapsedResult.metaData["c"]??>
		<p class="list-group-item-text small text-muted">
			<@core_controller.boldicize>
			<@core_controller.Truncate length=70>

					${collapsedResult.metaData["c"]!}

			</@core_controller.Truncate>
			<#-- /ResultSummary -->
			</@core_controller.boldicize>
		</p>
		</#if>
	</a>
    </#list>
</#macro>
<#-- @end -->
<#--  / Catgegory - Result Collapsing -->

<#-- vim: set noexpandtab :-->
