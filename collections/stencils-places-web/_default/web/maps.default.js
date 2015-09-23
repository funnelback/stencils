// Funnelback App: demoApp
// By: Steve Chan
// Last Update: 10/10/2014

;(function ( $, window, document, undefined ) {
	
 	$ = jQuery.noConflict();
	$w = jQuery(window);
	$d = jQuery(document);
	
	
     
	 
	
	function updateMap(){
		if(map)
			map._onResize(); 
		else
			return false;
	}
	function toogleSidebar(){
		jQuery('#search-maps-side').toggleClass('in');
	}
	function closeSidebar(){
		jQuery('#search-maps-side').removeClass('in');
	}
	function openSidebar(){
		jQuery('#search-maps-side').addClass('in');
	}
	
	// Update the maps to fit changes in layout sizing
	
	$d.
	on('click', '#layoutMapTabs a', function(e){
		
	})
	.on('click', '.navbar-toggle', function(){
		toogleSidebar();
		updateMap();
	})
	  .on('click', '.revert-view-all', function(){
			$(this).remove();
			$('#layoutMapTabs a[href="#mapsMapView"]').tab('show');
			$('#search-results li.active').removeClass('active');
			//alert('TODO: Fix up the center alignment of the bounds.');
			
	})
	  .on('click', '#search-results li a', function(e){
		  e.preventDefault();
		  	$('#layoutMapTabs a[href="#mapsMapView"]').tab('show');
		  	if($(this).parents('#search-results').length){
				$('#search-results .active').removeClass('active');	
			}
			var latlon = jQuery(this).attr('data-latlon');
			var zIndex = map._zoom;
			if(map && latlon){
				// If we are in a tab, lets que the co-ordinates and wait till the user decides to change to list view. 
				if($(this).parents('#layoutMapTabs').length){
					$('body').attr('data-que',latlon);
				}
				
				var latlon = latlon.split(";");
				map.setView(latlon, 13);
			}
			//Create a button that allows you to revert all the views.
			
			var tg = $(this).parents('li');
				tg.siblings('.active').removeClass('active');
				tg.addClass('active');
			if($('.revert-view-all').length){}
			else{
				$('#search-results')
					.prepend('<li class="revert-view-all"><div class="btn btn-success"><span class="glyphicon glyphicon-marker"></span>View All</div></li>')
					.on('click',function(){ 
						if(!origin){ console.log('origin needs to be set');}
						map.setView(origin, zIndex); 
				});
			}
			return false;	
	})
	
	// The following is required to fix the map tiles not rendering as expected. (Since we are in list view)
	.on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
		var target = e.currentTarget.hash;
		var targetElement = $(target);
		var latLon = $('body').attr('data-que');
		if(latLon == '' || latLon.indexOf('undefined') === true){ return false; console.log('not set');  }
		
		  if( target.indexOf('mapsMapView') == true && latLon.length){
			  
			targetElement.css({border:'2px solid #2c6b9f'});  
			var latLon = latLon.split(";");
			setTimeout(function(){
		    	map.setView(latLon, 13);
				map.fitBounds(latLon);
			},200);
			
			$('body').removeAttr('data-que');
		  }
	});
	
	$w.on('resize load', function(){
		if($w.width() < 767){
			closeSidebar();
			updateMap();	
		} 
		else if($w.width() > 1199){
			openSidebar();
		}
	});


	
})( $, window, document );	