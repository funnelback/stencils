Template files
===============

**&lt; NOTE: This fits in the build specification v0.1 under 7.2.4 Template files&gt;**<br>
Funnelback uses templates to allow administrators to customise their search interface. It supports changes to the appearance of the search page, as well as advanced search and inclusion of metadata/XML fields in result summaries.
<br>
Classic UI templates are .form files and are served via IIS.  The Classic UI is accessed from http://cbr50es01p/search/search.cgi?collection=casa-internal&form=<FORMNAME>
<br>
Modern UI templates are .ftl (Freemarker) files and are served via Funnelback’s Jetty web server. The Modern UI is accessed from http://cbr50es01p:8080/s/search.html?collection=casa-internal&form=<FORMNAME>
<br>
<FORMNAME> is the name of the template.  Eg. for casa.form, casa.ftl replace <FORMNAME> with casa.
 form=<FORMNAME> can be omitted from the URL if using the simple.form/ftl template.
<br>
Template files can be edited from the administration interface. See: https://docs.funnelback.com/13.0/search_forms.html

This project uses the following Modern UI Stencils templates;

| File | Description |
| -------- | ---------- |
| simple.ftl | Main index template, that pulls in all other templates. |
| project.view.ftl | Views specific to this project. |
| project.controller.ftl | Controllers specific to this project. |
| base.view.ftl | Views for common search components. |
| base.controller.ftl | Controllers for common search components.  |
| core.view.ftl | Views for core search components. |
| core.controller.ftl | Controllers for core search components. |
| social.view.ftl | Views specific to social media components. |
| social.controller.ftl | Controllers specific to social media components. |
| facebook.view.ftl | Views specific to Facebook components. |
| facebook.controller.ftl | Controllers specific to Facebook components. |
| twitter.view.ftl | Views specific to Twitter components. |
| twitter.controller.ftl | Controllers specific to Twitter components. |
| flickr.view.ftl | Views specific to Flickr components. |
| flickr.controller.ftl | Controllers specific to Flickr components. |
| youtube.view.ftl | Views specific to YouTube components. |
| youtube.controller.ftl | Controllers specific to YouTube components. |
