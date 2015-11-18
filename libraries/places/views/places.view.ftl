
<#ftl encoding="utf-8" />
<#---
	 <p>Provides views for places components.</p>
	 <p>These compontents include items such as ...</p>
	 <p>...</p>

	 <h2>Table of Contents</h2>
	 <ul>
		 <li><strong>Configuration:</strong> Configuration options.</li>
		 <li><strong>Result place: Views for place type results.</strong></li>
	 </ul>
-->
<#escape x as x?html>

<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign placesResourcesPrefix = "/stencils/resources/places/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${librariesPrefix}places/controllers/places.controller.ftl" as places_controller/>

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core","base","collapsedresult"] />
	<#--
		The following code imports and assigns stencil namespaces automatically eg. core_view and core_controller.
		The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/
		and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
	-->
<@stencils_utilities.ImportStencils stencils=stencils>
	<@stencils_utilities.imports?interpret />
</@stencils_utilities.ImportStencils>

<#---
	Stylesheet dependencies
 -->
<#macro CSS>
	<!-- places.view.ftl :: CSS -->
  <link rel="stylesheet" href="${placesResourcesPrefix}css/places.css" />

	<link rel="stylesheet" href="${thirdPartyResourcesPrefix}leafletjs/0.7.7/leaflet.css" />

  <#-- <link rel="stylesheet" href="${thirdPartyResourcesPrefix}leaflet/leaflet.css" />
  <link rel="stylesheet" href="${thirdPartyResourcesPrefix}leaflet/MarkerCluster.css" />
  <link rel="stylesheet" href="${thirdPartyResourcesPrefix}leaflet/MarkerCluster.Default.css" /> -->
</#macro>

<#---
	JavaScript dependencies
 -->
<#macro JS>
	<!-- places.view.ftl :: JS -->
		<script src="${thirdPartyResourcesPrefix}angularjs/1.4.7/angular.min.js"></script>


  <!-- Javascript required for maps -->
	<script src="${thirdPartyResourcesPrefix}leafletjs/0.7.7/leaflet.js"></script>

  <#-- <script src="${thirdPartyResourcesPrefix}leaflet/leaflet.js"></script>
  <script src="${thirdPartyResourcesPrefix}leaflet/leaflet.markercluster.js"></script>
  <script src="${thirdPartyResourcesPrefix}leaflet/leaflet.spin.js"></script> -->

  <#-- Only required if using google tileservice -->
  <script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
  <script src="${thirdPartyResourcesPrefix}gmaps/Google.js"></script>

  <#-- <script src="${placesResourcesPrefix}js/places.js"></script> -->
</#macro>
<#-- @end --><#-- /Configuration -->
<#-- ###################  Views ####################### -->

<#macro Map colWidth>

  <div id="search-content" data-stencils-map data-stencils-mapdataurl="<@places_controller.GetMapDataURL />" data-stencils-mapid="map" class="col-lg-${colWidth!} col-sm-12" >

		<@MapMarkerPopup mapId="map" />
    <@MapMarker mapId="map"  />
    <@MapControlLocate mapId="map"  />
    <@MapControlSearchOnMove mapId="map"  />
    <div id="mapsMapView" style="height:100%;">
      <div id="mapResults" data-mapdiv></div>
			<leaflet width="100%" height="480px"></leaflet>
    </div>
  </div>

</#macro>

<#macro MapMarkerPopup2 mapId="map">
<script>
jQuery(function(){
  stencils.module.places.overridePlacesMap("${mapId}", "viewMarkerPopup",
    function popup(feature){
      function categoryIcon(name){
        switch(name.toLowerCase()){
          case "agent":
          return '<i class="fa fa-male"></i>';
          break;
          case "centrelink customer service centre" :
          return '<i class="fa fa-building"></i>';
          break
        case "medicare":
          return '<i class="fa fa-university"></i>';
          break
        case "access point":
          return '<i class="fa fa-info-circle"></i>';
          break
        }
      }

      //check if value is undefined and returns as empty string
      function cn(x){ return (typeof x == "undefined") ? "" : x ; }

      var html = ""
      html += "<div class=\"mapitem-popup\">"
      html += "<h4>" + cn(feature.properties.title) + "</h4>"
      html += "<address class='list-group-item-text'><strong>"+ categoryIcon(feature.properties.metaData.officeType) + cn(feature.properties.metaData.officeType)+"</strong><br>";
      html += " <small class='text-muted'>"+cn(feature.properties.metaData.address)+" "+cn(feature.properties.metaData.suburb)+", "+cn(feature.properties.metaData.state)+" "+cn(feature.properties.metaData.postcode)+"</small></address>";
      html += "</div>";
      return html;
    });

});

</script>
 </#macro>

<#macro MapMarkerPopup mapId="map">
<script type="text/html" data-stencils-mapmarkerpopupview data-stencils-mapid="${mapId}" data-stencils-mapmarkerpopupview-extenddata="markerpopup" >
<div class="mapitem-popup">
  <h4>{{properties.title}}</h4>
  <address class='list-group-item-text'>
  <strong>{{categoryIcon}}Test{{/categoryIcon}} {{properties.metaData.officeType}}</strong><br>
  <small class='text-muted'>{{properties.metaData.address}} {{feature.properties.metaData.suburb}} {{properties.metaData.state}} {{feature.properties.metaData.postcode}}</small></address>
