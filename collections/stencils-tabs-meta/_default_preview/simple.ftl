<#ftl encoding="utf-8" />

<#--
	Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
	Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
	Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#--
	Stencil: Core
	Description: A sample stencil which simply provides the basic out of the box functionality derived
	from the simple.ftl that is shipped with the product.
-->
<#assign StencilsLibrariesPrefix = "/share/stencils/libraries/" >
<#assign StencilsThirdpartyResourcesPrefix = "${SearchPrefix}stencils-resources/thirdparty/" >


<#-- Import Utilities -->
<#import "${StencilsLibrariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Stencils -->
<#assign stencils=["core", "base"] />
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

<#-- Import project specific implementation logic -->
<#import "project.view.ftl" as project_view />

<#assign layoutType = '' largeLogoImg ="${SearchPrefix}funnelback.png">
<!DOCTYPE html>
<html lang="en-us">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="robots" content="nofollow">
		<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->
		<title><@core_controller.AfterSearchOnly>${question.inputParameterMap["query"]!}<@core_controller.IfDefCGI name="query">,&nbsp;</@core_controller.IfDefCGI></@core_controller.AfterSearchOnly><@core_controller.cfg>service_name</@core_controller.cfg> -  Funnelback Search</title>
		<@core_controller.OpenSearch />
		<@core_controller.AfterSearchOnly><link rel="alternate" type="application/rss+xml" title="Search results for ${question.inputParameterMap["query"]!}<@core_controller.IfDefCGI name="query">,&nbsp;</@core_controller.IfDefCGI><@core_controller.cfg>service_name</@core_controller.cfg>" href="?collection=<@core_controller.cfg>collection</@core_controller.cfg>&amp;query=${question.inputParameterMap["query"]!?url}&amp;form=rss&amp;sort=date"></@core_controller.AfterSearchOnly>
		<link rel="stylesheet" href="${SearchPrefix}thirdparty/bootstrap-3.0.0/css/bootstrap.min.css">
		<!--[if lt IE 9]>
		<script src="${SearchPrefix}thirdparty/html5shiv.js"></script>
		<script src="${SearchPrefix}thirdparty/respond.min.js"></script>
		<![endif]-->

		<#-- Load the stencil specific CSS -->
		<@stencils_utilities.ImportStencilsCSS stencils=stencils />

		<#-- Load the project specific CSS -->
		<@project_view.CSS />
	</head>
	<body id="funnelback-search" class="container<#if layoutType?? && layoutType != ''>-${layoutType}</#if> "<#if question.collection.configuration.valueAsBoolean("ui.modern.session")> data-ng-app="Funnelback" data-ng-controller="DefaultCtrl" </#if>">
		<@core_view.ViewModeBanner />

		<@core_controller.InitialFormOnly>
			<@core_view.InitialSearchForm />
		</@core_controller.InitialFormOnly>

		<@core_controller.AfterSearchOnly>
			<@core_view.NavBar />
			<@core_view.AdvancedForm />

			<#-- Custom code for this project -->
			<@project_view.Results />

			<@core_view.SearchHistory />
			<@core_view.Cart />
			<@core_view.Tools />
		</@core_controller.AfterSearchOnly>

		<@core_view.Footer />

		<#-- Load the stencil specific JavaScript-->
		<@stencils_utilities.ImportStencilsJS stencils=stencils />

		<#-- Load the project specific JavaScript -->
		<@project_view.JS />

		<#-- Funnelback Javascript Options -->
		<script>
			jQuery(document).ready( function() {
				// Query completion setup.
				jQuery("input.query").fbcompletion({
					'enabled'    : '<@core_controller.cfg>query_completion</@core_controller.cfg>',
					'standardCompletionEnabled': <@core_controller.cfg>query_completion.standard.enabled</@core_controller.cfg>,
					'collection' : '<@core_controller.cfg>collection</@core_controller.cfg>',
					'program'    : '${SearchPrefix}<@core_controller.cfg>query_completion.program</@core_controller.cfg>',
					'format'     : '<@core_controller.cfg>query_completion.format</@core_controller.cfg>',
					'alpha'      : '<@core_controller.cfg>query_completion.alpha</@core_controller.cfg>',
					'show'       : '<@core_controller.cfg>query_completion.show</@core_controller.cfg>',
					'sort'       : '<@core_controller.cfg>query_completion.sort</@core_controller.cfg>',
					'length'     : '<@core_controller.cfg>query_completion.length</@core_controller.cfg>',
					'delay'      : '<@core_controller.cfg>query_completion.delay</@core_controller.cfg>',
					'profile'    : '${question.inputParameterMap["profile"]!}',
					'query'      : '${QueryString}',
					//Search based completion
					'searchBasedCompletionEnabled': <@core_controller.cfg>query_completion.search.enabled</@core_controller.cfg>,
					'searchBasedCompletionProgram': '${SearchPrefix}<@core_controller.cfg>query_completion.search.program</@core_controller.cfg>',
				});
			});
		</script>


	</body>
</html>

</#escape>