package com.funnelback.stencils.hook.facets

import com.funnelback.common.config.Config
import com.funnelback.common.facetednavigation.models.FacetConstraintJoin
import com.funnelback.common.facetednavigation.models.FacetSelectionType
import com.funnelback.common.facetednavigation.models.FacetValues
import com.funnelback.common.facetednavigation.models.FacetValuesOrder
import com.funnelback.publicui.search.model.profile.ServerConfigReadOnlyWhichAlsoHasAStringGetMethod
import com.funnelback.publicui.search.model.transaction.Facet
import com.funnelback.publicui.search.model.transaction.Facet.CategoryValue;
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class FacetRenameHookLifecycleTest {

    def hook
    def profileConfig
    SearchTransaction transaction

    @Before
    void before() {
        hook = new FacetRenameHookLifecycle()
        def config = Mockito.mock(Config.class)

        profileConfig = Mockito.mock(ServerConfigReadOnlyWhichAlsoHasAStringGetMethod.class)
        def question = Mockito.mock(SearchQuestion.class)
        Mockito.when(question.currentProfileConfig).thenReturn(profileConfig)

        transaction = new SearchTransaction(question, new SearchResponse())

        // Prepare 2 facets, "Author" and "Publisher" with the same values
        def facet1 = facetWithName("Author")
        def facet2 = facetWithName("Publisher")

        transaction.response.facets << facet1 << facet2
    }

    @Test
    void testNoRenamesConfigured() {
        // No settings in the profile config
        Mockito.when(profileConfig.rawKeys).thenReturn([] as Set)
        hook.postProcess(transaction)

        testFacet(transaction.getResponse().getFacets().get(0), "Author", "john label", "jack label", "william label")
        testFacet(transaction.getResponse().getFacets().get(1), "Publisher", "john label", "jack label", "william label")
    }

    @Test
    void testRenameNonExistentFacet() {
        // Rename config for another facet
        Mockito.when(profileConfig.rawKeys).thenReturn(["${FacetRenameHookLifecycle.CONFIG_PREFIX}.Date.1998"] as Set)
        Mockito.when(profileConfig.get(FacetRenameHookLifecycle.CONFIG_PREFIX + ".Date.1998")).thenReturn("'98")

        hook.postProcess(transaction)

        testFacet(transaction.getResponse().getFacets().get(0), "Author", "john label", "jack label", "william label")
        testFacet(transaction.getResponse().getFacets().get(1), "Publisher", "john label", "jack label", "william label")
    }

    @Test
    void testRenameNonExistentValue() {
        // Rename config a valid facet, but the value to rename is not found
        Mockito.when(profileConfig.rawKeys).thenReturn(["${FacetRenameHookLifecycle.CONFIG_PREFIX}.Author.other label"] as Set)
        Mockito.when(profileConfig.get(FacetRenameHookLifecycle.CONFIG_PREFIX + ".Author.other label")).thenReturn("OTHER")

        hook.postProcess(transaction)

        testFacet(transaction.getResponse().getFacets().get(0), "Author", "john label", "jack label", "william label")
        testFacet(transaction.getResponse().getFacets().get(1), "Publisher", "john label", "jack label", "william label")
    }

    @Test
    void testRenameAuthor() {
        // Rename config for "Author" facet
        Mockito.when(profileConfig.rawKeys).thenReturn(["${FacetRenameHookLifecycle.CONFIG_PREFIX}.Author.jack label"] as Set)
        Mockito.when(profileConfig.get(FacetRenameHookLifecycle.CONFIG_PREFIX + ".Author.jack label")).thenReturn("roger label")

        hook.postProcess(transaction)

        // Author should have been renamed
        testFacet(transaction.getResponse().getFacets().get(0), "Author", "john label", "roger label", "william label")
        // Publisher should not have been renamed
        testFacet(transaction.getResponse().getFacets().get(1), "Publisher", "john label", "jack label", "william label")
    }

    private void testFacet(facet, name, label1, label2, label3) {
        Assert.assertEquals(name, facet.name)
        Assert.assertEquals(label1, facet.allValues.get(0).label)
        Assert.assertEquals(label2, facet.allValues.get(1).label)
        Assert.assertEquals(label3, facet.allValues.get(2).label)
    }

    private Facet facetWithName(name) {
        def facet = new Facet(name,
                FacetSelectionType.SINGLE,
                FacetConstraintJoin.AND,
                FacetValues.FROM_SCOPED_QUERY,
                new ArrayList<>(Arrays.asList(FacetValuesOrder.LABEL_ASCENDING, FacetValuesOrder.COUNT_DESCENDING)))
        facet.getAllValues().addAll(Arrays.asList(
                categoryWithLabel("john label", "john", 1),
                categoryWithLabel("jack label", "jack", 1),
                categoryWithLabel("william label", "william", 1)
        ))
        return facet
    }

    private CategoryValue categoryWithLabel(String label, String data, int count) {
        return new CategoryValue(data, label, count, false, "", "", 0)
    }
}
