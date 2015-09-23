<#ftl encoding="utf-8" />
<#--
	 Stencil: Core
	 By: Gioan Tran
	 Description: A sample stencil which simply provides the basic out of the box functionality derived
		from the simple.ftl that is shipped with the product.
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
	The following code imports and assigns stencil namespaces automatically eg. core_controller and core_view.
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

<#import "project.view.ftl" as project_view/>

<#assign layoutType = '' largeLogoImg ="${SearchPrefix}funnelback.png">
<!DOCTYPE html>
<html lang="en-us">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="robots" content="nofollow">
		<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->
		<title><@s.AfterSearchOnly>${question.inputParameterMap["query"]!}<@s.IfDefCGI name="query">,&nbsp;</@s.IfDefCGI></@s.AfterSearchOnly><@s.cfg>service_name</@s.cfg> -  Funnelback Search</title>
		<@s.OpenSearch />
		<@s.AfterSearchOnly><link rel="alternate" type="application/rss+xml" title="Search results for ${question.inputParameterMap["query"]!}<@s.IfDefCGI name="query">,&nbsp;</@s.IfDefCGI><@s.cfg>service_name</@s.cfg>" href="?collection=<@s.cfg>collection</@s.cfg>&amp;query=${question.inputParameterMap["query"]!?url}&amp;form=rss&amp;sort=date"></@s.AfterSearchOnly>
		<link rel="stylesheet" href="${SearchPrefix}thirdparty/bootstrap-3.0.0/css/bootstrap.min.css">
		<!--[if lt IE 9]>
		<script src="${SearchPrefix}thirdparty/html5shiv.js"></script>
		<script src="${SearchPrefix}thirdparty/respond.min.js"></script>
		<![endif]-->

		<#--Load stencil default CSS files-->
		<#list stencils as stencil>
			<#assign script = "<@" + stencil?lower_case + "_controller.CSS />" >
			<@script?interpret />
		</#list>

	</head>
	<body id="funnelback-search" class="container<#if layoutType?? && layoutType != ''>-${layoutType}</#if> "<#if question.collection.configuration.valueAsBoolean("ui.modern.session")> data-ng-app="Funnelback" data-ng-controller="DefaultCtrl" </#if>">
		<@fb.ViewModeBanner />

		<@s.InitialFormOnly>
				<@core_controller.InitialSearchForm image=largeLogoImg />
		</@s.InitialFormOnly>

		<@s.AfterSearchOnly>
			<@core_controller.NavBar />
			<@core_controller.AdvancedForm />

			<#-- Custom code for this project -->
			<@project_view.Results />

			<@core_controller.SearchHistory />
			<@core_controller.Cart />
			<@core_controller.Tools />
		</@s.AfterSearchOnly>

		<@core_controller.Footer />
		<#-- Javascript-->
		<@core_controller.jsDefault />

		<#-- Funnelback Javascript Options -->
		<script>
			jQuery(document).ready( function() {
				// Query completion setup.
				jQuery("input.query").fbcompletion({
					'enabled'    : '<@s.cfg>query_completion</@s.cfg>',
					'standardCompletionEnabled': <@s.cfg>query_completion.standard.enabled</@s.cfg>,
					'collection' : '<@s.cfg>collection</@s.cfg>',
					'program'    : '${SearchPrefix}<@s.cfg>query_completion.program</@s.cfg>',
					'format'     : '<@s.cfg>query_completion.format</@s.cfg>',
					'alpha'      : '<@s.cfg>query_completion.alpha</@s.cfg>',
					'show'       : '<@s.cfg>query_completion.show</@s.cfg>',
					'sort'       : '<@s.cfg>query_completion.sort</@s.cfg>',
					'length'     : '<@s.cfg>query_completion.length</@s.cfg>',
					'delay'      : '<@s.cfg>query_completion.delay</@s.cfg>',
					'profile'    : '${question.inputParameterMap["profile"]!}',
					'query'      : '${QueryString}',
					//Search based completion
					'searchBasedCompletionEnabled': <@s.cfg>query_completion.search.enabled</@s.cfg>,
					'searchBasedCompletionProgram': '${SearchPrefix}<@s.cfg>query_completion.search.program</@s.cfg>',
				});
			});
		</script>

		<#--Load stencil default JS files-->
		<#list stencils as stencil>
			<#assign script = "<@" + stencil?lower_case + "_controller.JS />" >
			<@script?interpret />
		</#list>

	</body>
</html>

</#escape>