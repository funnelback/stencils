package com.funnelback.stencils.hook.core

import com.funnelback.publicui.search.model.padre.Category
import com.funnelback.publicui.search.model.padre.Cluster
import com.funnelback.publicui.search.model.padre.ContextualNavigation
import com.funnelback.publicui.search.model.padre.ResultPacket
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class ContextualNavigationHookLifecycleTest {

    def hook
    def transaction

    @Before
    void before() {
        transaction = new SearchTransaction(null, new SearchResponse())
        transaction.response.resultPacket = new ResultPacket()
        transaction.response.resultPacket.contextualNavigation = new ContextualNavigation()

        hook = new ContextualNavigationHookLifecycle()
    }

    @Test
    void testOnlySiteWithSingleClusterNoValue() {
        def category = new Category("site", 0, "", "")
        transaction.response.resultPacket.contextualNavigation.categories << category

        hook.postDatafetch(transaction)

        Assert.assertTrue(
                "Site category should have been removed",
                transaction.response.resultPacket.contextualNavigation.categories.isEmpty())
    }

    @Test
    void testOnlySiteWithSingleClusterSingleValue() {
        def category = new Category("site", 0, "", "")
        category.clusters << new Cluster("href", 0, "label")
        transaction.response.resultPacket.contextualNavigation.categories << category

        hook.postDatafetch(transaction)

        Assert.assertTrue(
                "Site category should have been removed",
                transaction.response.resultPacket.contextualNavigation.categories.isEmpty())
    }

    @Test
    void testOnlySiteWithMultipleClusters() {
        def category = new Category("site", 0, "", "")
        category.clusters << new Cluster("href1", 1, "label1")
        category.clusters << new Cluster("href2", 2, "label2")
        transaction.response.resultPacket.contextualNavigation.categories << category

        hook.postDatafetch(transaction)

        Assert.assertEquals(
                "Site category should have been preserved",
                1,
                transaction.response.resultPacket.contextualNavigation.categories.size())
        Assert.assertEquals(
                "The site category should have been removed",
                "site",
                transaction.response.resultPacket.contextualNavigation.categories[0].name)
    }

    @Test
    void testMultipleCategoriesWithSingleSiteCluster() {
        def typeCategory = new Category("type", 0, "", "")
        typeCategory.clusters << new Cluster("href1", 1, "label1")
        typeCategory.clusters << new Cluster("href2", 2, "label1")

        def siteCategory = new Category("site", 0, "", "")
        siteCategory.clusters << new Cluster("href1", 1, "label1")

        transaction.response.resultPacket.contextualNavigation.categories << typeCategory << siteCategory

        hook.postDatafetch(transaction)

        Assert.assertEquals(
                "Only 1 category should remain",
                1,
                transaction.response.resultPacket.contextualNavigation.categories.size())
        Assert.assertEquals(
                "The site category should have been removed",
                "type",
                transaction.response.resultPacket.contextualNavigation.categories[0].name)
    }

    @Test
    void testMultipleCategoriesWithMultipleSiteCluster() {
        def typeCategory = new Category("type", 0, "", "")
        typeCategory.clusters << new Cluster("href1", 1, "label1")
        typeCategory.clusters << new Cluster("href2", 2, "label1")

        def siteCategory = new Category("site", 0, "", "")
        siteCategory.clusters << new Cluster("href1", 1, "label1")
        siteCategory.clusters << new Cluster("href2", 2, "label2")

        transaction.response.resultPacket.contextualNavigation.categories << typeCategory << siteCategory

        hook.postDatafetch(transaction)

        Assert.assertEquals(
                "All categories should remain",
                2,
                transaction.response.resultPacket.contextualNavigation.categories.size())
        Assert.assertEquals(
                "The type category should have been preserved",
                "type",
                transaction.response.resultPacket.contextualNavigation.categories[0].name)
        Assert.assertEquals(
                "The site category should have been preserved",
                "site",
                transaction.response.resultPacket.contextualNavigation.categories[1].name)
        Assert.assertEquals(
                "The type category clusters should have been preserved",
                2,
                transaction.response.resultPacket.contextualNavigation.categories[0].clusters.size())
        Assert.assertEquals(
                "The stie category clusters should have been preserved",
                2,
                transaction.response.resultPacket.contextualNavigation.categories[1].clusters.size())
    }

}

