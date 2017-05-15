package com.funnelback.stencils.util

import org.junit.Assert
import org.junit.Test

class OSUtilsTest {

    @Test
    void testOSWindows() {
        def osUtils = new OSUtils()
        osUtils.systemProperties = [ "os.name":  "Windows 10"]

        Assert.assertTrue(osUtils.isOSWindows())
    }

    @Test
    void testOSNotWindows() {
        def osUtils = new OSUtils()
        osUtils.systemProperties = [ "os.name":  "Linux RedHat"]

        Assert.assertFalse(osUtils.isOSWindows())
    }

    @Test
    void testExecutableSuffixWindows() {
        def osUtils = new OSUtils()
        osUtils.systemProperties = [ "os.name":  "Windows 8.1"]

        Assert.assertEquals(".exe", osUtils.getExecutableSuffix())
    }

    @Test
    void testExecutableSuffixNotWindows() {
        def osUtils = new OSUtils()
        osUtils.systemProperties = [ "os.name":  "Ubuntu 16.10"]

        Assert.assertEquals("", osUtils.getExecutableSuffix())
    }

}
