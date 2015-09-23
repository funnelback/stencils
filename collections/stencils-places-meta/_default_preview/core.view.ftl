<#ftl encoding="utf-8" />
<#--
   Stencil: Core  (Social variation)
   By: Robert Prib
   Description: Views Core specific components.
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Stencils which are to be included -->
<#assign stencils = ["base","places"] />

<#-- Include Project files -->
<#import "project.view.ftl" as project_view />
<#import "project.controller.ftl" as project_controller />

<#-- 
  The following code imports and assigns stencil namespaces automatically eg. core_view and core_controller.
  The code expects that the controller files are located under $SEARCH_HOME/web/templates/modernui/stencils-libraries/
  and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/

  Note: The full path has been added to ensure that the correct folder is being picked up  
-->
<#list stencils as stencil>
  <#assign controller = "/web/templates/modernui/stencils-libraries/${stencil}.controller.ftl" stencilNamespaceController="${stencil?lower_case}_controller" />
  <#assign view ="/conf/${question.collection.id}/${question.profile}/${stencil}.view.ftl" stencilNamespaceView="${stencil?lower_case}_view" />  
  <@'<#import controller as ${stencilNamespaceController}>'?interpret />
  <@'<#import view as ${stencilNamespaceView}>'?interpret />
</#list>

<#-- 
  If for any reason you need to modify a controller (not recommended as it will no longer be upgraded as part of the stencils release cycle), you can remove the stencil from the stencils array, take a copy of the controller and move it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/. You will then need to import it using the following:

  <#import "<stencil name>.controller.ftl" as <stencil name>_controller>
  <#import "<stencil name>.view.ftl" as <stencil name>_view>

  e.g. If you are using the core and base stencil but you want to override the base.controller.ftl

  You will need to:
  - Copy base.controller.ftl from  $SEARCH_HOME/web/templates/modernui/stencils-libraries/ and store it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
  - Change 'stencils = ["core", "base"]' to 'stencils = ["core"]'
  - Add '<#import "base.controller.ftl" as base_controller>' to the top of your file
  - Add '<#import "base.view.ftl" as base_view>' to the top of your file
--> 

<#-- Import the main macros used to put together this app -->
<#import "/web/templates/modernui/stencils-libraries/core.controller.ftl" as core_controller/>

<#--
  Results Wrapper
-->
<#macro Results>

  <div style="margin-bottom:0.5em">
        <@base_view.ResultsDisplaySelectbox />
        <@base_view.ResultsPerPageSelectbox />

        <#-- Display: Grid or Masonry -->
        <@base_controller.IfDefCGIEquals name="display" value="grid|masonry"  >
          <@base_view.ResultsGroupPerSelectbox />
        </@base_controller.IfDefCGIEquals>
        <@base_view.ResultsSortBySelectbox />
  </div>


    <ol id="search-results" class="list-unstyled" start="${response.resultPacket.resultsSummary.currStart}"  <@base_controller.IfDefCGIEquals name="display" value="masonry">data-masonry</@base_controller.IfDefCGIEquals>>
    <@s.Results>
      <#if s.result.class.simpleName == "TierBar">
        <#-- A tier bar -->
        <#if s.result.matched != s.result.outOf>
          <li class="search-tier"><h3 class="text-muted">Results that match ${s.result.matched} of ${s.result.outOf} words</h3></li>
        <#else>
          <li class="search-tier"><h3 class="hidden">Fully-matching results</h3></li>
        </#if>
        <#-- Print event tier bars if they exist -->
        <#if s.result.eventDate??>
          <h2 class="fb-title">Events on ${s.result.eventDate?date}</h2>
        </#if>
      <#else>
        
         <@project_view.ResultViewRouter />
        
      </#if>
    </@s.Results>
    </ol>
 
</#macro>

