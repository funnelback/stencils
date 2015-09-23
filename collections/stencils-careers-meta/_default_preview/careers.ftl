<#ftl encoding="utf-8" />
<#--
   Funnelback App: Careers
   By: Prathima Chandra 
   Description: Displays job board for an organization
-->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>
<#import "/conf/searchapp-careers/faceted_navigation.ftl" as fbf/>

<#escape x as x?html>

<#--Paths -->
<#assign basePath>/s/resources/
<@s.cfg>collection</@s.cfg>
</#assign>
<#assign webPath>${basePath}/${question.profile}</#assign>

<#--FunnelBack Apps used -->
<#assign FBApps = ["careers"] />
<#--FunnelBack Apps used -->


<#-- Import and assign app namespaces eg. core and core_custom -->
<#list FBApps as app>
    <#assign appTemplate="${app}.default.ftl" appNamespace="${app?lower_case}" />
    <#assign appTemplateCustom="${app}.ftl" appNamespaceCustom="${app?lower_case}_custom" /> <@'<#import appTemplate as ${appNamespace}>'?interpret /> <@'<#import appTemplateCustom as ${appNamespaceCustom}>'?interpret />
</#list>

<#--OPTIONS -->
<#--layout fixed column leave blank '' or set to 'fluid' for fluid layout -->
<#assign layoutType = '' largeLogoImg ="${SearchPrefix}funnelback.png"> 
<!DOCTYPE html>
<html lang="en-us">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="nofollow">
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->
<title>
<@s.AfterSearchOnly>${question.inputParameterMap["query"]!}
  <@s.IfDefCGI name="query">,&nbsp;</@s.IfDefCGI>
</@s.AfterSearchOnly>
<@s.cfg>service_name</@s.cfg>
-  Funnelback Search</title>
<@s.OpenSearch />
<@s.AfterSearchOnly><link rel="alternate" type="application/rss+xml" title="Search results for ${question.inputParameterMap["query"]!}<@s.IfDefCGI name="query">,&nbsp;
  </@s.IfDefCGI>
  <@s.cfg>service_name</@s.cfg>
  " href="?collection=
  <@s.cfg>collection</@s.cfg>
  &amp;query=${question.inputParameterMap["query"]!?url}&amp;form=rss&amp;sort=date"></@s.AfterSearchOnly>
<link rel="stylesheet" href="${SearchPrefix}thirdparty/bootstrap-3.3.2/css/bootstrap.min.css">
<!--[if lt IE 9]>
    <script src="${SearchPrefix}thirdparty/html5shiv.js"></script>
    <script src="${SearchPrefix}thirdparty/respond.min.js"></script>
    <![endif]--> 
<#--Load App default CSS files-->
<link rel="stylesheet" href="${webPath}/careers.css">
</head>
<body id="funnelback-search" class="container"<#if question.collection.configuration.valueAsBoolean("ui.modern.session")> data-ng-app="Funnelback" data-ng-controller="DefaultCtrl" </#if>>
<@s.InitialFormOnly> <br/>
  
  <div class="row search-initial">
    <div class="col-md-6 col-md-offset-3 text-center"> <#if error?? || (response.resultPacket.error)??>
      <div class="alert alert-danger">
        <@fb.ErrorMessage />
      </div>
      </#if> <a href="http://funnelback.com/"><img src="${SearchPrefix}funnelback.png" alt="Funnelback logo"></a> </div>
  </div>
  
  <ul class="nav nav-tabs">
    <li class="active"><a href="#nav-introduction" data-toggle="tab">Careers</a></li>
    <li><a href="#nav-configuration" data-toggle="tab">Contact Us</a></li>
  </ul>
  
  <div class="tab-content">
    <div class="tab-pane active row" id="nav-introduction">
     
      <div class="well">
      <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="search">
        <fieldset>
        <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!?html}">
        <@s.IfDefCGI name="enc">
          <input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}">
        </@s.IfDefCGI>
        <@s.IfDefCGI name="form">
          <input type="hidden" name="form" value="${question.inputParameterMap["form"]!}">
        </@s.IfDefCGI>
        <@s.IfDefCGI name="scope">
          <input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}">
        </@s.IfDefCGI>
        <@s.IfDefCGI name="lang">
          <input type="hidden" name="lang" value="${question.inputParameterMap["lang"]!}">
        </@s.IfDefCGI>
        <@s.IfDefCGI name="profile">
          <input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}">
        </@s.IfDefCGI>
        
        
        <div class="row">
        
        <div class="col-md-12">
            <div class="form-group"> 
              <label for="query">Keywords</label>
              <input name="query" id="query" title="Search query" type="text" value="${question.inputParameterMap["query"]!}" accesskey="q" placeholder="Search <@s.cfg>service_name</@s.cfg>&hellip;" class="input-lg query form-control">
            </div>
          </div>
          
          <div class="col-md-4">
            <div class="form-group">
              <label for="meta_l_sand">Location</label>
                <@s.Select name="meta_l_sand" options=["=Any", "Brisbane","Canberra","Melbourne","Sydney","London"] class="input-sm form-control"/>
            </div>
          </div>

          <div class="col-md-4">
            <div class="form-group">
              <label for="meta_j_sand">Category</label>
                <@s.Select name="meta_j_sand" options=["=Any ", "Finance", "Human Resources", "Production", "Research & Development", "Sales"] class="input-sm form-control"/>
            </div>
          </div>


          <div class="col-md-4">
              <div class="form-group">
                <label class="control-label " for="meta_f_sand">Job Type</label>
                  <@s.Select name="meta_f_sand" id="meta_f_sand" options=["=Any ", "Full Time ", "Part Time", "Contract"] class="input-sm form-control"/>
              </div>
          </div>

        </div>
          
          <button type="submit" class="btn btn-primary "><span class="glyphicon glyphicon-search"></span> Search</button>

           </fieldset>
       
        </div>
      </form>

       <div class="col-md-6">
        
      </div>


    </div>
    
      
    <div class="tab-pane" id="nav-configuration"> 
      <p>Funnnelback has offices in Australia, New Zealand and the UK. If you want more information about Funnelback Search, would like to request a no obligation demo, or have any other enquiry, please use the contact form for the location which is closest to you.</p>
    </div>
  </div>  <!-- End Tabbed Content-->
  

