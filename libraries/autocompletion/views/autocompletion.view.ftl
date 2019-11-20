<#ftl encoding="utf-8" />
<#-- DEPRECATED - This file has been deprecated. Please avoid using this file going forward -->
<#---
	<p>Provides views for Auto-Completion components.</p>

	<h2>Table of Contents</h2>
	<ul>
		<li><strong>Configuration:</strong> Configuration options for Auto-Completion Stencil.</li>
	</ul>
-->
<#escape x as x?html>
<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign autocompletionResourcesPrefix = "/stencils/resources/autocompletion/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${librariesPrefix}autocompletion/controllers/autocompletion.controller.ftl" as autocompletion_controller/>

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core"] />
	<#--
		The following code imports and assigns stencil namespaces automatically eg. core_view and core_controller.
		The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/
		and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
	-->
<@stencils_utilities.ImportStencils stencils=stencils>
	<@stencils_utilities.imports?interpret />
</@stencils_utilities.ImportStencils>

<#---
	Stylesheet dependencies
 -->
<#macro CSS>
	<!-- autocompletion.view.ftl.view.ftl :: CSS -->
	<link rel="stylesheet" href="${autocompletionResourcesPrefix}css/autocompletion.css">
</#macro>

<#---
	JavaScript dependencies
-->
<#macro JS>
	<!-- autocompletion.view.ftl.view.ftl :: JS -->
	<script src="${autocompletionResourcesPrefix}js/handlebars.js"></script>
	<script src="${autocompletionResourcesPrefix}js/typeahead.bundle.js"></script>
	<script src="${autocompletionResourcesPrefix}js/autocompletion.js"></script>
	<@simpleCompletion />
</#macro>
<#-- @end --><#-- /Configuration -->
<#-- ###################  Views ####################### -->
<#macro simpleCompletion>
<script type="text/javascript">
(function($) {
	$(document).ready(function() {
		stencils.module.autocompletion.run($('#query'), {
			collection 	: '<@autocompletion_controller.option>stencils.autocompletion.collection</@autocompletion_controller.option>',
			enabled 	: '<@autocompletion_controller.option>stencils.autocompletion</@autocompletion_controller.option>',
			profile		: '<@autocompletion_controller.option>stencils.autocompletion.profile</@autocompletion_controller.option>',
			format 		: '<@autocompletion_controller.option>stencils.autocompletion.format</@autocompletion_controller.option>',
			length 		: '<@autocompletion_controller.option>stencils.autocompletion.length</@autocompletion_controller.option>',
			program 	: '<@autocompletion_controller.option>stencils.autocompletion.program</@autocompletion_controller.option>',
			show		: '<@autocompletion_controller.option>stencils.autocompletion.show</@autocompletion_controller.option>',
			sort		: '<@autocompletion_controller.option>stencils.autocompletion.sort</@autocompletion_controller.option>'
		});
	});
}(jQuery));
</script>
</#macro>

</#escape>