</div>
</script>
<script type="text/json" stencils-mapmarkerpopupview-extenddata="markerpopup" >
{
  "categoryIcon" : function categoryIcon() {
    return function(text, render) {
      switch(text.toLowerCase()){
          case "agent":
          return '<i class="fa fa-male"></i>';
          break;
          case "centrelink customer service centre" :
          return '<i class="fa fa-building"></i>';
          break
        case "medicare":
          return '<i class="fa fa-university"></i>';
          break
        case "access point":
          return '<i class="fa fa-info-circle"></i>';
          break
        }
    }
  }
}
</script>
 </#macro>
<#--
  @desc Configure Map Marker
 -->
<#macro MapMarker mapId="map">
  <script type="text/html" data-stencils-mapmarkerview data-stencils-mapid="${mapId}" data-stencils-mapmarkerview-iconSize="[24,33]" data-stencils-mapmarkerview-className="">
    <span class="fa-stack">
      <i class="fa fa-map-marker fa-stack-2x" style="color:#0CA2E8; font-size:3em;text-shadow: 2px 2px 6px rgba(150, 150, 150, 1);"></i>
      <i class="fa fa-circle fa-stack-2x" style="color:#0CA2E8"></i>
    <i class="fa fa-stack-1x" style="color:#FFF;" data-stencils-template="">{{properties.rank}}</i></span>
  </script>
</#macro>

<#macro MapControlLocate mapId="map">
  <script type="text/html" data-stencils-mapcontrol="locate" data-stencils-mapid="${mapId}" data-stencils-mapcontrol-containerClass="stencils-mapcontrol-location btn btn-primary" data-stencils-mapcontrol-isinternal="true">
    <i class="fa fa-bullseye" title="My Location"></i>
    <small>My Location</small>
  </script>
</#macro>

<#macro MapControlLocateButton mapId="map">
  <button type="text/html" data-stencils-mapaction="locate" data-stencils-mapid="${mapId}" class="stencils-mapcontrol-locate btn btn-primary">
    <i class="fa fa-bullseye" title="My Location"></i>
    <small>My Location</small>
  </button>
</#macro>

<#macro MapControlSearchOnMove mapId="map">
  <script type="text/html" data-stencils-mapcontrol="searchOnMove" data-stencils-mapid="${mapId}" data-stencils-mapcontrol-containerClass="stencils-mapcontrol-searchOnMove btn btn-primary" data-stencils-mapcontrol-isinternal="true">
    <i class="fa fa-location-arrow" title="Search as I move map"></i>
    <small>Search as I move map</small>
  </script>
</#macro>

<#macro MapControlSearchOnMoveButton mapId="map">
  <button type="text/html" data-stencils-mapaction="searchOnMove" data-stencils-mapid="${mapId}" class="stencils-mapcontrol-searchOnMove btn btn-primary">
    <i class="fa fa-location-arrow" title="Search as I move map"></i>
    <small>Search as I move map</small>
  </button>
</#macro>

<#--
  Result
 -->
<#macro Result>
<!-- places.view.ftl:Result  -->
<div class="panel panel-default">

  <div data-stencils-mapresultlink data-stencils-mapresultlink-zoom='10' data-stencils-mapid="map" data-stencils-markerid="${core_controller.result.displayUrl}" class="panel-heading map-heading" title="Show ${core_controller.result.title} on map">
    <h4 class="media-heading">
      <i class="fa fa-location-arrow active-show"></i>
      <@MapMarkerIconNumbered />
      <@core_controller.boldicize><@core_controller.Truncate length=70>${core_controller.result.title}</@core_controller.Truncate></@core_controller.boldicize>
    </h4>
  </div>

    <div class="panel-body">


      <address class="list-group-item-text">
        <strong><@CategoryIcon />${core_controller.result.metaData.officeType}</strong><br>
        <small class="text-muted">${core_controller.result.metaData.address} ${core_controller.result.metaData.suburb}, ${core_controller.result.metaData.state} <#if core_controller.result.metaData.postcode??>${core_controller.result.metaData.postcode}</#if></small>
      </address>

     <button type="button" class="btn btn-default pull-right" data-stencils-mapresultlink data-stencils-mapresultlink-zoom='10' data-stencils-mapid="map" data-stencils-markerid="${core_controller.result.displayUrl}" class="panel-heading map-heading" title="Show ${core_controller.result.title} on map">
        <small class="text-muted" ><i class="fa fa-location-arrow active-show"></i>
        <i class="fa fa-map-marker active-hide"></i> Show on map
      </small>
    </button>

      <#if core_controller.result.summary??>
        <p class="list-group-item-text">${core_controller.result.summary}</p>
      </#if>

      <#if core_controller.result.metaData["c"]??><p class="list-group-item-text"><@core_controller.boldicize>${core_controller.result.metaData["c"]!}</@core_controller.boldicize></p></#if>


  </div>
  <div class="panel-footer">

  </div>
</div>
</#macro>
<#-- /ResultBasic -->


<#macro CategoryIcon name=core_controller.result.metaData.officeType?trim?lower_case>
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


<#macro MapMarkerIcon>
  <i class="fa fa-map-marker active-hide"></i>
</#macro>

<#macro MapMarkerIconNumbered>
  <span class="fa-stack active-hide" style="font-size: 0.5em; margin-top: -2em;"><i class="fa fa-map-marker fa-stack-2x" style="color:#0CA2E8; font-size:3em;"></i><i class="fa fa-circle fa-stack-2x" style="color:#0CA2E8"></i><i class="fa fa-stack-1x" style="color:#FFF;"> ${core_controller.result.rank}</i></span>
</#macro>

</#escape>
