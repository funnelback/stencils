package com.funnelback.stencils.hook.core

import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.hook.support.HookLifecycle

/**
 * <p>Hook functions for the Contextual Navigation within the Core Stencil</p>
 *
 * @author nguillaumin@funnelback.com
 */

class ContextualNavigationHookLifecycle implements HookLifecycle {

    /** Name of the site cluster */
    static final SITE_CLUSTER = "site"

    /**
     * Removes the "site" cluster if it has only one site as it's not
     * useful to display, and hiding it in FreeMarker is a cumbersome
     *
     * @param transaction
     */
    @Override
    void postDatafetch(SearchTransaction transaction) {
        if (transaction?.response?.resultPacket?.contextualNavigation) {
            transaction.response.resultPacket.contextualNavigation.categories
                    .findAll() { category -> category.name == SITE_CLUSTER }
                    .findAll() { category -> category.clusters.size() == 1 }
                    .each() { category ->
                transaction.response.resultPacket.contextualNavigation.categories.remove(category)
            }
        }
    }
}
