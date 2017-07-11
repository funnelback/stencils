package com.funnelback.stencils.hook.facets

import com.funnelback.publicui.search.model.transaction.Facet
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

/**
 * An augmented CategoryValue used in the facets Stencil
 *
 * @author nguillaumin@funnelback.com
 */
@ToString
@EqualsAndHashCode
class StencilCategoryValue extends Facet.CategoryValue {

    /** Name of the query string parameter for this value (e.g. <code>f.Location|X</code>) */
    String queryStringParamName

    /** Value of the query string parameter for this value (e.g. <code>Syndey</code>) */
    String queryStringParamValue

    /** URL to use to select this facet, built from the current URL */
    String selectUrl

    /** URL to use to unselect this facet, built from the current URL */
    String unselectUrl

    /**
     * Augment a CategoryValue
     * @param value CategoryValue to augment
     */
    StencilCategoryValue(Facet.CategoryValue value) {
        super(value.data,
                value.label,
                value.count,
                value.queryStringParam,
                value.constraint,
                value.selected)

        this.queryStringParamName = URLDecoder.decode(queryStringParam.split("=")[0], "UTF-8")
        this.queryStringParamValue = URLDecoder.decode(queryStringParam.split("=")[1], "UTF-8")
    }

}
