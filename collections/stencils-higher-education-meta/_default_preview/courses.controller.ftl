<#ftl encoding="utf-8" />
<#--
	Funnelback App: Courses
	By: Gioan Tran
	Description: <Description>

	Note: Do not modify this file for specific implementations as customisations will be lost during 
	Funnelback App upgrades. Customisations should be completed in the courses.ftl file.    
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- 
	Displays the facet breadcrumb as list. Provides a means for the user
	to unselect facet values
-->
<#macro BreadCrumbSearch>
	<#if (question.selectedFacets)!?has_content
		&& question.selectedFacets?size &gt; 0>
		<#nested>
	</#if>
</#macro>

<#-- Displays the facet breadcrumb as list which can be unselected-->
<#macro BreadCrumbs name="" names=[]>
	<#if response?exists && response.facets?exists>
	  <#if name == "" && names?size == 0>
      <#-- Iterate over all facets -->
      <#list response.facets as f>
        <#if f.hasValues() || question.selectedFacets?seq_contains(f.name)>
          <#assign facet = f in s>
          <#assign facet_index = f_index in s>
          <#assign facet_has_next = f_has_next in s>
          <#nested>
        </#if>
      </#list>
	  <#else>
	    <#list response.facets as f>
        <#if (f.name == name || names?seq_contains(f.name) ) && (f.hasValues() || question.selectedFacets?seq_contains(f.name))>
          <#assign facet = f in s>
          <#assign facet_index = f_index in s>
          <#assign facet_has_next = f_has_next in s>
          
          <#nested>
        </#if> 
	    </#list>
	  </#if>
	</#if>
</#macro>

<#macro BreadCrumb tag="span" class="">
	<#local fn = facetedNavigationConfig(question.collection, question.profile) >
	<#if fn?exists>
		<#-- 
			Find facet definition in the configuration corresponding
		  to the facet we're currently displaying 
		-->
		<#list fn.facetDefinitions as fdef>
			<#if fdef.name == s.facet.name>
			  <#assign facetDef = fdef in s />
			  <#assign facetDef_index = fdef_index in s />
			  <#assign facetDef_has_next = fdef_has_next in s />
        <${tag} class="${class}">
        <@BreadCrumbSummary>
          <#nested>
        </@BreadCrumbSummary>
        </${tag}>
			</#if>
		</#list> 
	</#if>
</#macro>

