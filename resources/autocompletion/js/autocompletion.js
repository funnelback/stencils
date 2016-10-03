/*
 * Stencil: Auto-Completion
 * version: 0.1
 * by: Liliana Nowak
 * description: Javascript specifically for auto-completion stencils.
 */

var stencils = stencils || {module: {}};
stencils.module.autocompletion = (function($, window, stencils, undefined) {
  return {
    element: '[data-stencils-autocompletion]',
    options: {},
    run    : function(element, options) {
      if (element) this.element = element;
      if (options) this.options = options;

      $(this.element).qc(this.options);
    }
  };
}(jQuery, window, stencils));

/*
 * Funnelback Auto-Completion plugin
 * version 1.3.1.1
 *
 * author: Liliana Nowak
 * Copyright Funnelback, 2015
 *
 * @requires jQuery https://jquery.com/
 * @requires typeahead.js https://twitter.github.io/typeahead.js/
 */
(function($) {
  'use strict';

  var qc = function(element, options) {
    // Global references
    this.options  = null;
    this.$element = null;

    this.init(element, options);
  }

  // Default options
  qc.defaults = {
    // default settings, can be overwritten in general or per completion type
    collection    : null,         // 'string'; the collection name
    defaultCall   : null,         // 'string'|[]|{}; use to trigger auto-completion when input value is empty and length=0
    /*
    defaultCall   : {
      filter    : _processDataTopQueries, // function(completion, data); filter function used to map response data
      params    : {},                     // {}; list of parameters added to request
      url       : ''                      // 'string'; URL to call request
    },
    defaultCall   : '',           // 'string'; query to replace empty value and call request
    defaultCall   : [],           // [{value: '', label: ''}, {value: '', label: ''}]; list of hardcoded data to fulfill dropdown menu
    defaultCall   : {
      data      : [],             // []; list of hardcoded data
      filter    : function        // function(completion, data); filter function used to map hardcoded data
    },
    */
    filter        : _processTierData, // function(completion, suggestion, index); filter function used to map response data
    format        : 'extended',   // 'simple|extended'; mapping into 'json' or 'json++'
    itemLabel     : 'label',      // 'string'; the name of field to be displayed as label in dropdown
    profile       : '_default',   // 'string'; the profile name
    program       : '/s/suggest.json',
    show          : 10,           // integer; maximum number of suggestions to diplay in dropdown
    sort          : 0,
    template      : {},           // {notFound: '', pending: '', header: '', footer: '', suggestion: ''}
    templateHeader: '<h5 class="tt-category">{{category}}</h5>', // 'string'; required substring '{{category}}'; default template to display category header when concierge auto-completion is enabled
    templateMerge : true,         // true|false; to wrap notFound and pending template with header and footer template
    wildcard      : '%QUERY',     // 'string'; the value to be replaced in url with the URI encoded query
    // simple auto-completion
    simple        : {
      enabled   : true,          // true|false; to enable simple auto-completion
      name      : 'simple'      // 'string'; the name of the dataset that will be appended to {{classNames.dataset}} - to form the class name of the containing DOM element
    },
    // concierger auto-completion
    concierge     : {
      dataset   : null, // [{url: ''}]
      enabled   : false,
      name      : 'concierge'
    },
    // display settings
    length      : 3,            // integer; the minimum character length to trigger auto-completion
    horizontal  : false,        // true|false; if true, display datasets in columns, else one below the other
    scrollable  : false,        // true|false; to limit height of a menu dropdown to maxheight by adding vertical scroll       
    // typeahead settings
    typeahead: {
      classNames  : {},         // {}; to override any of default classes, more https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md#class-names
      highlight   : true,       // true|false; when suggestions are rendered, pattern matches for the current query in text nodes will be wrapped in a strong element with its class set to {{classNames.highlight}}
      hint        : false,      // true|false; to show a hint in input field,
      events      : {           // {eventName: function}; events get triggered on the input element during the life-cycle of a typeahead
        select  : function(event, suggestion) {
          _itemSelect(suggestion, $(event.target));
        }
      }        
    }
  };
  qc.mapKeys = ['collection', 'defaultCall', 'filter', 'format', 'group', 'itemGroup', 'itemLabel', 'profile', 'program', 'show', 'sort', 'template', 'templateMerge', 'wildcard'];
  qc.navCols = {cursor : null, query  : ''};
  qc.types   = ['simple', 'concierge'];

  // Public methods
  qc.prototype.init = function(element, options) {
    this.$element = $(element);
    this.options  = this.getOptions(options);

    if (_isEnabled(this.options)) this.initTypeahead();
    else this.destroy();
  }

  qc.prototype.destroy = function () {
    this.destroyTypeahead();

    this.$element = null;
    this.options  = null;
  }

  qc.prototype.horizontal = function() {
    if (this.options.horizontal) this.setTypeaheadClass('menu', 'tt-horizontal');
    return this.options.horizontal;
  }

  qc.prototype.scrollable = function() {
    if (this.options.scrollable) this.setTypeaheadClass('menu', 'tt-scrollable');
    return this.options.scrollable;
  }

  qc.prototype.getOptions = function(options) {
    options = $.extend(true, {}, _getOptionsDefault(), options || {}, _getOptionsData(this.$element));
    return _mapOptions(options);
  }

  // Typeahead
  qc.prototype.initTypeahead = function() {
    var that = this, data = [];

    if (that.options.simple.enabled) {
      if (that.options.concierge.enabled && $.exist(that.options.concierge.dataset)) _setTierTemplateHeader(that.options.simple, that.options.templateHeader);
      data.push(_getTierData(that.options.simple));
    }

    if (that.options.concierge.enabled && $.exist(that.options.concierge.dataset)) {
      $.each(that.options.concierge.dataset, function(i, set) {
        var options = $.extend(true, {}, that.options.concierge, set);
        _setTierTemplateHeader(options, that.options.templateHeader);
        data.push(_getTierData(options));
      });
    }

    that.horizontal();
    that.scrollable();

    that.$element.typeahead({
      minLength   : that.options.length,
      hint        : that.options.typeahead.hint,
      highlight   : that.options.typeahead.highlight,
      classNames  : that.options.typeahead.classNames
    }, data);

    if (that.options.typeahead.events) {
      $.each(that.options.typeahead.events, function(eventName, func) {
        that.$element.on('typeahead:' + eventName, func);
      });
    }

    if (that.options.horizontal) {
      var data = that.$element.data(),
          menu = that.$element.siblings('.tt-menu');

      data.ttTypeahead._onDownKeyed = function() {
        _navCursorUD(40, menu, that.$element);
      };
      data.ttTypeahead._onUpKeyed = function() {
        _navCursorUD(38, menu, that.$element);
      }

      var cols = menu.find('.tt-dataset');
      if (cols.size() > 1) {
        data.ttTypeahead._onLeftKeyed = function() {
          _navCursorLR(37, cols, that.$element);
        };
        data.ttTypeahead._onRightKeyed = function() {
          _navCursorLR(39, cols, that.$element);
        }
      }

      that.$element.on('keydown', function(event) {
        var code = event.keyCode || event.which;
        if (code == 38 || code == 40) return false;
        if ((code == 37 || code == 39) && $.exist(qc.navCols.cursor)) return false;
      });
    }
  }

  qc.prototype.destroyTypeahead = function() {
    this.$element.typeahead('destroy');
  }

  qc.prototype.setTypeaheadClass = function(name, className) {
    if (!$.exist(this.options.typeahead.classNames[name], true)) this.options.typeahead.classNames[name] = 'tt-' + name; // default class
    this.options.typeahead.classNames[name] += ' ' + className;
  }

  // Private methods
  function _isEnabled(options) {
    var bState = false;
    for (var i = 0, len = qc.types.length; i < len; i++) {
      if($.exist(options[qc.types[i]].collection, true)) bState = true;
    };

    return $.exist(options.collection, true) || bState;
  }

  // Handle options
  function _getOptionsData(element) {
    var options = {}, keys = $.dataKeys(_getOptionsDefault()), splitKeys, data, i, len;
    for (i = 0, len = keys.length; i < len; i++) {
      data = element.data('qc-' + keys[i].toLowerCase());
      if (!$.isDefinied(data)) continue;

      splitKeys = keys[i].split('-');
      if (splitKeys.length > 1) {
        if (!options[splitKeys[0]]) options[splitKeys[0]] = {};
        options[splitKeys[0]][splitKeys[1]] = data;
      }
      else options[keys[i]] = data;
    }
    return options;
  }

  function _getOptionsDefault() {
    return qc.defaults;
  }

  function _mapOptions(options) {
    var map = {};
    $.each(qc.mapKeys, function(i, key) { map[key] = options[key] });
    $.each(qc.types, function(i, type) { options[type] = $.extend(true, {}, map, options[type]); options[type]['type'] = type; });
    return options;
  }

  // Handle tier
  function _getTierData(tier) {
    var engine = new Bloodhound({
      datumTokenizer : Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer : Bloodhound.tokenizers.whitespace,
      limit          : tier.show,  
      remote         : {
        url      : tier.url ? tier.url : _getTierUrl(tier),
        wildcard : tier.wildcard,
        filter   : function (response) {return $.map(response, function(suggestion, i) { return tier.filter(tier, suggestion, i) })}
      }
    });
    engine.initialize();

    return {
      name       : tier.name,
      limit      : 10000, // hack to display all returned data
      source     : source,
      displayKey : tier.itemLabel,
      templates  : _renderTierTemplate(tier)
    };

    function source(query, sync, async) {
      if (query.length < 1 && tier.defaultCall) {
        if ($.isString(tier.defaultCall)) {
          query = tier.defaultCall;
        }
        else if ($.isArray(tier.defaultCall)) {
          sync(tier.defaultCall);
          return;
        }
        else if ($.exist(tier.defaultCall.data)) {
          sync(tier.defaultCall.data);
          return;
        }
        else if ($.exist(tier.defaultCall.url, true)) {
          $.get(tier.defaultCall.url, tier.defaultCall.params, function(data) {
            async(tier.defaultCall.filter(tier, data));
            return;
          });
        }
      }

      engine.search(query, sync, async);
    }
  }

  function _getTierUrl(tier) {
    return tier.program
      + '?collection=' + tier.collection
      + '&partial_query=' + tier.wildcard
      + '&show=' + tier.show
      + '&sort=' + tier.sort
      + '&fmt=' + (tier.format == 'simple' ? 'json' : 'json++') 
      + ($.exist(tier.profile, true) ? '&profile=' + tier.profile : '' );
  }

  function _processTierData(tier, suggestion, i) {
    return {
      label    : (suggestion.disp) ? suggestion.disp : suggestion.key,
      value    : (suggestion.action_t == 'Q') ? suggestion.action : suggestion.key,
      extra    : suggestion,
      category : suggestion.cat ? suggestion.cat : tier.category,
      rank     : i + 1
    };
  }

  function _renderTierTemplate(tier) {
    $.each(tier.template, function(k, obj) {
      if ($.isObject(obj)) tier.template[k] = obj.prop('outerHTML');
    });

    if (tier.templateMerge) {
      templateMerge('notFound');
      templateMerge('pending');
    }

    $.each(tier.template, function(k, obj) {
      if ($.isString(obj)) tier.template[k] = Handlebars.compile(obj);
    });

    return tier.template;

    function templateMerge(temp) {
      if (tier.template[temp] && $.isString(tier.template[temp])) {
        if (tier.template.header && $.isString(tier.template.header)) tier.template[temp] = tier.template.header + tier.template[temp];
        if (tier.template.footer && $.isString(tier.template.footer)) tier.template[temp] += tier.template.footer;
      }
    }
  }

  function _setTierTemplateHeader(tier, template) {
    if (!tier.template.header) tier.template.header = template.replace('{{category}}', tier.name.capitalize());
  }

  // Handle tier item
  function _itemSelect(item, target) {
    if ($.exist(item.extra)) {
      switch(item.extra.action_t) {
        case 'C':
          eval(item.extra.action); break;
        case 'U':
          document.location = item.extra.action; break;
        case 'E':
          break;
        case undefined:
        case '':
          formSend(item.value); break;
        case 'S':
          formSend(item.extra.key); break;
        case 'Q':
        default:
          formSend(item.extra.action); break;
      }
    } else {
      formSend(item.value);
    }

    function formSend(val) { // Submit form on select
      target.val(val);
      target.closest('form').submit();
    }
  }

  function _getSelectableLabel(item) {
    return $.exist(item.data()) ? item.data().ttSelectableDisplay : item.text();
  }

  // Handle Typeahead navigation
  function _navCursorLR(code, cols, target) {
    if (!$.exist(qc.navCols.cursor)) return;

    var currCol      = qc.navCols.cursor.parent(),
        currColIdx   = cols.index(currCol),
        delta        = code == 37 ? -1 : 1,
        nextColItems = getNextColItems(currColIdx),
        cursorIdx    = $(currCol).children('.tt-selectable').index(qc.navCols.cursor),
        nextCursor   = $.exist(nextColItems[cursorIdx]) ? nextColItems[cursorIdx] : nextColItems[nextColItems.length - 1];

    $(qc.navCols.cursor).removeClass('tt-cursor');
    qc.navCols.cursor = $(nextCursor).addClass('tt-cursor');
    target.data().ttTypeahead.input.setInputValue(_getSelectableLabel(qc.navCols.cursor));

    function getNextColItems(currColIdx) {
      var nextColIdx = code == 37
        ? $.exist(cols[currColIdx - 1]) ? currColIdx - 1 : cols.length - 1
        : $.exist(cols[currColIdx + 1]) ? currColIdx + 1 : 0,
        nextColItems = $(cols[nextColIdx]).children('.tt-selectable');

      return $.exist(nextColItems) ? nextColItems : getNextColItems(nextColIdx);
    }
  }

  function _navCursorUD(code, menu, target) {
    if (!$.exist(menu.find('.tt-cursor'))) {
      qc.navCols.cursor = code == 38 ? menu.find('.tt-selectable').last() : menu.find('.tt-selectable').first();
      qc.navCols.cursor.addClass('tt-cursor');
      qc.navCols.query  = target.val();
      target.data().ttTypeahead.input.setInputValue(_getSelectableLabel(qc.navCols.cursor));
      return;
    }

    var currCol      = qc.navCols.cursor.parent(),
        currColItems = $(currCol).children('.tt-selectable');

    if(!$.exist(currColItems)) return;

    var cursorIdx  = currColItems.index(qc.navCols.cursor), delta = code == 38 ? -1 : 1;
    
    $(qc.navCols.cursor).removeClass('tt-cursor');

    if (!$.exist(currColItems[cursorIdx + delta])) {
      qc.navCols.cursor = null;
      target.data().ttTypeahead.input.resetInputValue();
      target.data().ttTypeahead._updateHint();
    }
    else {
      qc.navCols.cursor = $(currColItems[cursorIdx + delta]).addClass('tt-cursor');
      target.data().ttTypeahead.input.setInputValue(_getSelectableLabel(qc.navCols.cursor));
    }
  }

  // Generate plugin
  function Plugin(option) {
    return this.each(function () {
      var $this = $(this),
        data    = $this.data('fb.qc'),
        options = $.isObject(option) && option;

      if (!data && /destroy|hide/.test(option)) return;
      if (!data) $this.data('fb.qc', (data = new qc(this, options)));
      if ($.isString(option) && $.isFunction(data[option])) data[option]();
    });
  }

  $.fn.qc             = Plugin;
  $.fn.qc.Constructor = qc;

  // Helpers
  $.exist      = function(selector, bString) { if (!$.isDefinied(bString)) bString = false; var obj = bString ? selector : $(selector); return $.isDefinied(obj) && obj != null && obj.length > 0; }
  $.isDefinied = function(obj) { return typeof(obj) !== 'undefined'; }
  $.isFunction = function(obj) { return typeof(obj) === 'function'; }
  $.isString   = function(obj) { return typeof(obj) === 'string'; }
  $.isObject   = function(obj) { return typeof(obj) === 'object'; }     
  $.dataKeys   = function(obj) { return iterateKeys(obj, ''); function iterateKeys(obj, prefix) { return $.map(Object.keys(obj), function(key) { if(obj[key] && $.isObject(obj[key])) return iterateKeys(obj[key], key); else return (prefix ? prefix + '-' + key : key);}); }}

}(jQuery));

String.prototype.capitalize = function() { return this.charAt(0).toUpperCase() + this.slice(1); }