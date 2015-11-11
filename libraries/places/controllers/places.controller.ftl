<#ftl encoding="utf-8" />
<#---
	<p>Provides helpers for building places components.</p>
	<p>This includes helpers for places ....</p>
-->
<#escape x as x?html>

<#-- ################### Configuration ####################### -->
<#-- Import Utilities -->
<#import "/share/stencils/libraries/stencils.utilities.ftl" as stencils_utilities />

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core"] />

<#--
	The following code imports and assigns stencil namespaces automatically eg. core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/

 	Note: View files should not be imported to to the controller
-->
<@stencils_utilities.ImportStencilsControllers stencils=stencils>
	<@stencils_utilities.importsControllers?interpret />
</@stencils_utilities.ImportStencilsControllers>

<#-- ################### Controllers ####################### -->
<#--
  GetMapDataURL

  @author Robert Prib
  @desc The default map data URL
 -->
<#macro GetMapDataURL><#compress>
<#local profile = "mapservice" >
 <#if question.profile?contains("_preview") >
 <#local profile = "mapservice_preview" >
 </#if>
<#noescape>
${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["form","profile"])}&form=geojson&profile=mapservice
</#noescape>
</#compress></#macro>


</#escape>
