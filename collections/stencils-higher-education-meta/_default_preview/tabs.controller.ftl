<#ftl encoding="utf-8" />
<#--
	Funnelback App: Tabs
	By: Gioan Tran
	Description:
		App to provide a framework for displaying tabs. It re-uses the faceted navigation system in order 
		to obtain the counts the provide the scoping. 
	
	Note: Do not modify this file for specific implementations as customisations will be lost during 
	Stencils upgrades. Customisations should be completed in the tabs.ftl file. 
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#-- Paths -->
<#assign basePath>/s/resources/<@s.cfg>collection</@s.cfg></#assign>
<#assign webPath>${basePath}/${question.profile}</#assign>

<#-- FunnelBack Apps used -->
<#assign FBApps = ["utilities"] />

<#-- Import and assign app namespaces eg. core and core_custom -->
<#list FBApps as app>
  <#assign appController="${app}.controller.ftl" appNamespace="${app?lower_case}_controller" />
  <#assign appView="${app}.view.ftl" appNamespaceCustom="${app?lower_case}_view" />
  <@'<#import appController as ${appNamespace}>'?interpret />
  <@'<#import appView as ${appNamespaceCustom}>'?interpret />
</#list>

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- 
	The follow are Funnelback App specific macros and function which are maintained by Funnelback App owners.
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

	<@fb.ExtraResults name="FACETED_NAVIGATION">
		<#nested>
	</@fb.ExtraResults>
</#macro>


<#---
  Displays a facet as tabs

  @name The name of the facet in which to derive the tabs
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
	
	i.e. 
	Facets have the following architecture:
	
	Facet
		Categories
			Values
				Name
				Count
				Categories (for hierarchical facets )

	e.g. 
	
	A meta data based facets can have the following:

	Keyword
		f.keyword
			[value 1]
				road
				23
			[value 2]
				house
				15
	...etc

	This macro will display the values (road, house, etc.) as Tab entries
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

<#-- Prints the nested code only if the tab is currently selected -->
<#macro IsActive>
	<#compress>
		<#if (.namespace.tabSelectedFacets)!?has_content
			&& (.namespace.facet.name)!?has_content
			&& .namespace.tabSelectedFacets?seq_contains(.namespace.facet.name)
			&& (.namespace.tabQueryStringParamName)!?has_content
			&& (.namespace.tabSelectedCategoryValues[.namespace.tabQueryStringParamName])!?has_content
			&& (.namespace.tabValue.label)!?has_content
			&& .namespace.tabSelectedCategoryValues[.namespace.tabQueryStringParamName]?seq_contains(.namespace.tabValue.label)>
			  <#nested>
		</#if>
	</#compress>
</#macro>

<#--- Displays the name of the tab -->
<#macro Name>
	<#if (.namespace.tabValue.label)!?has_content>
		${.namespace.tabValue.label}
	</#if>
</#macro>

<#-- Displays a link for the tab -->
<#macro Url>
	<#if (.namespace.tabValue.queryStringParam)!?has_content>
	  <#assign urlStem = question.collection.configuration.value("ui.modern.search_link") + "?">
		<#assign parameters = ["collection", "profile", "form", "query"]>
  
	  <#assign tabMenuUrl = utilities_controller.buildQueryString(parameters, urlStem)>
	  <#assign tabMenuUrl = tabMenuUrl + "&" + .namespace.tabValue.queryStringParam>

	  <#noescape>
	  	${tabMenuUrl}
	  </#noescape>
	</#if>
</#macro>

<#--- Displays the result count tab -->
<#macro Count>
	<#compress>
		<#if (.namespace.tabValue.count)!?has_content>
			${.namespace.tabValue.count}
		</#if>
	</#compress>
</#macro>

<#-- Runs the nested code if the tab returns no results -->
<#macro IsDisabled>
	<#compress>
		<#if (.namespace.tabValue.count)!?has_content && .namespace.tabValue.count == 0>
			<#nested>
		</#if>
	</#compress>
</#macro>


</#escape>