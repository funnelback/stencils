
// Create the map origin - The values of ori_x and ori_y are defined in funnelback_mapping_config.js
var origin = new L.LatLng(ori_x, ori_y);

// Create the map object
var map = new L.Map(mapdiv, {center: origin, zoom: def_zoom});

// GeoJSON object containing the map data pins
var mapPoints;

// Layer to hand marker clustering
var marker_clusters;

// Layer to hold the map pins
var markers;

// Set up tile layer
switch(tileLayer) {
  case "osm":
    console.log("using OSM")
    tileLayer =  new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');
    break;
  case "google":
    console.log("using Google Roadmap")
    tileLayer = new L.Google('ROADMAP');
    break;
  case "google-hybrid":
    console.log("using Google Hybrid")
    tileLayer = new L.Google('HYBRID');
    break;
  case "google-satellite":
    console.log("using Google Satellite")
    tileLayer = new L.Google('SATELLITE');
    break;
  case "google-terrain":
    console.log("using Google Terrain")
    tileLayer = new L.Google('TERRAIN');
    break;
  default: console.log("Error: no tile layer defined")
}
map.addLayer(tileLayer);

// DEBUG - code for a layer switcher - only useful for demoing the flexibility

var osm = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');
var ggl = new L.Google('HYBRID');
var ggl2 = new L.Google('TERRAIN');
var ggl3 = new L.Google('SATELLITE');
map.addControl(new L.Control.Layers( {'OSM':osm, 'Google (Roadmap)':tileLayer, 'Google (Hybrid)':ggl, 'Google (Terrain)':ggl2, 'Google (Satellite)':ggl3}, {}));
// DEBUG END


function funnelback_map(jsondataurl) {

  var jqxhr = jQuery.ajax({
      url: jsondataurl,
      dataType: "json"
  })
  .done(function(data) {
    mapPoints = data
    addPoints(mapPoints)
    console.log( "success" );
  })
  .fail(function(jqxhr, textStatus, thrownError) {
    console.log( "error "+textStatus);
  })
  .always(function() {
    console.log( "complete" );
  });


}


    function pointToLayer(feature, latlng) {
       var pin = new L.marker(latlng);
       var popupContent = createPopup(feature)
       pin.bindPopup(popupContent);
       return pin;
    }


function addPoints(data) {
    mapPoints = data
    markers = new L.geoJson(mapPoints, {pointToLayer: pointToLayer});

    marker_clusters = L.markerClusterGroup();
    marker_clusters.addLayer(markers);
    map.addLayer(marker_clusters);
    map.fitBounds(marker_clusters.getBounds());
}
