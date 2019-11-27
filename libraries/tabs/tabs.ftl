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

<#-- 
  Provides preview of a tab. This allows the user to see 
  a sample of the results on anothe tab without having to click
  back and forwards. It also improvides the user flow by providing
  a link to navigate to the target tab.
-->
<#macro Preview extraSearchName title="" tabDisplayName=""  parentQuestion=question>
  <#assign parentQuestion = question>
  <@fb.ExtraResults name=extraSearchName>
    <#if (response.resultPacket.results)!?has_content>
      <div class="col-md-3 search-tab-preview text-muted mb-3">
        <h4>${title!}</h4>
        <ol class="list-unstyled">
          <#list (response.resultPacket.results)![] as result>
            <@base.Result result=result question=parentQuestion/>
          </#list>
        </ol>

        <#if (response.customData.stencilsTabsPreviewLink)!?has_content>
          
          <#assign searchLink = question.getCurrentProfileConfig().get("ui.modern.search_link")!>
          <#assign previewLink = response.customData.stencilsTabsPreviewLink!>
          
          <a href="${searchLink}${previewLink}" title="See more results for ${tabDisplayName!}">See more results for ${tabDisplayName!} </a>
        </#if>
      </div>
    </#if>
  </@fb.ExtraResults>
</#macro>
<#-- vim: set expandtab ts=2 sw=2 sts=2 :-->
