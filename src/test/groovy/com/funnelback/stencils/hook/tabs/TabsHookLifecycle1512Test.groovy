package com.funnelback.stencils.hook.tabs

import com.funnelback.common.Environment
import com.funnelback.common.config.Config
import com.funnelback.common.facetednavigation.models.FacetConstraintJoin
import com.funnelback.common.facetednavigation.models.FacetSelectionType
import com.funnelback.common.facetednavigation.models.FacetValues
import com.funnelback.common.facetednavigation.models.categories.CollectionCategory
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.padre.ResultPacket
import com.funnelback.publicui.search.model.padre.ResultsSummary
import com.funnelback.publicui.search.model.transaction.Facet
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.hook.StencilHooks
import com.funnelback.stencils.hook.facets.FacetsHookLifecycle
import com.funnelback.stencils.hook.facets.StencilFacet
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

/**
 * <p>Tests specific to 15.12 and above who have enhanced facets</p>
 *
 * <p>The tabs hook don't apply anymore since the enhanced facets support tabs out
 * of the box, however the "currently selected tab" is still implemented in the Stencils
 * and needs to be tested.</p>
 *
 */
class TabsHookLifecycle1512Test {
    def hook
    def transaction
    def config
    def responseCustomData

    @Before
    void before() {
        hook = new TabsHookLifecycle()

        config = Mockito.mock(Config.class)

        responseCustomData = [:]

        transaction = new SearchTransaction()
        transaction.question = Mockito.mock(SearchQuestion.class)
        transaction.response = Mockito.mock(SearchResponse.class)

        Mockito.when(transaction.question.collection).thenReturn(new Collection("mock", config))
        Mockito.when(transaction.question.funnelbackVersion).thenReturn(new Environment.FunnelbackVersion(15, 12, 0))
        Mockito.when(transaction.response.customData).thenReturn(responseCustomData)
    }

    @Test
    void testPostProcessTabSelected() {
        def f = new Facet(
                "Tabs",
                FacetSelectionType.SINGLE_AND_UNSELECT_OTHER_FACETS,
                FacetConstraintJoin.AND,
                FacetValues.FROM_UNSCOPED_ALL_QUERY,
                [])

        f.categories << new Facet.Category(null, null)
        f.categories[0].values << new Facet.CategoryValue("people-collection", "People", 1, "", "", false)

        f.categories << new Facet.Category(null, null)
        f.categories[1].values << new Facet.CategoryValue("courses-collection", "Courses", 2, "", "", true)

        f.categories << new Facet.Category(null, null)
        f.categories[2].values << new Facet.CategoryValue("events-collection", "Events", 3, "", "", false)

        // Inject tab facet with selected value
        Mockito.when(transaction.response.facets).thenReturn([ f ])

        hook.postProcess(transaction)

        Assert.assertEquals(
                "The Courses facet should have been marked as selected",
                "Courses",
                transaction.response.customData[TabsHookLifecycle.SELECTED_TAB])
    }

    /**
     * Test that the default ALL selected tab still applies in 15.12
     * when there are no new "tab-style" facet but only legacy one (which don't
     * have a default "All" value)
     */
    @Test
    void testPoostProcessAllTabSelectedByDefault() {
        Mockito.when(config.value(TabsHookLifecycle.ALL_TAB_LABEL_KEY, TabsHookLifecycle.ALL_TAB_DEFAULT_LABEL))
            .thenReturn("Default All Tab")

        def f = new Facet(
                "Tabs",
                FacetSelectionType.SINGLE_AND_UNSELECT_OTHER_FACETS,
                FacetConstraintJoin.LEGACY,
                FacetValues.FROM_UNSCOPED_ALL_QUERY,
                [])

        f.categories << new Facet.Category(null, null)
        f.categories[0].values << new Facet.CategoryValue("people-collection", "People", 1, "", "", false)

        f.categories << new Facet.Category(null, null)
        f.categories[1].values << new Facet.CategoryValue("courses-collection", "Courses", 2, "", "", false)

        f.categories << new Facet.Category(null, null)
        f.categories[2].values << new Facet.CategoryValue("events-collection", "Events", 3, "", "", false)

        // Inject tab facet with selected value
        Mockito.when(transaction.response.facets).thenReturn([ f ])

        hook.postProcess(transaction)

        Assert.assertEquals(
                "The default 'ALL' tab should have been marked as selected",
                "Default All Tab",
                transaction.response.customData[TabsHookLifecycle.SELECTED_TAB])
    }

}
