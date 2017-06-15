package com.funnelback.stencils.hook.core

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

/**
 * Class holding paging controls
 */
@EqualsAndHashCode
@ToString
class PagingControls {

    /** URL of the previous page of results. May be null when on the first page */
    String previousUrl

    /** URL of the next page of results. May be null when on the last page */
    String nextUrl

    /** URL of the first page of results */
    String firstUrl

    /** List of pages surrounding the current one */
    List<Page> pages = new ArrayList<>()

}
