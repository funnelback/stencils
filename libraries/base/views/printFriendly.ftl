<#ftl encoding="utf-8" />
<#--
	Print friendly view
	Displays results in a print friendly format.
-->
<#escape x as x?html>
<#--
	##############################################################
			TABLE OF CONTENTS
				Configuration
				Application
	##############################################################
 -->

<#-- ################### Configuration ####################### -->
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

<#-- ################### Application ####################### -->
<!DOCTYPE html>
<html lang="en-us">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="robots" content="nofollow">
		<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->
		<title><@core_controller.AfterSearchOnly>${question.inputParameterMap["query"]!}<@core_controller.IfDefCGI name="query">,&nbsp;</@core_controller.IfDefCGI></@core_controller.AfterSearchOnly><@core_controller.cfg>service_name</@core_controller.cfg> -	Funnelback Search</title>

		<@base_view.printCSS />
</head>
<body>
	<h1><@core_controller.AfterSearchOnly>${question.inputParameterMap["query"]!}<@core_controller.IfDefCGI name="query">,&nbsp;</@core_controller.IfDefCGI></@core_controller.AfterSearchOnly><@core_controller.cfg>service_name</@core_controller.cfg> -	Funnelback Search</h1>

	<@base_view.PrintMessage />

		<@core_controller.AfterSearchOnly>
				<section id="search-main">
						<@core_view.FacetedBreadCrumbSummary />
						<@core_view.Scope />
						<@core_view.Count />
						<@core_view.Blending />
						<@core_view.CuratorExhibits />
						<@core_view.NoResultSummary />
						<@core_view.EntityDefinition />
						<@core_view.CuratorExhibitsList />
						<@core_view.BestBets />
						<@project_view.Results />
						<@core_view.ContextualNavigation />
					</div>

		</@core_controller.AfterSearchOnly>

		<@core_view.Footer />

		<@stencils_utilities.ImportStencilsJS stencils=stencils />

		<@project_view.JS />

	</body>
</html>

</#escape>
