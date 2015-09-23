
(function ( $, window, document, undefined ) {
 	
	var $ = jQuery.noConflict();

	$(window).load(function(){
	  // initialize
	  //$('.masonry-container').masonry({
	    //itemSelector: '.masonry-item'
	  //});  
	});


	(function(){
	  $(".fb-result-menu a").click(function(){
	    setTimeout(function() {
	      $('.masonry-container').masonry();
	    }, 10);    
	  });
	})();

})( $, window, document );	