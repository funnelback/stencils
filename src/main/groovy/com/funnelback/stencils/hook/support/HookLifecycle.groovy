package com.funnelback.stencils.hook.support

import com.funnelback.publicui.search.model.transaction.SearchTransaction;

/**
 * Trait to implement to plug into the Modern UI
 * hooks, for Stencils
 * 
 * @author nguillaumin@funnelback.com
 *
 */
trait HookLifecycle {

    void preProcess(SearchTransaction transaction) {}
    
    void extraSearches(SearchTransaction transaction) {}
    
    void preDatafetch(SearchTransaction transaction) {}
    
    void postDatafetch(SearchTransaction transaction) {}
    
    void postProcess(SearchTransaction transaction) {}
    
}
