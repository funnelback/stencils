package com.funnelback.stencils.util

/**
 * Utilities for Operating System information
 *
 * @author nguillaumin@funnelback.com
 */
class OSUtils {

    /** Suffix to use on Windows for executables */
    static private WINDOWS_EXE_SUFFIX = ".exe"

    /** Get a copy of the systen properties. Overridden for unit testing */
    private Properties systemProperties = System.properties

    /**
     * @return True if the OS is Windows, false otherwise
     */
    boolean isOSWindows() {
        return systemProperties["os.name"] != null && systemProperties["os.name"].contains("Windows")
    }

    /**
     * @return Executable suffix to use on the current OS (Typically '.exe' on Windows and
     * an empty String on Linux/Mac)
     */
    String getExecutableSuffix() {
        if (isOSWindows()) {
            return WINDOWS_EXE_SUFFIX
        } else {
            return ""
        }
    }

    void setSystemProperties(Properties systemProperties) {
        this.systemProperties = systemProperties
    }
}
