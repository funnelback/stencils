<#ftl encoding="utf-8" />
<#--
   Stencil: Core
   By: Gioan Tran
   Description: A sample stencil which simply provides the basic out of the box functionality derived
    from the simple.ftl that is shipped with the product.
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
<#assign stencils = ["core", "base", "places"] />

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

<#assign layoutType = 'fluid' largeLogoImg ="${SearchPrefix}stencils-resources/base/images/funnelback-logo-small-v2.png">

<#-- Alter column width for map result list when grid or masonry view is selected and when grouping is higher -->
<#assign colWidth = 3>
<@base_controller.IfDefCGIEquals name="display" value="grid||masonry">
  <#assign groupSize><@base_controller.GetCGIValue name="groupSize" default="2" /></#assign>
  <#if groupSize?number gt 2>
   <#assign colWidth = 8>
  <#else>
    <#assign colWidth = 6>
  </#if>
</@base_controller.IfDefCGIEquals>

<!DOCTYPE html>
<html lang="en-us">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="nofollow">
    <!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->
    <title><@s.AfterSearchOnly>${question.inputParameterMap["query"]!}<@s.IfDefCGI name="query">,&nbsp;</@s.IfDefCGI></@s.AfterSearchOnly><@s.cfg>service_name</@s.cfg> -  Funnelback Search</title>
    <@s.OpenSearch />
    <@s.AfterSearchOnly><link rel="alternate" type="application/rss+xml" title="Search results for ${question.inputParameterMap["query"]!}<@s.IfDefCGI name="query">,&nbsp;</@s.IfDefCGI><@s.cfg>service_name</@s.cfg>" href="?collection=<@s.cfg>collection</@s.cfg>&amp;query=${question.inputParameterMap["query"]!?url}&amp;form=rss&amp;sort=date"></@s.AfterSearchOnly>
   
    <!--[if lt IE 9]>
    <script src="${SearchPrefix}thirdparty/html5shiv.js"></script>
    <script src="${SearchPrefix}thirdparty/respond.min.js"></script>
    <![endif]-->

    <#--Load stencil default CSS files-->
    <#list stencils as stencil>
      <#assign script = "<@" + stencil?lower_case + "_controller.CSS />" >
      <@script?interpret />
    </#list>
    
    <@project_controller.CSS />
    
  </head>
  <body id="funnelback-search" class="container<#if layoutType?? && layoutType != ''>-${layoutType}</#if> "<#if question.collection.configuration.valueAsBoolean("ui.modern.session")> data-ng-app="Funnelback" data-ng-controller="DefaultCtrl" </#if> data-ng-show="isDisplayed('results')">
    
    
    
    
    
    <@s.InitialFormOnly>
      <@fb.ViewModeBanner />
      <@core_controller.InitialSearchForm image=largeLogoImg />
    </@s.InitialFormOnly>


    <@s.AfterSearchOnly>

        <@core_view.NavBar />


        <@core_controller.AdvancedForm />

        <section id="search-main">
          
          <div id="search-maps-side" class="col-sm-12 col-lg-${colWidth?string} collapse in">
            <div style="text-align:center;margin:0 0 0.5em">
                <button type="button" class="btn btn-primary" data-toggle="button" data-button-show="#search-facets,#btn-hide-facets" data-button-hide="#map-results-list,#btn-show-facets"  id="btn-show-facets">Show filters</button>

              <button type="button" class="btn btn-primary" data-toggle="button" data-button-hide="#search-facets,#btn-hide-facets" data-button-show="#map-results-list,#btn-show-facets"  id="btn-hide-facets" style="display:none">Hide filters</button>
            </div>
              

            <@core_view.Facets />

            <div id="map-results-list" data-stencils-mapresultlist data-stencils-mapid="map">
              <@base_view.BreadCrumb />
              <@core_controller.Count />
              <@core_view.Results/>
              <@core_controller.QueryHistory />
              <@core_controller.SearchHistory />
              <@core_controller.Scope />
              <@core_controller.Blending />
              <@core_controller.CuratorExhibits />
              <@core_controller.Spelling />
              <@core_controller.NoResultSummary />
              <@core_controller.EntityDefinition />            
              <@core_controller.CuratorExhibitsList />
              <@core_controller.BestBets />
              <@core_controller.Pagination />
              <@core_controller.ContextualNavigation />
              <@core_controller.Cart />
              <@core_controller.Tools />
            </div>
            <!-- Close map list -->

          </div>

          <div id="search-content" data-stencils-map data-stencils-mapdataurl="<@places_controller.GetMapDataURL />" data-stencils-mapid="map" class="col-lg-${(12-colWidth)?string} col-sm-12" data-stencils-map-defaulttile="googleRoadmap">
            <#if places_view.MapMarkerPopup??><@places_view.MapMarkerPopup mapId="map" /></#if>
            <div id="mapsMapView" style="height:100%;">
              <div id="mapResults" data-mapdiv></div>
            </div>
          </div>


        </section>
        
    </@s.AfterSearchOnly>
    
 

    <@core_controller.Footer />
    <#-- Javascript-->
    <@core_controller.jsDefault />

    <#-- Funnelback Javascript Options -->
    <script>
      jQuery(document).ready( function() {
        // Query completion setup.
        jQuery("input.query").fbcompletion({
          'enabled'    : '<@s.cfg>query_completion</@s.cfg>',
          'standardCompletionEnabled': <@s.cfg>query_completion.standard.enabled</@s.cfg>,
          'collection' : '<@s.cfg>collection</@s.cfg>',
          'program'    : '${SearchPrefix}<@s.cfg>query_completion.program</@s.cfg>',
          'format'     : '<@s.cfg>query_completion.format</@s.cfg>',
          'alpha'      : '<@s.cfg>query_completion.alpha</@s.cfg>',
          'show'       : '<@s.cfg>query_completion.show</@s.cfg>',
          'sort'       : '<@s.cfg>query_completion.sort</@s.cfg>',
          'length'     : '<@s.cfg>query_completion.length</@s.cfg>',
          'delay'      : '<@s.cfg>query_completion.delay</@s.cfg>',
          'profile'    : '${question.inputParameterMap["profile"]!}',
          'query'      : '${QueryString}',
          //Search based completion
          'searchBasedCompletionEnabled': <@s.cfg>query_completion.search.enabled</@s.cfg>,
          'searchBasedCompletionProgram': '${SearchPrefix}<@s.cfg>query_completion.search.program</@s.cfg>',
        });
      });
    </script>

    <#--Load stencil default JS files-->
    <#list stencils as stencil>
      <#assign script = "<@" + stencil?lower_case + "_controller.JS />" >
      <@script?interpret />
    </#list>

    <@project_controller.JS />

  </body>
</html>

</#escape>