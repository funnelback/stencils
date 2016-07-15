package com.funnelback.stencils.hook.people

import groovy.util.logging.Log4j2

import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.search.model.transaction.SearchQuestion.SearchQuestionType
import com.funnelback.stencils.hook.support.HookLifecycle
import com.funnelback.stencils.util.ConfigUtils

/**
 * Hook functions for the People Stencil
 * 
 * @author nguillaumin@funnelback.com
 *
 */
@Log4j2
class PeopleHookLifecycle implements HookLifecycle {

    /** Name of the people stencil */
    private static final String PEOPLE_STENCIL = "people"
    
    /**
     * Force the query to <code>!padrenullquery</code> if no query has
     * been set. This is to allow browsing the directory by viewing all
     * entries.
     */
    @Override
    void preProcess(SearchTransaction transaction) {
        if (ConfigUtils.isStencilEnabled(transaction.question.collection.configuration, PEOPLE_STENCIL)
            && SearchQuestionType.SEARCH == transaction.question.questionType
            && transaction.question.query == null) {
            transaction.question.query = "!padrenullquery"
        }
    }

}
