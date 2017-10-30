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
    <#list response.customData.stencilsFacets![] as facet>
      <#if facetNames?size lt 1 || facetName == facet.name>
        <#if facet.values?size gt 0>
          <div class="card search-facet">
            <div class="card-block">

              <div class="card-title">
                  <#if facet.selected><small class="float-right"><a class="text-muted" href="${facet.unselectAllUrl}"><span class="fa fa-times"></span> clear all</a></small></#if>
                  <h4>${facet.name}</h4>
              </div>

              <ul class="list-unstyled">
                <#list facet.selectedValues as value>
                  <li>
                    <a href="${value.unselectUrl}"><span class="fa fa-times"></span> ${value.label}</a>
                    <span class="badge badge-default float-right">${value.count?string}</span>
                  </li>
                </#list>
                <#if !facet.selected>
                  <#list facet.unselectedValues as value>
                    <li>
                      <a href="${value.selectUrl}">${value.label}</a>
                      <span class="badge badge-default float-right">${value.count?string}</span>
                    </li>
                  </#list>
                </#if>
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
  <#if (response.customData.stencilsFacetsSelectedValues![])?size gt 0>
    <ul class="list-inline">
      <li class="list-inline-item">${label!}</li>
      <#list response.customData.stencilsFacetsSelectedValues as value>
        <li class="list-inline-item"><a href="${value.unselectUrl}" class="badge badge-default">${value.facetName}: ${value.value} <span class="fa fa-remove"></span></a></li>
      </#list>
    </ul>
  </#if>
</#macro>

<#-- vim: set expandtab ts=2 sw=2 sts=2 :-->
