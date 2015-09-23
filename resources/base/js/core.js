angular.module('Funnelback')
	/*
	 Services
	*/
	.service('RecommenderService', ['$http', function($http) {
		// Setup the defaults used for this service
		this.defaults = {
			method: 'get',
			url: '/s/recommender/similarItems.json',
			params: {
				seedItem: '',
				collection: '',
				maxRecommendations : '',
				scope: '', 
				source: 'default' 
			}
		}

		// Function to get recommendations based on the server and 
		// parameters specified in the @config
		this.getRecommendations = function(config){
	    // Override the defaults with the passed in @config
	    $.extend(defaults, config); 

	    return $http(config);			
		}

	}]);
	
	/*
		Controllers
	*/


	/*
	 Filters
	 */
	.filter('fileNameOnly', function() {   
		return function(input) {     
			return input.replace(/.*\//,"");   
		}; 
	});     