package com.funnelback.stencils.hook.tabs

import com.funnelback.stencils.hook.support.HookLifecycle

import groovy.util.logging.Log4j2;

import com.funnelback.publicui.search.model.transaction.SearchQuestion.SearchQuestionType

/**
 * Hook functions for the Tabs stencil
 * 
 * @author nguillaumin@funnelback.com
 *
 */
@Log4j2
class TabsHookLifecycle implements HookLifecycle {

    @Override
    void postDatafetch() {
        def questionType = transaction.question.questionType
        if (SearchQuestionType.SEARCH.equals(questionType)
            || SearchQuestionType.EXTRA_SEARCH.equals(questionType)) {
            
            // Do something
            transaction.response.customData["test"] = 42
        }
    }

}
