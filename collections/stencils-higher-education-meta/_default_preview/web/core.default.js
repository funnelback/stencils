(function ( $, window, document, undefined ) {
 	
	var $ = jQuery.noConflict();

	// $.widget.bridge('uitooltip', $.ui.tooltip); 
	
	// Enable Bootstrap Tooltips
	if ($().tooltip) { 
		$('[data-toggle=tooltip]').tooltip({
			'html': true
		});
	}

	// Search Facets
	$('div.facet ul').each(function() {
		$(this).children('li:gt(' + (FB.displayedCategories - 1) + ')').hide();
	});

	$('.search-toggle-more-categories').each(function() {
		var nbCategories = $(this).parent().parent().find('li').size();
		if (nbCategories <= displayedCategories) {
			$(this).hide();
		}
		else {
			$(this).css('display', 'block');
			$(this).click(function() {
				if ($(this).attr('data-state') === 'less') {
					$(this).attr('data-state', 'more');
					$(this).parent().parent().find('li:gt(' + (FB.displayedCategories - 1) + ')').hide();
					$(this).find('span').text($(this).attr('data-more'));
				}
				else {
					$(this).attr('data-state', 'less');
					$(this).parent().parent().find('li').css('display', 'block');
					$(this).find('span').text($(this).attr('data-less'));
				}
			});
		}
	});

	// Search Geolocation
	$('.search-geolocation').on('click',function() {
		try {
			navigator.geolocation.getCurrentPosition(function(position) {
				// Success
				var latitude = Math.ceil(position.coords.latitude * 10000) / 10000;
				var longitude = Math.ceil(position.coords.longitude * 10000) / 10000;
				var origin = latitude + ',' + longitude;
				$('#origin').val(origin);
				alert('booya');
			}, function(error) {
				// Error
			}, {
				enableHighAccuracy: true
			});
		}
		catch (e) {
			alert('Your web browser doesn\'t support this feature');
		}
	});

	// Responsive Search Facets
	var responsiveFacets = function(){
      var searchFacets = jQuery('#search-facets');
      if(searchFacets.length){
	      if (window.innerWidth < 992)
	      	searchFacets.removeClass('in');  
	      else
	      	searchFacets.addClass('in');
  	  }
  	}   
  
    $(window).on('resize load', responsiveFacets);

    // Query Completion Setup
    if ($().fbcompletion) { 
    	jQuery("input.query").fbcompletion(FB.fbcompletionOptions);
	}

	// Debug
	
	//if(console){
	//	console.log(FB);
	//}


})( $, window, document );	