<#ftl encoding="utf-8" output_format="HTML" />
<#import "/web/templates/modernui/funnelback.ftl" as s />

<#--
  Includes client-specific HTML header (for CSS, JS links)
-->
<#macro HTMLHeader>
  <@ClientInclude elementName="html_header" />
</#macro>

<#--
  Includes client-specific HTML content header (e.g. banner, menu, ...)
-->
<#macro ContentHeader>
  <@ClientInclude elementName="content_header" />
</#macro>

<#--
  Includes client-specific HTML content footer
-->
<#macro ContentFooter>
  <@ClientInclude elementName="content_footer" />
</#macro>

<#--
  Include client specific content

  Can be included from a remote URL, or from a local template named after the element
  name in the profile folder (e.g. html_header.ftl, content_header.ftl, etc.)

  @param elementName Name of the element to include (e.g. html_header, content_header, etc.)
-->
<#macro ClientInclude elementName>
  <#if question.collection.configuration.value("stencils.client_includes.${elementName}.url")??>
    <@s.IncludeUrl
      url=question.collection.configuration.value("stencils.client_includes.${elementName}.url")
      start=question.collection.configuration.value("stencils.client_includes.${elementName}.start")
      end=question.collection.configuration.value("stencils.client_includes.${elementName}.end")
      convertRelative=true />
  <#else>
    <#include "/conf/${question.collection.id}/${question.profile!'_default'}/${elementName}.ftl" ignore_missing=true />
  </#if>
</#macro>

<#-- vim: set expandtab ts=2 sw=2 sts=2 :-->
