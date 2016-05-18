<#ftl encoding="utf-8" />
<#---
	<p>Provides helpers for building Auto-Completion components.</p>

	<h2>Table of Contents</h2>
-->
<#escape x as x?html>

<#-- Import Utilities -->
<#import "/share/stencils/libraries/stencils.utilities.ftl" as stencils_utilities />

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils = ["core"] />

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
	Read a configuration parameter.
	Reads a collection.cfg parameter for the current collection being searched and displays it.

	@nested Name of the parameter
-->
<#macro cfg><#compress>
	<#local key><#nested></#local>
	<#local val><@core_controller.cfg>${key}</@core_controller.cfg></#local>
	<#if !val?has_content>
		<#local val><@core_controller.cfg>${key!?replace('stencils.autocompletion', 'query_completion')}</@core_controller.cfg></#local>
	</#if>
	${val!}
</#compress></#macro>

<#---
	Retrieves a cgi parameter value.

	@nested Name of the parameter
-->
<#macro cgi><#compress>
	<#local key><#nested></#local>
	<#local val><@core_controller.cgi>${key}</@core_controller.cgi></#local>
	<#if !val?has_content>
		<#local val><@core_controller.cgi>${key!?replace('stencils.autocompletion.', '')}</@core_controller.cgi></#local>
	</#if>
	${val!}
</#compress></#macro>

<#---
	Retrieves a configuration or cgi parameter

	@nested Name of the parameter
-->
<#macro option><#compress>
	<#local val><@cfg><#nested></@cfg></#local>
	<#if !val?has_content>
		<#local val><@cgi><#nested></@cgi></#local>
	</#if>
	${val!}
</#compress></#macro>

</#escape>