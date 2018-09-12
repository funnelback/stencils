<#ftl encoding="utf-8" output_format="HTML" />

<#--
  Generates facets

  @param facets Comma delimited list of facet names to display. If not set all facets are displayed
--->
<#macro Facets facets="">
  <#local facetNames = [] />
  <#if facets != "">
    <#local facetNames = facets?split(",") />
  </#if>

  <#-- List the provided names first rather than the facet order, to
    to preserve the order that was passed in -->
  <#list facetNames as facetName>
    <#list response.facets![] as facet>
      <#if facetNames?size lt 1 || facetName == facet.name>
        <#if facet.allValues?size gt 0>
          <div class="card search-facet">
            <div class="card-body">

              <div class="card-title">
                <#-- Display a "Clear all" link except for radio button type facets
                  as they already have an "all" value -->
                <#if facet.selected && facet.guessedDisplayType != "RADIO_BUTTON"><small class="float-right"><a class="text-muted" href="${facet.unselectAllUrl}"><span class="fa fa-times"></span> clear all</a></small></#if>
                <h4>${facet.name}</h4>
              </div>

              <ul class="list-unstyled">
                <#list facet.allValues as value>
                  <li>
                    <span class="badge badge-default float-right">${value.count?string}</span>
                    <a href="${value.toggleUrl}">
                      <#if facet.guessedDisplayType == "RADIO_BUTTON">
                        <span class="text-muted fa ${value.selected?then("fa-dot-circle-o", "fa-circle-o")}"></span>
                      <#elseif facet.guessedDisplayType == "CHECKBOX">
                        <span class="text-muted fa ${value.selected?then("fa-check-square-o", "fa-square-o")}"></span>
                      <#elseif value.selected>
                        <#if facet.guessedDisplayType == "SINGLE_DRILL_DOWN" && value?counter gt 1><span class="text-muted ml-${value?counter}">&#8627;</span></#if>
                        <span class="text-muted fa fa-times"></span>
                      </#if>
                      ${value.label}
                    </a>
                  </li>
                </#list>
              </ul>

              <button type="button" class="btn btn-link btn-sm search-toggle-more-categories" style="display: none;" data-more="More&hellip;" data-less="Less&hellip;" data-state="more" title="Show more categories from this facet"><small class="fa fa-plus"></small>&nbsp;<span>More&hellip;</span></button>
            </div>
          </div>
        </#if>
      </#if>
    </#list>
  </#list>
</#macro>

<#--
  List currently selected facet values, with a "Refine by" header
-->
<#macro SelectedFacetValues label="Refined by:">
  <#if response.facetExtras.hasSelectedNonTabFacets>
    <ul class="list-inline">
      <li class="list-inline-item">${label!}</li>
      <#list (response.facets)![] as facet>
        <#if facet.selected && facet.guessedDisplayType != "TAB">
          <#list facet.selectedValues as value>
            <li class="list-inline-item"><a href="${value.toggleUrl}" class="badge badge-light">${facet.name}: ${value.label} <span class="fa fa-remove"></span></a></li>
          </#list>
        </#if>
      </#list>
    </ul>
  </#if>
</#macro>

<#-- vim: set expandtab ts=2 sw=2 sts=2 :-->
