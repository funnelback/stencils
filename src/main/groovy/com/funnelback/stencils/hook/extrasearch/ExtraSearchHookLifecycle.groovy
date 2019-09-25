package com.funnelback.stencils.hook.extrasearch

import com.funnelback.publicui.search.model.transaction.Facet
import com.funnelback.publicui.search.model.transaction.facet.FacetDisplayType
import com.funnelback.publicui.utils.QueryStringUtils
import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.stencils.hook.facets.FacetsHookLifecycle
import com.funnelback.stencils.hook.facets.StencilCategoryValue
import com.funnelback.stencils.hook.facets.StencilFacet
import com.funnelback.stencils.util.DatamodelUtils
import groovy.util.logging.Log4j2

import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.search.model.transaction.SearchQuestion.SearchQuestionType
import com.funnelback.stencils.hook.support.HookLifecycle

/**
 * <p>Hook functions for the Tabs stencil.</p>
 *
 * <p>Will force Gscope and Metadata based facet to appear
 * even if they have no value, as configured in the collection
 * config</p>
 *
 * <p>It works by injecting counts of "0" in the result packet (gscope
 * or RMC counts)</p>
 *
 * <p>When the Facets Stencils is used, this hook also injects
 * a fake "All" value for the Tabs, copies the "selected" status of
 * the tab from the main search into the FACETED_NAVIGATION extra search,
 * updates the selectUrl of the tabs to ensure all facet constraints are reset,
 * and populates the custom map with the name of the currently selected tab</p>
 *
 * @author nguillaumin@funnelback.com
 *
 */
@Log4j2
class ExtraSearchHookLifecycle implements HookLifecycle {
	/** Key holding the Metadata names */
	static final String METADATA_KEY_PREFIX = "stencils.tabs.extra_searches"

	/** Separator for metadata keys */
	static final String METADATA_KEY_SEPARATOR = "."

	/** Separator for facet prefix and facet name */
	static final String FACET_PREFIX_SEPARATOR = "."

	/** Separator for facet suffix and facet name */
	static final String FACET_SUFFIX_SEPARATOR = "|"

	/** Separator for whitelist of extra search keys */
	static final String EXTRA_SEARCH_VALUE_SEPARATOR = ","

	/** Name of the facet containing the tabs */
	static final String TABS_FACET_NAME = "TABS"

	/**
	 * Remove extra searches which are not specified for a particular tab
	 *
	 * @param transaction
	 */
	@Override
	void extraSearches(SearchTransaction transaction) {
		// Determine if a tab has been selected	
		transaction.question.selectedCategoryValues
		.find() {
			def selectedFacet =  it.key.substring(it.key.indexOf(FACET_PREFIX_SEPARATOR) + 1, it.key.lastIndexOf(FACET_SUFFIX_SEPARATOR))

			selectedFacet.toUpperCase() == TABS_FACET_NAME
		}
		.each() {
			// Get the label of the tab
			[it.value]
			.find() {
				it != null
			}
			// Determine which extra search to keep and which ones should be removed
			.each() {
				selectedFacetLabel ->
				// Obtain the whitelist of extra searches for the selected tab
				if(transaction.question.getCurrentProfileConfig().get(METADATA_KEY_PREFIX + METADATA_KEY_SEPARATOR + selectedFacetLabel) != null) {
					def extraSearchesToKeep = transaction.question.getCurrentProfileConfig().get(METADATA_KEY_PREFIX + METADATA_KEY_SEPARATOR + selectedFacetLabel).split(EXTRA_SEARCH_VALUE_SEPARATOR)

					// Remove extra search which do not appear in the list of extra search to key
					// and not an internal extra search used for accurate facet counts
					transaction.extraSearchesQuestions.keySet()
					.findAll() { 
						extraSearchesToKeep.contains(it) == false && 
						it.startsWith("INTERNAL_FACETED_NAV_SEARCH") == false
					}
					.each() { transaction.extraSearchesQuestions.remove(it) }
				}
			}	
		}
	}
}