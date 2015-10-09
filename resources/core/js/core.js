/*
  Stencil: Core
  Description: Javascript specifically for core stencils.
*/
jQuery(document).ready( function() {

  // jQuery.widget.bridge('uitooltip', jQuery.ui.tooltip);

  jQuery('[data-toggle=tooltip]').tooltip({'html': true});

  // Faceted Navigation more/less links
  var displayedCategories = 8;

  jQuery('div.facet ul').each( function() {
      jQuery(this).children('li:gt('+(displayedCategories-1)+')').hide();
  });

  jQuery('.search-toggle-more-categories').each( function() {
    var nbCategories = jQuery(this).parent().parent().find('li').size();
    if ( nbCategories <= displayedCategories ) {
      jQuery(this).hide();
    } else {
      jQuery(this).css('display', 'block');
      jQuery(this).click( function() {
        if (jQuery(this).attr('data-state') === 'less') {
          jQuery(this).attr('data-state', 'more');
          jQuery(this).parent().parent().find('li:gt('+(displayedCategories-1)+')').hide();
          jQuery(this).find('span').text(jQuery(this).attr('data-more'));
        } else {
          jQuery(this).attr('data-state', 'less');
          jQuery(this).parent().parent().find('li').css('display', 'block');
          jQuery(this).find('span').text(jQuery(this).attr('data-less'));
        }
      });
    }
  });

  jQuery('.search-geolocation').click( function() {
    try {
      navigator.geolocation.getCurrentPosition( function(position) {
        // Success
        var latitude  = Math.ceil(position.coords.latitude*10000) / 10000;
        var longitude = Math.ceil(position.coords.longitude*10000) / 10000;
        var origin = latitude+','+longitude;
        jQuery('#origin').val(origin);
      }, function (error) {
        // Error
      }, { enableHighAccuracy: true });
    } catch (e) {
      alert('Your web browser doesn\'t support this feature');
    }
  });
});
