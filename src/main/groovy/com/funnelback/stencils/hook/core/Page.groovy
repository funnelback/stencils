package com.funnelback.stencils.hook.core

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

/**
 * A results page
 */
@EqualsAndHashCode
@ToString
class Page {

    /** Page number */
    int number

    /** URL to the page */
    String url

    /** If this page is the current one or not */
    boolean selected
}
