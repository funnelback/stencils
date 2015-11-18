<#ftl encoding="utf-8" />
<#---
	<p>Provides helpers for building Social Media components.</p>
	<p>This includes helpers for Social Media ... there is actually nothing useful in here for now.</p>
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

</#escape>
