/* Funnelback: Faceted Navigation UI support
 * -
 * $Id: funnelback-faceted-navigation.js 39138 2014-05-22 11:34:18Z nguillaumin $
 *
 * Copyright Funnelback 2011
 */

(function() {

    // Quotes a regex by escaping any special chars
    var quoteRegex = function(str) {
        return str.replace(/([|.?*+^$[\]\\(){}-])/g, "\\$1");
    };

    jQuery(document).ready( function() {

        // For each checkbox, in case of multiple selection mode
        // we'll add an onclick() handler that will update the
        // 'facetScope' input field in the main search form
        jQuery('input.fb-facets-value').click( function() {
            if ( jQuery('#facetScope').length < 1) {
                // Create the 'facetScope' input field
                jQuery('#fb-queryform .checkbox-inline').append('<input type="hidden" name="facetScope" id="facetScope" />');
            }

            var name = jQuery(this).attr('name');
            var value = jQuery(this).attr('value');

            var facetScope = unescape(jQuery('#facetScope').attr('value')) || '';
            var reUnescaped = new RegExp('&?'+quoteRegex(name)+'='+quoteRegex(value));
            var reEscaped = new RegExp('&?'+quoteRegex(escape(name))+'='+quoteRegex(escape(value)));
            var alreadyThere = reUnescaped.test(facetScope);

console.log("facetscope: "+facetScope);
console.log("reUnescaped: "+facetScope);
console.log("reEscaped: "+facetScope);
console.log("alreadyThere: "+facetScope);
            if (jQuery(this).is(':checked') && ! alreadyThere) {
                // Add the new constraint to the current facet scope
                jQuery('#facetScope').attr('value', jQuery('#facetScope').attr('value') + '&'+name+'='+value);
            } else if ( ! jQuery(this).is(':checked') && alreadyThere) {
                // Remove the constraint from the current facet scope
                jQuery('#facetScope').attr('value', jQuery('#facetScope').attr('value').replace(reEscaped, ''));
            }
console.log("Final facetscope string: "+ jQuery(this).attr('value'));
        });
    });
})();
