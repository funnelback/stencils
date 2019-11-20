<#ftl encoding="utf-8" />
<#-- DEPRECATED - This file has been deprecated. Please avoid using this file going forward -->
<#--
   Funnelback App: People
   By: Gioan Tran
   Description: This stencils aims to provide standard implementations of a people search
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign thirdPartyResourcesPrefix = "${GlobalResourcesPrefix}stencils-resources/thirdparty/" >

<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#assign stencils=["core","base"] />

<@stencils_utilities.ImportStencilsControllers stencils=stencils>
	<@stencils_utilities.importsControllers?interpret />
</@stencils_utilities.ImportStencilsControllers>

<#---
    Get the number of results for a given initial, from the faceted navigation data
    
    @param letter Letter to get the results count from
    @return Result count for the letter, or zero if the letter is not found
-->
<#function getLetterCount letter>
    <#list response.facets as f>
        <#if "Initial" == f.name && f.categories?size gt 0>
            <#list f.categories[0].values as v>
                <#if v.label == letter>
                    <#return v.count>
                </#if>
            </#list>
        </#if>
    </#list>
    
    <#return 0>
</#function>

<#---
    Check if a letter is currently selected by looking at the faceted navigation CGI parameters
    
    @param letter Letter to check for selection
    @return true if the letter is currently selected, false otherwise
-->
<#function isLetterSelected letter>
    <#return question.inputParameterMap["f.Initial|stencilsPeopleInitial"]! == letter>
</#function>

<#---
    Check if a letter is currently selected
    
    @return true if no letters are currently selected, false otherwise
-->
<#function noLetterSelected>
    <#return !question.inputParameterMap?keys?seq_contains("f.Initial|stencilsPeopleInitial")>
</#function>

<#---
    Execute nested code if the user is viewing the initial page, with no search (query or letter selection)
    being run
-->
<#macro BrowsingMode>
    <#if !question.inputParameterMap?keys?seq_contains("query") && question.selectedFacets?size lte 0>
        <#nested>
    </#if>
</#macro>

<#---
    Execute nested code if the user is currently searching (query or letter selection)
-->
<#macro SearchingMode>
    <#if question.inputParameterMap?keys?seq_contains("query") || question.selectedFacets?size gt 0>
        <#nested>
    </#if>
</#macro>

</#escape>
