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

    /** SearchTransaction the hook applies to */
    SearchTransaction transaction;
    
    void preProcess() {}
    
    void extraSearches() {}
    
    void preDatafetch() {}
    
    void postDatafetch() {}
    
    void postProcess() {}
    
}
