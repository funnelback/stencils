<#ftl encoding="utf-8" />
<#--
   Funnelback App: Tabs
   By: Gioan Tran
   Description: 
   	This file aims to store the client specific markup required for implementations.
   	It also contains out of the box markup which can be used as a basis for further
   	customisations.
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
<#import "tabs.controller.ftl" as tabs_controller/>

<#-- 
	The following functions are generic layout code which can be copied and customised
	to suit individual implementations.
--->

<#-- Sample implementation of tabs which can be customised --> 
<#macro TabMenu>
	<@tabs_controller.TabSearch>
		<ul class="nav nav-tabs">
		  <@tabs_controller.Tabs name="Tabs">
		  	<@tabs_controller.Tab>
		      <li class="<@tabs_controller.IsActive>active</@tabs_controller.IsActive> <@tabs_controller.IsDisabled>disabled</@tabs_controller.IsDisabled>">
		        <a href="<@tabs_controller.Url />" alt="<@tabs_controller.Name />" title="<@tabs_controller.Name />">
		         	<@tabs_controller.Name /> <span class="badge"> <@tabs_controller.Count /> </span>
		        </a>
		      </li>    
		    </@tabs_controller.Tab>
		  </@tabs_controller.Tabs>    
		</ul>
	</@tabs_controller.TabSearch>
</#macro>

<#-- Sample implementation of tabs which is useful for an A-Z listing --> 
<#macro AZListing>
	<@tabs_controller.TabSearch>
		<ul class="pagination">
		  <@tabs_controller.Tabs name="Tabs">
		  	<@tabs_controller.Tab>
		      <li class="<@tabs_controller.IsActive>active</@tabs_controller.IsActive> <@tabs_controller.IsDisabled>disabled</@tabs_controller.IsDisabled>">
		        <a href="<@tabs_controller.Url />" alt="<@tabs_controller.Name />" title="<@tabs_controller.Name /> (<@tabs_controller.Count />)">
		         	<@tabs_controller.Name /> 
		        </a>
		      </li>    
		    </@tabs_controller.Tab>
		  </@tabs_controller.Tabs>    
		</ul>
	</@tabs_controller.TabSearch>
</#macro>

</#escape>