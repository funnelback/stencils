/*
  Stencil: Recommender
  Description: Helpers specific to recommender.
*/

var stencils = typeof stencils == "object" ? stencils : { module : {} };
stencils.module.recommender = (function ($, window, stencils, undefined) {
/*
	Sub Modules
*/
/*
  function recommenderService() {
    //get servername
    var funnelbackServer = "http://demo-au.funnelback.com";

    //get recommender URL
    var recommenderURL = funnelbackServer + "/s/recommender/similarItems.json?callback=?";

    //get collection Name
    var collectionName = "demo-v13-recommender";

    var recommendations = {}

    var template;


    function drawRecommendations(){

    }

    function getQueryURL(recomendations){
      var query = "meta_v_orsand="
      for (var recommendation in recomendations ) {
        if (recomendations.hasOwnProperty(recommendation)) {
          query =+ '"%24%2B%2B%20' + recomendation.itemID + '%20%24%2B%2B"+';
        }
      }
      return query;
    }

    function getRecommendations(){

      $.getJSON(recommenderURL,
        {
          seedItem: window.location.href, // Default to current page
          collection: "demo-v13-recommender",
          scope: "",
          maxRecommendations: "5"
        }
        ,function(response){
          if ($("#funnelback-recommender").length ==0) {

            $("body").append("<link href='" + funnelbackServer + "/s/resources/demo-v13-recommender/_default_preview/bookmarklet-recommender.css' rel='stylesheet' type='text/css'><div id='funnelback-recommender'><!--<a href='#' title='Close' class='close'>Close</a>--><h2>Related Items</h2></div>");

            if (response.RecommendationResponse.status == "OK") {
              $("<ul class='recommendations'>").appendTo("#funnelback-recommender");
              $.each (response.RecommendationResponse.recommendations, function (i, item) {
                var thumbnails = item.metaData["I"].split("|");
                $("<li><a href='" + item.itemID + "'><img src='" + thumbnails[0] + "' /><h3>" + item.metaData["T"] + "</h3>").appendTo("#funnelback-recommender ul");
              });
            }
            else {
              $("<p>No recommendations found:</p><dl><dt>Collection</dt><dd>TODO</dd><dt>Scope</dt><dd>TODO</dd></dl>").appendTo("#funnelback-recommender");
            }

          }
        });
    }

  }
*/



/*
  Runtime logic and event bindings
*/
  //On DOM Ready
  $(function () {

  });

}(jQuery, window, stencils) );
