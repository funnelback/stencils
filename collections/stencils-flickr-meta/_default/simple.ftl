<#ftl encoding="utf-8" />
<#---
	Client: ...
	Project: ...
	Description: ...
-->
<#escape x as x?html>
<#--
	##############################################################
			TABLE OF CONTENTS
			C. Configuration
			A. Application
	##############################################################
 -->

<#-- ################### C. Configuration ####################### -->
<#-- Import Utilities -->
<#import "/web/templates/modernui/stencils-libraries/stencils.utilities.ftl" as stencils_utilities />

<#-- Import Libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core","base","flickr"] />
	<#--
	The following code imports and assigns stencil namespaces automatically eg. core_view and core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/web/templates/modernui/stencils-libraries/
	and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
	-->
<@stencils_utilities.ImportStencils stencils=stencils>
	<@stencils_utilities.imports?interpret />
</@stencils_utilities.ImportStencils>

<#-- Include Project files -->
<#import "project.view.ftl" as project_view />
<#import "project.controller.ftl" as project_controller />

<#-- Project settings -->
<#assign layoutType = ''>


<#-- ################### A. Application ####################### -->
<!DOCTYPE html>
<html lang="en-us">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="robots" content="nofollow">
		<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->
		<title><@core_controller.AfterSearchOnly>${question.inputParameterMap["query"]!}<@core_controller.IfDefCGI name="query">,&nbsp;</@core_controller.IfDefCGI></@core_controller.AfterSearchOnly><@core_controller.cfg>service_name</@core_controller.cfg> -	Funnelback Search</title>
		<@core_controller.OpenSearch />
		<@core_controller.AfterSearchOnly><link rel="alternate" type="application/rss+xml" title="Search results for ${question.inputParameterMap["query"]!}<@core_controller.IfDefCGI name="query">,&nbsp;</@core_controller.IfDefCGI><@core_controller.cfg>service_name</@core_controller.cfg>" href="?collection=<@core_controller.cfg>collection</@core_controller.cfg>&amp;query=${question.inputParameterMap["query"]!?url}&amp;form=rss&amp;sort=date"></@core_controller.AfterSearchOnly>

		<!--[if lt IE 9]>
		<script src="${SearchPrefix}thirdparty/html5shiv.js"></script>
		<script src="${SearchPrefix}thirdparty/respond.min.js"></script>
		<![endif]-->

		<@stencils_utilities.ImportStencilsCSS stencils=stencils />

		<#-- Load the project specific CSS -->
		<@project_view.CSS />

</head>
<body id="funnelback-search" class="container<#if layoutType?? && layoutType != ''>-${layoutType}</#if>" <#if question.collection.configuration.valueAsBoolean("ui.modern.session")> data-ng-app="Funnelback" data-ng-controller="DefaultCtrl"</#if>>
		<@core_view.ViewModeBanner />

		<@core_controller.InitialFormOnly>
			<@core_view.InitialSearchForm/>
		</@core_controller.InitialFormOnly>

		<@core_controller.AfterSearchOnly>
				<@core_view.NavBar />
				<@core_view.AdvancedForm />

				<section id="search-main" class="row"	data-ng-show="isDisplayed('results')">
					<div class="col-md-<@core_controller.FacetedSearch>9 col-md-push-3</@core_controller.FacetedSearch><@core_controller.FacetedSearch negate=true>12</@core_controller.FacetedSearch>">
						<@core_view.QueryHistory />
						<@core_view.SearchHistory />
						<@base_view.BreadCrumb />
						<@core_view.Scope />
						<@core_view.Count />
						<@project_view.ResultsViewSelectors />
						<@core_view.Blending />
						<@core_view.CuratorExhibits />
						<@core_view.Spelling />
						<@core_view.NoResultSummary />
						<@core_view.EntityDefinition />
						<@core_view.CuratorExhibitsList />
						<@core_view.BestBets />
						<@project_view.Results />
						<@core_view.Pagination />
						<@core_view.ContextualNavigation />
					</div>
					<@core_view.Facets />
				</section>
				<@core_view.SearchHistory />
				<@core_view.Cart />
				<@core_view.Tools />
		</@core_controller.AfterSearchOnly>

		<@core_view.Footer />

		<div id="modals">
			<@project_view.Modals />
		</div>

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
