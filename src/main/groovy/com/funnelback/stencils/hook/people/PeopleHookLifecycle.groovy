package com.funnelback.stencils.hook.people

import groovy.util.logging.Log4j2

import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.search.model.transaction.SearchQuestion.SearchQuestionType
import com.funnelback.stencils.hook.support.HookLifecycle

/**
 * Hook functions for the People Stencil
 * 
 * @author nguillaumin@funnelback.com
 *
 */
@Log4j2
class PeopleHookLifecycle implements HookLifecycle {

    /** Name of the setting enabling the People Stencil in <code>collection.cfg</code> */
    static final String PEOPLE_STENCIL_ENABLED_KEY = "stencils.people"
    
    /**
     * Force the query to <code>!padrenullquery</code> if no query has
     * been set. This is to allow browsing the directory by viewing all
     * entries.
     */
    @Override
    void preProcess(SearchTransaction transaction) {
        if (transaction.question.collection.configuration.valueAsBoolean(PEOPLE_STENCIL_ENABLED_KEY, false)
            && SearchQuestionType.SEARCH == transaction.question.questionType
            && transaction.question.query == null) {
            transaction.question.query = "!padrenullquery"
        }
    }

}
