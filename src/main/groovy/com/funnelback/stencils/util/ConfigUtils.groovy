package com.funnelback.stencils.util

import com.funnelback.common.config.Config
import com.funnelback.stencils.hook.StencilHooks;

/**
 * Utilities for Funnelback {@link Config}s
 * 
 * @author nguillaumin@funnelback.com
 */
public class ConfigUtils {

    /** Utility class = private constructor */
    private ConfigUtils() { }
    
    /**
     * Check if a specific Stencil is enabled
     * @param config {@link Config} to check
     * @param stencil Name of the Stencil to check
     * @return true if the Stencil is enabled or if the Config is null, false otherwise
     */
    public static boolean isStencilEnabled(Config config, String stencil) {
        if (config == null) {
            return false
        }
        
        return config.value(StencilHooks.STENCILS_KEY, "")
            .split(",")
            .collect { name -> name.trim() }
            .any { name -> name == stencil }
    }
    
}
