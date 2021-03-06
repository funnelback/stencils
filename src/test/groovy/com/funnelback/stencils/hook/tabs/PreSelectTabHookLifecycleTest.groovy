package com.funnelback.stencils.hook.tabs

import com.funnelback.common.config.Config
import com.funnelback.common.facetednavigation.models.FacetConstraintJoin
import com.funnelback.common.facetednavigation.models.FacetSelectionType
import com.funnelback.common.facetednavigation.models.FacetValues
import com.funnelback.common.facetednavigation.models.FacetValuesOrder
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.collection.FacetedNavigationConfig
import com.funnelback.publicui.search.model.collection.Profile
import com.funnelback.publicui.search.model.collection.facetednavigation.FacetDefinition
import com.funnelback.publicui.search.model.collection.facetednavigation.impl.CollectionFill
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class PreSelectTabHookLifecycleTest {

    def hook
    def config
    def transaction
    def inputParameterMap

    @Before
    void beforeTEst() {
        hook = new TabsHookLifecycle()
        inputParameterMap = [:]

        transaction = new SearchTransaction()

        config = Mockito.mock(Config.class)

        def collection = new Collection("mock", config)
        collection.profiles["_default"] = new Profile("_default")

        def question = Mockito.mock(SearchQuestion.class)
        Mockito.when(question.inputParameterMap).thenReturn(inputParameterMap)
        Mockito.when(question.collection).thenReturn(collection)
        Mockito.when(question.questionType).thenReturn(SearchQuestion.SearchQuestionType.SEARCH)
        Mockito.when(question.currentProfile).thenReturn("_default")

        transaction.question = question

        // Prepare a facet definition for a typical Tab facet
        def coursesCategory = new CollectionFill("Courses", ["courses-1", "courses-2"])
        coursesCategory.facetName = "Tabs"
        def websiteCategory = new CollectionFill("Website", ["web-1", "web-2"])
        websiteCategory.facetName = "Tabs"
        def socialCategory = new CollectionFill("Social", ["social-1", "social-2"])
        socialCategory.facetName = "Tabs"

        def tabsFacetDefinition = new FacetDefinition(
                "Tabs",
                [
                        coursesCategory,
                        websiteCategory,
                        socialCategory
                ],
                FacetSelectionType.SINGLE_AND_UNSELECT_OTHER_FACETS,
                FacetConstraintJoin.AND,
                FacetValues.FROM_UNSCOPED_QUERY,
                [FacetValuesOrder.CATEGORY_DEFINITION_ORDER])

        // Assign our definition to the default profile
        def fnConfig = new FacetedNavigationConfig([tabsFacetDefinition])
        question.collection.profiles["_default"].facetedNavConfConfig = fnConfig
    }

    @Test
    void testPreselectedTab() {
        Mockito.when(config.value(TabsHookLifecycle.DEFAULT_SELECTED_TAB_KEY)).thenReturn("Website")
        hook.preProcess(transaction)

        Assert.assertTrue("A parameter to select the Website tab should have been injected", inputParameterMap.containsKey("f.Tabs|web-1,web-2"))
        Assert.assertEquals("The value of the injected parameter should be Website", "Website", inputParameterMap["f.Tabs|web-1,web-2"])
    }

    @Test
    void testNoPreselectedTab() {
        hook.preProcess(transaction)

        Assert.assertTrue("No parameters should have been injected", inputParameterMap.isEmpty())
    }

    @Test
    void testPreselectInvalidTab() {
        Mockito.when(config.value(TabsHookLifecycle.DEFAULT_SELECTED_TAB_KEY)).thenReturn("Invalid")
        hook.preProcess(transaction)

        Assert.assertTrue("No parameters should have been injected", inputParameterMap.isEmpty())
    }

    @Test
    void testPreselectWhenAValueIsAlreadySelected() {
        inputParameterMap["f.Tabs|courses-1,courses-2"] = "Courses"
        Mockito.when(config.value(TabsHookLifecycle.DEFAULT_SELECTED_TAB_KEY)).thenReturn("Invalid")
        hook.preProcess(transaction)

        Assert.assertEquals("No new parameters should have been injected", 1, inputParameterMap.size())
        Assert.assertEquals("The existing parameter should have been left as-is", "Courses", inputParameterMap["f.Tabs|courses-1,courses-2"])

    }


}