<#macro BreadCrumbSummary>
    <#-- We must test various combinations here as different browsers will encode
         some characters differently (i.e. '/' will sometimes be preserved, sometimes
         encoded as '%2F' -->
    <#if QueryString?contains("f." + s.facetDef.name?url)
        || urlDecode(QueryString)?contains("f." + s.facetDef.name)
        || urlDecode(QueryString)?contains("f." + s.facetDef.name?url)>
        <#assign breadCrumbUrl = question.collection.configuration.value("ui.modern.search_link") + "?" +  removeParam(facetScopeRemove(QueryString, s.facetDef.allQueryStringParamNames), ["start_rank"] + s.facetDef.allQueryStringParamNames) in s>
        <@NestedBreadCrumbName categoryDefinitions=s.facetDef.categoryDefinitions selectedCategoryValues=question.selectedCategoryValues>
          <#nested>
        </@NestedBreadCrumbName>
    </#if>
</#macro>

<#---
    Recursively generates the breadcrumbs for a facet.

    @param categoryDefinitions List of sub categories (hierarchical).
    @param selectedCategoryValues List of selected values.
    @param separator Separator to use in the breadcrumb.
-->
<#macro NestedBreadCrumbName categoryDefinitions selectedCategoryValues separator="">
  <#list categoryDefinitions as def>
    <#if def.class.simpleName == "URLFill" && selectedCategoryValues?keys?seq_contains(def.queryStringParamName)>
      <#-- Special case for URLFill facets: Split on slashes -->
      <#assign path = selectedCategoryValues[def.queryStringParamName][0]>
      <#assign pathBuilding = "">
      <#list path?split("/", "r") as part>
        <#assign pathBuilding = pathBuilding + "/" + part>
        <#-- Don't display bread crumb for parts that are part
             of the root URL -->
        <#if ! def.data?lower_case?matches(".*[/\\\\]"+part?lower_case+"[/\\\\].*")>
          <#if part_has_next>
            ${separator} <a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(facetScopeRemove(QueryString, def.allQueryStringParamNames), ["start_rank"] + def.allQueryStringParamNames)?html}&amp;${def.queryStringParamName}=${pathBuilding?url}">${part}</a>
          <#else>
            ${separator} ${part}
          </#if>
        </#if>
      </#list>
    <#else>
      <#if selectedCategoryValues?keys?seq_contains(def.queryStringParamName)>
        <#-- Find the label for this category. For nearly all categories the label is equal
             to the value returned by the query processor, but not for date counts for example.
             With date counts the label is the actual year "2003" or a "past 3 weeks" but the
             value is the constraint to apply like "d=2003" or "d>12Jun2012" -->
        <#-- Use value by default if we can't find a label -->
        <#local valueLabel = selectedCategoryValues[def.queryStringParamName][0] />

        <#-- Iterate over generated facets -->
        <#list response.facets as facet>
          <#if def.facetName == facet.name>
            <#-- Facet located, find current working category -->
            <#assign fCat = facet.findDeepestCategory([def.queryStringParamName])!"" />
            <#if fCat != "">
              <#list fCat.values as catValue>
                <#-- Find the category value for which the query string param
                     matches the currently selected value -->
                <#local kv = catValue.queryStringParam?split("=") />
                <#if valueLabel == urlDecode(kv[1])>
                    <#local valueLabel = catValue.label />
                </#if>
              </#list>
            </#if>
          </#if>
        </#list> 

        <#-- Find if we are processing the last selected value (leaf node) -->
        <#local last = true>
        <#list def.allQueryStringParamNames as param>
          <#if param != def.queryStringParamName && selectedCategoryValues?keys?seq_contains(param)>
            <#local last = false>
            <#break>
          </#if>
        </#list>

        <#if last == true>         
          <#assign breadCrumbName = valueLabel in s>
          <#nested>             
        <#else>
        	<#assign breadCrumbName = valueLabel in s>
          <#nested>
          <#assign breadCrumbUrl = question.collection.configuration.value("ui.modern.search_link") + "?" + removeParam(facetScopeRemove(QueryString, def.allQueryStringParamNames), ["start_rank"] + def.allQueryStringParamNames) + "&" + def.queryStringParamName + "=" + selectedCategoryValues[def.queryStringParamName][0] in s>  

          <@NestedBreadCrumbName categoryDefinitions=def.subCategories selectedCategoryValues=selectedCategoryValues separator=separator>
            <#nested>
          </@NestedBreadCrumbName>
        </#if>
        <#-- We've displayed one step in the breadcrumb, no need to inspect
             other category definitions -->
        <#break />
      </#if>
    </#if>
  </#list>
</#macro>

<#macro BreadCrumbName>
	<#compress>
		<#if (s.breadCrumbName)!?has_content>
			${s.breadCrumbName}
		</#if>
	</#compress>
</#macro>

<#macro BreadCrumbUrl>
	<#compress>
		<#if (s.breadCrumbUrl)!?has_content>
			${s.breadCrumbUrl}
		</#if>
	</#compress>
</#macro>

