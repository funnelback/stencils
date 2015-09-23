<#ftl encoding="utf-8" />
<#--
   Stencil: Project (Default for Places)
   By: Robert Prib
   Description: Project specific views.
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

<#-- 
  The following code imports and assigns stencil namespaces automatically eg. core and core_view.
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
<#import "project.view.ftl" as project_view />
<#import "project.controller.ftl" as project_controller />

<#-- 
  The following functions are generic layout code which can be copied and customised
  to suit individual implementations.

  Note: Before the tab layout can be used, you must enable the full facet list by addition the following to collection.cfg
  
  ui.modern.full_facets_list=true
  
  It is also best practice to hide the facet group which has been used to populate the tabs from the list of available facets
--->

<#--
  Result View Router

  @author Robert Prib
  @desc Buisiness Logic for routing to different 'display' views.
-->
<#macro ResultViewRouter>
  
  <#local groupSize><@base_controller.GetCGIValue name="groupSize" default="2" /></#local>

  <#-- Display: List  -->
  <@base_controller.IfDefCGIEquals name="display" value="list" trueIfEmpty=true> 
      <li data-fb-result=${s.result.indexUrl}>
        <@ResultStyleRouter />
      </li>
  </@base_controller.IfDefCGIEquals>
  
  <#-- Display: Grid  -->
  <@base_controller.IfDefCGIEquals name="display" value="grid"  >
    <#local columnOpen><li class="row"><ol class="list-unstyled"></#local>
    <#local columnClose></ol></li></#local>
    <@base_controller.GroupResults groupSize=groupSize?number open=columnOpen close=columnClose>
      <li data-fb-result=${s.result.indexUrl} class="col-md-${(12/groupSize?number)?floor}">
        <@ResultStyleRouter />
      </li>
    </@base_controller.GroupResults>
  </@base_controller.IfDefCGIEquals>
  
  <#-- Display: Masonry  -->
  <@base_controller.IfDefCGIEquals name="display" value="masonry"  >
    <li data-fb-result=${s.result.indexUrl} class="  col-md-${(12/groupSize?number)?floor}" data-masonry-item>
      <@ResultStyleRouter />
    </li>
  </@base_controller.IfDefCGIEquals>

</#macro>

<#--
  Result Collection Router

  @author Robert Prib
  @desc Buisiness Logic for routing to different collection views.
  @requirements Requires setting up a metadata result attribute that defines the owning collection name of the result. Named as "collection".
-->
<#macro ResultCollectionRouter>
  

   <#-- Collection: stencils-facebook-custom -->
    <@base_controller.ResultIsCollection name=".." >
      <#-- E.g. route to <@FacebookResultStyleRouter /> -->
    </@base_controller.ResultIsCollection>

</#macro>

<#-- Result Style Routers 
  Business Logic for routing result to different 'style' views.

  Template
  <#macro <STYLE_ROUTER_NAME>ResultStyleRouter>
    <@base_controller.IfDefCGIEquals name="resultStyle" value="<STYLE_ROUTE_NAME>" trueIfEmpty=<STYLE_ROUTE_IS_DEFAULT> > 
      ... <REFERENCE_TO_STYLE_VIEW_TO_PRINT> ...
    </@base_controller.IfDefCGIEquals>
  </#macro>
-->

<#-- 
  Result Style Router

  @author Robert Prib
  @desc Business Logic for routing result to different 'style' views.
 -->
<#macro ResultStyleRouter>
  
  <#-- Style: Basic -->
  <@base_controller.IfDefCGIEquals name="commonResultStyle" value="basic" trueIfEmpty=true> 
    <@ResultBasic />
  </@base_controller.IfDefCGIEquals>

  <#-- Style: Card-->
  <@base_controller.IfDefCGIEquals name="commonResultStyle" value="card" > 
    <@ResultCard />
  </@base_controller.IfDefCGIEquals>
  
</#macro>

<#-- 
  Result Style: Basic 
 -->
