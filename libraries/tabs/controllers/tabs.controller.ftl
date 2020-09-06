<#ftl encoding="utf-8" />
<#-- DEPRECATED - This file has been deprecated. Please avoid using this file going forward -->
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

<#---
	Conditional display - Runs the nested code if facets which
	represents the tabs are defined.

	<p>
		Requires the Faceted Navigation extra search to be enabled via
		<code> ui.modern.full_facets_list=true </code>
	</p>
-->
<#macro TabSearch>
	<#--
		Saving the selected facets and selected category values for later
		as there are not avaliable in the Faceted Navigation extra search
	-->
	<#if (question.selectedFacets)!?has_content>
			<#assign tabSelectedFacets = question.selectedFacets in .namespace>
	</#if>

	<#if (question.selectedCategoryValues)!?has_content>
			<#assign tabSelectedCategoryValues = question.selectedCategoryValues in .namespace>
	</#if>

	<@core_controller.ExtraResults name="FACETED_NAVIGATION">
		<#nested>
	</@core_controller.ExtraResults>
</#macro>

<#---
	Displays a facet as tabs

	@requires TabSearch

	@param name The name of the facet in which to derive the tabs

	@provides <code>${core_controller.facet}</code> <br /> <code>${core_controller.facet_index}</code> <br /> <code>${core_controller.facet_has_next}</code>
-->
<#macro Tabs name="">
	<#if (response.facets)!?has_content>
		<#list response.facets as f>
			<#if f.name == name && f.hasValues() >
				<#assign facet = f in .namespace>
				<#assign facet_index = f_index in .namespace>
				<#assign facet_has_next = f_has_next in .namespace>
					<#nested>
			</#if>
		</#list>
	</#if>
</#macro>

<#---
	Displays a individual facet value as a tab item.

	<pre>
	i.e.
	Facets have the following architecture:

	Facet
		Categories
			Values
				Name
				Count
				Categories (for hierarchical facets )

	e.g.

	Meta data based facets can have the following:

	Keyword
		f.keyword
			[value 1]
				road
				23
			[value 2]
				house
				15
	...etc

	</pre>

	<p>
		This macro will display the values (road, house, etc.) as Tab entries
	</p>

	@requires Tabs

	@provides <code>${core_controller.tabQueryStringParamName}</code> <br /> <code>${core_controller.tabValue}</code>
-->
<#macro Tab>
	<#if (.namespace.facet)!?has_content>
		<#list .namespace.facet.categories as category>
			<#assign tabQueryStringParamName = category.queryStringParamName in .namespace>
			<#list category.values as category_value>
				<#assign tabValue = category_value in .namespace>
				<#nested>
			</#list>
		</#list>
	</#if>
</#macro>

<#--
	Conditional display - Runs the nested code only if the tab is currently selected

	@param negate is a switch which can be used to reverse the logic of this function
-->
<#macro IsActive negate=false>
	<#-- Variable used to determine if the logic of this function has been fulfilled -->
	<#local found = false>

	<#if (.namespace.tabSelectedFacets)!?has_content
		&& (.namespace.facet.name)!?has_content
		&& .namespace.tabSelectedFacets?seq_contains(.namespace.facet.name)
		&& (.namespace.tabQueryStringParamName)!?has_content
		&& (.namespace.tabSelectedCategoryValues[.namespace.tabQueryStringParamName])!?has_content
		&& (.namespace.tabValue.label)!?has_content
		&& .namespace.tabSelectedCategoryValues[.namespace.tabQueryStringParamName]?seq_contains(.namespace.tabValue.label)>
			<#local found = true>
	</#if>

	<#compress>
		<#if negate == false && found == true>
			<#--
				Display the nested code if the above logic is satified and the negate options
				has not been set to true
			-->
			<#nested>
		<#elseif negate == true && found == false>
			<#--
				Negating the above logic. Display the nested code only when the above
				logic is not satified and that the user has set negate to true
			-->
			<#nested>
		</#if>
	</#compress>
</#macro>

<#---
	Displays the name of the tab
-->
<#macro Name><#compress>
	<#if (.namespace.tabValue.label)!?has_content>
		${.namespace.tabValue.label}
	</#if>
</#compress></#macro>

<#---
	Displays a link for the tab
-->
<#macro Url><#compress>
	<#if (.namespace.tabValue.queryStringParam)!?has_content>
		<#assign urlStem = question.getCurrentProfileConfig().get("ui.modern.search_link") + "?">
		<#assign parameters = ["collection", "profile", "form", "query", "admin"]>

		<#assign tabMenuUrl = base_controller.buildQueryString(parameters, urlStem)>
		<#assign tabMenuUrl = tabMenuUrl + "&" + .namespace.tabValue.queryStringParam>

		<#noescape>
			${tabMenuUrl}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Displays the result count of the tab
-->
<#macro Count><#compress>
		<#if (.namespace.tabValue.count)!?has_content>
			${.namespace.tabValue.count}
		</#if>
</#compress></#macro>

<#---
	Conditional display - Runs the nested code if the tab will return no results
-->
<#macro IsDisabled>
	<#if (.namespace.tabValue.count)!?has_content && .namespace.tabValue.count == 0>
		<#nested>
	</#if>