<#macro Cart>
  <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
    <div id="search-history" data-ng-cloak data-ng-show="isDisplayed('history')">
      <div class="row">
        <div class="col-md-12">
          <a href="#" data-ng-click="hideHistory()" class="btn btn-primary">
            <span class="glyphicon glyphicon-arrow-left"></span> Back to results
          </a>
          <h2><span class="glyphicon glyphicon-time"></span> History</h2>

          <div class="row">
            <div class="col-md-6" data-ng-controller="ClickHistoryCtrl">
              <div data-ng-show="!clickHistoryEmpty && <@fb.HasClickHistory />">
                <h3><span class="glyphicon glyphicon-heart"></span> Recently clicked results
                  <button class="btn btn-danger btn-xs" title="Clear click history" data-ng-click="clear('Your history will be cleared')"><span class="glyphicon glyphicon-remove"></span> Clear</button>
                </h3>
                <ul class="list-unstyled">
                  <#list session.clickHistory as h>
                    <li><a href="${h.indexUrl?html}">${h.title}</a> &middot; <span class="text-warning">${prettyTime(h.clickDate)}</span><#if h.query??><span class="text-muted"> for &quot;${h.query!?html}&quot;</#if></span></li>
                  </#list>
                </ul>
              </div>
              <div data-ng-show="clickHistoryEmpty || !<@fb.HasClickHistory />">
                <h3><span class="glyphicon glyphicon-heart"></span> Recently clicked results</h3>
                <p class="text-muted">Your click history is empty.</p>
              </div>
            </div>
            <div class="col-md-6" data-ng-controller="SearchHistoryCtrl">
              <div data-ng-show="!searchHistoryEmpty && <@fb.HasSearchHistory />">
                <h3><span class="glyphicon glyphicon-search"></span> Recent searches
                  <button class="btn btn-danger btn-xs" title="Clear search history" data-ng-click="clear('Your history will be cleared')"><span class="glyphicon glyphicon-remove"></span> Clear</button>
                </h3>
                <ul class="list-unstyled">
                  <#list session.searchHistory as h>
                    <li><a href="?${h.searchParams?html}">${h.originalQuery} <small>(${h.totalMatching})</small></a> &middot; <span class="text-warning">${prettyTime(h.searchDate)}</span></li>
                  </#list>
                </ul>
              </div>
              <div data-ng-show="searchHistoryEmpty || !<@fb.HasSearchHistory />">
                <h3><span class="glyphicon glyphicon-search"></span> Recent searches</h3>
                <p class="text-muted">Your search history is empty.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div id="search-cart" data-ng-cloak data-ng-show="isDisplayed('cart')" data-ng-controller="CartCtrl">
      <div class="row">
        <div class="col-md-12">
          <a href="#" data-ng-click="hideCart()" class="btn btn-primary"><span class="glyphicon glyphicon-arrow-left"></span> Back to results</a>
          <h2><span class="glyphicon glyphicon-pushpin"></span> Saved
            <button class="btn btn-danger btn-xs" title="Clear selection" data-ng-click="clear('Your selection will be cleared')"><span class="glyphicon glyphicon-remove"></span> Clear</button>
          </h2>
        </div>
      </div>
      <div class="row">
        <table class="table table-striped table-hover table-condensed">                
          <tbody>
            <tr>
              <th scope="row" rowspan="2" width="8em"><small>Course</small></th>                        
                <td data-ng-repeat="item in cart"><a href="{{item.indexUrl}}">{{item.title}}</a></td>
            </tr>
            <#--
            <tr>                                                          
              <td data-ng-repeat="item in cart" width="180"><img src="/s/scale?url=http://localhost/s/resources/<@s.cgi>collection</@s.cgi>/img/{{item.metaData.I|fileNameOnly}}&amp;width=212&amp;height=160" /></td>                        
            </tr>
            -->            
            <tr>
              <th scope="row"><small>Area of Study</small></th>
              <td data-ng-repeat="item in cart">{{item.metaData.1}}</td>
            </tr>
            <tr>
              <th scope="row"><small>Campuses</small></th>
              <td data-ng-repeat="item in cart">{{item.metaData.6}}</td>
            </tr>
            <tr>
              <th scope="row"><small>Entry Score</small></th>
              <td data-ng-repeat="item in cart">{{item.metaData.2}}</td>
            </tr>
            <tr>
              <th scope="row"><small>Intake</small></th>
              <td data-ng-repeat="item in cart">{{item.metaData.7}}</td>
            </tr>
            <tr>
              <th scope="row"><small>Study Level</small></th>
              <td data-ng-repeat="item in cart">{{item.metaData.4}}</td>
            </tr>
            <tr>
              <th scope="row"><small class="sr-only">Remove</small></th>
              <td data-ng-repeat="item in cart">
                <a data-ng-click="remove(item.indexUrl)" href="javascript:;" class="btn btn-danger btn-xs" title="Remove {{item.title}}"><span class="glyphicon glyphicon-remove"></span>&nbsp;Remove</a>
              </td>
            </tr>                  
          </tbody>
        </table>
      </div>
    </div>
  </#if>
</#macro>


<#macro jsDefault>
  <#-- CART FILTERS -->
  <script src="/s/resources/${question.collection.id}/${question.profile}/ng-filter-fileNameOnly.js"></script>
</#macro>

</#escape>