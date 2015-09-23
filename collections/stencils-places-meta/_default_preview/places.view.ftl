<#ftl encoding="utf-8" />
<#--
   Stencil: Social
   By: Robert Prib
   Description: Display results from social media collections such as Facebook, Twitter, YouTube and Flickr.
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
<#assign stencils = ["core"] />

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
<#import "/web/templates/modernui/stencils-libraries/places.controller.ftl" as places_controller/>


<#-- 
  The following functions are generic layout code which can be copied and customised
  to suit individual implementations.

  Note: Before the tab layout can be used, you must enable the full facet list by addition the following to collection.cfg
  
  ui.modern.full_facets_list=true
  
  It is also best practice to hide the facet group which has been used to populate the tabs from the list of available facets
--->

<#-- 
  Map Marker Popup 

  @desc View for map marker popup. Needs to be contructed using the JavaScript. The feature param passed to the function includes all the data from s.result
  @author Robert Prib
 -->
<#macro MapMarkerPopup mapId="map">
<script>
if(typeof stencilsMapMarkerPopups ==  "undefined") var stencilsMapMarkerPopups = {};
if(typeof stencilsMapMarkerPopups.${mapId} ==  "undefined") stencilsMapMarkerPopups.${mapId} = {};
stencilsMapMarkerPopups.${mapId}.createPopup = function createPopup(feature){
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
}
</script>
 </#macro>

 <#-- 
  
  -->
<#macro MapMoveUpdate>
  <form role="form">
  <div class="checkbox">
    <label>
      <input type="checkbox"> Redo search proximity or map move
    </label>
  </div>
  </form>
</#macro>

</#escape>