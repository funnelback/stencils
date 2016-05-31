<#ftl encoding="utf-8" />
<#--
	Utitlities
	By: Robert Prib
	Description: This contains helper utitilites for using the stencils framework
-->

<#--
	##############################################################
			TABLE OF CONTENTS
			1. Import Utils
	##############################################################
 -->
<#escape x as x?html>

<#-- ## 1.Import Utils ## -->
 <#--
	ImportStencils
	@author Robert Prib
	@desc The following code imports and assigns stencil namespaces automatically eg. core and core_view. The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
-->
<#macro ImportStencils stencils>
	<#assign imports ="" in .namespace>

	<#list stencils as stencil>
		<#local controller = 	"/share/stencils/libraries/${stencil}/controllers/${stencil}.controller.ftl" stencilNamespaceController="${stencil?lower_case}_controller" />
		<#local view =			"/conf/${question.collection.id}/${question.profile}/${stencil}.view.ftl" stencilNamespaceView="${stencil?lower_case}_view" />
		<#noescape>
		<#assign imports in .namespace>
			<#t>${.namespace.imports!}
			<#t>${"\t\l#import \""+ view +"\" as " + stencilNamespaceView +"\g\n"}
			<#t>${"\t\l#import \""+ controller +"\" as " + stencilNamespaceController + "\g\n"}
		</#assign>
		</#noescape>
	</#list>

	<#nested>
</#macro>

 <#--
	ImportStencilsControllers
	@author Robert Prib
	@desc The following code imports and assigns stencil namespaces automatically eg. core and core_view. The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
-->
<#macro ImportStencilsControllers stencils>
	<#assign importsControllers ="" in .namespace>
	<#list stencils as stencil>
		<#local controller = 	"/share/stencils/libraries/${stencil}/controllers/${stencil}.controller.ftl" stencilNamespaceController="${stencil?lower_case}_controller" />
		<#noescape>
		<#assign importsControllers in .namespace>
			<#t>${.namespace.importsControllers!}
			<#t>${"\t\l#import \""+ controller +"\" as " + stencilNamespaceController + "\g\n"}
		</#assign>
		</#noescape>
	</#list>
	<#nested>
</#macro>

<#--
	ImportStencilsCSS
	@author Robert Prib
	@desc Prints out CSS for Stencils
	@param {array{string}} List of stencil names to load css for
-->
<#macro ImportStencilsCSS stencils=stencils>
	<!-- utilities.ftl :: ImportStencilsCSS -->
	<#--Load stencil default CSS files-->
		<#list stencils as stencil>
			<#-- Show CSS if set in view -->
			<#if .main[(stencil +"_view")]?? && .main[(stencil +"_view")].CSS??	>
				<@.main[(stencil +"_view")].CSS />
			</#if>
			<#-- Show CSS if set in controller -->
			<#if .main[(stencil +"_controller")]?? && .main[(stencil +"_controller")].CSS??	>
				<@.main[(stencil +"_controller")].CSS />
			</#if>
		</#list>
</#macro>

<#--
	ImportStencilsJS
	@author Robert Prib
	@desc Prints out JS for Stencils
	@param {array{string}} List of stencil names to load js for
-->
<#macro ImportStencilsJS stencils>
	<!-- utilities.ftl :: ImportStencilsJS -->
	<#--Load stencil default JS files-->
		<#list stencils as stencil>
			<#-- Show JS if set in view -->
			<#if .main[(stencil +"_view")]?? && .main[(stencil +"_view")].JS??	>
			 <@.main[(stencil +"_view")].JS />
			</#if>
			<#-- Show JS if set in controller -->
			<#if .main[(stencil +"_controller")]?? && .main[(stencil +"_controller")].JS??	>
				<@.main[(stencil +"_controller")].JS />
			</#if>
		</#list>
</#macro>


</#escape>
