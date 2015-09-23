<#ftl encoding="utf-8" />
<#--
   Funnelback Stencil: Maps
   By: Pete
   Description: Display Maps for Funnelback Search
   Last Edited by: Steve Chan. Done: Re-assembled everything to become a map stencil.
-->

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>
<#escape x as x?html>

  <#macro layoutMapTabs defaultView="">
  <div id="layoutMapTabs" role="tabpanelSearchView">

   <#assign defaultView = 'map' />
  <!-- Search Tab Navigation -->
  <ul class="nav nav-tabs" role="tablist">
    <li role="searchview" class=""><a href="#mapsListView" aria-controls="listview" role="tab" data-toggle="tab">List View</a></li>
    <li role="searchview" class="active"><a href="#mapsMapView" aria-controls="mapview" role="tab" data-toggle="tab">Map View</a></li>
  </ul>

  <!-- Search Tab Panels -->
  <div class="tab-content">
    <div role="searchview_tabpanel" class="tab-pane active" id="mapsMapView"><@layoutMapContainer /></div>
    <div role="searchview_tabpanel" class="tab-pane" id="mapsListView">



      
        <@core.Count />
        <@maps.results/>
        <@core.SearchHistory />
        <@core.Scopes />

        <@core.Blending />
        <@core.CuratorExhibits />
        <@core.Spelling />
        <@core.Summary />
        <@core.EntityDefinition />
        <@core.CuratorExhibitsList />
        <@core.BestBets />
        <@core.Pagination />
        <@core.ContextualNavigation />


    </div>
  </div>

