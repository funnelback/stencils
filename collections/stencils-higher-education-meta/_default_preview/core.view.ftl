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
<#assign FBApps = ["core", "courses", "tabs", "experts"] />

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

<#macro Results >
  <ol id="search-results" class="list-unstyled masonry-container" start="${response.resultPacket.resultsSummary.currStart}">
    <@s.Results>
	    <#if s.result.class.simpleName == "TierBar">
	    <#-- A tier bar -->
	    <#if s.result.matched != s.result.outOf>
	    <li class="search-tier"><h3>Results that match ${s.result.matched} of ${s.result.outOf} words</h3></li>
	    <#else>
	    <li class="search-tier"><h3 class="hidden">Fully-matching results</h3></li>
	    </#if>
	    <#-- Print event tier bars if they exist -->
	    <#if s.result.eventDate??>
	    <h2 class="fb-title">Events on ${s.result.eventDate?date}</h2>
	    </#if>
	    <#else>
	    	<#if (s.result.collection)!?has_content>
	    		<#switch s.result.collection>
	      		<#case "stencils-higher-education-courses-web">
	        		<@courses_view.Result />
	        		<#break>
	      		<#case "stencils-higher-education-experts-web">
	        		<@experts_view.Result />
	        		<#break>
	      			<#default>         
	    		</#switch>
	    	</#if>
	    </#if>
    </@s.Results>
  </ol>
</#macro>

<#macro jsDefault>
  <script src="${SearchPrefix}js/jquery/jquery-1.10.2.min.js"></script>
  <script src="${SearchPrefix}js/jquery/jquery-ui-1.10.3.custom.min.js"></script>
  <script src="${SearchPrefix}thirdparty/bootstrap-3.0.0/js/bootstrap.min.js"></script>
  <script src="${SearchPrefix}js/jquery/jquery.tmpl.min.js"></script>
  <script src="${SearchPrefix}js/jquery.funnelback-completion.js"></script>
  
  <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
    <script src="${SearchPrefix}thirdparty/angular-1.0.7/angular.js"></script>
    <script src="${SearchPrefix}thirdparty/angular-1.0.7/angular-resource.js"></script>
    <script src="${SearchPrefix}js/funnelback-session.js"></script>
  </#if>
</#macro>

</#escape>
