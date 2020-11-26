# Autocompletion

## csv-auto-completion.ftl

This file is a Freemarker template that generates CSV data to build the autocompletion index from.
This process is described in greater detail in the [Groovy script documentation](../../src/main/groovy/com/funnelback/stencils/workflow/autocompletion).

This file is generally included in the `auto-completion` profile of a datasource as `auto-completion.ftl`. The syntax to include the file is:

```
<#include "/share/stencils/libraries/autocompletion/csv-auto-completion.ftl">
```

### Configuration Options

The following configuration option controls whether spaces will be preserved after commas. If the (default) value of false is used, spaces after commas are not preserved.

| Key | Type | Allowed Values | Default Value |
| --- | ---- | -------------- | ------------- |
| stencils.auto-completion.preserve-spaces | boolean | true/false | false

This configuration setting replaces the space character with `&nbsp;`. When templating the autocompletion item, ensure to not escape the HTML so that characters are not double-encoded. For example, in Handlebars use triple curly-brace instead of double curly-brace.
