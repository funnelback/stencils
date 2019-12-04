<#ftl encoding="utf-8" output_format="HTML" />

<#---
  Display tabs, from the FACETED_NAVIGATION extra search
-->
<#macro Tabs>
  <#list (response.facets)![] as facet>
    <#if facet.allValues?size gt 0 && facet.guessedDisplayType == "TAB">
      <div class="navbar-expand-md navbar-dark text-center">
        <button class="navbar-toggler mb-3" type="button" data-toggle="collapse" data-target="#search-tabs" aria-expanded="false" aria-label="Toggle tabs">
          <small class="navbar-toggler-icon"></small> Show Filters
        </button>

        <div class="collapse navbar-collapse" id="search-tabs">
          <ul class="nav nav-tabs justify-content-center mx-auto w-100">
            <#list facet.allValues as value>
              <li class="nav-item ml-1 mr-1">
                <a class="nav-link text-center<#if value.selected> active</#if><#if value.count lt 1> disabled</#if>" <#if value.count gt 0>href="${value.toggleUrl}"</#if>>
                  <#if question.getCurrentProfileConfig().get("stencils.tabs.icon.${value.label}")??>
                    <span class="${question.getCurrentProfileConfig().get("stencils.tabs.icon.${value.label}")}"></span>
                  </#if>
                  ${value.label} <span class="search-facet-count">(${value.count})</span>
                </a>
              </li>
            </#list>
          </ul>
        </div>
      </div>
    </#if>
  </#list>
</#macro>
<#-- vim: set expandtab ts=2 sw=2 sts=2 :-->
