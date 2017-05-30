package com.funnelback.stencils.hook.facets

import com.funnelback.publicui.search.model.transaction.Facet
import org.junit.Assert
import org.junit.Test

class StencilFacetTest {

    @Test
    void testNoValues() {
        Assert.assertFalse(new StencilFacet([
                name                 : null,
                values               : [],
                unselectAllUrl       : null,
                unselectAllFacetScope: null]).selected)
    }

    @Test
    void testValuesNoSelected() {
        Assert.assertFalse(new StencilFacet([
                name                 : null,
                values               : [
                        new StencilCategoryValue(new Facet.CategoryValue("data", "label", 42, "name=value", "constraint", false)),
                        new StencilCategoryValue(new Facet.CategoryValue("data", "label", 42, "name=value", "constraint", false)),
                        new StencilCategoryValue(new Facet.CategoryValue("data", "label", 42, "name=value", "constraint", false))
                ],
                unselectAllUrl       : null,
                unselectAllFacetScope: null]).selected)
    }

    @Test
    void testValuesSelected() {
        Assert.assertTrue(new StencilFacet([
                name                 : null,
                values               : [
                        new StencilCategoryValue(new Facet.CategoryValue("data", "label", 42, "name=value", "constraint", true)),
                        new StencilCategoryValue(new Facet.CategoryValue("data", "label", 42, "name=value", "constraint", true)),
                        new StencilCategoryValue(new Facet.CategoryValue("data", "label", 42, "name=value", "constraint", false))
                ],
                unselectAllUrl       : null,
                unselectAllFacetScope: null]).selected)
    }

}
