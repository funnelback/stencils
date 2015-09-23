//PL TODO - auto detect origin if set?????
//Set initial origin for the map initialisation
var ori_x = -41.155038;
var ori_y = 145.325089;

//Set default zoom for the map initialisation
var def_zoom = 12;

//Set the ID of the div that will contain the map
var mapdiv = 'mapResults'

var geojsonMarkerOptions = {
    radius: 8,
    fillColor: "#ff7800",
    color: "#000",
    weight: 1,
    opacity: 1,
    fillOpacity: 0.8
};

// Configure the tile layer library to use
/*
Available values for tileLayer are:
osm: Open Street Map
google: Google maps (ROADMAP)
google-terrain: Google maps (TERRAIN)
google-satellite: Google maps (SATELLITE)
google-hybrid: Google maps(HYBRID)
*/
var tileLayer = "google";


// Configure the code that shouold be returned for each popup

function createPopup(feature) {
console.log("cretingpopup")
    var html = ""
    html += "<div class=\"mapitem-popup\">"
    html += "<h4><a href=\"" + feature.properties.clickTrackingUrl + "\" title=\"" + feature.properties.url + "\">" + feature.properties.title + "</a></h4>"    
    html += "<div><span>Office type: "+feature.properties.metaData.T+"</span></div>"
    html += "<div><span>Address: "+feature.properties.metaData.A+" "+feature.properties.metaData.B+" "+feature.properties.metaData.C+" "+feature.properties.metaData.D+"</span></div>"
    if(feature.properties.description) {
        html += "<div class=\"description\">"
        html += truncate(feature.properties.description,99)+"<a class=\"more-details-button\" href=\""+feature.properties.clickTrackingUrl+"\">More...</a></div>";
    }
    html += "</div>"
    return html;
}

