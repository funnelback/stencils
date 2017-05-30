package com.funnelback.stencils.hook.facets

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

/**
 * A currently selected facet value
 *
 * @author nguillaumin@funnelback.com
 */
@ToString
@EqualsAndHashCode
class StencilSelectedFacetValue {

    /** Name of the selected facet (e.g. "Location") */
    String facetName

    /** Value being selected (e.g. "Sydney") */
    String value

    /** URL to use to unselect this facet, built from the current URL */
    String unselectUrl

}
