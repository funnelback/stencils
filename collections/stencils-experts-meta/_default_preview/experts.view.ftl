<#ftl encoding="utf-8" />
<#--
   Funnelback App: Experts
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
<#import "experts.controller.ftl" as experts_controller/>

<#-- 
  The following functions are generic layout code which can be copied and customised
  to suit individual implementations.
--->
<#macro Result>
  <@s.AfterSearchOnly>
    <li class="masonry-item thumbnail" data-fb-result="${s.result.indexUrl}">
      <#-- Menu system -->
      <div class="fb-result-menu btn-group-vertical clearfix">
        <a href="#fb-summary-${s.result.rank}" data-toggle="tab">          
          <button type="button" class="btn btn-default btn-sm">
            <span class="glyphicon glyphicon-list-alt"></span>
          </button>
        </a>

        <a href="#fb-publications-${s.result.rank}" data-toggle="tab">  
          <button type="button" class="btn btn-default btn-sm">
            <span class="glyphicon glyphicon-file"></span>
          </button>
        </a>

        <a href="#fb-contact-details-${s.result.rank}" data-toggle="tab">  
          <button type="button" class="btn btn-default btn-sm">
            <span class="glyphicon glyphicon-earphone"></span>
          </button>
        </a>
      </div>

      <#-- Tab panes -->
      <div class="tab-content">

        <div class="fb-result-photo">
        <@ReasearcherPhoto />  
        </div>

        <div class="tab-pane active" id="fb-summary-${s.result.rank}">
          <@Summary />
        </div>
        <div class="tab-pane" id="fb-publications-${s.result.rank}">
          <@Publications />
        </div>
        <div class="tab-pane" id="fb-contact-details-${s.result.rank}">
          <@ContactDetails />
        </div>
      </div>
    </li>
  </@s.AfterSearchOnly>
</#macro>

<#-- Contains the markup for the researcher's photo -->
<#macro ReasearcherPhoto>
 <a href="${s.result.clickTrackingUrl?html}" title="<#if s.result.metaData["4"]!?has_content> ${s.result.metaData["A"]!?html} ${s.result.metaData["B"]!?html} - ${s.result.metaData["4"]!?html}</#if>">
    <#if (s.result.customData["thumbnail"]["url"])!?has_content>
      <img class="pull-left" alt="${s.result.liveUrl?html}" src="${s.result.customData["thumbnail"]["url"]}" /> 
    <#else>
        <#-- Placeholder thumbnail to go here
          <img class="pull-left" alt="No Photo" src="resources/${resourceCollection}/${question.profile}/img/search-result-researcher.jpg" /> 
        -->
    </#if>
  </a>
</#macro>

<#-- Contains the markup for the researcher's summary view -->
<#macro Summary>
  <div class="fb-summary">
    <h4>
      <a href="${s.result.clickTrackingUrl?html}" title="${s.result.liveUrl?html}">
        <@s.boldicize>${s.result.metaData["A"]!?html} ${s.result.metaData["B"]!?html}</@s.boldicize>
      </a>
      <#-- Organisation -->
      <#if s.result.metaData["4"]!?has_content>
        <span class="text-muted">
          <@s.boldicize>(${s.result.metaData["4"]!?html})</@s.boldicize>
        </span>
      </#if>
      <#-- File Type -->
      <#if s.result.fileType!?matches("(pdf|doc|xls|ppt|rtf)", "r")>
        <small class="text-muted">${s.result.fileType?upper_case} (${filesize(s.result.fileSize!0)})</small>
      </#if>                  
    </h4>
    
    <#-- Display URL -->
    <cite data-url="${s.result.displayUrl?html}" class="text-muted">
      <@s.cut cut="http://">
        <@s.boldicize>
          <@s.Truncate length=120>
              ${s.result.displayUrl?html}
          </@s.Truncate>
        </@s.boldicize>
      </@s.cut>
    </cite>
    
    <#-- Drop down options -->
    <div class="btn-group">
      <a href="" class="dropdown-toggle" data-toggle="dropdown" title="More actions&hellip;">
        <small class="glyphicon glyphicon-chevron-down"></small>
        <span class="sr-only">More actions</span>
      </a>
      <ul class="dropdown-menu">
        <li><#if s.result.cacheUrl??><a href="${s.result.cacheUrl?html}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="Cached version of ${s.result.title} (${s.result.rank})">Cached</a></#if></li>
        <#local similarLink>
          <@s.Explore />
        </#local>
        <#local similarLink = similarLink?replace("Explore</a>","Similar</a>")>
        
        <li>
          ${similarLink}
        </li>
        <@fb.AdminUIOnly><li><@fb.Optimise /></li></@fb.AdminUIOnly>
      </ul>
    </div>

    <#-- Generic Funnelback summary -->
    <#--
    <#if s.result.summary??>
      <p>
        <#if s.result.date??><small class="text-muted">${s.result.date?date?string("d MMM yyyy")}:</small></#if>
        <span class="search-summary"><@s.boldicize>${s.result.summary}</@s.boldicize></span>
      </p>
    </#if>
    -->
    <#if s.result.collapsed??>
      <div class="search-collapsed"><small><span class="glyphicon glyphicon-expand text-muted"></span>&nbsp; <@fb.Collapsed /></small></div>
    </#if>        

    <ul class="fb-result-detail-list list-inline text-muted clearfix">   
      <#if s.result.metaData["I"]??><li><span>homepage:</span><span>${s.result.metaData["I"]!?replace("|", ", ")}</span></li></#if>
      <#if s.result.metaData["4"]??><li><span>Orgnisation:</span><span>${s.result.metaData["4"]!?replace("|", ", ")}</span></li></#if>
      <#if s.result.metaData["5"]??><li><span>Overview:</span><span>${s.result.metaData["5"]!?replace("|", ", ")}</span></li></#if>
      <#--
      <li><#if s.result.metaData["8"]??><span>Grants/Agreements:</span><span>${s.result.metaData["8"]!?replace("|", ", ")}</span></#if></li>
      #-->
      <#if s.result.metaData["Y"]??><li><span>Subject Area:</span><span>${s.result.metaData["Y"]!?replace("|", ", ")}</span></li></#if>
      <#if s.result.metaData["X"]??><li><span>Research Overview:</span><span>${s.result.metaData["X"]!?replace("|", ", ")}</span></li></#if>
      <#if s.result.metaData["2"]??><li><span>Description:</span><span>${s.result.metaData["2"]!?replace("|", ", ")}</span></li></#if>
      <#if s.result.metaData["7"]??><li><span>International Linkage:</span><span>${s.result.metaData["7"]!?replace("|", ", ")}</span></li></#if>
      <#if s.result.metaData["M"]??><li><span>Media Only:</span><span>${s.result.metaData["M"]!?replace("|", ", ")}</span></li></#if>            
      <#if s.result.metaData["6"]??><li><span>Geographical Focus:</span><span>${s.result.metaData["6"]!?replace("|", ", ")}</span></li></#if>
    </ul>
  </div>
