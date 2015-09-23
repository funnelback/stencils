<#ftl encoding="utf-8" />
<#--
  Funnelback App: Courses
  By: Gioan Tran
  Description: <Description>  
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#--Paths -->
<#assign basePath>/s/resources/<@s.cfg>collection</@s.cfg></#assign>
<#assign webPath>${basePath}/${question.profile}</#assign>

<#--FunnelBack Apps used -->
<#assign FBApps = ["utilities"] />

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
<#import "courses.controller.ftl" as courses_controller/>

<#-- 
  The following functions are generic layout code which can be copied and customised
  to suit individual implementations.
--->

<#macro Result>
  <#-- Convert the meta data classes to human readiable variables -->
  <#if (s.result)!?has_content>
    <#local name = s.result.metaData["t"]!>
    <#local id = s.result.metaData["0"]!>
    <#local campus = s.result.metaData["1"]!>
    <#local school = s.result.metaData["2"]!>
    <#local department = s.result.metaData["E"]!>
    <#local type = s.result.metaData["4"]!>
    <#local category = s.result.metaData["6"]!> 
    <#local code = s.result.metaData["U"]!>
    <#local summary = s.result.metaData["V"]!>
  </#if>

  <li class="masonry-item clearfix" data-fb-result="${s.result.indexUrl}">
    <h4>      
      <#-- Cart information -->
      <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
        <a href="#" data-ng-click="toggle()" data-cart-link data-css="pushpin|remove" title="{{label}}"><small class="glyphicon glyphicon-{{css}}"></small></a>
      </#if>
      
      <a href="${s.result.clickTrackingUrl}" title="${s.result.liveUrl}">
        <@s.boldicize><@s.Truncate length=70>${s.result.title}</@s.Truncate></@s.boldicize>
      </a>
      
      <#if s.result.fileType!?matches("(doc|docx|ppt|pptx|rtf|xls|xlsx|xlsm|pdf)", "r")>
        <small class="text-muted">${s.result.fileType?upper_case} (${filesize(s.result.fileSize!0)})</small>
      </#if>

      <#-- Click history -->
      <#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(s.result.indexUrl)??>
        <small class="text-warning">
          <span class="glyphicon glyphicon-time"></span> 
            <a title="Click history" href="#" class="text-warning" data-ng-click="toggleHistory()">Last visited ${prettyTime(session.getClickHistory(s.result.indexUrl).clickDate)}</a>
          </small>
        </#if>
    </h4>

    <#-- Cite/URL preview -->
    <cite data-url="${s.result.displayUrl}" class="text-success">
      <@s.cut cut="http://"><@s.boldicize>${s.result.displayUrl}</@s.boldicize></@s.cut>
    </cite>

    <div class="btn-group">
      <a href="#" class="dropdown-toggle" data-toggle="dropdown" title="More actions&hellip;"><small class="glyphicon glyphicon-chevron-down text-success"></small></a>
      <ul class="dropdown-menu">
        <li><#if s.result.cacheUrl??><a href="${s.result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="Cached version of ${s.result.title} (${s.result.rank})">Cached</a></#if></li>
        <li><@s.Explore /></li>
        <@fb.AdminUIOnly><li><@fb.Optimise /></li></@fb.AdminUIOnly>
      </ul>
    </div>
    
    <#-- Funnelback automatic generated summary -->
    <#if s.result.summary??>
      <p>
        <#if s.result.date??>
          <small class="text-muted">${s.result.date?date?string("d MMM yyyy")}:</small>
        </#if>
        <span class="search-summary"><@s.boldicize><#noescape>${s.result.summary}</#noescape></@s.boldicize></span>
      </p>
    </#if>
    <#if s.result.metaData["c"]??>
      <p><@s.boldicize>${s.result.metaData["c"]!}</@s.boldicize></p>
    </#if>
    <#-- Result collapsing -->
    <#if s.result.collapsed??>
      <div class="search-collapsed">
        <small><span class="glyphicon glyphicon-expand text-muted"></span>&nbsp; <@fb.Collapsed /></small>
      </div>
    </#if>

    <#-- Meta data details -->
    <dl class="dl-horizontal text-muted">
      <#if name?has_content><dt>Name:</dt><dd>${name}</dd></#if>
      <#if id?has_content><dt>ID:</dt><dd>${id}</dd></#if>
      <#if campus?has_content><dt>Campus:</dt><dd>${campus}</dd></#if>
      <#if school?has_content><dt>School:</dt><dd>${school}</dd></#if>
      <#if department?has_content><dt>Department:</dt><dd>${department}</dd></#if>
      <#if type?has_content><dt>Type:</dt><dd>${type}</dd></#if>
      <#if category?has_content><dt>Category:</dt><dd>${category}</dd></#if>
      <#if code?has_content><dt>Code:</dt><dd>${code}</dd></#if>
      <#if summary?has_content><dt>Summary:</dt><dd>${summary}</dd></#if>
    </dl>

  </li>
</#macro>

<#--
  Sample implementation of a facet breadcrumb which allows users
  to remove active facets
-->
<#macro BreadCrumb>
  <@courses_controller.BreadCrumbSearch>
    <div class="panel panel-default">
      <div class="panel-heading">
        Active filters
      </div>
      <div class="panel-body">
        <@courses_controller.BreadCrumbs>
            <@courses_controller.BreadCrumb tag="span" class="">
              <a href="<@courses_controller.BreadCrumbUrl />">
                <button type="button" class="btn btn-primary">
                  <span class="glyphicon glyphicon-remove"></span> 
                  <@courses_controller.BreadCrumbName />
                </button>
              </a>
            </@courses_controller.BreadCrumb>  
        </@courses_controller.BreadCrumbs>
      </div>
    </div>
  </@courses_controller.BreadCrumbSearch>
</#macro>

</#escape>