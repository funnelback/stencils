<#ftl encoding="utf-8" />
<#---
	This contains the controllers specific to this project.
-->
<#escape x as x?html>
<#--
	##############################################################
			TABLE OF CONTENTS
			C. Configuration
			CTRL. Controllers
				CTRL. ...
			F. Functions
				F. ...
	##############################################################
 -->

<#-- ################### C. Configuration ####################### -->
<#assign StencilsLibrariesPrefix = "/web/templates/modernui/stencils-libraries/" >

<#-- Import Utilities -->
<#import "${StencilsLibrariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=[] />
<#-- Import Stencils -->
	<#--
	The following code imports and assigns stencil namespaces automatically eg. core_controller.
	The code expects that the controller files are located under /web/templates/modernui/stencils-libraries/
 *Note view files should not be imported to to the controller
	-->
<@stencils_utilities.ImportStencilsControllers stencils=stencils>
	<@stencils_utilities.importsControllers?interpret />
</@stencils_utilities.ImportStencilsControllers>

<#-- ################### CTRL. Controllers ####################### -->
<#-- @begin CTRL. <X> -->
<#-- @end --> <#-- /CTRL. <X> -->


<#-- ################### F. Functions ####################### -->
<#-- @begin F. <X> -->
<#-- @end --> <#-- /F. <X> -->

</#escape>
