<#ftl encoding="utf-8" />
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>
<@Print />

<#macro Print>
  <#compress>
    <@s.AfterSearchOnly>
      <?xml version="1.0" encoding="UTF-8"?>
      <results>
        <@s.Results>
          <#if s.result.class.simpleName == "TierBar">
            <#-- We ignore tier bar results -->
          <#else>
            <@Results />
          </#if>
        </@s.Results>
      </results>
    </@s.AfterSearchOnly>
  </#compress>
</#macro>

<#-- Prints out one result as xml -->
<#macro Results>
  <result>                  
    <rank><@CDATA>${s.result.rank!""}</@CDATA></rank>
    <title><@CDATA>${s.result.title!""}</@CDATA></title>
    <liveUrl><@CDATA>${s.result.liveUrl!""}</@CDATA></liveUrl>
    <displayUrl><@CDATA>${s.result.displayUrl!""}</@CDATA></displayUrl>
    <indexUrl><@CDATA>${s.result.indexUrl!""}</@CDATA></indexUrl>
    <summary><@CDATA>${s.result.summary!""}</@CDATA></summary>
    <fileSize><@CDATA>${s.result.fileSize!""}</@CDATA></fileSize>
    <fileType><@CDATA>${s.result.fileType!""}</@CDATA></fileType>
    <#-- Print the metadata -->
    <@Metadata s.result />
  </result>
</#macro>

<#--
  Prints metadata as xml elements in the following format:
  <<tag>><!CDATA[<value>]]]</<<tag>>

  e.g <a><!CDATA[super pugs]]></a>
--> 
<#macro Metadata result>
  <#list result.metaData?keys as tag>
    <${tag}><@CDATA>${result.metaData[tag]}</@CDATA></${tag}>
  </#list>
</#macro>

<#-- Wraps the contents in CDATA tags -->
<#macro CDATA>
  <#compress>
    <![CDATA[<#nested>]]>
  </#compress>
</#macro>