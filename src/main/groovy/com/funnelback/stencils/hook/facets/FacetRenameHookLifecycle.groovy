package com.funnelback.stencils.hook.facets

import com.funnelback.publicui.search.model.transaction.Facet
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.hook.support.HookLifecycle
import groovy.util.logging.Log4j2

/**
 * Rename facet category values from profile.cfg
 *
 * @author nguillaumin@funnelback.com
 */
@Log4j2
class FacetRenameHookLifecycle implements HookLifecycle {

    /**
     * Prefix of the setting containing the values to rename
     *
     * They're in the form stencils.facets.rename._Facet name_._Value_=_Rename_
     * e.g.: stencils.facets.rename.Date.Past fortnight=Past 2 weeks
     */
    static final String CONFIG_PREFIX = "stencils.facets.rename"

    @Override
    void postProcess(SearchTransaction transaction) {
        // Find out if any facet rename has been configured
        // Look at the profile level, since facets are defined inside a profile
        def isFacetRenameConfigured = !transaction.question.currentProfileConfig.rawKeys.findAll() { key -> key.startsWith(CONFIG_PREFIX) }.empty

        if (isFacetRenameConfigured && transaction?.response?.facets) {
            // Iterate over each facet and each category, and apply the rename
            transaction.response.facets.each() { facet ->
                facet.getAllValues().each() { categoryValue ->
                    renameCategory(transaction.question.currentProfileConfig, categoryValue, facet.name)
                }
            }
        }
    }

    /**
     * Rename values of a facet category if there is a relevant profile.cfg setting
     * @param config Profile configuration
     * @param categoryValue Category to rename the values of
     * @param facetName Name of the facet the category belong to
     */
    void renameCategory(config, Facet.CategoryValue categoryValue, String facetName) {
        def rename = config.get("${CONFIG_PREFIX}.${facetName}.${categoryValue.label}")
        if (rename) {
            categoryValue.label = rename
        }
    }
}