</div>


  </#macro>




  <#macro layoutMapContainer>
  <div id="mapResults"></div>

  <!--Add in Maps Default Resources -->
  </#macro>

  <#macro results>

    <ol id="search-results" class="list-unstyled " start="${response.resultPacket.resultsSummary.currStart}">
    <@s.Results>
    <#if s.result.class.simpleName == "TierBar">
    <#-- A tier bar -->
    <#if s.result.matched != s.result.outOf>
    <li class="search-tier"><h3>Results that match ${s.result.matched} of ${s.result.outOf} words</h3></li>
    <#else>
    <li class="search-tier"><h3 class="hidden">Fully-matching results</h3></li>
    </#if>
    <#-- Print event tier bars if they exist -->
    <#if s.result.eventDate??>
    <h2 class="fb-title">Events on ${s.result.eventDate?date}</h2>
    </#if>
    <#else>
    <li data-fb-result="${s.result.indexUrl}">
      <h4>
      <#if question.collection.configuration.valueAsBoolean("ui.modern.session")><a href="#" data-latlon="${s.result.metaData.x}" data-ng-click="toggle()" data-cart-link data-css="pushpin|remove" title="{{label}}"><small class="glyphicon glyphicon-{{css}}"></small></a></#if>
      <a data-latlon="${s.result.metaData.x}" href="${s.result.clickTrackingUrl}" title="${s.result.liveUrl}">
        <@s.boldicize><@s.Truncate length=70>${s.result.title}</@s.Truncate></@s.boldicize>
      </a>
      <#if s.result.fileType!?matches("(doc|docx|ppt|pptx|rtf|xls|xlsx|xlsm|pdf)", "r")>
      <small class="text-muted">${s.result.fileType?upper_case} (${filesize(s.result.fileSize!0)})</small>
      </#if>
      <#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(s.result.indexUrl)??><small class="text-warning"><span class="glyphicon glyphicon-time"></span> <a title="Click history" href="#" class="text-warning" data-ng-click="toggleHistory()">Last visited ${prettyTime(session.getClickHistory(s.result.indexUrl).clickDate)}</a></small></#if>
      </h4>
      <cite data-url="${s.result.displayUrl}" class="text-success"><@s.cut cut="http://"><@s.boldicize>${s.result.displayUrl}</@s.boldicize></@s.cut></cite>
      <div class="btn-group">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown" title="More actions&hellip;"><small class="glyphicon glyphicon-chevron-down text-success"></small></a>
        <ul class="dropdown-menu">
          <li><#if s.result.cacheUrl??><a href="${s.result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="Cached version of ${s.result.title} (${s.result.rank})">Cached</a></#if></li>
          <li><@s.Explore /></li>
          <@fb.AdminUIOnly><li><@fb.Optimise /></li></@fb.AdminUIOnly>
        </ul>
      </div>
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
      <#if s.result.summary??>
      <p>
      <#if s.result.date??><small class="text-muted">${s.result.date?date?string("d MMM yyyy")}:</small></#if>
      <span class="search-summary"><@s.boldicize>${s.result.summary}</@s.boldicize></span>
      </p>
      </#if>
      <#if s.result.metaData["c"]??><p><@s.boldicize>${s.result.metaData["c"]!}</@s.boldicize></p></#if>
      <#if s.result.collapsed??>
      <div class="search-collapsed"><small><span class="glyphicon glyphicon-expand text-muted"></span>&nbsp; <@fb.Collapsed /></small></div>
      </#if>
      <#if s.result.metaData["a"]?? || s.result.metaData["s"]?? || s.result.metaData["p"]??>
      <dl class="dl-horizontal text-muted">
        <#if s.result.metaData["a"]??><dt>by</dt><dd>${s.result.metaData["a"]!?replace("|", ", ")}</dd></#if>
        <#if s.result.metaData["s"]??><dt>Keywords:</dt><dd>${s.result.metaData["s"]!?replace("|", ", ")}</dd></#if>
        <#if s.result.metaData["p"]??><dt>Publisher:</dt><dd>${s.result.metaData["p"]!?replace("|", ", ")}</dd></#if>
      </dl>
      </#if>
    </li>
    </#if>
    </@s.Results>
  </ol>
  </#macro> 

  <#macro NavBar class="">
  <nav class="navbar navbar-default row ${class}" role="navigation" style="padding-bottom: 6px;">
    <h1 class="sr-only">Search</h1>
    <div id="search-branding" class="col-xs-5 col-sm col-md-4  col-lg-3 clearfix">

    <button data-target=".bs-navbar-collapse" data-toggle="collapse" type="button" class="navbar-toggle collapsed">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>

    <a class="brand-wrapper" href="#"><img src="${SearchPrefix}images/funnelback-logo-small-v2.png" alt="Funnelback" style="height:20px; margin-top:15px"></a></div>
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
          <span class="caret hidden-xs"></span>
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
          <input required name="query" id="query" title="Search query" type="text" value="${question.inputParameterMap["query"]!}" accesskey="q" placeholder="Search <@s.cfg>service_name</@s.cfg>&hellip;" class="form-control query" data-ng-disabled="isDisplayed('cart') || isDisplayed('history')">
          <span class="input-group-btn">
          <button type="submit" class="btn btn-primary" data-ng-disabled="isDisplayed('cart') || isDisplayed('history')"><span class="glyphicon glyphicon-search"></span> <span class="visible-sm-inline visible-md-inline visible-lg-inline">Search</span></button></span>
        </div>
        <div class="input-inline">
          <@s.FacetScope> <small>Within selected categories only</small></@s.FacetScope>
        </div>
      </form>
    </div>
  </nav>
</#macro>

  <#macro scripts>
        <!--Import Maps Maps Resources -->
        <#import "/conf/stencils-places-web/funnelback_mapping.ftl" as map/>
        <@map.MapResources/> 

        <script>
        jQuery(document).ready(function(){

          jQuery('.search-geolocation').click( function() {
            try {
              navigator.geolocation.getCurrentPosition( function(position) {
                // Success
                var latitude  = Math.ceil(position.coords.latitude*10000) / 10000;
                var longitude = Math.ceil(position.coords.longitude*10000) / 10000;
                var origin = latitude+','+longitude;
                jQuery('#origin').val(origin);
              }, function (error) {
                // Error
              }, { enableHighAccuracy: true });
            } catch (e) {
              alert('Your web browser doesn\'t support this feature');
            }
          });
        });
        </script>


  </#macro> 

</#escape>