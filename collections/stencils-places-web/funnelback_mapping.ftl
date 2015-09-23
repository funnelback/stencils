<#---
    Macros required for Funnelback mapping.  
-->

<#--- @begin MapResources -->
<#---
    Generates the CSS and Javascript links for the page footer.

    @param tileservice Defines the tileservice to use for additional javascript loads.  'google' - use google maps. TODO: extend for bing, yandex.  osm doesn't require any additional JS

    @param mapdiv ID of div that will be used as the map container
-->

<#macro MapResources tileservice="google" mapdiv="mapResults">
<!--==================== FUNNELBACK MAPPING ==================-->

<!-- Set the height for the map results div - this must be done before the map is initialised -->
<style>
#${mapdiv?html} {height:500px;}
#mapnoresults {z-index:500; position:absolute; top: 46%; left: 0; bottom: 0; right: 0}
#mapnoresults p {text-align:center;}
#mapnoresults span {background:#fff; padding:5px; border: 3px solid #f00; border-radius:5px}
</style>

<!-- Javascript required for maps -->
<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css" />
<script src="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js"></script>

<!-- Javascript and CSS required for the Marker Clusters -->
<link rel="stylesheet" href="/s/resources/${question.inputParameterMap["collection"]}/mapservice/MarkerCluster.css" />
<link rel="stylesheet" href="/s/resources/${question.inputParameterMap["collection"]}/mapservice/MarkerCluster.Default.css" />
<script src="/s/resources/${question.inputParameterMap["collection"]}/mapservice/leaflet.markercluster.js"></script>

<#if tileservice == "google">
<!-- Use Google Maps tiles -->
<script src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
<script src="/s/resources/${question.inputParameterMap["collection"]}/mapservice/Google.js"></script>
</#if>

<!-- Funnelback-specific  mapping javascript -->
<script src="/s/resources/${question.inputParameterMap["collection"]}/mapservice/funnelback_mapping_config.js"></script>
<script src="/s/resources/${question.inputParameterMap["collection"]}/mapservice/funnelback_mapping.js"></script>
<script>
    jQuery('document').ready( function(){
        mapdataurl = "${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","form","num_ranks","profile"])}&form=geojson&profile=mapservice";
        funnelback_map(mapdataurl);
    });
</script>

<!-- Plugin to display loading icon -->
<script src="/s/resources/${question.inputParameterMap["collection"]}/mapservice/spin.min.js"></script>
<script src="/s/resources/${question.inputParameterMap["collection"]}/mapservice/leaflet.spin.js"></script>

<!--==================== /FUNNELBACK MAPPING ==================-->
</#macro>
