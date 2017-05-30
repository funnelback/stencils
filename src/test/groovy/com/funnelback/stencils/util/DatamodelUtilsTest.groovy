package com.funnelback.stencils.util

import org.junit.Assert
import org.junit.Test

class DatamodelUtilsTest {

    @Test
    void testGetQueryStringMapCopy() {
        def testMap = Collections.unmodifiableMap([
                "key1": ["value-1", "value-2"],
                "key2": ["value-A"]
        ])

        def copyMap = DatamodelUtils.getQueryStringMapCopy(testMap)

        Assert.assertNotSame("The copy should not be the same instance as the source",
                testMap, copyMap)

        Assert.assertEquals("The copy should be identical to the source",
                testMap, copyMap)

        // Adding an entry should be allowed on the copy
        copyMap["new-entry"] = ["new-value"]

        // Modifying an existing entry should be allowed on the copy
        copyMap["key1"] << "value-3"

        Assert.assertEquals("Copy should have been updated", [
                "key1"     : ["value-1", "value-2", "value-3"],
                "key2"     : ["value-A"],
                "new-entry": ["new-value"]
        ], copyMap)
    }

    @Test
    void testGetQueryStringMapCopyEmptyOrNull() {
        Assert.assertEquals([:], DatamodelUtils.getQueryStringMapCopy(null));
        Assert.assertEquals([:], DatamodelUtils.getQueryStringMapCopy([:]));
    }

    @Test
    void testRemoveValueAndPossiblyParameterFromMap() {
        def getQueryString = {
            return [
                    "param1": ["value1", "value2"],
                    "param2": ["value1"],
                    "param3": ["value1"]
            ]
        }

        def qs = getQueryString()
        DatamodelUtils.removeQueryStringFacetValue(qs, "param1", "value1")
        Assert.assertEquals(
                "Removing param1=value1 should preserve param1=value2", [
                "param1": ["value2"],
                "param2": ["value1"],
                "param3": ["value1"]
        ], qs)

        qs = getQueryString()
        DatamodelUtils.removeQueryStringFacetValue(qs, "param2", "value1")
        Assert.assertEquals(
                "Removing param2=value1 should completely remove param2", [
                "param1": ["value1", "value2"],
                "param3": ["value1"]
        ], qs)

        qs = getQueryString()
        DatamodelUtils.removeQueryStringFacetValue(qs, "non-existent", "dummy")
        Assert.assertEquals(
                "Removing a non-existent parameter should not affect the map", [
                "param1": ["value1", "value2"],
                "param2": ["value1"],
                "param3": ["value1"]
        ], qs)
    }

    @Test
    void testRemoveQueryStringFacetValueEncodedParams() {
        def qs = [
                "param1"    : ["value1"],
                "f.Facet|X" : ["Canberra"],
                "f.Facet|Y" : ["ACT"],
                "facetScope": ["f.Facet%7CX=Canberra&f.Facet%7CY=ACT"]
        ]

        DatamodelUtils.removeQueryStringFacetValue(qs, "f.Facet|X", "Canberra")
        Assert.assertEquals([
                "param1"    : ["value1"],
                "f.Facet|Y" : ["ACT"],
                "facetScope": ["f.Facet%7CY=ACT"]
        ], qs)
    }

    @Test
    void testRemoveQueryStringFacetValue() {
        def getQueryString = {
            return [
                    "param1"    : ["value1", "value2"],
                    "param2"    : ["value1"],
                    "param3"    : ["value1"],
                    "facetScope": ["param3=value1&param1=value1&param1=value2"]
            ]
        }

        def qs = getQueryString()
        DatamodelUtils.removeQueryStringFacetValue(qs, "param1", "value1")
        Assert.assertEquals(
                "Removing param1=value1 should preserve param1=value2 and also remove it from the facetScope", [
                "param1"    : ["value2"],
                "param2"    : ["value1"],
                "param3"    : ["value1"],
                "facetScope": ["param3=value1&param1=value2"]
        ], qs)

        qs = getQueryString()
        DatamodelUtils.removeQueryStringFacetValue(qs, "param2", "value1")
        Assert.assertEquals(
                "Removing param2=value1 should completely remove param2", [
                "param1"    : ["value1", "value2"],
                "param3"    : ["value1"],
                "facetScope": ["param3=value1&param1=value1&param1=value2"]
        ], qs)

        qs = getQueryString()
        DatamodelUtils.removeQueryStringFacetValue(qs, "param3", "value1")
        Assert.assertEquals(
                "Removing param3=value1 should completely remove param3, including in facetScope", [
                "param1"    : ["value1", "value2"],
                "param2"    : ["value1"],
                "facetScope": ["param1=value1&param1=value2"]
        ], qs)

        qs = getQueryString()
        DatamodelUtils.removeQueryStringFacetValue(qs, "param1", "value1")
        DatamodelUtils.removeQueryStringFacetValue(qs, "param1", "value2")
        DatamodelUtils.removeQueryStringFacetValue(qs, "param3", "value1")
        Assert.assertEquals(
                "Removing all values of param1 and param3 should remove them completely, and should remove facetScope as it is now empty", [
                "param2": ["value1"]
        ], qs)
    }

    @Test
    void testFilterQueryStringParameters() {
        def getQueryString = {
            return [
                    "param1"    : ["value1", "value2"],
                    "param2"    : ["value1"],
                    "param3"    : ["value1"],
                    "facetScope": ["param3=value1&param1=value1&param1=value2"]
            ]
        }

        Assert.assertEquals(
                "Filtering param1 parameter should remove it from the map and facetScope", [
                "param2"    : ["value1"],
                "param3"    : ["value1"],
                "facetScope": ["param3=value1"]
        ],
                DatamodelUtils.filterQueryStringParameters(getQueryString(), { key, value -> !key.startsWith("param1") }))

        Assert.assertEquals(
                "Filtering param2 parameter should remove it from the map and leave facetScope unchanged", [
                "param1"    : ["value1", "value2"],
                "param3"    : ["value1"],
                "facetScope": ["param3=value1&param1=value1&param1=value2"]
        ],
                DatamodelUtils.filterQueryStringParameters(getQueryString(), { key, value -> key != "param2" }))

        Assert.assertEquals(
                "Filtering param1 and param3 should remove them from the map and facetScope", [
                "param2": ["value1"]
        ],
                DatamodelUtils.filterQueryStringParameters(getQueryString(), { key, value -> !key.matches("param[13]") }))

    }


}
