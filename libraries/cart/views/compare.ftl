<#ftl encoding="utf-8" />
<#---
	Compare Table form

	Display's results within a comparrision table.
-->
<#escape x as x?html>
<#--
	##############################################################
			TABLE OF CONTENTS
				Configuration
				Application
	##############################################################
 -->

<#-- ################### C. Configuration ####################### -->
<#-- Import Utilities -->
<#import "/share/stencils/libraries/stencils.utilities.ftl" as stencils_utilities />

<#-- Import Libraries -->
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

<#-- Include Project files -->
<#import "project.view.ftl" as project_view />
<#import "project.controller.ftl" as project_controller />

<#-- ################### A. Application ####################### -->
<!DOCTYPE html>
<html lang="en-us">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="robots" content="nofollow">
		<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->
		<title><@core_controller.AfterSearchOnly>${question.inputParameterMap["query"]!}<@core_controller.IfDefCGI name="query">,&nbsp;</@core_controller.IfDefCGI></@core_controller.AfterSearchOnly><@core_controller.cfg>service_name</@core_controller.cfg> -	Funnelback Search</title>
		<@core_controller.OpenSearch>
			<link rel="search" type="application/opensearchdescription+xml" href="<@core_controller.OpenSearchUrl />" title="<@core_controller.OpenSearchTitle />">
		</@core_controller.OpenSearch>
		<@core_controller.AfterSearchOnly>
			<link rel="alternate" type="application/rss+xml" title="Search results for ${question.inputParameterMap["query"]!}<@core_controller.IfDefCGI name="query">,&nbsp;</@core_controller.IfDefCGI><@core_controller.cfg>service_name</@core_controller.cfg>" href="?collection=<@core_controller.cfg>collection</@core_controller.cfg>&amp;query=${question.inputParameterMap["query"]!?url}&amp;form=rss&amp;sort=date">
		</@core_controller.AfterSearchOnly>

		<!--[if lt IE 9]>
		<script src="${SearchPrefix}thirdparty/html5shiv.js"></script>
		<script src="${SearchPrefix}thirdparty/respond.min.js"></script>
		<![endif]-->

		<@stencils_utilities.ImportStencilsCSS stencils=stencils />

		<#-- Load the project specific CSS -->
		<@project_view.CSS />

</head>
<body id="funnelback-search" class="container" <#if question.collection.configuration.valueAsBoolean("ui.modern.session")> data-ng-app="Funnelback" data-ng-controller="DefaultCtrl"</#if>>
		<@core_view.ViewModeBanner />

		<@core_controller.AfterSearchOnly>
				<section id="search-main" class="row"	data-ng-show="isDisplayed('results')">
					<div class="col-md-12">
						<h1>Compare</h1>

						<a class="btn btn-default" href="?${base_controller.removeParamWithValue(QueryString,"form","compare")}">Back to search</a>

						<div class="row" style="margin-bottom:0.5em;">
							<div class="col-md-12">
									<div class="pull-right">
										<@base_view.PrintFriendlyBtn />
									</div>
							</div>
						</div>
						<@core_view.NoResultSummary />

						<#if (response.resultPacket.results)!?has_content>
						<div class="table-responsive">
							<table class="table table-hover table-bordered">
								<thead>
									<tr>
										<th></th>
										<@base_view.ResultsOnly>
											<th>
												<#if core_controller.result.metaData.stencilsCoursesName??>
													<a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl}">${core_controller.result.metaData.stencilsCoursesName!}</a>
												</#if>
												<#if core_controller.result.metaData.stencilsCoursesCode??>
												 <@core_controller.boldicize><small class="badge">${core_controller.result.metaData.stencilsCoursesCode}</small></@core_controller.boldicize>
												</#if>

												<#if core_controller.result.metaData.stencilsCoursesLevel??>
													<br><small class="text-muted"><em>${core_controller.result.metaData.stencilsCoursesLevel}</em></small>
												</#if>
											</th>
										</@base_view.ResultsOnly>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th>Summary</th>
										<@base_view.ResultsOnly>
											<td>${core_controller.result.metaData.c!}</td>
										</@base_view.ResultsOnly>
									</tr>
									<tr>
										<th>Duration</th>
										<@base_view.ResultsOnly>
											<td>${core_controller.result.metaData.stencilsCoursesDuration!}</td>
										</@base_view.ResultsOnly>
									</tr>
									<tr>
										<th>Campus</th>
										<@base_view.ResultsOnly>
											<td>${core_controller.result.metaData.stencilsCoursesCampus!}</td>
										</@base_view.ResultsOnly>
									</tr>
									<tr>
										<th>Mode</th>
										<@base_view.ResultsOnly>
											<td>${core_controller.result.metaData.stencilsCoursesMode!}</td>
										</@base_view.ResultsOnly>
									</tr>
								</tbody>
							</table>
						</div>
						</#if>

					</div>
				</section>

				<@core_view.Cart />
				<@core_view.Tools />
		</@core_controller.AfterSearchOnly>

		<@core_view.Footer />

		<@stencils_utilities.ImportStencilsJS stencils=stencils />

		<@project_view.JS />

		<#-- Funnelback Javascript Options -->
		<script>
			jQuery(document).ready( function() {
				// Query completion setup.
				jQuery("input.query").fbcompletion({
					'enabled'		: '<@core_controller.cfg>query_completion</@core_controller.cfg>',
					'standardCompletionEnabled': <@core_controller.cfg>query_completion.standard.enabled</@core_controller.cfg>,
					'collection' : '<@core_controller.cfg>collection</@core_controller.cfg>',
					'program'		: '${SearchPrefix}<@core_controller.cfg>query_completion.program</@core_controller.cfg>',
					'format'		 : '<@core_controller.cfg>query_completion.format</@core_controller.cfg>',
					'alpha'			: '<@core_controller.cfg>query_completion.alpha</@core_controller.cfg>',
					'show'			 : '<@core_controller.cfg>query_completion.show</@core_controller.cfg>',
					'sort'			 : '<@core_controller.cfg>query_completion.sort</@core_controller.cfg>',
					'length'		 : '<@core_controller.cfg>query_completion.length</@core_controller.cfg>',
					'delay'			: '<@core_controller.cfg>query_completion.delay</@core_controller.cfg>',
					'profile'		: '${question.inputParameterMap["profile"]!}',
					'query'			: '${QueryString}',
					//Search based completion
					'searchBasedCompletionEnabled': <@core_controller.cfg>query_completion.search.enabled</@core_controller.cfg>,
					'searchBasedCompletionProgram': '${SearchPrefix}<@core_controller.cfg>query_completion.search.program</@core_controller.cfg>',
				});
			});
		</script>

	</body>
</html>

</#escape>
