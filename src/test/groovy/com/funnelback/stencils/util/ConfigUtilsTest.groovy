package com.funnelback.stencils.util

import org.junit.Assert
import org.junit.Test
import org.mockito.Mockito

import com.funnelback.common.config.Config
import com.funnelback.common.config.NoOptionsConfig
import com.funnelback.stencils.hook.StencilHooks

class ConfigUtilsTest {

    @Test
    void testNoStencilConfigured() {
        Config c = Mockito.mock(Config.class)
        Mockito.when(c.value(StencilHooks.STENCILS_KEY, "")).thenReturn("")
        
        Assert.assertFalse(ConfigUtils.isStencilEnabled(c, "stencil"))
    }

    @Test
    void testConfigMissing() {
        Assert.assertFalse(ConfigUtils.isStencilEnabled(null, "stencil"))
    }

    @Test
    void test() {
        Config c = Mockito.mock(Config.class)
        Mockito.when(c.value(StencilHooks.STENCILS_KEY, "")).thenReturn("ab, cd, ef  ")
        
        Assert.assertFalse(ConfigUtils.isStencilEnabled(c, "stencil"))
        Assert.assertFalse(ConfigUtils.isStencilEnabled(c, " cd"))
        Assert.assertFalse(ConfigUtils.isStencilEnabled(c, " ef  "))
        
        Assert.assertTrue(ConfigUtils.isStencilEnabled(c, "ab"))
        Assert.assertTrue(ConfigUtils.isStencilEnabled(c, "cd"))
        Assert.assertTrue(ConfigUtils.isStencilEnabled(c, "ef"))
    }
    
}
