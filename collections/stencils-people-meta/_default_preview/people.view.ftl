<#ftl encoding="utf-8" />

<#--
   Funnelback App: Core
   By: <Name>
   Description: <Description>
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#--FunnelBack Apps used -->
<#assign FBApps = ["core", "utilities", "people"] />

<#-- Import and assign app namespaces eg. core and core_custom -->
<#list FBApps as app>
    <#assign appController="${app}.controller.ftl" appNamespace="${app?lower_case}_controller" />
    <#assign appView="${app}.view.ftl" appNamespaceCustom="${app?lower_case}_view" />
    <@'<#import appController as ${appNamespace}>'?interpret />
    <@'<#import appView as ${appNamespaceCustom}>'?interpret />
</#list>

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import the main macros used to put together this app -->
<#import "core.controller.ftl" as core_controller/>

<#macro Results>
    <#-- Convert the meta data classes to human readiable variables -->
  <#if (s.result)!?has_content>
    <#local username = s.result.metaData["b"]!>
    <#local salutation = s.result.metaData["c"]!>
    <#local firstName = s.result.metaData["g"]!>
    <#local lastName = s.result.metaData["j"]!>
    <#local position = s.result.metaData["l"]!>
    <#local department = s.result.metaData["S"]!>
    <#local discipline = s.result.metaData["M"]!> 
    <#local email = s.result.metaData["n"]!>
    <#local phone = s.result.metaData["o"]!>
    <#local expertise = s.result.metaData["A"]!>
    <#if s.result.metaData["q"]??>
        <#local thumbnail = s.result.metaData["q"]!>
    <#else>
        <#local thumbnail = "http://img3.wikia.nocookie.net/__cb20121227201208/jamesbond/images/6/61/Generic_Placeholder_-_Profile.jpg">
    </#if>
  </#if>  
  <li data-fb-result=${s.result.indexUrl}">
    <div class="row">
        <div class="col-md-2">
            <a href="${s.result.clickTrackingUrl}">
                <img src="https://admin-demo-au.funnelback.com/s/scale?url=${thumbnail!}&width=80&height=80&format=jpg&type=keep_aspect">
            </a>
        </div>
        <div class="col-md-10">
            <h4>
                <a href="${s.result.clickTrackingUrl}" title="${s.result.liveUrl}">
                    <@s.boldicize><@s.Truncate length=70>${salutation!} ${firstName!} ${lastName!}</@s.Truncate></@s.boldicize>
                </a>
            </h4>
            <cite data-url="${s.result.liveUrl}" class="text-success"><@s.cut cut="http://"><@s.boldicize>${s.result.liveUrl}</@s.boldicize></@s.cut></cite>
            <div class="btn-group">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" title="More actions&hellip;"><small class="glyphicon glyphicon-chevron-down text-success"></small></a>
                <ul class="dropdown-menu">
                    <li><#if s.result.cacheUrl??><a href="${s.result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="Cached version of ${s.result.title} (${s.result.rank})">Cached</a></#if></li>
                    <li><@s.Explore /></li>
                </ul>
            </div>
            <dl class="dl-horizontal text-muted">
                <#if email?has_content><dt><span class="glyphicon glyphicon-envelope" title="Email"></span></dt><dd><a href="${email!}">${email!}</a></dd></#if>
                <#if phone?has_content><dt><span class="glyphicon glyphicon-phone-alt" title="Phone"></span></dt><dd><a href="${phone!}">+61 ${phone!}</a></dd></#if>                          
            </dl>
        </div>
    </div>
  </li>

</#macro>

<#--
  Sample implementation of a facet breadcrumb which allows users
  to remove active facets
-->
<#macro BreadCrumb>
  <@people_controller.BreadCrumbSearch>
    <div class="panel panel-default">
      <div class="panel-heading">
        Active filters
      </div>
      <div class="panel-body">
        <@people_controller.BreadCrumbs>
            <@people_controller.BreadCrumb tag="span" class="">
              <a href="<@people_controller.BreadCrumbUrl />">
                <button type="button" class="btn btn-primary">
                  <span class="glyphicon glyphicon-remove"></span> 
                  <@people_controller.BreadCrumbName />
                </button>
              </a>
            </@people_controller.BreadCrumb>  
        </@people_controller.BreadCrumbs>
      </div>
    </div>
  </@people_controller.BreadCrumbSearch>
</#macro>

</#escape>