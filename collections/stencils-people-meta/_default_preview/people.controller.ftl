<#ftl encoding="utf-8" />

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

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#macro InitialForm image index=false>
  <div class="row search-initial">
        <div class="col-md-6 col-md-offset-3 text-center">

            <#if error?? || (response.resultPacket.error)??>
                <div class="alert alert-danger"><@fb.ErrorMessage /></div>
                <br><br>
            </#if>

            <a href="http://funnelback.com/"><img src="${SearchPrefix}funnelback.png" alt="Funnelback logo"></a>
            <br><br>

            <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET"
                  role="search">
                <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
                <@s.IfDefCGI name="enc"><input type="hidden" name="enc"
                                               value="${question.inputParameterMap["enc"]!}"></@s.IfDefCGI>
                <@s.IfDefCGI name="form"><input type="hidden" name="form"
                                                value="${question.inputParameterMap["form"]!}"></@s.IfDefCGI>
                <@s.IfDefCGI name="scope"><input type="hidden" name="scope"
                                                 value="${question.inputParameterMap["scope"]!}"></@s.IfDefCGI>
                <@s.IfDefCGI name="lang"><input type="hidden" name="lang"
                                                value="${question.inputParameterMap["lang"]!}"></@s.IfDefCGI>
                <@s.IfDefCGI name="profile"><input type="hidden" name="profile"
                                                   value="${question.inputParameterMap["profile"]!}"></@s.IfDefCGI>
                <div class="input-group">
                    <input required name="query" id="query" title="Search query" type="text"
                           value="${question.inputParameterMap["query"]!}" accesskey="q"
                           placeholder="Search <@s.cfg>service_name</@s.cfg>        "
                           class="form-control input-lg query">

                    <div class="input-group-btn">
                        <button type="submit" class="btn btn-primary input-lg"><span
                                class="glyphicon glyphicon-search"></span> Search
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
  <div class="col-md-12 text-center">
              <h3><span class="glyphicon glyphicon-book"></span> A-Z Index (Surname)</h3>
              <ul class="pagination pagination-sm">
                <#assign alphabet = ["all", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] />
                <#list alphabet as letter>
                <li><a href="/s/search.html?collection=<@s.cgi>collection</@s.cgi>&amp;<@s.IfDefCGI name="profile">profile=<@s.cgi>profile</@s.cgi>&amp;</@s.IfDefCGI>letter=${letter}">${letter?capitalize}</a></li>
                </#list>
              </ul>
              </div>
</#macro>
<#---
Create an A-Z listing (including 'All', and '0-9' options) based on facets 
returned from a metadata field count.  
@param rmcField Mandatory result metadata count field
-->
<#macro azList rmcField>

  <#if question.inputParameterMap["letter"]?? >        
    <#assign currentLetter = (question.inputParameterMap["letter"]!)?lower_case />
    <#assign alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] />
    
    <ul class="pagination pagination-sm">
        <li<#if !currentLetter?? || currentLetter = "all"> class="active"</#if>>
            <a href="/s/search.html?collection=<@s.cgi>collection</@s.cgi>&amp;<@s.IfDefCGI name="profile">profile=<@s.cgi>profile</@s.cgi>&amp;</@s.IfDefCGI>letter=all">All</a>
        </li>
        <#list alphabet as letter>
            <#if letter == currentLetter>
                <li class="active">
                    <a href="/s/search.html?collection=<@s.cgi>collection</@s.cgi>&amp;<@s.IfDefCGI name="profile">profile=<@s.cgi>profile</@s.cgi>&amp;</@s.IfDefCGI>letter=${letter}">${letter?upper_case}</a>
                </li>
            <#else>
                <#assign rmc = rmcField + ":" + letter  />                 
                  <#if extraSearches.FACETED_NAVIGATION?? 
                    && extraSearches.FACETED_NAVIGATION.response.resultPacket.rmcs?? 
                    && extraSearches.FACETED_NAVIGATION.response.resultPacket.rmcs[rmc]??>
                    <#assign count = extraSearches.FACETED_NAVIGATION.response.resultPacket.rmcs[rmc] />
                      <li>
                          <a 
                            id="az_browse_${letter?upper_case}" 
                            title="Browse by letter: '${letter?upper_case}' (${count} results)" 
                            href="/s/search.html?collection=<@s.cgi>collection</@s.cgi>&amp;<@s.IfDefCGI name="profile">profile=<@s.cgi>profile</@s.cgi>&amp;</@s.IfDefCGI>letter=${letter}">
                                ${letter?upper_case}
                        </a>
                        </li>
                  <#else>
                        <li class="disabled"><a href="#">${letter?upper_case}</a></li>
                  </#if>
            </#if>
        </#list>
    </ul>
   <#else>
              <ul class="pagination pagination-sm">
                <#assign alphabet = ["all", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] />
                <#list alphabet as letter>
                <li><a href="/s/search.html?collection=<@s.cgi>collection</@s.cgi>&amp;<@s.IfDefCGI name="profile">profile=<@s.cgi>profile</@s.cgi>&amp;</@s.IfDefCGI>letter=${letter}">${letter?capitalize}</a></li>
                </#list>
              </ul>
   </#if>