<#macro ResultBasic>
<div class="panel panel-default">

  <div data-stencils-mapresultlink data-stencils-mapresultlink-zoom='10' data-stencils-mapid="map" data-stencils-markerid="${s.result.displayUrl}" class="panel-heading map-heading" title="Show ${s.result.title} on map">
    <h4 class="media-heading">
      <i class="fa fa-location-arrow active-show"></i>
      <i class="fa fa-map-marker active-hide"></i>
      <@s.boldicize><@s.Truncate length=70>${s.result.title}</@s.Truncate></@s.boldicize>
    </h4>
  </div>   

    <div class="panel-body">
      <@s.Quicklinks>
        <ul class="list-inline">
            <@s.QuickRepeat><li><a href="${s.ql.url}" title="${s.ql.text}">${s.ql.text}</a></li></@s.QuickRepeat>
        </ul>
        <#if question.collection.quickLinksConfiguration["quicklinks.domain_searchbox"]?? && question.collection.quickLinksConfiguration["quicklinks.domain_searchbox"] == "true">
          <#if s.result.quickLinks.domain?matches("^[^/]*/?[^/]*$", "r")>
            <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="search">
                <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
                <input type="hidden" name="meta_u_sand" value="${s.result.quickLinks.domain}">
                <@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@s.IfDefCGI>
                <@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@s.IfDefCGI>
                <@s.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@s.IfDefCGI>
                <@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@s.IfDefCGI>
                <div class="row">
                  <div class="col-md-4">
                  <div class="input-group input-sm">
                    <input required title="Search query" name="query" type="text" class="form-control" placeholder="Search ${s.result.quickLinks.domain}&hellip;">
                    <div class="input-group-btn">
                      <button type="submit" class="btn btn-info"><span class="glyphicon glyphicon-search"></span></button>
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </#if>
        </#if>
      </@s.Quicklinks>
        
      <address class="list-group-item-text">
        <strong><@CategoryIcon />${s.result.metaData.officeType}</strong><br>
        <small class="text-muted">${s.result.metaData.address} ${s.result.metaData.suburb}, ${s.result.metaData.state} <#if s.result.metaData.postcode??>${s.result.metaData.postcode}</#if></small>
      </address>

     <button type="button" class="btn btn-default pull-right" data-stencils-mapresultlink data-stencils-mapresultlink-zoom='10' data-stencils-mapid="map" data-stencils-markerid="${s.result.displayUrl}" class="panel-heading map-heading" title="Show ${s.result.title} on map"> 
        <small class="text-muted" ><i class="fa fa-location-arrow active-show"></i>
        <i class="fa fa-map-marker active-hide"></i> Show on map
      </small>
    </button>
     
      <#if s.result.summary??>
        <p class="list-group-item-text">${s.result.summary}</p>
      </#if>

      <#if s.result.metaData["c"]??><p class="list-group-item-text"><@s.boldicize>${s.result.metaData["c"]!}</@s.boldicize></p></#if>

      <#if s.result.collapsed??>
        <div class="search-collapsed"><small><span class="glyphicon glyphicon-expand text-muted"></span>&nbsp; <@fb.Collapsed /></small></div>
      </#if>

      <#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(s.result.indexUrl)??><small class="text-warning"><span class="glyphicon glyphicon-time"></span> <a title="Click history" href="#" class="text-warning" data-ng-click="toggleHistory()">Last visited ${prettyTime(session.getClickHistory(s.result.indexUrl).clickDate)}</a></small></#if>
  </div>
  <div class="panel-footer">
      <div class="btn-group">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown" title="More actions&hellip;"><small class="glyphicon glyphicon-chevron-down text-success"></small></a>
        <ul class="dropdown-menu">
          <li><#if s.result.cacheUrl??><a href="${s.result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="Cached version of ${s.result.title} (${s.result.rank})">Cached</a></#if></li>
          <li><@s.Explore /></li>
          <@fb.AdminUIOnly><li><@fb.Optimise /></li></@fb.AdminUIOnly>
        </ul>
      </div>

      <#if question.collection.configuration.valueAsBoolean("ui.modern.session")><a href="#" data-ng-click="toggle()" data-cart-link data-css="pushpin|remove" title="{{label}}"><small class="glyphicon glyphicon-{{css}}"></small></a></#if>
  </div>
</div>
</#macro>
<#-- /ResultBasic -->


<#macro CategoryIcon name=s.result.metaData.officeType?trim?lower_case>
  <#switch  name>
    <#case "agent">
      <i class="fa fa-male"></i>
      <#break>
    <#case "centrelink customer service centre">
      <i class="fa fa-building"></i>
      <#break>
    <#case "medicare">
      <i class="fa fa-university"></i>
      <#break>
    <#case "access point">
      <i class="fa fa-info-circle"></i>
      <#break>
  </#switch>
</#macro>


</#escape>

