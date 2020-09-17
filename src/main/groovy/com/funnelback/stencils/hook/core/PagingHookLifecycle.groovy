package com.funnelback.stencils.hook.core

import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.publicui.utils.QueryStringUtils
import com.funnelback.stencils.hook.support.HookLifecycle
import com.google.common.collect.ArrayListMultimap
import com.google.common.collect.ListMultimap

/**
 * <p>Hook functions for the paging within the Core Stencil</p>
 *
 * @author nguillaumin@funnelback.com
 */
class PagingHookLifecycle implements HookLifecycle {

    /**
     * Config key holding the number of pages to display
     */
    static final String NUM_PAGES_KEY = "stencils.paging.num_pages"

    /**
     * Default number of pages to show
     */
    static final int NUM_PAGES_DEFAULT = 5

    /**
     * Key where the pagination will be stored in the custom data map
     */
    static final String STENCILS_PAGING = "stencilsPaging"

    /**
     * Name of the start_rank parameter
     */
    static final String START_RANK = "start_rank"

    /**
     * Compute URLs for the first, previous, next page, and the pages
     * surrounding the current one.
     *
     * @param transaction
     */
    @Override
    void postDatafetch(SearchTransaction transaction) {
        if (transaction.question.hasProperty("customData") && transaction?.response?.resultPacket?.resultsSummary) {

            def pagingControls = new PagingControls([
                    firstUrl   : getFirstPageUrl(transaction),
                    previousUrl: getPreviousPageUrl(transaction),
                    nextUrl    : getNextPageUrl(transaction),
                    pages      : getPages(transaction)
            ])

            transaction.response.customData[STENCILS_PAGING] = pagingControls
        }
    }

    /**
     * Get URL of the first page. The first page URL has no start_rank
     *
     * @param transaction
     * @return URL of the first page
     */
    String getFirstPageUrl(SearchTransaction transaction) {
        ListMultimap<String, String> qs = ArrayListMultimap.create(transaction.question.getQueryStringMapCopy())
        qs.removeAll(START_RANK)
        return QueryStringUtils.toString(qs, true)
    }

    /**
     * Get URL of the previous page. The previous page has a start_rank
     * equals to "prevStart" from the response.
     *
     * @param transaction
     * @return URL of the previous page
     */
    String getPreviousPageUrl(SearchTransaction transaction) {
        def summary = transaction.response.resultPacket.resultsSummary
        if (summary.prevStart) {
            ListMultimap<String, String> qs = ArrayListMultimap.create(transaction.question.getQueryStringMapCopy())
            updateStartRank(qs, summary.prevStart)
            return QueryStringUtils.toString(qs, true)
        } else {
            return null
        }
    }

    /**
     * Get URL of the next page. The next page has a start_rank equals to
     * "nextStart" from the response.
     *
     * @param transaction
     * @return URL of the next page
     */
    String getNextPageUrl(SearchTransaction transaction) {
        def summary = transaction.response.resultPacket.resultsSummary
        if (summary.nextStart) {
            ListMultimap<String, String> qs = ArrayListMultimap.create(transaction.question.getQueryStringMapCopy())
            updateStartRank(qs, summary.nextStart)
            return QueryStringUtils.toString(qs, true)
        } else {
            return null
        }
    }

    /**
     * Get list of pages around the current page. Computes the correct value of start_rank depending
     * on the current results counts, number of results and current start_rank
     *
     * @param transaction
     * @return List of pages
     */
    List<Page> getPages(SearchTransaction transaction) {
        // Get how many pages to produce from collection.cfg
        def numPages = transaction.question.collection.configuration.valueAsInt(NUM_PAGES_KEY, NUM_PAGES_DEFAULT)
        def summary = transaction.response.resultPacket.resultsSummary

        if (summary.numRanks <= 0) {
            // The `-num_ranks` QPO has been set to zero (or below?)
            // so there will be no page to compute
            return []
        }

        // Max page number is the total number of results by the number of results per page
        // We add (numRanks-1) so that the first page is 1, not 0
        def maxPage = ((summary.totalMatching + summary.numRanks - 1) / summary.numRanks).intValue()

        def currentPage = 1
        if (summary.currStart && summary.currEnd) {
            // Current page is the current start offset by the number of results per page
            // We add (numRanks-1) to have 1-indexed page numbers, not 0-indexed
            currentPage = ((summary.currStart + summary.numRanks - 1) / summary.numRanks).intValue()
        }

        def firstPage = 1
        if (currentPage > ((numPages - 1) / 2).intValue()) {
            // We divide the number of desired pages in half, and subtract it from
            // our current page to find out the first page (e.g. if we need 5 pages, we
            // should have 2 before the current and 2 after).
            firstPage = (currentPage - ((numPages - 1) / 2).intValue())
        }

        // Last page is either:
        // - the first page + number of desired page (e.g. if we're on page 4 and
        // we want 5 pages, it means 2 before and 2 after. The first page is "2", the last page
        // is 2 + (5-1) = 6)
        // - OR the total number of page, if we're at the last page
        def lastPage = Math.min(firstPage + numPages - 1, maxPage)

        def pages = new ArrayList<Page>()

        // Build our list of pages between our first and last
        for (int pageNumber = firstPage; pageNumber < lastPage + 1; pageNumber++) {
            def startRank = ((pageNumber - 1) * summary.numRanks + 1)
            ListMultimap<String, String> qs = ArrayListMultimap.create(transaction.question.getQueryStringMapCopy())
            updateStartRank(qs, startRank)

            def page = new Page([
                    number  : pageNumber,
                    url     : QueryStringUtils.toString(qs, true),
                    selected: pageNumber == currentPage])
            pages << page
        }

        return pages
    }

    private void updateStartRank(ListMultimap<String, String> qs, startRank) {
        qs.removeAll(START_RANK);
        if (startRank > 1) {
            qs.put(START_RANK, startRank.toString())
        }
    }
}
