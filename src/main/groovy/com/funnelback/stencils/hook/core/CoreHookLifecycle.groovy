package com.funnelback.stencils.hook.core

import com.funnelback.publicui.search.model.padre.Result
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.utils.QueryStringUtils
import com.funnelback.stencils.freemarker.method.LinkifyMethod
import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.stencils.hook.support.HookLifecycle
import com.funnelback.stencils.util.DatamodelUtils
import org.springframework.web.util.UriUtils

/**
 * <p>Hook functions for the Core stencil</p>
 *
 * <p>These always apply without checking if the "core" stencil is explicitely
 * enabled, as we assume that if the Stencil hooks were configured in the collection
 * for any Stencil, all the core hooks should apply
 *
 * @author nguillaumin@funnelback.com
 */
class CoreHookLifecycle implements HookLifecycle {

    /** Name of the start_rank parameter */
    static final START_RANK_PARAM = "start_rank"

    /** Name of the duplicate_start_rank parameter */
    static final DUPLICATE_START_RANK_PARAM = "duplicate_start_rank"

    @Override
    void postDatafetch(SearchTransaction transaction) {
        transaction.response.customData[StencilHooks.STENCILS_FREEMARKER_METHODS]["linkify"] = new LinkifyMethod()

        if (transaction.response.resultPacket?.results) {
            transaction.response.resultPacket.results.each() { result ->
                addExploreUrl(transaction, result)
                addCollapsedUrl(transaction, result)
                addOptimiseUrl(transaction, result)
            }
        }
    }

    /**
     * Add explore URL to a result
     * @param transaction Search transaction
     * @param result Result to add the URL to
     */
    void addExploreUrl(SearchTransaction transaction, Result result) {
        def qs = DatamodelUtils.getQueryStringMapCopy(transaction.response.customData[StencilHooks.QUERY_STRING_MAP_KEY])
        qs.remove(START_RANK_PARAM)
        qs.remove(DUPLICATE_START_RANK_PARAM)
        qs["query"] = ["explore:" + result.liveUrl]

        result.customData["stencilsCoreExploreUrl"] = QueryStringUtils.toString(qs, true)
    }

    /**
     * Add collapsed URL to a result
     * @param transaction Search transaction
     * @param result Result to add the URL to
     */
    void addCollapsedUrl(SearchTransaction transaction, Result result) {
        if (result.collapsed) {
            def qs = DatamodelUtils.getQueryStringMapCopy(transaction.response.customData[StencilHooks.QUERY_STRING_MAP_KEY])
            qs.remove(START_RANK_PARAM)
            qs.remove(DUPLICATE_START_RANK_PARAM)
            qs["s"] = ["?:" + result.collapsed.signature]
            qs["fmo"] = ["on"]
            qs["collapsing"] = ["off"]

            result.customData["stencilsCoreCollapsedUrl"] = QueryStringUtils.toString(qs, true)
        }
    }

    /**
     * Add optimise URL to a result
     * @param transaction Search transaction
     * @param result Result to add the URL to
     */
    void addOptimiseUrl(SearchTransaction transaction, Result result) {
        // The result URL is appended inside the fragment part of the Optimise URL
        // (as it's an Angular 1 app) and must be encoded suitably.
        // Slashes need to be double encoded to prevent Angular treating it as a path
        def fragmentEncodedUrl = UriUtils.encodeFragment(result.indexUrl, "UTF-8").replace("/", "%252F")

        result.customData["stencilsCoreOptimiseUrl"] = ("/a/#/" + result.collection + ":" + transaction.question.profile
                + "/analyse/seo-auditor/"
                + UriUtils.encodeFragment(transaction.response.resultPacket.query, "UTF-8") + "/" + fragmentEncodedUrl)
    }
}