</#macro>

<#macro Facets name="" names=[]>
  <@s.FacetedSearch>
  <div id="search-refine" class="hidden-md hidden-lg">
  <button data-target="#search-facets" data-toggle="collapse" type="button" class="btn btn-default btn-sm" style="margin:0 0 0 15px">
  <span class="glyphicon glyphicon-filter"></span> Refine
  </button>
  <hr>
  </div>
  <div id="search-facets" class="col-md-3 hidden-print collapse in">
  <h2 class="sr-only">Refine</h2>
  <@s.Facet name names>
    <@s.FacetLabel tag="h3"/>
    <div class="panel-body">
      <ul class="list-unstyled">
        <@s.Category tag="li">
        <@s.CategoryName class="" />&nbsp;<small class="text-muted">(<@s.CategoryCount />)</small>
        </@s.Category>
      </ul>
      <button type="button" class="btn btn-search-toggle-more-categories" style="display: none;" data-more="More&hellip;" data-less="Less&hellip;" data-state="more" title="Show more categories from this facet"><small class="glyphicon glyphicon-plus"></small>&nbsp;<span>More&hellip;</span></button>
    </div>
    </@s.Facet>
  </div>
  </@s.FacetedSearch>
</#macro>

<#macro sortDropdown>
<#noescape>
<#-- SORT MODES -->
        <div class="dropdown pull-right">
            <a class="dropdown-toggle text-muted" data-toggle="dropdown" href="#" id="dropdown-sortmode" title="Sort">
            <small><span class="glyphicon glyphicon-sort"></span>&nbsp;Sort</small>
            </a>
            <ul class="dropdown-menu" role="menu" aria-labelledby="dropdown-sortmode">
            <#if !question.inputParameterMap["letter"]??><li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}"><span class="glyphicon glyphicon-sort-by-attributes-alt"></span> Relevance</a></li></#if>
            <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}&sort=metaj">Last Name (A-Z)</a></li>
            <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}&sort=dmetaj">Last Name (Z-A)</a></li>
             <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}&sort=metag">First Name (A-Z)</a></li>
            <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}&sort=dmetag">First Name (Z-A)</a></li>
            
            <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}&sort=metaS">Department (A-Z)</a></li>
            <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}&sort=dmetaS">Department (Z-A)</a></li>
            </ul>
        </div>
</#noescape>
</#macro>

<#macro Count>
  <div id="search-result-count" class="text-muted">
    <#if response.resultPacket.resultsSummary.totalMatching == 0>
    <span id="search-total-matching">0</span> search results <#if response.resultPacket.query != "!padrenullqueryAZ">for <strong><@s.QueryClean /></strong></#if>
    </#if>
    <#if response.resultPacket.resultsSummary.totalMatching != 0>
    <span id="search-page-start">${response.resultPacket.resultsSummary.currStart}</span> -
    <span id="search-page-end">${response.resultPacket.resultsSummary.currEnd}</span> of
    <span id="search-total-matching">${response.resultPacket.resultsSummary.totalMatching?string.number}</span>
    <#if question.inputParameterMap["s"]?? && question.inputParameterMap["s"]?contains("?:")><em>collapsed</em> </#if>search results <#if response.resultPacket.query != "!padrenullqueryAZ">for <strong><@s.QueryClean></@s.QueryClean></strong></#if>
    </#if>
    <#if (response.resultPacket.resultsSummary.partiallyMatching!0) != 0>
    where <span id="search-fully-matching">${response.resultPacket.resultsSummary.fullyMatching?string.number}</span>
    match all words and <span id="search-partially-matching">${response.resultPacket.resultsSummary.partiallyMatching?string.number}</span>
    match some words.
    </#if>
    <#if (response.resultPacket.resultsSummary.collapsed!0) != 0>
    <span id="search-collapsed">${response.resultPacket.resultsSummary.collapsed}</span>
    very similar results included.
    </#if>
    <@sortDropdown />
  </div>
</#macro>

<#-- 
    Displays the facet breadcrumb as list. Provides a means for the user
    to unselect facet values
-->
<#macro BreadCrumbSearch>
	<#if ((question.selectedFacets)!?has_content && ((question.selectedFacets?size &gt; 1 && question.selectedFacets?seq_contains("LNInitial")) || (question.selectedFacets?size &gt; 0 && (question.inputParameterMap["letter"]?? && question.inputParameterMap["letter"] == "all"))))>
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

</#escape>