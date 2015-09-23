<#ftl encoding="utf-8" />
<#--
  Funnelback App: Utilities
  By: Gioan Tran
  Description: <Description>

  Note: Do not modify this file for specific implementations as customisations will be lost during 
  Funnelback App upgrades. Customisations should be completed in the tabs.ftl file.    
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Macro which executes only if at least one result is found -->
<#macro HasResults>
  <#if (response.resultPacket.resultsSummary.totalMatching)!?has_content
   && response.resultPacket.resultsSummary.totalMatching &gt; 0>
   <#nested>
  </#if>
</#macro>

<#-- Macro which executes code only when there are values found for at least one facet -->
<#macro HasFacets>
  <@s.AfterSearchOnly>
    <#assign facetFound = false>
    <#if response.facets??>
      <#list response.facets as facet>
        <#if facet.categories??>
          <#list facet.categories as category>
            <#if (category.values?? && category.values?size > 0)>
              <#assign facetFound = true>
            <#elseif (category.categories?? && category.categories?size > 0)>
              <#assign facetFound = true>
            </#if>
          </#list>
        </#if>
      </#list>
    </#if>

    <#if facetFound == true>
      <#nested>
    </#if>
  </@s.AfterSearchOnly>
</#macro>

<#-- Macro which executes code only when there are values found for at least one contextual navigation entry that is not in "Site" -->
<#macro HasContextNavigationEntries>
  <#assign contextFound = false>
  <@s.AfterSearchOnly>
    <#if (response.resultPacket.contextualNavigation.categories)!?has_content>
      <#list response.resultPacket.contextualNavigation.categories as category>
        <#if category.name != "site">
          <#assign contextFound = true>
        </#if>
      </#list>
    </#if>
  </@s.AfterSearchOnly>

  <#if contextFound == true>
    <#nested>
  </#if>
</#macro>

<#-- Creates hidden input type for the meta data and all its values -->
<#macro PrintAllHiddenInputs strMeta>
  <#if (question.rawInputParameters)!?has_content
    && question.rawInputParameters[strMeta]??>
    <#list question.rawInputParameters[strMeta] as strValue>
      <#if !strValue?matches("")>
        <input type="hidden" name="${strMeta}" value="${strValue}">
      </#if>
    </#list>
  </#if>
</#macro>

<#-- 
  Builds a url which is used to navigate to another page 
  maintaining the values of the @parameters
-->
<#function buildQueryString(parameters, urlStem ="")>
  <#local url = urlStem>
  <#-- Search for each parameter and append the values to the url
    if a value can be found -->
  <#local flag = false>
  <#list parameters as param>
    <#if (question.rawInputParameters)!?has_content
      && question.rawInputParameters[param]??>            
      <#-- 
        Append values for each occurence of the parameter 
        i.e. meta_a=peter&meta_a=john 
      -->  
      <#list question.rawInputParameters[param] as value>
        <#if value?has_content>
          <#-- 
            Appends a & only if this is not the first time a value
            is being added to the url
          -->
          <#if url?matches("&$") == false && flag>
            <#local url = url + "&">
          </#if>

          <#local url = url + param + "=" + value>

          <#local flag = true>
        </#if>
      </#list>
    </#if>    
  </#list>
  <#return url>
</#function>

</#escape>