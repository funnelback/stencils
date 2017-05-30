package com.funnelback.stencils.hook.facets

import com.funnelback.common.config.Config
import com.funnelback.publicui.search.model.collection.Collection
import com.funnelback.publicui.search.model.transaction.Facet
import com.funnelback.publicui.search.model.transaction.SearchQuestion
import com.funnelback.publicui.search.model.transaction.SearchResponse
import com.funnelback.publicui.search.model.transaction.SearchTransaction
import com.funnelback.stencils.hook.StencilHooks
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class FacetsHookLifecycleTest {

    def hook
    def config
    def transaction

    @Before
    void before() {
        hook = new FacetsHookLifecycle()
        config = Mockito.mock(Config.class)

        Mockito.when(config.value(StencilHooks.STENCILS_KEY, "")).thenReturn("facets")

        transaction = new SearchTransaction(new SearchQuestion(), new SearchResponse())
        transaction.question.collection = new Collection("collection", config)
        transaction.response.customData[StencilHooks.QUERY_STRING_MAP_KEY] = [:]
    }

    @Test
    void testGetCategories() {
        def c1 = new Facet.Category("Category 1", null)
        def c11 = new Facet.Category("Category 1.1", null)
        def c12 = new Facet.Category("Category 1.2", null)
        def c121 = new Facet.Category("Category 1.2.1", null)

        c1.categories << c11 << c12
        c12.categories << c121

        def c2 = new Facet.Category("Category 2", null)
        def c21 = new Facet.Category("Category 2.1", null)

        c2.categories << c21

        def c3 = new Facet.Category("Category 3", null)

        Assert.assertEquals([c11, c12, c121], hook.getCategories(c1))
        Assert.assertEquals([c21], hook.getCategories(c2))
        Assert.assertEquals([], hook.getCategories(c3))
    }

    @Test
    void testGetStencilFacet() {

        def valuesList = [
                new StencilCategoryValue(new Facet.CategoryValue("data1", "label1", 1, "queryStringParamName1=queryStringParamValue1", "constraint1", false)),
                new StencilCategoryValue(new Facet.CategoryValue("data2", "label2", 2, "queryStringParamName2=queryStringParamValue2", "constraint2", false))
        ]
        Facet f = new Facet("Facet")
        def stencilFacet = hook.getStencilFacet([
                "param"     : ["value"],
                "f.Facet|X" : ["value1", "value2"],
                "f.Facet|Y" : ["value1", "value2"],
                "facetScope": ["f.Facet|Z=value1&f.Location|W=Canberra"]
        ], f, valuesList)

        Assert.assertEquals(
                "The stencil facet name should be identical to the source facet name",
                "Facet",
                stencilFacet.name)
        Assert.assertEquals(
                "The clear all URL should not contain any f.Facet parameter, preserve existing parameters including facetScope",
                "?param=value&facetScope=f.Location%257CW%3DCanberra",
                stencilFacet.unselectAllUrl)
        Assert.assertEquals(
                "The clear all facetScope should not contain any f.Facet parameter and preserve other parameters",
                "f.Location%7CW=Canberra",
                stencilFacet.unselectAllFacetScope)
        Assert.assertEquals(
                "The list of values passed in should be assigned to the facet",
                valuesList,
                stencilFacet.values)
        Assert.assertFalse(
                "The facet should not be selected as no values are selected",
                stencilFacet.selected)
    }

    @Test
    void testGetStencilCategoryValue() {
        def cv = new Facet.CategoryValue("data", "label", 1, "f.Facet|Y=ACT", "constraint", false)
        def stencilCv = hook.getStencilCategoryValue([
                "param"     : ["value"],
                "f.Facet|X" : ["Australia"],
                "f.Facet|Y" : ["ACT", "QLD", "WA"],
                "facetScope": ["f.Type%7Cf=PDF&f.Facet%7CY=ACT"]
        ], cv)

        Assert.assertEquals(
                "The query string parameter name should have been correctly extracted",
                "f.Facet|Y",
                stencilCv.queryStringParamName)
        Assert.assertEquals(
                "The query string parameter value should have been correctly extracted",
                "ACT",
                stencilCv.queryStringParamValue)
        Assert.assertEquals(
                "The select URL should contain the query string parameters for the value, and the value present in facetScope should have been preserved",
                "?param=value&f.Facet%7CX=Australia&f.Facet%7CY=ACT&facetScope=f.Type%257Cf%3DPDF%26f.Facet%257CY%3DACT",
                stencilCv.selectUrl)
        Assert.assertEquals(
                "The unselect URL should not include the query string parameters for the value, nor in facetScope",
                "?param=value&f.Facet%7CX=Australia&f.Facet%7CY=QLD&f.Facet%7CY=WA&facetScope=f.Type%257Cf%3DPDF",
                stencilCv.unselectUrl)
    }

    @Test
    void testGetSelectedFacetValuesNoValues() {
        def selectedValues = hook.getSelectedFacetValues([
                "param"      : ["value"],
                "f.Type|f"   : ["PDF"],
                "f.Country|X": ["Australia"],
                "f.State|Y"  : ["ACT", "QLD"]
        ], [:])

        Assert.assertEquals("No values should have been selected", 0, selectedValues.length)
    }

    @Test
    void testGetSelectedFacetValues() {
        def selectedValues = hook.getSelectedFacetValues([
                "param"      : ["value"],
                "f.Type|f"   : ["PDF"],
                "f.Country|X": ["Australia"],
                "f.State|Y"  : ["ACT", "QLD"]
        ], [
                "f.Country|X": ["Australia"],
                "f.State|Y"  : ["ACT", "QLD"]
        ])

        Assert.assertEquals(
                "Selected values should have been correctly computed from the query string and list of selected values", [
                new StencilSelectedFacetValue([
                        facetName  : "Country",
                        value      : "Australia",
                        unselectUrl: "?param=value&f.Type%7Cf=PDF&f.State%7CY=ACT&f.State%7CY=QLD"
                ]),
                new StencilSelectedFacetValue([
                        facetName  : "State",
                        value      : "ACT",
                        unselectUrl: "?param=value&f.Type%7Cf=PDF&f.Country%7CX=Australia&f.State%7CY=QLD"
                ]),
                new StencilSelectedFacetValue([
                        facetName  : "State",
                        value      : "QLD",
                        unselectUrl: "?param=value&f.Type%7Cf=PDF&f.Country%7CX=Australia&f.State%7CY=ACT"
                ])
        ], selectedValues as List)
    }

    @Test
    void test() {
        def c1 = new Facet.Category("Category 1", null)
        c1.values << getValue("Category 1", "X", "Value 1.a")
        c1.values << getValue("Category 1", "X", "Value 1.b")
        c1.values << getValue("Category 1", "X", "Value 1.c")

        def c11 = new Facet.Category("Category 1.1", null)
        c11.values << getValue("Category 1.1", "Y", "Value 1.1.a")
        c11.values << getValue("Category 1.1", "Y", "Value 1.1.b")

        def c12 = new Facet.Category("Category 1.2", null)
        c12.values << getValue("Category 1.2", "Z", "Value 1.2.a")
        c1.categories << c11 << c12

        def c2 = new Facet.Category("Category 2", null)
        c2.values << getValue("Category 2", "A", "Value 2.a")
        c2.values << getValue("Category 2", "A", "Value 2.b")

        def f = new Facet("Facet")
        f.categories << c1 << c2

        transaction.response.facets << f

        transaction.response.customData[StencilHooks.QUERY_STRING_MAP_KEY] = [
                "param"     : ["value"],
                "facetScope": ["f.OtherFacet%7C=Other+Value"]
        ]

        hook.postProcess(transaction)

        def stencilsFacets = transaction.response.customData[FacetsHookLifecycle.STENCILS_FACETS]
        Assert.assertNotNull(stencilsFacets)
        Assert.assertEquals(1, stencilsFacets.size())

        def facet = stencilsFacets[0]
        Assert.assertEquals("Facet", facet.name)
        Assert.assertEquals("?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue", facet.unselectAllUrl)
        Assert.assertEquals("f.OtherFacet%7C=Other+Value", facet.unselectAllFacetScope)
        Assert.assertEquals(false, facet.selected)

        def expectedValues = [
                new StencilCategoryValue(new Facet.CategoryValue("Value 1.a", "Value 1.a", 42, "f.Category 1|X=Value 1.a", "X", false)),
                new StencilCategoryValue(new Facet.CategoryValue("Value 1.b", "Value 1.b", 42, "f.Category 1|X=Value 1.b", "X", false)),
                new StencilCategoryValue(new Facet.CategoryValue("Value 1.c", "Value 1.c", 42, "f.Category 1|X=Value 1.c", "X", false)),
                new StencilCategoryValue(new Facet.CategoryValue("Value 1.1.a", "Value 1.1.a", 42, "f.Category 1.1|Y=Value 1.1.a", "Y", false)),
                new StencilCategoryValue(new Facet.CategoryValue("Value 1.1.b", "Value 1.1.b", 42, "f.Category 1.1|Y=Value 1.1.b", "Y", false)),
                new StencilCategoryValue(new Facet.CategoryValue("Value 1.2.a", "Value 1.2.a", 42, "f.Category 1.2|Z=Value 1.2.a", "Z", false)),
                new StencilCategoryValue(new Facet.CategoryValue("Value 2.a", "Value 2.a", 42, "f.Category 2|A=Value 2.a", "A", false)),
                new StencilCategoryValue(new Facet.CategoryValue("Value 2.b", "Value 2.b", 42, "f.Category 2|A=Value 2.b", "A", false)),
        ]

        expectedValues[0].selectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue&f.Category+1%7CX=Value+1.a"
        expectedValues[0].unselectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue"
        expectedValues[1].selectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue&f.Category+1%7CX=Value+1.b"
        expectedValues[1].unselectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue"
        expectedValues[2].selectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue&f.Category+1%7CX=Value+1.c"
        expectedValues[2].unselectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue"
        expectedValues[3].selectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue&f.Category+1.1%7CY=Value+1.1.a"
        expectedValues[3].unselectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue"
        expectedValues[4].selectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue&f.Category+1.1%7CY=Value+1.1.b"
        expectedValues[4].unselectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue"
        expectedValues[5].selectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue&f.Category+1.2%7CZ=Value+1.2.a"
        expectedValues[5].unselectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue"
        expectedValues[6].selectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue&f.Category+2%7CA=Value+2.a"
        expectedValues[6].unselectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue"
        expectedValues[7].selectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue&f.Category+2%7CA=Value+2.b"
        expectedValues[7].unselectUrl = "?param=value&facetScope=f.OtherFacet%257C%3DOther%2BValue"

        Assert.assertEquals(expectedValues, facet.values)
    }

    Facet.CategoryValue getValue(String facetName, String constraint, String data) {
        return new Facet.CategoryValue(data, data, 42, "f.${facetName}|${constraint}=${data}", constraint, false)
    }

}
