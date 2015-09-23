// Funnelback App: demoApp
// By: YourNameHere
// Last Update: 10/10/2014

;(function ( $, window, document, undefined ) {
	
 	var $ = jQuery.noConflict();
	
	if(!FB){
		var FB = [];
	}
	
	//some text to show when you click the demp app button
	FB.demoAppTextIntro = 'Hello this is a FunnelBack demo app, hip hooray!';
	
	// A demo function for the demo app. Can also be set in another file if you so wish but it's nice to keep everything under the hood of your app.
	// It's also nice to keep everything in the FB javascript object so we can easily analyse what is avaliable when using it to build/develop. Be careful of how you name your objects and try and conform to the namespace bellow note the difference: FB.demoAppTextIntro to FB.demoAppFunctionTest (your app name, it's an app, is it a function or is it text?, identify it).
	FB.demoAppFunctionTest = function(){ 
	  var targetPage = jQuery(this).attr('href');
	  var targetPageNumber = jQuery(this).text(); 
	  jQuery('#search-main').load( targetPage + ' #search-main', function(){ 
		  $("html, body").animate({ scrollTop: 0 },0); 
		  $('#app-demo-intro h2').text('You are now viewing page' + targetPageNumber);
	  });  
	  return false; 
	};
	
	$(document).ready(function(){
		
		if(console)
			console.log('welcome to the demo Funnelback App');	
			
	})
	.on('click','#search-pagination ul li a', FB.demoAppFunctionTest)
	.on('click','#app-demo-intro .btn', function(){ 
			alert(FB.demoAppTextIntro); 
			$('#app-demo-intro h2').html('<i class="icon-large icon-hand-down"></i> Now click a pagination link below');
			return false; 
	});

	
})( $, window, document );	