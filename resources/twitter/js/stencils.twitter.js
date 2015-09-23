'use strict';
/*
  Stencil: Twitter
  Description: Javascript specifically for twitter stencils.
*/


var stencils = typeof stencils === "object" ? stencils : { module : {} };
stencils.module.twitter = (function ($, window, stencils, undefined) {

  /**
   * @module stencils > twitter > TweetEmbed
   * @author Robert Prib
   * @desc Binds data elements to create an embeded tweet on DOMReady.
   * @example
   *  <div data-stencils-tweet-embed="<TWEET_ID>"" data-stencils-tweet-embed-<OPTION_NAME>="<TWEET_EMBED_OPTIONS>"></div>
   *  <div data-stencils-tweet-embed="102" data-tweet-embed-conversation="none" data-stencils-tweet-embed-width="550"></div>
  */
  function dataBindTweetEmbed() {
    $("[data-stencils-tweet-embed]").each(function () {
      var $tweet = $(this);
      var ID = $tweet.data("data-stencils-tweet-embed"),
      //default options
      options = {
        conversation : "none",
        //max width for embeds is 550 so if its less automatically calulate and set.
        width : $tweet.outerWidth() > 550 ? 550 : $tweet.outerWidth()
      };

      //extend js options.
      for(var option in options) {
        if(options.hasOwnProperty(option)){
          options[option] = $container.data("data-stencils-tweet-embed-" +  option.toLowerCase() ) || options[option];
        }
      }

      tweetEmbed(this, ID, options);
    });
  }

  /**
   * @function createTweetEmbed
   * @author Robert Prib
   * @desc transforms a dom element into a embeded twitter tweet using twitters api.
   * @param {Domnode} el - Dom node to replace with embeded tweet.
   * @param {String} ID - ID of tweet to embed
   * @param {object} options - Set extra options which can be passed through
   * See https://dev.twitter.com/web/embedded-tweets/javascript-create.
   * See full list of tweet options at https://dev.twitter.com/web/embedded-tweets/parameters
   * Requires https://platform.twitter.com/widgets.js
  */
  function createTweetEmbed(el, ID, options){
    $(el).html("");
    if (!$.isEmptyObject(twttr)) {
      twttr.widgets.createTweet(
        ID,
        el,
        options
      )
    }
  }

  /*
    Runtime logic and event bindings
  */

  //On DOM Ready
  $(function () {
   //Get third party dependencies
    $.getScript("https://platform.twitter.com/widgets.js", function () {
      dataBindTweetEmbed();
    });
  });



}(jQuery, window, stencils) );
