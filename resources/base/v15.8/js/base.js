/**
 * Setup handlers for the more/less buttons on facets
 *
 * These buttons are automatically inserted if there are too many favec
 * values.
 *
 * @param displayedCategories Number of facet values that will cause a button
 *  to be inserted
 * @param facetSelector jQuery selector to find a facet
 */
function setupFacetLessMoreButtons(displayedCategories, facetSelector) {
    // Faceted Navigation more/less links
    displayedCategories = displayedCategories || 8;
    facetSelector = facetSelector || 'div.facet';

    jQuery(facetSelector).each( function() {
        jQuery(this).find('li:gt('+(displayedCategories-1)+')').hide();
    });

    jQuery('.search-toggle-more-categories').each( function() {
      var nbCategories = jQuery(this).closest(facetSelector).find('li').length;
      if ( nbCategories <= displayedCategories ) {
        jQuery(this).hide();
      } else {
        jQuery(this).css('display', 'block');
        jQuery(this).click( function() {
          if (jQuery(this).attr('data-state') === 'less') {
            jQuery(this).attr('data-state', 'more');
            jQuery(this).attr('title', jQuery(this).data('title-more'));
            jQuery(this).closest(facetSelector).find('li:gt('+(displayedCategories-1)+')').hide();
            jQuery(this).find('span').text(jQuery(this).attr('data-more'));
            jQuery(this).find('small').removeClass('fa-minus');
            jQuery(this).find('small').addClass('fa-plus');
          } else {
            jQuery(this).attr('data-state', 'less');
            jQuery(this).attr('title', jQuery(this).data('title-less'));
            jQuery(this).closest(facetSelector).find('li').css('display', 'block');
            jQuery(this).find('span').text(jQuery(this).attr('data-less'));
            jQuery(this).find('small').removeClass('fa-plus');
            jQuery(this).find('small').addClass('fa-minus');
          }
        });
      }
    });
}

/**
 * Process deferred images.
 *
 * Deferred images are not loaded immediately so that we have an opportunity
 * to attach an error handler to them, in order to hide the images that fail to
 * load. This is especially useful when images are scraped from the content
 * and there's no way to know if they are valid or not.
 *
 * This works by having the image SRC pointing to a 1x1 transparent GIF,
 * registering an error handler for the images, and then replacing
 * the `src` attribute by the value of `data-deferred-src` which contains
 * the real image URL
 *
 * @param imageSelector jQuery selector to find the images to process
 */
function setupDeferredImages(imageSelector) {
    imageSelector = imageSelector || 'img.deferred';

    jQuery(imageSelector)
    .on('load', function() {
        // Show images that succeed to load
        jQuery(this).show();
    })
    .on('error', function() {
        // Hide images that fail to load
        jQuery(this).unbind('error');
        jQuery(this).hide();
    }).each(function() {
        // Replace the SRC attribute, causing the image to load
        jQuery(this).attr('src', jQuery(this).attr('data-deferred-src'));
    });
}
