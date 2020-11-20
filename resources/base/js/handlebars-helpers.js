/**
 * Custom handlebars helpers for Funnelback templating
 */
if (!window.Funnelback) window.Funnelback = {}; // create namespace

if (!Handlebars) {
  throw new Error('Handlebars must be included (https://handlebarsjs.com/)')
}
if (!window.Funnelback.Handlebars) {
	window.Funnelback.Handlebars = Handlebars.create();
}

window.Funnelback.Handlebars.registerHelper({
    // Cut the left part of a string if it matches the provided `toCut` string
    // Usage: {{#cut "https://"}}{{indexUrl}}{{/cut}}
    cut: function(toCut, options) {
      const str = options.fn(this);
      if (str.indexOf(toCut) === 0) return str.substring(toCut.length);
      return str;
    },
    // Truncate content to provided length
    // Usage: {{#truncate 70}}{{title}}{{/truncate}}
    truncate: function (len, options) {
      const str = options.fn(this);
      if (str && str.length > len) {
          let newStr = str + " ";
          newStr = str.slice(0, len);
          newStr = str.slice(0, newStr.lastIndexOf(" "));
          newStr = (newStr.length > 0) ? newStr : str.slice(0, len);
          return new window.Funnelback.Handlebars.SafeString(newStr +'...'); 
      }
      return str;
    },
    /**
     * Splits a string by a delimiter and returns an iterated list of
     * the items in that string. 
     * 
     * Optional arguments:
     * delimiter: character to split by (default == '|')
     * joinWith: character to join with (default == '')
     * 
     * {{ this }} is substituted with the current item in the list
     * 
     * Example input:
     * metaData.courseTerm == "Spring|Summer|Fall"
     * 
     * Simple usage:
     * <ul>{{#list metaData.courseTerm}}<li>{{ this }}</li>{{/list}}</ul>
     * Output:
     * --> <ul><li>Spring</li><li>Summer</li><li>Fall</li></ul>
     * 
     * Use a different delimiter:
     * <ul>{{#list metaData.courseTermCommas delimiter=","}}<li>{{ this }}</li>{{/list}}</ul>
     * --> <ul><li>Spring</li><li>Summer</li><li>Fall</li></ul>
     * 
     * Join with commas:
     * <span>{{#list metaData.courseTerm joinWith=", "}}{{ this }}{{/list}}</span>
     * --> <span>Spring, Summer, Fall</span>
     * 
     * Multiple substitution:
     * {{#list metaData.courseTerm}}<a href="https://example.com/{{ this }}">{{ this }}</a>{{/list}}
     * --> 
     * <a href="https://example.com/Spring">Spring</a>
     * <a href="https://example.com/Summer">Summer</a>
     * <a href="https://example.com/Fall">Fall</a>
     */
    list: function (list, options) {
      const delimiter = options.hash.delimiter || '|'
      const joinWith = options.hash.joinWith || ''
      return list.split(delimiter).map(item => options.fn(item)).join(joinWith)
    },
});
