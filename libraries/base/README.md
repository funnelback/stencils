# Base Templates

Configuration options for base templates can be set in the collection's `collection.cfg` file or in the profile's `profile.cfg` file. The following settings are allowed:

## base.ftl

The `base.ftl` file allows configuring different result styles based on either collections `stencils.template.result.collection-name=template-name` or gscopes `stencils.template.result.gscope_name=template_name`. Examples 

```
stencils.template.result.yvcc-courses=courses
stencils.template.result.catalog=programs
```

## client_includes.ftl

```
stencils.client_includes.[header/footer].url=(url to collect header or footer)
stencils.client_includes.[header/footer].[end/start]=(regex to start and end inclusion)
stencils.client_includes.[header/footer].cssSelector=(jSoup selector, instead of start/end)
stencils.client_includes.[header/footer].expiry=(time to cache, in seconds)
stencils.client_includes.[header/footer].relative=[true/false]
stencils.client_includes.[header/footer].username=(username for HTTP authentication)
stencils.client_includes.[header/footer].password=(password for HTTP authentication)
stencils.client_includes.[header/footer].useragent=(useragent used when fetching the remote HTML)
stencils.client_includes.[header/footer].timeout=(time to wait for the resource, in seconds)
stencils.client_includes.[header/footer].removeByCssSelectors=(list of jSoup selectors to remove elements)
stencils.client_includes.[header/footer].expiry=(time to hold HTML in cache, in seconds)
```

## history_cart.ftl

The Funnelback API endpoints for the cart, search history, and click history are (respectively):
`/s/cart.json`, `/s/search-history.json`, and `/s/click-history.json`.

In an embedded HTML integration, the cart and history asynchronous HTTP request may be proxied through the client's back-end to the Funnelback server to correctly pass the sessions cookie. The API base is likely not the same, it can be configured in the profile or collection configuration settings as follows:

```
stencils.sessions.cart.api_base=<proxy endpoint for cart in client back-end>
stencils.sessions.history.search.api_base=<proxy endpoint for search history in client back-end>
stencils.sessions.history.click.api_base=<proxy endpoint for click history in client back-end>
```

For example, proxy endpoints in a Wordpress CMS might be located at:
```
stencils.sessions.cart.api_base=/search/wp-json/funnelback/v1/cart
stencils.sessions.history.search.api_base=/search/wp-json/funnelback/v1/search-history
stencils.sessions.history.click.api_base=/search/wp-json/funnelback/v1/click-history
```
