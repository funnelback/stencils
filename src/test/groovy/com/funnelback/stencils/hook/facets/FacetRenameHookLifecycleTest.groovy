package com.funnelback.stencils.hook.facets

import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.profile.ServerConfigReadOnlyWhichAlsoHasAStringGetMethod
import com.funnelback.publicui.search.model.transaction.Facet
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
    def transaction

    @Before
    void before() {
        hook = new FacetRenameHookLifecycle()
        def config = Mockito.mock(Config.class)

        profileConfig = Mockito.mock(ServerConfigReadOnlyWhichAlsoHasAStringGetMethod.class)
        def question = Mockito.mock(SearchQuestion.class)
        Mockito.when(question.currentProfileConfig).thenReturn(profileConfig)

        transaction = new SearchTransaction(question, new SearchResponse())

        // Prepare 2 facets, "Author" and "Publisher" with the same values

        def cat1 = new Facet.Category("Category 1", null)
        cat1.values << new Facet.CategoryValue("john", "john label", 1, "", "", false)
        cat1.values << new Facet.CategoryValue("jack", "jack label", 1, "", "", false)
        cat1.values << new Facet.CategoryValue("william", "william label", 1, "", "", false)

        def facet1 = new Facet("Author")
        facet1.categories << cat1

        def cat2 = new Facet.Category("Category 2", null)
        cat2.values << new Facet.CategoryValue("john", "john label", 1, "", "", false)
        cat2.values << new Facet.CategoryValue("jack", "jack label", 1, "", "", false)
        cat2.values << new Facet.CategoryValue("william", "william label", 1, "", "", false)

        // Add a nested category on Publisher
        def subCat = new Facet.Category("Sub-Category", null)
        subCat.values << new Facet.CategoryValue("nested1", "nested1 label", 1, "", "", false)
        subCat.values << new Facet.CategoryValue("nested2", "nested2 label", 1, "", "", false)
        cat2.categories << subCat

        def facet2 = new Facet("Publisher")
        facet2.categories << cat2

        transaction.response.facets << facet1 << facet2
    }

    @Test
    void testNoRenamesConfigured() {
        // No settings in the profile config
        Mockito.when(profileConfig.rawKeys).thenReturn([] as Set)
        hook.postProcess(transaction)

        Assert.assertEquals("john label", transaction.response.facets[0].categories[0].values[0].label)
        Assert.assertEquals("jack label", transaction.response.facets[0].categories[0].values[1].label)
        Assert.assertEquals("william label", transaction.response.facets[0].categories[0].values[2].label)

        Assert.assertEquals("john label", transaction.response.facets[1].categories[0].values[0].label)
        Assert.assertEquals("jack label", transaction.response.facets[1].categories[0].values[1].label)
        Assert.assertEquals("william label", transaction.response.facets[1].categories[0].values[2].label)
    }

    @Test
    void testRenameNonExistentFacet() {
        // Rename config for another facet
        Mockito.when(profileConfig.rawKeys).thenReturn([
                "${FacetRenameHookLifecycle.CONFIG_PREFIX}.Date.1998"
        ] as Set)
        Mockito.when(profileConfig.get(FacetRenameHookLifecycle.CONFIG_PREFIX + ".Date.1998")).thenReturn("'98")

        hook.postProcess(transaction)

        Assert.assertEquals("john label", transaction.response.facets[0].categories[0].values[0].label)
        Assert.assertEquals("jack label", transaction.response.facets[0].categories[0].values[1].label)
        Assert.assertEquals("william label", transaction.response.facets[0].categories[0].values[2].label)

        Assert.assertEquals("john label", transaction.response.facets[1].categories[0].values[0].label)
        Assert.assertEquals("jack label", transaction.response.facets[1].categories[0].values[1].label)
        Assert.assertEquals("william label", transaction.response.facets[1].categories[0].values[2].label)
    }

    @Test
    void testRenameNonExistentValue() {
        // Rename config a valid facet, but the value to rename is not found
        Mockito.when(profileConfig.rawKeys).thenReturn([
                "${FacetRenameHookLifecycle.CONFIG_PREFIX}.Author.other label"
        ] as Set)
        Mockito.when(profileConfig.get(FacetRenameHookLifecycle.CONFIG_PREFIX + ".Author.other label")).thenReturn("OTHER")

        hook.postProcess(transaction)

        Assert.assertEquals("john label", transaction.response.facets[0].categories[0].values[0].label)
        Assert.assertEquals("jack label", transaction.response.facets[0].categories[0].values[1].label)
        Assert.assertEquals("william label", transaction.response.facets[0].categories[0].values[2].label)

        Assert.assertEquals("john label", transaction.response.facets[1].categories[0].values[0].label)
        Assert.assertEquals("jack label", transaction.response.facets[1].categories[0].values[1].label)
        Assert.assertEquals("william label", transaction.response.facets[1].categories[0].values[2].label)
    }

    @Test
    void testRenameAuthor() {
        Mockito.when(profileConfig.rawKeys).thenReturn([
                "${FacetRenameHookLifecycle.CONFIG_PREFIX}.Author.jack label"
        ] as Set)
        Mockito.when(profileConfig.get(FacetRenameHookLifecycle.CONFIG_PREFIX + ".Author.jack label")).thenReturn("roger label")

        hook.postProcess(transaction)

        // Author should have been renamed
        Assert.assertEquals("john label", transaction.response.facets[0].categories[0].values[0].label)
        Assert.assertEquals("roger label", transaction.response.facets[0].categories[0].values[1].label)
        Assert.assertEquals("william label", transaction.response.facets[0].categories[0].values[2].label)

        // Publisher should not have been renamed
        Assert.assertEquals("john label", transaction.response.facets[1].categories[0].values[0].label)
        Assert.assertEquals("jack label", transaction.response.facets[1].categories[0].values[1].label)
        Assert.assertEquals("william label", transaction.response.facets[1].categories[0].values[2].label)
    }

    @Test
    void testRenameSubCategory() {
        Mockito.when(profileConfig.rawKeys).thenReturn([
                "${FacetRenameHookLifecycle.CONFIG_PREFIX}.Publisher.nested2 label"
        ] as Set)
        Mockito.when(profileConfig.get(FacetRenameHookLifecycle.CONFIG_PREFIX + ".Publisher.nested2 label")).thenReturn("nested rename")

        hook.postProcess(transaction)

        Assert.assertEquals("john label", transaction.response.facets[0].categories[0].values[0].label)
        Assert.assertEquals("jack label", transaction.response.facets[0].categories[0].values[1].label)
        Assert.assertEquals("william label", transaction.response.facets[0].categories[0].values[2].label)

        Assert.assertEquals("john label", transaction.response.facets[1].categories[0].values[0].label)
        Assert.assertEquals("jack label", transaction.response.facets[1].categories[0].values[1].label)
        Assert.assertEquals("william label", transaction.response.facets[1].categories[0].values[2].label)

        Assert.assertEquals("nested1 label", transaction.response.facets[1].categories[0].categories[0].values[0].label)
        Assert.assertEquals("nested rename", transaction.response.facets[1].categories[0].categories[0].values[1].label)
    }

}