<#macro NavBar>
  <nav class="navbar navbar-default row" role="navigation" style="margin:0;padding: 0 15px;background: #fff;box-shadow: 0px 0px 4px #888;z-index:99;max-height:19%;overflow:auto;">
  <@fb.ViewModeBanner />
    <h1 class="sr-only">Search</h1>
    <div id="search-branding" class="col-xs-5 col-sm col-md-4  col-lg-3 clearfix">

    <button data-target=".bs-navbar-collapse" data-toggle="collapse" type="button" class="navbar-toggle collapsed">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>

    <a class="brand-wrapper" href="#"><img src="${SearchPrefix}stencils-resources/base/images/funnelback-logo-small-v2.png" alt="Funnelback" style="height:20px; margin-top:15px"></a></div>
    <div class="col-xs-7 col-md-3 pull-right">
      <div class="btn-group btn-group-sm pull-right" style="margin-top:10px">
        <a href="#search-advanced" class="btn btn-default" data-toggle="collapse" title="Advanced search"><span class="glyphicon glyphicon-cog"></span> <span class="visible-md-inline visible-lg-inline">Advanced Search</span></a>
        
        <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
        <a href="#" class="btn btn-default" data-ng-class="{active: isDisplayed('history')}" data-ng-click="toggleHistory()" title="Search History"><span class="glyphicon glyphicon-time"></span></a>
        </#if>
        <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
        <a href="#" class="btn btn-default" data-ng-class="{active: isDisplayed('cart')}" data-ng-click="toggleCart()" title="{{cart.length}} item(s) in your selection"><span class="glyphicon glyphicon-shopping-cart"></span> <span class="badge" data-ng-cloak>{{cart.length}}</ng-pluralize --></span></a>
        </#if>
        
        <div class="btn-group btn-group-sm dropdown pull-right">
          <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
          <span class="glyphicon glyphicon-question-sign"></span>
          </button>
          <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
            <li role="presentation"><a role="menuitem" tabindex="-1" href="${SearchPrefix}help/simple_search.html" title="Search help">Help</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" data-toggle="modal" href="#search-performance" title="Performance report">Performance</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" data-toggle="modal" href="#search-syntaxtree" title="Query syntax tree">Query syntax tree</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div id="search-form-query" class="col-xs-12 col-md-5">
      <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="search" style="margin-top:8px;">
        <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
        <@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="lang"><input type="hidden" name="lang" value="${question.inputParameterMap["lang"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@s.IfDefCGI>
        <div class="input-group" style="margin-bottom:5px">
          <input required name="query" id="query" title="Search query" type="text" value="${question.inputParameterMap["query"]!}" accesskey="q" placeholder="Search <@s.cfg>service_name</@s.cfg>&hellip;" class="form-control query" data-ng-disabled="isDisplayed('cart') || isDisplayed('history')" style="width:100%;">
          <span class="input-group-btn">
          <button type="submit" class="btn btn-primary" data-ng-disabled="isDisplayed('cart') || isDisplayed('history')" style="white-space:nowrap;"><span class="glyphicon glyphicon-search"></span> <span class="visible-sm-inline visible-md-inline visible-lg-inline">Search</span></button></span>
        </div>
        <div class="input-inline">
          <@s.FacetScope> <small>Within selected categories only</small></@s.FacetScope>
        </div>
      </form>
    </div>
  </nav>
</#macro>


<#macro Facets name="" names=[] class="facet">
  <@s.FacetedSearch>
    <div class="hidden-print col-md-10 col-md-offset-1" id="search-facets" style="display:none">
      <h2 class="sr-only">Refine</h2>
      <@s.Facet name=name names=names class=class>
        <div class="panel panel-default">
          <div class="panel-heading"><@s.FacetLabel tag="h3"/></div>
          <div class="panel-body">
            <ul class="list-unstyled">
              <@s.Category tag="li">
                <@project_view.CategoryIcon name=s.categoryValue.label?html /> <@s.CategoryName class="" />&nbsp;<span class="badge pull-right"><@s.CategoryCount /></span>
              </@s.Category>
            </ul>
            <button type="button" class="btn btn-link btn-sm search-toggle-more-categories" style="display: none;" data-more="More&hellip;" data-less="Less&hellip;" data-state="more" title="Show more categories from this facet"><small class="glyphicon glyphicon-plus"></small>&nbsp;<span>More&hellip;</span></button>
          </div>
        </div>
      </@s.Facet>
    </div>
  </@s.FacetedSearch>
</#macro>

</#escape>

