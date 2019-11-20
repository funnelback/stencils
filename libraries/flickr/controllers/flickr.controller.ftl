<#ftl encoding="utf-8" />
<#-- DEPRECATED - This file has been deprecated. Please avoid using this file going forward -->
<#---
	Application logic required to for flickr components.

		<p>Provides helpers for building Flickr components.</p>
		<p>This includes helpers for Flickr results that extend the data model depending on the content type.</p>

		<h2>Table of Contents</h2>
		<ul>
			<li><strong>General:</strong> General flickr helpers.</li>
			<li><strong>Picture:</strong>  Flickr picture result.</li>
		</ul>

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
<#-- @begin General -->
<#-- @end --><#-- /Category - General -->

<#-- @begin Picture -->
<#---
	Constructor for Picture.
	@requires core_view.Results
-->
<#macro Picture>
	<#nested>
</#macro>

<#-- @end --><#-- /Category - Picture -->
</#escape>
