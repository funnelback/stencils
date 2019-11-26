package com.funnelback.stencils.hook.tabs

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
 * <p>Hook functions for provide a preview of a tab using extra searches.</p>
 *
 *
 */
@Log4j2
class TabsPreviewHookLifecycle implements HookLifecycle {

	/** Key where the preview links will be stored in the custom data map */
	static final String CUSTOM_DATA_NAMESPACE = "stencilsTabsPreviewLink"

	/** Name of the facet containing the tabs */
	static final String TABS_FACET_NAME = "Tabs"

	/** Key holding the config */
	static final String CONFIG_KEY_PREFIX = "stencils.tabs.preview"

	/** Separator for config keys */
	static final String CONFIG_KEY_SEPARATOR = "."

	/**
	 * Injects the "more link" into each extra search. The "more link"
	 * will provide the user a different way to navigate to a particular tab
	 *  
	 * @param transaction
	 */
	@Override
	void postProcess(SearchTransaction transaction) {

		def profileConfig = transaction.question.getCurrentProfileConfig()

		// Get all the configs which apply to this hook life cycle
		Map<String, String> config = profileConfig.getRawKeys()
			.findAll() {				
				it.startsWith(CONFIG_KEY_PREFIX)
			}
			// Massage the key into the right format: [<extra_search_id>:<tab_name>]
			.inject([:]) { 
				result, key ->
				
        int separator = key.lastIndexOf(".")
        
				// Config is expected in the following format:
				// stencils.tabs.preview.<extra search name>=<tab name>
				if (separator >= 0 ) {
					String extraSearchID = key.substring(separator + 1)
					String tabName = profileConfig.get(key)
					
					result.put(extraSearchID, tabName)		
				}
				else {
					// Warn the user if the key is invalid
					log.warn("'${key}' is invalid");
					log.warn("Expected format the key is '${CONFIG_KEY_PREFIX}.<extra search name>=<tab name>")
					log.warn("e.g '${CONFIG_KEY_PREFIX}.events=All Events")
				}

				result
			}

		// Create more links for each extra search based on the config		
		config
			// Only add more links to extra search which exists and have the
			// neccessary config
			.findAll{
				extraSearchID, tabName ->
				transaction.extraSearches.keySet().contains(extraSearchID)
			}
			.each() {
				extraSearchID, tabName ->
				def extraSearch = transaction.extraSearches[extraSearchID]

				// Add more links to the extra search	only if facets have been defined			
				if( transaction?.response && transaction?.response?.facets) {
					String moreLink = getMoreLink(tabName, profileConfig, transaction.response.facets)
					extraSearch.response.customData.put(CUSTOM_DATA_NAMESPACE, moreLink)
				}
			}
	}

	/** 
	 *	Generate the more link 
	 *
	 * @param tabName - The name of the tab in which the user will be redirected to
	 * @param profileConfig - The config at the profile level
	 * @param facetedNavigationConfig - The faceted navigation for the collection
	 *
	 **/
	public String getMoreLink(String tabName, def profileConfig, def facets) {
		// Get the facet which powers tabs
		def tabFacet = facets.find {
			it.name.toUpperCase() == TABS_FACET_NAME.toUpperCase()
		}

		// Get individual facet category which is the target of the more link
		def tabFacetCategory = tabFacet.categories
			.findAll {
				it.values.find { it.label.toUpperCase() == tabName.toUpperCase() }
			}
			.collect {
				it.values
			}
			.flatten()
			.find()

		return tabFacetCategory.toggleUrl
	}
}
