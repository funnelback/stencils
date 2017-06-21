package com.funnelback.stencils.hook.facets

import groovy.transform.ToString

/**
 * An augmented Facet used in the facets Stencil
 *
 * @author nguillaumin@funnelback.com
 */
@ToString
class StencilFacet {

    /** Facet name (e.g. "Location") */
    String name

    /**
     * List of values for this facet. Any hierarchical values will have been flattened
     */
    List<StencilCategoryValue> values

    /** URL to use to unselect all possible values of this facet, built from the current URL */
    String unselectAllUrl

    /**
     * <code>facetScope</code> parameter value to use to clear all possible values of this facet,
     * built from the current facetScope. Useful to use as an hidden input in a form
     */
    String unselectAllFacetScope

    /**
     * @return List of selected values, useful to build breadcrumbs
     */
    List<StencilCategoryValue> getSelectedValues() {
        return values.findAll() { v -> v.selected }
    }

    /**
     * @return List of unselected values
     */
    List<StencilCategoryValue> getUnselectedValues() {
        return values.findAll() { v -> !v.selected }
    }

    /**
     * @return True if any of the values of this facet is selected
     */
    boolean isSelected() {
        return values.any() { v -> v.selected }
    }
}
