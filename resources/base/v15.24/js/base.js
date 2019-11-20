
/**
 * Setup handlers for the more/less buttons on facets
 *
 * These buttons are automatically inserted if there are more facet values than
 * the configured amount.
 * 
 * Polyfills: Element.prototype.matches, Element.prototype.closest
 * NodeList.forEach not used to reduce bundle size
 * 
 * Browser Compatibility: bundled version is theoretically compatible to IE8+
 * 
 * @param displayedCategories Number of facet values that will cause a button
 *  to be inserted
 * @param facetSelector CSS selector to find a facet
 */

const setupFacetLessMoreButtons = (displayedCategories = 8, facetSelector = 'div.facet') => {
    /* Initialize by hiding values beyond the limit */
    const facets = document.querySelectorAll(facetSelector)
    for (let i = 0; i < facets.length; i++) {
        const values = facets[i].querySelectorAll('li')
        for (let j = displayedCategories; j < values.length; j++) {
            values[j].style.display = 'none'
        }
    }

    /* Event handler called by clicking toggle */
    function showMoreValues() {
        /* Show all values */
        const values = this.closest(facetSelector).querySelectorAll('li')
        for (let i = displayedCategories; i < values.length; i++) {
            values[i].style.display = 'block'
        }

        /* Toggle state to show less values on the next click */
        this.setAttribute('data-state', 'less')
        this.setAttribute('title', this.getAttribute('data-title-less'))
        this.querySelector('span').textContent = this.getAttribute('data-less')
        this.querySelector('small').classList.add('fa-minus')
        this.querySelector('small').classList.remove('fa-plus')
    }

    function showLessValues() {
        /* Hide values beyond the limit */
        const values = this.closest(facetSelector).querySelectorAll('li')
        for (let i = displayedCategories; i < values.length; i++) {
            values[i].style.display = 'none'
        }

        /* Toggle state to show more values on the next click */
        this.setAttribute('data-state', 'more')
        this.setAttribute('title', this.getAttribute('data-title-more'))
        this.querySelector('span').textContent = this.getAttribute('data-more')
        this.querySelector('small').classList.remove('fa-minus')
        this.querySelector('small').classList.add('fa-plus')
    }

    /* Event handler called when clicking the button */
    function handleClick() {
        this.getAttribute('data-state') === 'less' 
            ? showLessValues.call(this) 
            : showMoreValues.call(this)
    }

    /* If there are fewer values than the limit, hide the toggle */
    /* Otherwise, show the toggle and assign the event listener */
    const toggles = document.querySelectorAll('.search-toggle-more-categories')
    for (let i = 0; i < toggles.length; i++) {
        const valuesCount = toggles[i].closest(facetSelector).querySelectorAll('li').length
        if (valuesCount <= displayedCategories) {
            toggles[i].style.display = 'none'
        } else {
            toggles[i].style.display = 'block'
            toggles[i].addEventListener('click', handleClick.bind(toggles[i]))
        }
    }
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
 * @param imageSelector CSS selector to find the images to process
 */

const setupDeferredImages = (imageSelector = 'img.deferred') => {
    const images = document.querySelectorAll(imageSelector)
    for (let i = 0; i < images.length; i++) {
        const image = images[i]
        image.onload = () => image.style.display = 'inline'
        image.onerror = () => {
            image.style.display = 'none'
            image.onerror = null
        }
        image.setAttribute('src', image.getAttribute('data-deferred-src'))
    }
}

/* Element.prototype.matches polyfill for IE */
/* https://developer.mozilla.org/en-US/docs/Web/API/Element/matches */
if (!Element.prototype.matches) {
  Element.prototype.matches = 
      Element.prototype.matchesSelector || 
      Element.prototype.mozMatchesSelector ||
      Element.prototype.msMatchesSelector || 
      Element.prototype.oMatchesSelector || 
      Element.prototype.webkitMatchesSelector ||
      function(s) {
        var matches = (this.document || this.ownerDocument).querySelectorAll(s),
            i = matches.length;
        while (--i >= 0 && matches.item(i) !== this) {}
        return i > -1;            
      };
}

/* Element.prototype.closest polyfill for IE */
/* https://developer.mozilla.org/en-US/docs/Web/API/Element/closest */
if (!Element.prototype.closest) {
    Element.prototype.closest = function(s) {
        var el = this
        do {
            if (el.matches(s)) return el
            el = el.parentElement || el.parentNode
        } while (el !== null && el.nodeType === 1)
        return null
    }
}
