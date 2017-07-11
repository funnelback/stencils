package com.funnelback.stencils.hook.facets

import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.transaction.Facet
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class FacetsCustomSortHookLifecycleTest {

    def hook
    def config
    def transaction

    @Before
    void before() {
        hook = new FacetsCustomSortHookLifecycle()
        config = Mockito.mock(Config.class)

        Mockito.when(config.valueKeys()).thenReturn([
                FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.1",
                FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.3",
                FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.2",
                FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.0"
        ] as Set)
        Mockito.when(config.value(FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.0")).thenReturn("zero")
        Mockito.when(config.value(FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.1")).thenReturn("first")
        Mockito.when(config.value(FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.2")).thenReturn("second")
        Mockito.when(config.value(FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.3")).thenReturn("third")

        transaction = new SearchTransaction(new SearchQuestion(), new SearchResponse())
        transaction.question.collection = new Collection("collection", config)
        transaction.response.customData[FacetsHookLifecycle.STENCILS_FACETS] = [
                new StencilFacet([
                        name  : "Facet Name",
                        values: [
                                new StencilCategoryValue(new Facet.CategoryValue("data:second", "second", 1, "k=v", "", false)),
                                new StencilCategoryValue(new Facet.CategoryValue("data:first", "first", 1, "k=v", "", false)),
                                new StencilCategoryValue(new Facet.CategoryValue("data:third", "third", 1, "k=v", "", false)),
                                new StencilCategoryValue(new Facet.CategoryValue("data:zero", "zero", 1, "k=v", "", false)),
                        ]
                ]),
                new StencilFacet([
                        name  : "Other Facet",
                        values: [
                                new StencilCategoryValue(new Facet.CategoryValue("data:second", "second", 1, "k=v", "", false)),
                                new StencilCategoryValue(new Facet.CategoryValue("data:first", "first", 1, "k=v", "", false)),
                                new StencilCategoryValue(new Facet.CategoryValue("data:third", "third", 1, "k=v", "", false)),
                                new StencilCategoryValue(new Facet.CategoryValue("data:zero", "zero", 1, "k=v", "", false)),
                        ]
                ]),
        ]
    }

    @Test
    void test() {
        hook.postProcess(transaction)

        def facets = transaction.response.customData[FacetsHookLifecycle.STENCILS_FACETS]

        Assert.assertEquals("Facet values should have been sorted", "zero", facets[0].values[0].label)
        Assert.assertEquals("Facet values should have been sorted", "first", facets[0].values[1].label)
        Assert.assertEquals("Facet values should have been sorted", "second", facets[0].values[2].label)
        Assert.assertEquals("Facet values should have been sorted", "third", facets[0].values[3].label)

        Assert.assertEquals("Other facet should not have been sorted", "second", facets[1].values[0].label)
        Assert.assertEquals("Other facet should not have been sorted", "first", facets[1].values[1].label)
        Assert.assertEquals("Other facet should not have been sorted", "third", facets[1].values[2].label)
        Assert.assertEquals("Other facet should not have been sorted", "zero", facets[1].values[3].label)
    }
}