</@s.InitialFormOnly>
<@s.AfterSearchOnly>
<@careers.NavBar />
<@careers.AdvancedForm />
<section id="search-main" class="row">
  <div class="search-main-inner">
<@careers.Facets />

<div id="search-tabs" class="col-md-9 col-lg-10">
<!-- Tabbed Navigation-->
<ul class="nav nav-tabs">
<li class="active"><a href="#nav-introduction" data-toggle="tab">Current Jobs</a></li>
<li><a href="#nav-configuration" data-toggle="tab">Pinned Jobs &nbsp;(<span data-ng-cloak>{{cart.length}}</ng-pluralize --></span>)</a></li>
<li><a href="#history" data-ng-click="toggleHistory()" data-toggle="tab">Search History</a></li>
</ul>
<!-- End Tabbed Navigation-->

<!-- Tabbed Content-->
<div class="tab-content">
  <div class="tab-pane active" id="nav-introduction">
    <div id="search-content" class="col-md-12"> <#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session.searchHistory?? && session.searchHistory?size &gt; 0>
      <#-- Build list of previous queries -->
      <div style="display:none"> <#assign qsSignature = computeQueryStringSignature(QueryString) />
        <#if session.searchHistory?? &&
        (session.searchHistory?size &gt; 1 || session.searchHistory[0].searchParamsSignature != qsSignature)>
        <div class="breadcrumb" data-ng-controller="SearchHistoryCtrl" data-ng-show="!searchHistoryEmpty" style="display:none">
          <button class="btn btn-link pull-right" data-ng-click="toggleHistory()"><small class="text-muted"><span class="glyphicon glyphicon-plus"></span> More&hellip;</small></button>
          <ol class="list-inline" >
            <li class="text-muted">Recent:</li>
            <#list session.searchHistory as h>
            <#if h.searchParamsSignature != qsSignature>
            <#assign facetDescription><#compress>
            <#list h.searchParams?matches("f\\.([^=]+)=([^&]+)") as f>
            ${urlDecode(f?groups[1])?split("|")[0]} = ${urlDecode(f?groups[2])}<#if f_has_next></#if>
            </#list>
            </#compress></#assign>
            <li> <a <#if facetDescription != ""> data-toggle="tooltip" data-placement="bottom" title="${facetDescription?html}"</#if> title="${prettyTime(h.searchDate)}" href="${question.collection.configuration.value("ui.modern.search_link")}?${h.searchParams?html}">${h.originalQuery} <small>(${h.totalMatching})</small></a> <#if facetDescription != ""></a></#if> </li>
            </#if>
            </#list>
          </ol>
        </div>
        </#if> </div>
      </#if>
      <@careers.Count />
      <@careers.Scopes />
      <@careers.Blending />
      <@careers.CuratorExhibits />
      <@careers.Spelling />
      <@careers.Summary />
      <@careers.EntityDefinition />
      <@careers.CuratorExhibitsList />
      <@careers.BestBets />
      <@careers.Results />
      
    </div>
    <@careers.Pagination /> 
  </div>
  <div class="tab-pane" id="nav-configuration">
    <@careers.Cart />
  </div>
  <div class="tab-pane" id="history">
    <@careers.SearchHistory />
  </div>
</div>
<!-- End Tabbed Content-->
</div>

</@s.AfterSearchOnly>
</div>
</section>
<@careers.Footer />
<#-- Javascript-->
<@careers.jsDefault />
<#-- Funnelback Javascript Options --> 
<script>
        var FB =[];

        <#-- Query Completion Options -->
        FB.fbcompletionOptions = {
            'enabled'    : '<@s.cfg>query_completion</@s.cfg>',
            'standardCompletionEnabled': <@s.cfg>query_completion.standard.enabled</@s.cfg>,
            'collection' : '<@s.cfg>collection</@s.cfg>',
            'program'    : '${SearchPrefix}<@s.cfg>query_completion.program</@s.cfg>',
            'format'     : '<@s.cfg>query_completion.format</@s.cfg>',
            'alpha'      : '<@s.cfg>query_completion.alpha</@s.cfg>',
            'show'       : '<@s.cfg>query_completion.show</@s.cfg>',
            'sort'       : '<@s.cfg>query_completion.sort</@s.cfg>',
            'length'     : '<@s.cfg>query_completion.length</@s.cfg>',
            'delay'      : '<@s.cfg>query_completion.delay</@s.cfg>',
            'profile'    : '${question.inputParameterMap["profile"]!}',
            'query'      : '${QueryString}',
            //Search based completion
            'searchBasedCompletionEnabled': <@s.cfg>query_completion.search.enabled</@s.cfg>,
            'searchBasedCompletionProgram': '${SearchPrefix}<@s.cfg>query_completion.search.program</@s.cfg>'
        }
        
        <#-- Faceted Navigation more/less links -->
        FB.displayedCategories = 8;
        
    </script> 
<#--Load App default JS files-->
    <#list FBApps as app> 
    <script src="${webPath}/${app}.default.js"></script> 
    <script src="${webPath}/${app}.js"></script> 
    <script src="/s/resources/searchapp-careers/funnelback-faceted-navigation.js"></script> 
    </#list>
    </body>
    </html>
</#escape> 