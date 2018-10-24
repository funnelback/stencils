package com.funnelback.stencils.web.request

import com.funnelback.stencils.web.request.HttpServletRequestXForwardedForWrapper
import org.junit.Assert
import org.junit.Test
import org.mockito.Mockito

import javax.servlet.http.HttpServletRequest

class HttpServletRequestXForwardedForWrapperTest {

    @Test
    void testShouldNotChangeOtherHeaders() {
        def request = Mockito.mock(HttpServletRequest.class)
        Mockito.when(request.getHeader("Custom-Header")).thenReturn("Custom-Value")
        def wrapped = new HttpServletRequestXForwardedForWrapper(HttpServletRequestXForwardedForWrapper.Mode.RemoveFirst, request)

        Assert.assertEquals("Non X-Forwarded-For header should be left unchanged",
                "Custom-Value", wrapped.getHeader("Custom-Header"))
    }

    @Test
    void testNoXForwardedForValue() {
        def request = Mockito.mock(HttpServletRequest.class)
        Mockito.when(request.getHeader("X-Forwarded-For")).thenReturn(null)
        def wrapped = new HttpServletRequestXForwardedForWrapper(HttpServletRequestXForwardedForWrapper.Mode.RemoveFirst, request)

        Assert.assertNull("Null X-Forwarded-For should be kept as-is", wrapped.getHeader("X-Forwarded-For"))
    }

    @Test
    void testSingleXForwardedForValue() {
        def request = Mockito.mock(HttpServletRequest.class)
        Mockito.when(request.getHeader("X-Forwarded-For")).thenReturn("1.2.3.4")
        def wrapped = new HttpServletRequestXForwardedForWrapper(HttpServletRequestXForwardedForWrapper.Mode.RemoveFirst, request)

        Assert.assertEquals("Single valued X-Forwarded-For header should be left unchanged",
                "1.2.3.4", wrapped.getHeader("X-Forwarded-For"))
    }

    @Test
    void testRemoveFirst() {
        def request = Mockito.mock(HttpServletRequest.class)
        Mockito.when(request.getHeader("X-Forwarded-For")).thenReturn("1.2.3.4,5.6.7.8,9.10.11.12")
        def wrapped = new HttpServletRequestXForwardedForWrapper(HttpServletRequestXForwardedForWrapper.Mode.RemoveFirst, request)

        Assert.assertEquals("First value should have been removed",
                "5.6.7.8,9.10.11.12", wrapped.getHeader("X-Forwarded-For"))
    }

    @Test
    void testRemoveLast() {
        def request = Mockito.mock(HttpServletRequest.class)
        Mockito.when(request.getHeader("X-Forwarded-For")).thenReturn("1.2.3.4,5.6.7.8,9.10.11.12")
        def wrapped = new HttpServletRequestXForwardedForWrapper(HttpServletRequestXForwardedForWrapper.Mode.RemoveLast, request)

        Assert.assertEquals("Last value should have been removed",
                "1.2.3.4,5.6.7.8", wrapped.getHeader("X-Forwarded-For"))
    }

    @Test
    void testSpaces() {
        def request = Mockito.mock(HttpServletRequest.class)
        Mockito.when(request.getHeader("X-Forwarded-For")).thenReturn("1.2.3.4  , 5.6.7.8,    9.10.11.12")
        def wrapped = new HttpServletRequestXForwardedForWrapper(HttpServletRequestXForwardedForWrapper.Mode.RemoveFirst, request)

        Assert.assertEquals("Spaces should be preserved",
                " 5.6.7.8,    9.10.11.12", wrapped.getHeader("X-Forwarded-For"))
    }

    @Test
    void testCase() {
        def request = Mockito.mock(HttpServletRequest.class)
        Mockito.when(request.getHeader("x-FoRwArDeD-fOr")).thenReturn("1.2.3.4,5.6.7.8")
        def wrapped = new HttpServletRequestXForwardedForWrapper(HttpServletRequestXForwardedForWrapper.Mode.RemoveFirst, request)

        Assert.assertEquals("X-Forwarded-For header name case should be ignored",
                "5.6.7.8", wrapped.getHeader("x-FoRwArDeD-fOr"))
    }

    @Test
    void testInvalidXForwardedForValue() {
        def request = Mockito.mock(HttpServletRequest.class)
        Mockito.when(request.getHeader("X-Forwarded-For")).thenReturn(",,")
        def wrapped = new HttpServletRequestXForwardedForWrapper(HttpServletRequestXForwardedForWrapper.Mode.RemoveFirst, request)

        Assert.assertEquals("Invalid X-Forwarded-For value should be left as-is",
                ",,", wrapped.getHeader("X-Forwarded-For"))
    }


}
