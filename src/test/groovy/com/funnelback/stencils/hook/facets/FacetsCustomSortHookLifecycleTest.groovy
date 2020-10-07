package com.funnelback.stencils.hook.facets

import com.funnelback.common.config.CollectionId
import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.collection.ServiceConfig
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
    SearchTransaction transaction

    @Before
    void before() {
        hook = new FacetsCustomSortHookLifecycle()

        config = Mockito.mock(ServiceConfig.class)
        Mockito.when(config.getRawKeys()).thenReturn([
                FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.1",
                FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.3",
                FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.2",
                FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.0"
        ] as Set)
        Mockito.when(config.get(FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.0")).thenReturn("zero")
        Mockito.when(config.get(FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.1")).thenReturn("first")
        Mockito.when(config.get(FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.2")).thenReturn("second")
        Mockito.when(config.get(FacetsCustomSortHookLifecycle.CUSTOM_SORT_PREFIX + ".Facet Name.3")).thenReturn("third")

        def cat1 = [
                categoryValue("second"),
                categoryValue("first"),
                categoryValue("third"),
                categoryValue("zero")
        ]
        def cat2 = [
                categoryValue("second"),
                categoryValue("first"),
                categoryValue("third"),
                categoryValue("zero")
        ]
        def facets = [facet("Facet Name", cat1), facet("Other Facet", cat2)]

        def question = Mockito.mock(SearchQuestion.class)
        def response = Mockito.mock(SearchResponse.class)
        Mockito.when(question.questionType).thenReturn(SearchQuestion.SearchQuestionType.SEARCH)
        Mockito.when(question.getCurrentProfileConfig()).thenReturn(config)
        Mockito.when(response.facets).thenReturn(facets)
        transaction = new SearchTransaction(question, response)
    }

    @Test
    void test() {
        hook.postProcess(transaction)
        def facets = transaction.response.getFacets()

        Assert.assertEquals("Facet values should have been sorted", "zero", facets[0].getAllValues().get(0).label)
        Assert.assertEquals("Facet values should have been sorted", "first", facets[0].getAllValues().get(1).label)
        Assert.assertEquals("Facet values should have been sorted", "second", facets[0].getAllValues().get(2).label)
        Assert.assertEquals("Facet values should have been sorted", "third", facets[0].getAllValues().get(3).label)

        Assert.assertEquals("Other facet should not have been sorted", "second", facets[1].getAllValues().get(0).label)
        Assert.assertEquals("Other facet should not have been sorted", "first", facets[1].getAllValues().get(1).label)
        Assert.assertEquals("Other facet should not have been sorted", "third", facets[1].getAllValues().get(2).label)
        Assert.assertEquals("Other facet should not have been sorted", "zero", facets[1].getAllValues().get(3).label)
    }

    private Facet facet(String name, List<Facet.CategoryValue> categoryValues) {
        Facet facet = Mockito.mock(Facet.class)
        Mockito.when(facet.name).thenReturn(name)
        Mockito.when(facet.allValues).thenReturn(categoryValues)
        return facet
    }

    private Facet.CategoryValue categoryValue(String label) {
        Facet.CategoryValue category = Mockito.mock(Facet.CategoryValue.class)
        Mockito.when(category.label).thenReturn(label)
        return  category
    }
}
