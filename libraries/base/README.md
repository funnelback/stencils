# Base Templates

Configuration options for base templates can be set in the collection's collection.cfg file. The following settings are allowed:

## client_includes.ftl

```
stencils.client_includes.[header/footer].url=(url to collect header or footer)
client_includes.[header/footer].[end/start]=(html to start and end inclusion)
client_includes.[header/footer].relative=[true/false]
```