</#macro>

<#-- Contains the markup for the researcher's collaboration view -->
<#macro Publications>
  <div class="fb-publications">

    <h4>
      <a href="${s.result.clickTrackingUrl?html}" title="${s.result.liveUrl?html}">
        <@s.boldicize>${s.result.metaData["A"]!?html} ${s.result.metaData["B"]!?html}</@s.boldicize>
      </a>
      <#-- Organisation -->
      <#if s.result.metaData["4"]!?has_content>
        <span class="text-muted">
          <@s.boldicize>(${s.result.metaData["4"]!?html})</@s.boldicize>
        </span>
      </#if>
      <#-- File Type -->
      <#if s.result.fileType!?matches("(pdf|doc|xls|ppt|rtf)", "r")>
        <small class="text-muted">${s.result.fileType?upper_case} (${filesize(s.result.fileSize!0)})</small>
      </#if>                  
    </h4>
    
    <#-- Display URL -->
    <cite data-url="${s.result.displayUrl?html}" class="text-muted">
      <@s.cut cut="http://">
        <@s.boldicize>
          <@s.Truncate length=120>
              ${s.result.displayUrl?html}
          </@s.Truncate>
        </@s.boldicize>
      </@s.cut>
    </cite>

    <div class="panel panel-default">
      <div class="panel-body fb-scroll-listing">
        <#if (s.result.customData["publications"])!?has_content>
          <ul>
            <#list s.result.customData["publications"] as publication>
              <li>${publication}</li>
            </#list>
          </ul>
        </#if>
      </div>
    </div> 
       
  </div>
</#macro>

<#-- Contains the markup for a experts's contact view -->
<#macro ContactDetails>
  <div class="fb-contact-details">
    <h4>
      <a href="${s.result.clickTrackingUrl?html}" title="${s.result.liveUrl?html}">
        <@s.boldicize>${s.result.metaData["A"]!?html} ${s.result.metaData["B"]!?html}</@s.boldicize>
      </a>
      <#-- Organisation -->
      <#if s.result.metaData["4"]!?has_content>
        <span class="text-muted">
          <@s.boldicize>(${s.result.metaData["4"]!?html})</@s.boldicize>
        </span>
      </#if>
      <#-- File Type -->
      <#if s.result.fileType!?matches("(pdf|doc|xls|ppt|rtf)", "r")>
        <small class="text-muted">${s.result.fileType?upper_case} (${filesize(s.result.fileSize!0)})</small>
      </#if>                  
    </h4>
    
    <#-- Display URL -->
    <cite data-url="${s.result.displayUrl?html}" class="text-muted">
      <@s.cut cut="http://">
        <@s.boldicize>
          <@s.Truncate length=120>
              ${s.result.displayUrl?html}
          </@s.Truncate>
        </@s.boldicize>
      </@s.cut>
    </cite>

    <div>
        <ul class="fb-result-detail-list list-inline text-muted clearfix">
        <#if s.result.metaData["L"]??><li><span>Phone:</span><span>${s.result.metaData["L"]!?replace("|", ", ")}</span></li></#if>
        <#if s.result.metaData["F"]??><li><span>Fax:</span><span>${s.result.metaData["F"]!?replace("|", ", ")}</span></li></#if>
        <#if s.result.metaData["G"]??><li><span>Email:</span><span>${s.result.metaData["G"]!?replace("|", ", ")}</span></li></#if>
      </ul> 
    </div> 
  </div>
</#macro>

</#escape>