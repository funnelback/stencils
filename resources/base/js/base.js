/*
  Stencil: Base
  Description: Javascript for base search.
*/

/**
 * Protect window.console method calls, e.g. console is not defined on IE
 * unless dev tools are open, and IE doesn't define console.debug
 *
 * Chrome 41.0.2272.118: debug,error,info,log,warn,dir,dirxml,table,trace,assert,count,markTimeline,profile,profileEnd,time,timeEnd,timeStamp,timeline,timelineEnd,group,groupCollapsed,groupEnd,clear
 * Firefox 37.0.1: log,info,warn,error,exception,debug,table,trace,dir,group,groupCollapsed,groupEnd,time,timeEnd,profile,profileEnd,assert,count
 * Internet Explorer 11: select,log,info,warn,error,debug,assert,time,timeEnd,timeStamp,group,groupCollapsed,groupEnd,trace,clear,dir,dirxml,count,countReset,cd
 * Safari 6.2.4: debug,error,log,info,warn,clear,dir,dirxml,table,trace,assert,count,profile,profileEnd,time,timeEnd,timeStamp,group,groupCollapsed,groupEnd
 * Opera 28.0.1750.48: debug,error,info,log,warn,dir,dirxml,table,trace,assert,count,markTimeline,profile,profileEnd,time,timeEnd,timeStamp,timeline,timelineEnd,group,groupCollapsed,groupEnd,clear
 */
(function() {
  // Union of Chrome, Firefox, IE, Opera, and Safari console methods
  var methods = ["assert", "assert", "cd", "clear", "count", "countReset",
    "debug", "dir", "dirxml", "dirxml", "dirxml", "error", "error", "exception",
    "group", "group", "groupCollapsed", "groupCollapsed", "groupEnd", "info",
    "info", "log", "log", "markTimeline", "profile", "profileEnd", "profileEnd",
    "select", "table", "table", "time", "time", "timeEnd", "timeEnd", "timeEnd",
    "timeEnd", "timeEnd", "timeStamp", "timeline", "timelineEnd", "trace",
    "trace", "trace", "trace", "trace", "warn"];
  var length = methods.length;
  var console = (window.console = window.console || {});
  var method;
  var noop = function() {};
  while (length--) {
    method = methods[length];
    // define undefined methods as noops to prevent errors
    if (!console[method])
      console[method] = noop;
  }
})();


var stencils = { module : {} };

stencils.module.base = (function ($, window, stencils, undefined) {
  /*
    masonry

    @author Robert Prib
    @desc Masonry is a plugin for helping layout grids. See http://masonry.desandro.com/#getting-started.
    @setup Default item selector is '[data-masonry-item]'
    @usage
      <div data-masonry="<OPTIONS>"></div>
      e.g. <div data-masonry='{"itemSelector" : ".item"}'></div>
    @dependencies masonry.pkgd.min.js
  */
  function masonryjs() {
    $("[data-masonry]").each(function () {
      var $masonry = $(this);
      //default options
      var options = {
        "itemSelector": "[data-masonry-item]",
        "percentPosition" : true,
        "isFitWidth": true
      };
      if ($masonry.data("masonry-options")) {
        $.extend(options, JSON.parse($masonry.data("masonry-options")));
      }

      if ( typeof $.fn.masonry !== 'undefined') $masonry.masonry(options);
    });
  }

  /*
    momentjs

    @author Robert Prib
    @desc Moment is a plugin for helping format time and dates. See http://masonry.desandro.com/#getting-started.
    @usage
      <div data-moment="<ACTION>" data-moment-datetime="<DATE_TO_ADJUST>"></div>
      e.g. <small data-moment="relative" data-moment-datetime="${_.date?datetime}">${s.result.date?date?string("d MMM yyyy")}</small>
    @dependencies masonry.pkgd.min.js
  */
  function momentjs() {
    $("[data-moment]").each(function () {
      var $moment = $(this);
      var action = $moment.data("moment");
      var datetime = $moment.data("moment-datetime");

      switch(action) {

        case "relative" :
          $(this).html( moment(datetime).fromNow() )
          break;

        case "calendar" :
          $(this).html( moment(datetime).calendar() )
          break;
      }

    });


  }

  /*
    Button Show

    @author Robert Prib
    @desc Allows user to quickly create a button to display page elements on click
    @param data-button-show - Input css the selector for items to show
    @usage
      <button data-button-show="<CSS_SELECTOR>">Click me</button>
  */
  function buttonShowjs() {
    $("[data-button-show]").click(function(){
       $( $(this).data("button-show") ).show();
    });
  }

  /*
    Button Hide

    @author Robert Prib
    @desc Allows user to quickly create a button to hide page elements on click
    @param data-button-hide - Input css the selector for items to show

    @usage
      <button data-button-show="<CSS_SELECTOR>">Click me</button>
  */
  function buttonHidejs() {
    $("[data-button-hide]").click(function(){
       $( $(this).data("button-hide") ).hide();
    });
  }

  /* Allows panels to be clickable and adds a highlight class that change the view state.*/
  function clickablePanels(){
    //globals
    var NAME = "clickable-panel";
    var ACTIVE_CLASS = "panel-highlight";

    $("[data-"+ NAME +"]").click(function(){
      var $panel = $(this);
      var isSelected = $panel.is("." + ACTIVE_CLASS);
      var group = $panel.data(NAME);
      $("[data-"+ NAME +"= " + group + "]").removeClass(ACTIVE_CLASS);
      if(!isSelected) $panel.addClass(ACTIVE_CLASS);
    });
  }

  function printBtn(){
    $("[data-print-btn]").click(function(){
      window.print();
    });
  }



  /*
    Runtime logic and event bindings
  */

  //On DOM Ready
  $(function () {
    masonryjs();
    momentjs();
    buttonShowjs();
    buttonHidejs();
    clickablePanels();
    printBtn();
  });

  //Progressively run after a couple of images have loaded
  $("img").load(function(){
    if ($.isFunction(masonryjs)) masonryjs();
  });


  //Allow other methods to call redraw of masonry on demand
  $(window).on("base-stencil-masonry", function(){
    if ($.isFunction(masonryjs)) masonryjs();
  });

}(jQuery, window, stencils) );
