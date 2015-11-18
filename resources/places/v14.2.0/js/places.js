"use strict";
/*
  Stencil: Places
  By: Robert Prib
  Description: Javascript specifically for twitter stencils.
*/
stencils.module.places = (function($, window, stencils, undefined) {
  var maps = {}

    /* Class */
  function PlacesMap($container, id, endPoint, options) {
    var that = this,
      attrs = {
        $container: undefined,
        $mapdiv: undefined,
        id: undefined,
        endPoint: undefined,
        map: undefined,
        geojsonmarkers : {},
        markers : {},
        createPopup: function emptyPopup(){},
        userMarker: undefined,
        options: {
          //Set initial origin for the map initialisation
          originX: -41.155038, //lat
          originY: 145.325089, //lng
          useUserOrigin: false,
          zoom: 12, //Set  zoom for the map initialisation
          mapdiv: '[data-mapdiv]', //Set the ID of the div that will contain the map
          cluster: false, //Cluster groups of markers
          addMarkerZoom : 18,
          zoomOnAddMarker : true,
          controlLocate: true, //Show locate control
          controlLocateZoom: 18, //How far to zoom in when locating user.
          controlLocateWatch: true, //Whether to watch and locate or just locate on demand.
          controlLocateActiveClass: "active", //Class to apply when element is active and no active.
          controlClear: true, //Show clear control
          controlReset: true, //Show reset control
          controlSearchOnMove: true, //Show searchOnMove control
          defaultTile: "openStreetMap", //Default map tile options are
          tileLayers: {
            openStreetMap: new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'),
            googleRoadmap: new L.Google('ROADMAP'),
            googleHybrid: new L.Google('HYBRID'),
            googleSatellite: new L.Google('TERRAIN'),
            googleTerrain: new L.Google('SATELLITE')
          }
        }
      };
    /*************************
      Private methods
    **************************/
    /*
      init
      @author Robert Prib
      @desc method for instantising the map setup
    */
    function init($container, id, endPoint) {
      if ((typeof $container) === "undefined") {
        return false;
      }
      attrs.$container = $container;
      attrs.id = id;
      attrs.endPoint = endPoint;

      //extend js options.
      for(var option in attrs.options) {
        if(attrs.options.hasOwnProperty(option)){
          attrs.options[option] = $container.data("stencils-map-" +  option.toLowerCase() ) || attrs.options[option];
        }
      }

      setMapDiv();
    }
    /*
      setMapDiv
      @author Robert Prib
      @desc Sets the map to the to the container selecter in the dom from the provided selector.
    */
    function setMapDiv() {
      if (!attrs.$container.find(attrs.options.mapdiv).length) {
        console.error("Please check you have your mapdiv setup. Mapdiv = ", attrs.mapdiv);
        return false;
      }
      attrs.$mapdiv = attrs.$container.find(attrs.options.mapdiv).get(0);
    }
    /*
      @desc create a marker for the locate user function
    */
    function createUserMarker() {
      var userMarkerIcon = new L.divIcon({
        className: 'fa usermarker fa-street-view'
      });
      var marker = new L.marker(origin, {
        icon: userMarkerIcon,
        draggable: true,
        riseOnHover: true
      });
      attrs.userMarker = new PlacesMapUserLocation(that, marker, { zoom : attrs.options.controlLocateZoom});
    }

    /*
      addMarkerToLayer
      @author Robert Prib
      @desc Create markers from geojson and assign a popup if required.
    */
    function addMarkerToLayer(feature, latlng) {
      var marker = new L.marker(latlng);
      var popupContent = attrs.createPopup(feature);

      if($.trim(popupContent).length) {
        marker.bindPopup(popupContent);
      }

      attrs.markers[feature.properties.displayUrl] = marker;

      return marker;
    }
    /*
      addMarkerStyle
      @author Robert Prib
      @desc Setup style options from geojson
    */
    function addMarkerStyle(feature) {
      return feature.style;
    }

    /*
      addMarkers

      @author Robert Prib
      @desc add markers to map layer
      @param {json} options.data - geojson to plot on map.
      @param {boolean} options.fitBounds - option for fitting markers in bound after plotting onto map. This is true by default.
    */
    function addMarkers(extendOptions) {
      var options = {
        data: undefined,
        fitBounds: true
      };

      $.extend(options, extendOptions);
      if (typeof options.data === "undefined") {
        return false;
      }
      //flush old markers
      attrs.markers = {};

      attrs.geojsonmarkers = new L.geoJson(options.data, {
        pointToLayer: addMarkerToLayer,
        style: addMarkerStyle
      });


      if (attrs.options.cluster) {
        var marker_clusters = L.markerClusterGroup();
        marker_clusters.addLayer(attrs.geojsonmarkers);
        attrs.map.addLayer(marker_clusters);
        attrs.geojsonmarkers = marker_clusters;
      }

      attrs.map.addLayer(attrs.geojsonmarkers);
      if (options.fitBounds) {
        attrs.map.fitBounds(attrs.geojsonmarkers);
      }

    }

    /*
      getMapRadiusKM
      @author Robert Prib
      @desc Finds the maps radius in KM based on size of map and zoom.
    */
    function getMapRadiusKM() {
      var mapBoundNorthEast = attrs.map.getBounds().getNorthEast();
      var mapDistance = mapBoundNorthEast.distanceTo(attrs.map.getCenter());
      return mapDistance / 1000;
    }
    /*
      createLocateControl
      @author Robert Prib
      @desc Creates a button on map to locate the users current location
    */
    function createLocateControl() {
      var options = {
        html: '<i class="fa fa-bullseye" title="My Location"></i>',
        container: 'button',
        containerClass: 'user-location btn btn-primary',
        position: 'topleft'
      }
      var MyControl = L.Control.extend({
        options: {
          position: 'topleft'
        },
        onAdd: function(map) {
          // create the control container with a particular class name
          var container = L.DomUtil.create('button', 'user-location btn btn-primary');
          var $container = $(container);
          $container.html('<i class="fa fa-bullseye" title="My Location"></i>');
          $container.attr("data-stencils-mapcontrolelocateuser", "");
          $container.attr("data-stencils-mapid", attrs.id);
          //Fix for disabling map from zooming in when button is doubled clicked.
          $container.dblclick(function(e) {
            e.stopImmediatePropagation()
          });
          return container;
        }
      });
      attrs.map.addControl(new MyControl);
    }

    /*
      createSearchOnMoveControl

      @author Robert Prib
      @desc Creates a button on map to redo search as the position and zoom on the map changes
    */
    function createSearchOnMoveControl() {
      var MyControl = L.Control.extend({
        options: {
          position: 'topleft'
        },
        onAdd: function(map) {
          // create the control container with a particular class name
          var container = L.DomUtil.create('button', 'btn btn-primary');
          var $container = $(container);
          $container.html('Search as I move the map');
          $container.click(function(e) {
              e.stopImmediatePropagation()
              if (!$(this).is(".active")) {
                attrs.map.on("dragend zoomend", searchByMapCenter);
              } else {
                attrs.map.off("dragend zoomend", searchByMapCenter);
              }
              $(this).toggleClass("active");
            })
            //Fix for disabling map from zooming in when button is doubled clicked.
          $container.dblclick(function(e) {
            e.stopImmediatePropagation()
          });
          return container;
        }
      });
      attrs.map.addControl(new MyControl);
    }
    /*
      searchByMapCenter
      @author Robert Prib
      @desc Searches Map from center point
    */
    function searchByMapCenter() {
      //get maps current center
      var origin = attrs.map.getCenter();
      var maxdist = Math.ceil(getMapRadiusKM());
      attrs.map.removeLayer(attrs.geojsonmarkers);

      that.mapSearch({
        endPoint: attrs.endPoint + "&origin=" + origin.lat + "," + origin.lng + "&maxdist=" + maxdist,
        fitBounds: false
      });

      //update result list
      $("[data-stencils-mapresultlist][data-stencils-mapid=" + attrs.id + "]").each(function(){
        $(this).html('<i class="fa fa-spinner fa-pulse"></i> Loading Resuls')
        $(this).load(window.location.href + "&origin=" + origin.lat + "," + origin.lng + "&maxdist=" + maxdist + "&form=resultservice", function(data){
          $(this).html( data.replace(/form\=resultservice/g,""))
          $("[data-stencils-mapresultlink]").each(dataBind.mapResultLink);
        });
      });
    }
    /*
      @desc Add these Controls once map is initiated.
    */
    function createControlsMapInit() {
      //Add controls to map that are not marker dependant
      if (attrs.options.controlLocate) createLocateControl();
      if (attrs.options.controlSearchOnMove) createSearchOnMoveControl();
    }

    /*
       @desc go and grab the mappop from the places.view.ftl if it exists.
       -- R.P to find a more elegenat way to allow this to be editable from the view.
      */
    function bindCreatePopupFunction() {
      if (typeof stencilsMapMarkerPopups == "undefined") return false;
      attrs.createPopup = stencilsMapMarkerPopups[id].createPopup || attrs.createPopup;
    }
    /*
      @author Robert Prib
      @desc Set the tile layer
    */
    function setUpTileLayer() {
      attrs.map.addLayer(attrs.options.tileLayers[attrs.options.defaultTile]);
      //R.P TODO: this is static at the moment, come back and iterate it.
      attrs.map.addControl(new L.Control.Layers({
        'Open Street Map': attrs.options.tileLayers.openStreetMap,
        'Google (Roadmap)': attrs.options.tileLayers.googleRoadmap,
        'Google (Hybrid)': attrs.options.tileLayers.googleHybrid,
        'Google (Terrain)': attrs.options.tileLayers.googleTerrain,
        'Google (Satellite)': attrs.options.tileLayers.googleSatellite
      }, {}));
    }
    /*
      R.P - TODO: Not currently implemented.
    */
    function useUserOrigin() {
      //Attempt to set defaults for origin to current location if the browser permits
      if (attrs.options.useUserOrigin) {
        //TODO: come back to this as it is not working
        getUserOrigin();
      }
    }
    /*************************
      Privileged methods
    **************************/
    /*
      createMap
      @author Robert Prib
      @desc Creates the map within the DOM.
    */
    this.createMap = function createMap() {
        var center = new L.latLng(attrs.options.originX, attrs.options.originY);
        attrs.map = new L.Map(attrs.$mapdiv, {
          center: center,
          zoom: attrs.options.zoom
        });
        createUserMarker();
        bindCreatePopupFunction();
        setUpTileLayer();
        that.mapSearch({
          endPoint: attrs.endPoint
        }, function(data) {
          that.createControlsAfterMarkers();
        });
        createControlsMapInit();

        return that;
      }
      /*
        mapSearch
        @desc Searches the map with a provided query and and adds new markers to the map.
        @param {string} options.endPoint - Funnelback mapservice URL to query. Mapservice must return geojson data. See http://geojson.org/
        @param {boolean} options.fitBounds - Option to zoom in or out map to fit in markers once added. Default is true.
        @param {function} callback(data,err) - Can provide own function to run after search action has completed.
      */
    this.mapSearch = function mapSearch(extendOptions, callback) {
        var options = {
          fitBounds: true,
          endPoint: undefined
        };
        $.extend(options, extendOptions);
        callback = callback || function() {};
        if (typeof options.endPoint == "undefined") {
          callback.call(undefined, "End point must be provided, search not completed. endPoint=" + endPoint);
          return false;
        }
        jQuery.ajax({
          url: options.endPoint,
          dataType: "json"
        }).done(function(data) {
          addMarkers({
            data: data,
            fitBounds: options.fitBounds
          });
          callback.call(data);
        }).error(function(err,errortxt){
          console.error("Map search failed.",err,errortxt, attr.map);
        })

        return that;
      }
      /*
        bindControlLocateUser
        @author Robert Prib
        @desc Binds the action for locating user on this map
        @param {jQuery Object} $container - Dom element bind actions and events to.
      */
    this.bindControlLocateUser = function bindControlLocateUser($control) {
        var options = {
          activeClass: attrs.options.controlLocateActiveClass,
          watch : attrs.options.controlLocateWatch,
          zoom: attrs.options.controlLocateZoom
        }

        if ($container.data("stencils-mapcontrolelocateuser-options")) {
          $.extend(options, JSON.parse($mapMyLocation.data("stencils-mapcontrolelocateuser-options")));
        }
        //RP - TODO: overide userMarker options.
        $control.click(function() {
          if (attrs.options.controlLocateWatch) {
            //Watch location
            if (!$(this).is("." + options.activeClass)) {
              attrs.userMarker.watch();
            } else {
              attrs.userMarker.stop();
            }
            $(this).toggleClass(options.activeClass);
          } else {
            //Find location on request
            attrs.userMarker.getUserLocation();
          }
        });
        return that;
      }
      /*
        getAttrs
        @author Robert Prib
        @desc - back way to view attributes.
        @return {object} attrs - Returns all the objects variables.
      */
    this.getOptions = function getAttrs() {
        return attrs.options;
      }
      /*
        setAttrs
        @author Robert Prib
        @desc - back way to set attributes.
        @param {object} nattrs - Object containing list of attributes to change.
      */
    this.setOptions = function setAttrs(attrs) {
      $.extend(attrs.options, attrs);
      return that;
    }

    /*
        setView
        @author Robert Prib
        @desc - Returns the leaflet map object
        @return {object} attrs - Returns all the objects variables.
      */
    this.setViewToMarker = function setView(options) {
      if(typeof options.markerId ==="undefined") return that;
      var marker = that.getMarker(options.markerId);
      if(!marker) return that;
      options.openPopup = options.openPopup || true;
      options.zoom = options.zoom || attrs.map._zoom;
      var latLng = marker.getLatLng();

      attrs.map.setView(latLng, options.zoom);
      if(options.openPopup) marker.openPopup();
      return that;
    }

    this.addMarker = function addMarker(marker, extendOptions){
      var options = {
        zoom : attrs.options.addMarkerZoom,
        zoomOnAdd : attrs.options.addMarkerZoom
      };
      $.extend(options,extendOptions);
      attrs.map.addLayer(marker);

      if(options.zoomOnAdd) {
         attrs.map.setView(marker.getLatLng(), options.zoom);
      }else {
         attrs.map.setView(marker.getLatLng());
      }

      return that;
    }

    this.removeMarker = function removeMarker(marker){
      attrs.map.removeLayer(marker);
      return that;
    }

    this.getMarker = function getMarker(id) {
      if(attrs.markers.hasOwnProperty(id)){
        return attrs.markers[id];
      } else {
        return false;
      }
    }

    /*
      Empty function that can be overwritten to add custom controls to map
    */
    this.createControlsAfterMarkers = function createControlsAfterMarkers(){};

    init($container, id, endPoint, options);
  };
  /*
      Class PlacesMapUserLocation
      @author Robert Prib
      @desc Create and manage the Marker for the user on the map.
    */
  function PlacesMapUserLocation(map, marker, options) {
    var attrs = {
        watch: undefined,
        marker: undefined,
        map: undefined,
        options : {
          zoom: 18
        }
      },
      geo_options = {
        enableHighAccuracy: true,
        maximumAge: 30000,
        timeout: 27000
      };
    var that = this;

    function init(map, marker, options) {
      attrs.map = map;
      attrs.marker = marker;
      $.extend(attrs.options, options);
    }

    function geo_error(error) {
      alert("Geolocation service is not supported by your browser or no position available.");
      console.error("Locate User failed:", error)
    }

    function convertPositiontoLatLng(position) {
      var x = Math.ceil(position.coords.latitude * 10000) / 10000;
      var y = Math.ceil(position.coords.longitude * 10000) / 10000;
      return new L.latLng(x,y);
    }

    function updateMarkerOnMap(position){
      attrs.latLng = convertPositiontoLatLng(position);
      attrs.marker.setLatLng(attrs.latLng);
      attrs.map.addMarker(attrs.marker,{
        zoom : attrs.zoom
      });
    }

    /*
     getUserLocation

      @author Robert Prib
      @desc Not functional at the moment as code has been ported over.
    */
    this.getUserLocation = function getUserLocation() {

      navigator.geolocation.getCurrentPosition(function(position) {
        updateMarkerOnMap(position);
      }, geo_error, geo_options);
    }
    this.watch = function watch() {
      //Clear previous watch if set.
      if (typeof attrs.watch !== "undefined") {
        that.stop();
      }
      attrs.watch = navigator.geolocation.watchPosition(function(position) {
        updateMarkerOnMap(position);
      }, geo_error, geo_options);
    }
    this.stop = function stop() {
      //No need to run if watch is not currently set
      if (typeof attrs.watch === "undefined"){
        return false;
      }
      navigator.geolocation.clearWatch(attrs.watch);
      attrs.map.removeMarker(attrs.marker);
    }
    this.getMarker = function getMarker() {
      return attrs.marker;
    }

    init(map, marker, options);
  }
  /*
    Bind actions for data attribute found in dom on dom ready
  */
  var dataBind = {
      /*
        map
        @desc contructs data-places-map elements on map
      */
      map: function Map() {
        var $container = $(this);
        var id = $container.data("stencils-mapid")
        var endPoint = $container.data("stencils-mapdataurl");
        var placesMap = new PlacesMap($container, id, endPoint);
        placesMap.createMap();
        $container.data("placesMap", placesMap);
        maps[id] = placesMap;
      },
      /*
        map
        @desc contructs data-places-mapresults elements on map
      */
      mapResultLink: function mapResultLink() {
        var $container = $(this);

        var mapId = $container.data("stencils-mapid"),
          markerId = $container.data("stencils-markerid");

        var placesMap = getPlacesMapById(mapId);

        var $mapResultLinks = $("[data-stencils-mapresultlink][data-stencils-mapid="+ mapId + "]");
        var $markerLinks = $("[data-stencils-mapresultlink][data-stencils-markerid="+ markerId.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|\:]/g, "\\$&") + "]");

        var options = {
          activeClass : "active",
          zoom : 13,
          useSetZoom : false
        };

        //extend js options.
        for(var option in options) {
          if(options.hasOwnProperty(option)){
            options[option] = $container.data("stencils-mapresultlink-" +  option.toLowerCase() ) || options[option];
          }
        }

        if (placesMap) {


          $container.on('click', function(e) {
            e.preventDefault();
            if( $(this).is("." + options.activeClass)) return false;
            //remove all other active
            $mapResultLinks.removeClass(options.activeClass);
            $markerLinks.addClass(options.activeClass);
            if( options.useSetZoom ){
              placesMap.setViewToMarker({ zoom : options.zoom, markerId: markerId});
            }else {//Use maps current zoom state.
              placesMap.setViewToMarker({markerId: markerId});
            }

          });


        }
      },
      mapControlLocateUser: function mapControlLocateUser() {
        var $control = $(this),
          placesMap;
        var ids = $control.data("stencils-mapid").split(",");
        //for each map id attach this button to it.
        for (var i = ids.length - 1; i >= 0; i--) {
          placesMap = getPlacesMapById(ids[i]);
          placesMap.bindControlLocateUser($control);
        };
      }
    }

    /*
      Initiate sub modules
    */
    //On DOM Ready
  $(function() {
    //Data Bindings
    $("[data-stencils-map]").each(dataBind.map);
    $("[data-stencils-mapresultlink]").each(dataBind.mapResultLink);
    $("[data-stencils-mapcontrolelocateuser]").each(dataBind.mapControlLocateUser);
  });
  /*
    Publically available information from this module.
  */
  var getPlacesMapById = function getMapById(id) {
    if(maps.hasOwnProperty(id)){
      return maps[id];
    } else {
      return false;
    }
  }
  return {
    getPlacesMapById : getPlacesMapById
  };
}(jQuery, window, stencils));
