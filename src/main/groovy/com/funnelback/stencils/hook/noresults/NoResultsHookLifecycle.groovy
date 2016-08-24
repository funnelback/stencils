package com.funnelback.stencils.hook.noresults

import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.hook.support.HookLifecycle

import groovy.json.JsonOutput;
import groovy.util.logging.Log4j2;;

/**
 * <p>Hook functions for the No Results stencil</p>
 * 
 * <p>Updates the "no_results" extra search if there's one
 * with a configure query, or a default null query</p>
 * 
 * @author nguillaumin@funnelback.com
 *
 */
@Log4j2
class NoResultsHookLifecycle implements HookLifecycle {
    
    /** Name of the no_results extra search */
    static final String NO_RESULTS_EXTRA_SEARCH = "no_results"
    
    /** Default query to use for the no results extra search */
    static final String DEFAULT_NO_RESULTS_QUERY = "!padrenullquery"
    
    /** Key holding the query to use when there are no results */
    static final String NO_RESULTS_QUERY_KEY = "stencil.no_results.query"

    @Override
    public void extraSearches(SearchTransaction transaction) {
        if (transaction.extraSearchesQuestions[NO_RESULTS_EXTRA_SEARCH] != null) {
            transaction.extraSearchesQuestions[NO_RESULTS_EXTRA_SEARCH].query =
                transaction.question.collection.configuration.value(NO_RESULTS_QUERY_KEY, DEFAULT_NO_RESULTS_QUERY);
        }
    }

}
