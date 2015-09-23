/* Funnelback: Faceted Navigation UI support
 * -
 * $Id: funnelback-faceted-navigation.js 39138 2014-05-22 11:34:18Z nguillaumin $
 *
 * Copyright Funnelback 2011
 */
 /*
  FBAPP - Added for people app
 */

(function() {

    // Quotes a regex by escaping any special chars
    var quoteRegex = function(str) {
        return str.replace(/([|.?*+^$[\]\\(){}-])/g, "\\$1");
    };


    jQuery(document).ready( function() {
         //FBAPP This will tag a button corresponding to a selected facet
         if(jQuery('#facetScope').length > 0){

            var value = jQuery('#facetScope').attr('value');
            var getlabel = value.match(/=[a-z]/g);
            jQuery.each( getlabel, function( index, value ){
                var replabel=value.replace('=','#');
                jQuery('input'+replabel).prop('checked',true);
            });   

        }
        //FBAPP

        // For each checkbox, in case of multiple selection mode
        // we'll add an onclick() handler that will update the
        // 'facetScope' input field in the main search form
        jQuery('input.fb-facets-value').click( function() {
            if ( jQuery('#facetScope').length < 1) {
                // Create the 'facetScope' input field
                // Added value="" for people-app
                jQuery('#search-form-query .input-inline').append('<input type="hidden" name="facetScope" id="facetScope" value=""/>');
            }

            var name = jQuery(this).attr('name');
            var value = jQuery(this).attr('value');

            //FBAPP - Update escape to encodeURI 
            var facetScope = encodeURI(jQuery('#facetScope').attr('value')) || '';
            var reUnescaped = new RegExp('&?'+quoteRegex(name)+'='+quoteRegex(value));
            var reEscaped = new RegExp('&?'+quoteRegex(encodeURI(name))+'='+quoteRegex(encodeURI(value)));
            //FBAPP - get facet regex for index
            var remove = new RegExp('&?'+quoteRegex(name)+'=[a-z,A-Z]')
            //FBAPP
            var alreadyThere = reEscaped.test(facetScope);

            if (jQuery(this).is(':checked') && ! alreadyThere) {
                // Add the new constraint to the current facet scope
                //FBAPP Add this line to prevent multifacet selection
                jQuery('#facetScope').attr('value', jQuery('#facetScope').attr('value').replace(remove, ''));
                //FBAPP
                jQuery('#facetScope').attr('value', jQuery('#facetScope').attr('value') + '&'+name+'='+value);
                //FBAPP
                jQuery('#search-form-query form').submit();
                //FBAPP
            } else if ( ! jQuery(this).is(':checked') && alreadyThere) {
                // Remove the constraint from the current facet scope
                jQuery('#facetScope').attr('value', jQuery('#facetScope').attr('value').replace(reUnescaped, ''));
                //FBAPP
                jQuery('#search-form-query form').submit();
                //FBAPP
            }
        });
    });
})();
