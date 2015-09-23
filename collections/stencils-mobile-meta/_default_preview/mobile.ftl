<#ftl encoding="utf-8" />

<#--
   Funnelback App: Core
   By: <Name>
   Description: <Description>
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->


<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import the main macros used to put together this app -->
<#import "mobile.default.ftl" as app/>


<#escape x as x?html>


<#macro layoutHelloWorld>
        <h1>Hello world, I'm from the demo app.</h1>
</#macro>

<#macro layoutDemoWell title="No title set!" buttonText="Awseome">
<div id="intro" class="intro well well-sm">
  <h2>${title}</h2> 
  <a class="btn btn-danger">${buttonText}</a>
</div>    
</#macro>
<#macro NavButton>
  <button type="button" class="navbar-toggle"><a href="#mmenu" class="glyphicon glyphicon-th-list"></a></button> 
</#macro>



<#macro NavMenu >
<nav id="mmenu">
  <ul>
    <@Facets />
    <@SelectedCategories />
    <@ContextualNavigation items />
  </ul>
</nav>
</#macro>


<#macro Facet name="" names=[] class="facet">
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


<#macro CategoryName class="categoryName">
    <#if s.categoryValue?exists>
        <#assign paramName = s.categoryValue.queryStringParam?split("=")[0]>
            <a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(facetScopeRemove(QueryString, paramName), ["start_rank", paramName])?html}&amp;${s.categoryValue.queryStringParam?html}">${s.categoryValue.label}</a>
    </#if>
</#macro>

<#macro Spacer>
  <li class="Label Spacer"><#nested></li>
</#macro>

<#macro Toggler>
<li><span><#nested></span><input type="checkbox" class="Toggle" /></li>
</#macro>

<#macro SelectedCategories> 
<@Spacer>Search within selected categories</@Spacer>
<@Toggler>Selected Categories</@Toggler>
<@Spacer>Sort By</@Spacer>
<li>
  <span class="form-group mm-search">    
      <@s.Select id="sort" name="sort" class="form-control" options=["=Relevance ", "date=Date (Newest first)", "adate=Date (Oldest first)", "title=Title (A-Z)", "dtitle=Title (Z-A)", "prox=Distance" "url=URL (A-Z)", "durl=URL (Z-A)", "shuffle=Shuffle"] />
  </span>  
</li>
</#macro>



<#macro Facets>
<@Spacer>Filter By:</@Spacer>
  <@s.FacetedSearch>
      <@Facet>
        <li><@s.FacetLabel tag="a"/>
            <ul>
              <@s.Category tag="li">
                <@CategoryName class="" />
              </@s.Category>
            </ul>
        </li>
      </@Facet>
  </@s.FacetedSearch>
</#macro>


<#macro ContextualNavigation items=["type","topic","site"]>
<@s.ClusterNavLayout />
<@s.NoClustersFound />
<@s.ClusterLayout>
<!--   <li><a>Related searches for <strong><@s.QueryClean /></strong></a> -->
  <@Spacer>Related searches for <strong><@s.QueryClean /></strong></@Spacer>
    <#list items as item>
    <@s.Category name="${item}">
      <li><a>${item}</a>
        <ul class="">
         <@s.Clusters>
            <li><a href="${s.cluster.href}"> <#noescape>${s.cluster.label?html?replace("...", " <strong>"+s.contextualNavigation.searchTerm?html+"</strong> ")}</#noescape></a></li>
          </@s.Clusters>
        </ul>
      </li>
    </@s.Category>      
    </#list>
  </li>
</@s.ClusterLayout>
</#macro>

</#escape>

