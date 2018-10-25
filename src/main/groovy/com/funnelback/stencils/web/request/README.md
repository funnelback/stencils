# Request wrapper to alter the X-Forwarded-For value

## Background

The X-Forwarded-For header contains a list of IP addresses of the various "hops" that the request
went through before reaching the Funnelback backend server.

In a complex scenario, a request can go through multiple hops:
1. Proxy server of the client, to the CMS
2. CMS to the Funnelback load balancer (partial HTML example)
4. Funnelback load balancer to the actual backend server

In this example, the X-Forwarded-For would have 3 values:
1. The IP address of the client proxy (1.2.3.4)
2. The IP address of the CMS (5.6.7.8)
3. The IP address of the load balancers (9.10.11.12)

```
X-Forwarded-For: 1.2.3.4,5.6.7.8,9.10.11.12
```

Another example is when Funnelback is put behind a Content Delivery Network such as Akamaï:
1. Client makes a request to the Funnelback domain name, that sends to Akamaï
2. Akamaï makes a request to Funnelback load balancers on behalf of the client
3. Load balancers forwards the request to the actual backend server

In all these cases it is desirable to only retain the IP address of the original client to ensure
accurate Analytics. Funnelback has partial support for this with `logging.ignored_x_forwarded_for_ranges`
that will cause the last IP address (load balancer → backend server) to be scrubbed. Multiple IP addresses
may remain however and there's no easy way to control which one should be kept.

For the example in the Akamaï case it would not be practical to configure all the possible IP addresses
of Akamaï (hundreds) to be ignored. A better approach instead is to simply ignore the last X-Forwarded-For
value and consider the one before last, as it will be the one of the client that issued the request to
Akamaï.

For more background and discussions, see FUN-11993.

This utility class allows removing the first or the last value of a X-Forwarded-For header
before it reaches Funnelback. It's intended to be used in a Groovy servlet filter hook.

## Usage

Create a Groovy servlet filter hook in your collection (see the Funnelback documentation), in
`$SEARCH_HOME/conf/$COLLECTION_NAME/GroovyServletFilterHookPublicUIImpl.groovy`. In this filter,
wrap the request using this wrapper and specifying which mode to use (remove first, or remove last)

```groovy
package com.<client>

import com.funnelback.stencils.web.request.HttpServletRequestXForwardedForWrapper
import com.funnelback.springmvc.web.filter.GroovyServletFilterHook
import javax.servlet.ServletRequest

@groovy.util.logging.Log4j2
class GroovyServletFilterHookPublicUIImpl extends GroovyServletFilterHook {

    ServletRequest preFilterRequest(ServletRequest request) {
        return new HttpServletRequestXForwardedForWrapper(HttpServletRequestXForwardedForWrapper.Mode.RemoveLast, request)
    }
}
```  

## Considerations

Note that:
- The first IP address in the X-Forwarded-For header will be the one closer to the client
- X-Forwarded-For should not be trusted for access restriction as it can be easily spoofed
