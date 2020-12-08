<#ftl encoding="utf-8" output_format="HTML" />
<#import "/web/templates/modernui/funnelback.ftl" as fb />

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
  <#local profileConfig = question.getCurrentProfileConfig()>
  <#if profileConfig.get("stencils.client_includes.${elementName}.url")??>
    <@fb.IncludeUrl 
      url=profileConfig.get("stencils.client_includes.${elementName}.url")
      start=profileConfig.get("stencils.client_includes.${elementName}.start")
      end=profileConfig.get("stencils.client_includes.${elementName}.end")
      expiry=profileConfig.get("stencils.client_includes.${elementName}.expiry")
      convertRelative=(profileConfig.get("stencils.client_includes.${elementName}.relative")!"true")?boolean
      username=profileConfig.get("stencils.client_includes.${elementName}.username")
      password=profileConfig.get("stencils.client_includes.${elementName}.password")
      useragent=profileConfig.get("stencils.client_includes.${elementName}.useragent")
      timeout=profileConfig.get("stencils.client_includes.${elementName}.timeout")
      cssSelector=profileConfig.get("stencils.client_includes.${elementName}.cssSelector")
      removeByCssSelectors=profileConfig.get("stencils.client_includes.${elementName}.removeByCssSelectors") />
  <#else>
    <#include "/conf/${question.collection.id}/${question.profile!'_default'}/${elementName}.ftl" ignore_missing=true />
  </#if>
</#macro>

<#-- vim: set expandtab ts=2 sw=2 sts=2 :-->
