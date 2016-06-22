<#ftl encoding="utf-8" />
<#---
	This contains helpers specifically for no results.

	<h2>Table of Contents</h2>
	<ul>
		<li><strong>Facets:</strong> Faceted navigation, search breadcrumbs.</li>
		<li><strong>Result features:</strong> Search view selectors/formaters, best bets, contextual navigation.</li>
		<li><strong>Results:</strong> Results wrapper.</li>
		<li><strong>Result:</strong> Result helpers e.g. panels ...</li>
	</ul>
-->
<#escape x as x?html>

<#-- Import Utilities -->
<#import "/share/stencils/libraries/stencils.utilities.ftl" as stencils_utilities />

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils = ["core","base"] />

<#--
	The following code imports and assigns stencil namespaces automatically eg. core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/

 	Note: View files should not be imported to to the controller
-->
<@stencils_utilities.ImportStencilsControllers stencils=stencils>
	<@stencils_utilities.importsControllers?interpret />
</@stencils_utilities.ImportStencilsControllers>

<#-- ###################  Controllers ####################### -->

<#---
	Conditional Display - Runs the nested code only if no result is found.
-->
<#macro NoResult>
	<@base_controller.HasResults negate=true >
		<#nested>
	</@base_controller.HasResults>
</#macro>

<#---
	Configures and displays no results search if setup.
	@requires NoResult
-->
<#macro NoResultSearch>
	<@core_controller.ExtraResults name="no_results" >
		<#assign cacheQueryString = QueryString />
		<#global QueryString = QueryString?replace("query=[^&]+","query=${question.query}","r") >
	 	<#nested>
		<#global QueryString = cacheQueryString >
	 </@core_controller.ExtraResults>
</#macro>

</#escape>