</#macro>

<#---
	Represents an area of a select tab in which the results are to be displayed

	@param facet Represents facet group which to derive the tabs from
-->
<#macro TabPane facet>
	<#assign tabGroup = facet in .namespace>
	<#nested>
</#macro>

<#--
	Conditional display - Runs nested content only when a certain tab has been selected

	<p>
		Requires the @name of the tab group (facet group), the corresponding @code
		(metadata class or gscope number) and the tab @value (facet label)
	</p>

	@requires TabPane

	@param name Optional Name of the facet group. If none is specified, it will attempt to obtain the name from the namespace (as assigned by #TabPane macro)
	@param code Metadata class or gscope number of the facets which the tabs are based off
	@param value Facet label
	@param negate A switch which can be used to reverse the logic of this function
-->
<#macro IsTabSelected code value name="" negate=false>
	<#-- Determine the name of the selected tab group -->
	<#if name!?has_content>
		<#local tabGroup = name>
	<#else>
		<#local tabGroup = .namespace.tabGroup>
	</#if>

	<#-- Generate the parameter name which is made up of the tab group and code -->
	<#local paramName = "f." + tabGroup + "|" + code>

	<#-- Variable used to determine if the logic of this function has been fulfilled -->
	<#local found = false>

	<#if (question.selectedFacets)!?has_content
		&& question.selectedFacets?seq_contains(tabGroup)
		&& (question.selectedCategoryValues[paramName])!?has_content
		&& question.selectedCategoryValues[paramName]?seq_contains(value)>
		<#local found = true>
	</#if>

	<#if negate == false && found == true>
		<#--
			Display the nested code if the above logic is satified and the negate options
			has not been set to true
		-->
		<#nested>
	<#elseif negate == true && found == false>
		<#--
			Negating the above logic. Display the nested code only when the above
			logic is not satified and that the user has set negate to true
		-->
		<#nested>
	</#if>

</#macro>

<#--
	Conditional display - Runs the nested content only when a tabs is selected.

	@param name Represents the tab name
	@param negate A switch which can be used to reverse the logic of this function
-->
<#macro HasTabSelected name nagate=false>
	<#local found = false>
	<#if (question.selectedFacets)!?has_content
		&& question.selectedFacets?seq_contains(name)>
			<#local found = true>
	</#if>

	<#if negate == false && found == true>
		<#--
			Display the nested code if the above logic is satified and the negate options
			has not been set to true
		-->
		<#nested>
	<#elseif negate == true && found == false>
		<#--
			Negating the above logic. Display the nested code only when the above
			logic is not satified and that the user has set negate to true
		-->
		<#nested>
	</#if>
</#macro>

<#--
	Conditonal display - Runs the nested content only when no tabs are selected or
	when the tab by the @name is not selected

	@param name The name of the tab
-->
<#macro NoTabSelected name="">
	<#if (question.selectedFacets)!?has_content == false
		|| question.selectedFacets?seq_contains(name) == false>
		<#nested>
	</#if>
</#macro>

<#---
	Conditonal display - Runs the nested content only when the @extraSearchName
	has at least one result.

	@param extraSearchName The name of the extra search
-->
<#macro Preview extraSearchName>
	<@core_controller.ExtraResults name=extraSearchName>
		<#-- Only run the nested code if there is at least one result -->
		<@base_controller.HasResults>
			<#nested>
		</@base_controller.HasResults>
	</@core_controller.ExtraResults>
</#macro>

<#---
	Conditonal display - Runs the nested content only if there are more results

	<p>
		This is used to determine if we should create a link to show more results
		from the specified extra search.
	</p>

	@requires Preview
-->
<#macro PreviewMoreLinkArea>
	<#if (response.resultPacket.resultsSummary.nextStart)!?has_content>
		<#nested>
	</#if>
</#macro>

<#---
	Prints the preview link will will show more results from the selected facet.

	@param code The code of the tab/facet preview e.g. for meta data based facets, it would be the metadata class such as <code> a </code>. For gscope based facets, it would be the gscope number such as <code> 11 </code>
	@param value The value of the tab/facet of the preview e.g. e.g. for meta data based facets, it would be the metadata value such as "funnelback". For gscope based facets, it would be the gscope label
	@param name Optional Name of the facet group. If none is specified, it will attempt to obtain the name from the namespace (as assigned by #TabPane macro)
	@param params List of cgi options to retain. These can include things such as scope, gscope1, fmo etc. Defaults to query, profile and collection.
<#-->
<#macro PreviewMoreLink code value name="" params=["query", "profile", "collection"]><#compress>
	<#-- Determine the name of the selected tab group -->
	<#if name!?has_content>
		<#local tabGroup = name>
	<#else>
		<#local tabGroup = .namespace.tabGroup>
	</#if>

	<#-- Generate the parameter for the new tab -->
	<#local paramName = "f." + tabGroup + "|" + code>

	<#-- Generate the more link -->
	<#local searchLink = question.getCurrentProfileConfig().get("ui.modern.search_link") + "?">
	<#local moreLink = base_controller.buildQueryString(params, searchLink) + "&" + paramName!?url + "=" + value!?url>

	${moreLink}
</#compress></#macro>

</#escape>
