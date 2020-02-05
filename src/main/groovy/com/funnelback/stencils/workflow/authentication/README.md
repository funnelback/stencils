# Microsoft Active Directory Federation Services (ADFS) Pre-Gather Authentication

This script provides a way for the Funnelback crawler to authenticate through a Microsoft ADFS page with a username and
password. 

## Background

The standard ADFS Login Form requires two POST requests to authenticate and set the correct cookies on the user's
browser. The first POST request is sent after the user types their username and password, and the second POST request
is initiated by Javascript so it is not seen by the user.

The first request has a static URL but dynamic form parameters (solvable by pre-crawl authentication) and the second
request has a dynamic URL but static form parameters (solvable by in-crawl authentication). Out of the box, Funnelback
can only be configured for one of those modes, which requires this custom workflow script.

### Required Configuration

The following fields are required to configure in `collection.cfg`

`stencils.workflow.crawler.adfs.username` : The username the crawler will use to log in

Note: On the ADFS login page, the `domain:\\` may be prepended  by
Javascript to the username depending on its configuration. If this is the case, you must
also prepend the `domain:\\` here.

`stencils.workflow.crawler.adfs.password` : The password the crawler will use to log in

`stencils.workflow.crawler.adfs.cookie_domain` : The domain that the authentication cookies will be issued for (the
domain that is being crawled).

`stencils.workflow.crawler.adfs.start_url` : The first page for the crawler to visit. This is generally the home page
of the domain that you wish to crawl (NOT the login page). When the crawler attempts to connect to
this home page, it will be redirected to the login page.
This parameter is not required if the `start_url` configuration parameter is set (must be a single value).

`stencils.workflow.crawler.adfs.post_response_page` : This is a left-anchored match to the URL of the second POST
request in the authentication process. This URL is typically not seen when logging in through the browser because
the POST is sent by Javascript before the page can be shown to the user. This can be seen by disabling Javascript
while testing the authentication flow. This URL is dynamically generated, thus only a left-anchored match is required.

This URL may look similar to `https://secure.client.com/saml/postResponse`. It also may require a port number, i.e.
`https://secure.client.com:443/saml/postResponse`.


### Configuration Examples

Configure the crawler parameters in the `collection.cfg` file.

Example:
```
stencils.workflow.crawler.adfs.username=funnelback-crawler
stencils.workflow.crawler.adfs.password=VeRy_SeCuRe_PaSsWoRd
stencils.workflow.crawler.adfs.cookie_domain=secure.client.com
stencils.workflow.crawler.adfs.start_url=https://secure.client.com/home
stencils.workflow.crawler.adfs.post_response_page=https://secure.client.com/saml/postResponse
```

Configure the pre gather command in the `collection.cfg` file including the Funnelback libraries.

Example (Linux):
```
pre_gather_command=$SEARCH_HOME/linbin/java/bin/java -cp "$SEARCH_HOME/lib/java/all/*" groovy.ui.GroovyMain $SEARCH_HOME/share/stencils/src/main/groovy/com/funnelback/stencils/workflow/authentication/ADFSPreGatherAuthentication.groovy $SEARCH_HOME $COLLECTION_NAME
```