angular.module('Funnelback').filter('fileNameOnly', function() {
	return function(input) {
	  return input.replace(/.*\//,"");
	};
});
