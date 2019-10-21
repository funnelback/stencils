# Base Templates

Configuration options for base templates can be set in the collection's `collection.cfg` file or in the profile's `profile.cfg` file. The following settings are allowed:

## client_includes.ftl

```
stencils.client_includes.[header/footer].url=(url to collect header or footer)
stencils.client_includes.[header/footer].[end/start]=(regex to start and end inclusion)
stencils.client_includes.[header/footer].cssSelector=(jSoup selector, instead of start/end)
stencils.client_includes.[header/footer].relative=[true/false]
stencils.client_includes.[header/footer].username=(username for HTTP authentication)
stencils.client_includes.[header/footer].password=(password for HTTP authentication)
stencils.client_includes.[header/footer].useragent=(useragent used when fetching the remote HTML)
stencils.client_includes.[header/footer].timeout=(time to wait for the resource, in seconds)
stencils.client_includes.[header/footer].removeByCssSelectors=(list of jSoup selectors to remove elements)
stencils.client_includes.[header/footer].expiry=(time to hold HTML in cache, in seconds)
```