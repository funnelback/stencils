package com.funnelback.stencils.hook.facets

import com.funnelback.publicui.search.model.transaction.Facet
import org.junit.Assert
import org.junit.Test

class StencilCategoryValueTest {

    @Test
    void test() {
        Facet.CategoryValue value = new Facet.CategoryValue("data", "label", 42, "name=value", "constraint", true)
        def stencilValue = new StencilCategoryValue(value)

        Assert.assertEquals("name", stencilValue.queryStringParamName)
        Assert.assertEquals("value", stencilValue.queryStringParamValue)

        Assert.assertNull(stencilValue.selectUrl)
        Assert.assertNull(stencilValue.unselectUrl)
    }
}

