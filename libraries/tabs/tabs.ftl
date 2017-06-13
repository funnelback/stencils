<#ftl encoding="utf-8" output_format="HTML" />

<#---
  Display tabs, from the FACETED_NAVIGATION extra search
-->
<#macro Tabs>
    <#list extraSearches.FACETED_NAVIGATION.response.customData.stencilsFacets![] as facet>
      <#if facet.name?starts_with("Tabs")>
        <ul class="nav nav-tabs justify-content-center">
          <#list facet.values as value>
            <li class="nav-item">
              <a class="nav-link text-center<#if value.selected> active</#if><#if value.count lt 1> disabled</#if>" <#if value.count gt 0>href="${value.selectUrl}"</#if>>
                <#if question.collection.configuration.value("stencils.tabs.icon.${value.label}")??>
                  <span class="${question.collection.configuration.value("stencils.tabs.icon.${value.label}")}"></span>
                </#if>
                ${value.label} <span class="search-facet-count">(${value.count})</span>
              </a>
            </li>
          </#list>
        </ul>
      </#if>
    </#list>
</#macro>
<#-- vim: set expandtab ts=2 sw=2 sts=2 :-->
