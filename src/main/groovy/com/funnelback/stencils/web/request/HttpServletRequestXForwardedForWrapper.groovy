package com.funnelback.stencils.web.request

import groovy.util.logging.Log4j2

import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletRequestWrapper

/**
 * Class to manipulate the X-Forwarded-For header of an HTTP request
 *
 * Allows removal of the first or last value of the X-Forwarded-For
 */
@Log4j2
class HttpServletRequestXForwardedForWrapper extends HttpServletRequestWrapper {

    static final def XFF_HEADER = "X-Forwarded-For"

    /**
     * Possible modes of operation
     */
    static enum Mode {
        /** Remove first value of the X-Forwarded-For */
        RemoveFirst,
        /** Remove last value of the X-Forwarded-For */
        RemoveLast
    }

    /** Mode of operation */
    final def mode

    HttpServletRequestXForwardedForWrapper(Mode mode, HttpServletRequest request) {
        super(request)
        this.mode = mode
    }

    /**
     * Check if the requested header is X-Forwarded-For, and if it is
     * alter the value according to the mode
     *
     * @param name Name of the header to retrieve
     * @return Header value, possibly altered
     */
    @Override
    String getHeader(String name) {
        if (name.toLowerCase().equals(XFF_HEADER.toLowerCase())) {
            def value = super.getHeader(name)
            def newValue = value

            if (value && value.contains(",")) {
                try {
                    switch (mode) {
                        case Mode.RemoveFirst:
                            newValue = value.tokenize(",").tail().join(",")
                            break
                        case Mode.RemoveLast:
                            newValue = value.tokenize(",").init().join(",")
                            break
                    }

                    log.debug("Changed ${XFF_HEADER} value from '{}' to '{}'", value, newValue)
                    return newValue
                } catch (e) {
                    log.error("Error while altering ${XFF_HEADER} value '{}'", value, e)
                }
            }
        }

        return super.getHeader(name)
    }
}
