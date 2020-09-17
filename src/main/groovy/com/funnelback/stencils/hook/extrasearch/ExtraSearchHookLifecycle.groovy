package com.funnelback.stencils.hook.extrasearch

import groovy.util.logging.Log4j2

import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.hook.support.HookLifecycle

/**
 * <p>Hook functions for the ExtraSearch stencil.</p>
 *
 */
@Log4j2
class ExtraSearchHookLifecycle implements HookLifecycle {
	/** Key holding the config */
	static final String CONFIG_KEY_PREFIX = "stencils.tabs.extra_searches"

	/** Separator for config keys */
	static final String CONFIG_KEY_SEPARATOR = "."

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
				if(transaction.question.getCurrentProfileConfig().get(CONFIG_KEY_PREFIX + FACET_PREFIX_SEPARATOR + selectedFacetLabel) != null) {
					// Find the list of extra searches to keep
					def extraSearchesToKeep = transaction.question.getCurrentProfileConfig().get(CONFIG_KEY_PREFIX + FACET_PREFIX_SEPARATOR + selectedFacetLabel)
						.split(EXTRA_SEARCH_VALUE_SEPARATOR)
						// Remove any white spaces between the list of extra searches
						.collect() { it.trim() }

					// Remove extra search which do not appear in the list of permitted extra searches 
					// but leave the internal extra search intact so that facet counts remain accurate
					transaction.extraSearchesQuestions.keySet()
					.findAll() { 
						extraSearchesToKeep.contains(it) == false && 
						it.startsWith("INTERNAL_FACETED_NAV_SEARCH") == false
					}
					// Remove the extra search which prevents it for running
					.each() { transaction.extraSearchesQuestions.remove(it) }
				}
			}	
		}
	}
}