<#ftl encoding="utf-8" />
<#---
	Contains the application logic required to display search results within tabs.

	<p>
		This file aims to store the application logic required for implementing tabs.
		It aims to represent the <em> control </em> aspect of Model-View-Control for the tab stencil.
	</p>

	<p>
		It re-uses the faceted navigation system in order to obtain the counts and the scoping.
		This is achieved by using adding the following to the <code> collection.cfg </code> file:
		<code> ui.modern.full_facets_list=true </code>
	</p>

	<p>
		It is also best practice to hide the facet group which has been used to populate the
		tabs from the list of available facets
	</p>
-->

<#escape x as x?html>

<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign thirdPartyResourcesPrefix = "${GlobalResourcesPrefix}stencils-resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Stencils -->
<#assign stencils=["core","base"] />
<#--
	The following code imports and assigns stencil namespaces automatically eg. core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/

 	Note: View files should not be imported to to the controller
-->
<@stencils_utilities.ImportStencilsControllers stencils=stencils>
	<@stencils_utilities.importsControllers?interpret />
</@stencils_utilities.ImportStencilsControllers>

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


</#escape>
