
    // Map origin
    
    var zoomLevel = 8;  // Defaults to city-level zoom
    var mapMarkers = []; // Populated from GeoJSON
    
    var map = L.map('search-map', {
        
        zoom: zoomLevel
    });

    // Add OpenStreetMap Tiles
    L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors',
        key: ''
    }).addTo(map);

    // Add GoogleMaps Tiles
    var googleLayer = new L.Google('ROADMAP');
    map.addLayer(googleLayer,true);

    // Add Bing Tiles
//    var bing = new L.BingLayer(YOUR_BING_API_KEY);
//    map.addLayer(bing);




  
