<#ftl encoding="utf-8" />

<#--
  Stencil: Maps
  By: Robert Prib
  Description: This contains the controllers for the maps.

  Note: Do not modify this file for specific implementations as customisations will be lost during
  stencil upgrades. Customisations should be completed in the core.view.ftl file.
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#-- Stencils which are to be included -->
<#assign stencils = ["core"] />

<#--
  The following code imports and assigns stencil namespaces automatically eg. core and core_view.
  The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/
  and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/

  Note: The full path has been added to ensure that the correct folder is being picked up
-->
<#list stencils as stencil>
  <#assign controller = "/share/stencils/libraries/${stencil}.controller.ftl" stencilNamespaceController="${stencil?lower_case}_controller" />
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
  - Copy base.controller.ftl from  $SEARCH_HOME/share/stencils/libraries/ and store it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
  - Change 'stencils = ["core", "base"]' to 'stencils = ["core"]'
  - Add '<#import "base.controller.ftl" as base_controller>' to the top of your file
  - Add '<#import "base.view.ftl" as base_view>' to the top of your file
-->

<#-- Import the main macros used to put together this app -->
<#import "/conf/${question.collection.id}/${question.profile}/places.view.ftl" as places_view/>


<#-- Quick reference to Places Web Resources -->
<#assign PlacesResourcesPrefix = "${SearchPrefix}stencils-resources/places/" >
<#assign thirdPartyResourcesPrefix = "${SearchPrefix}stencils-resources/thirdparty/" >

<#--
  CSS

  @author Robert Prib
  @desc Stylesheet dependencies
 -->
<#macro CSS>
  <link rel="stylesheet" href="${PlacesResourcesPrefix}css/stencils.places.css" />
  <link rel="stylesheet" href="${thirdPartyResourcesPrefix}leaflet/leaflet.css" />
  <link rel="stylesheet" href="${thirdPartyResourcesPrefix}leaflet/MarkerCluster.css" />
  <link rel="stylesheet" href="${thirdPartyResourcesPrefix}leaflet/MarkerCluster.Default.css" />
</#macro>

<#--
  JS

  @author Robert Prib
  @desc JavaScript dependencies
 -->
<#macro JS>
  <!-- Javascript required for maps -->
  <script src="${thirdPartyResourcesPrefix}leaflet/leaflet.js"></script>
  <script src="${thirdPartyResourcesPrefix}leaflet/leaflet.markercluster.js"></script>
  <script src="${thirdPartyResourcesPrefix}leaflet/leaflet.spin.js"></script>

  <#-- Only required if using google tileservice -->
  <script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
  <script src="${thirdPartyResourcesPrefix}gmaps/Google.js"></script>

  <!-- Plugin to display loading icon -->
  <script src="${thirdPartyResourcesPrefix}spin/spin.min.js"></script>

  <script src="${PlacesResourcesPrefix}js/stencils.places.js"></script>


</#macro>

<#--
  GetMapDataURL

  @author Robert Prib
  @desc The default map data URL
 -->
<#macro GetMapDataURL><#compress>
<#local profile = "mapservice" >
 <#if question.profile?contains("_preview") >
 <#local profile = "mapservice_preview" >
 </#if>
<#noescape>
${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["form","profile"])}&form=geojson&profile=mapservice
</#noescape>
</#compress></#macro>


</#escape>