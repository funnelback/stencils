<#ftl encoding="utf-8" />
<#--
   Funnelback App: Core
   By: <Name>
   Description: <Description>
-->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#--Paths -->
<#assign basePath>/s/resources/<@s.cfg>collection</@s.cfg></#assign>
<#assign webPath>${basePath}/${question.profile}</#assign>

<#--FunnelBack Apps used -->
<#assign FBApps = ["core", "courses", "tabs", "experts"] />

<#-- Import and assign app namespaces eg. core and core_view -->
<#list FBApps as app>
    <#assign appController="${app}.controller.ftl" appNamespace="${app?lower_case}_controller" />
    <#assign appView="${app}.view.ftl" appNamespaceCustom="${app?lower_case}_view" />
    <@'<#import appController as ${appNamespace}>'?interpret />
    <@'<#import appView as ${appNamespaceCustom}>'?interpret />
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
    <title><@s.AfterSearchOnly>${question.inputParameterMap["query"]!}<@s.IfDefCGI name="query">,&nbsp;</@s.IfDefCGI></@s.AfterSearchOnly><@s.cfg>service_name</@s.cfg> -  Funnelback Search</title>
    <@s.OpenSearch />
    <@s.AfterSearchOnly><link rel="alternate" type="application/rss+xml" title="Search results for ${question.inputParameterMap["query"]!}<@s.IfDefCGI name="query">,&nbsp;</@s.IfDefCGI><@s.cfg>service_name</@s.cfg>" href="?collection=<@s.cfg>collection</@s.cfg>&amp;query=${question.inputParameterMap["query"]!?url}&amp;form=rss&amp;sort=date"></@s.AfterSearchOnly>
    <link rel="stylesheet" href="${SearchPrefix}thirdparty/bootstrap-3.0.0/css/bootstrap.min.css">
    <!--[if lt IE 9]>
    <script src="${SearchPrefix}thirdparty/html5shiv.js"></script>
    <script src="${SearchPrefix}thirdparty/respond.min.js"></script>
    <![endif]-->
     <#--Load App default CSS files-->
    <#list FBApps as app>
        <link rel="stylesheet" href="${webPath}/${app}.default.css">
        <link rel="stylesheet" href="${webPath}/${app}.css">
    </#list>
  </head>
  <body id="funnelback-search" class="container<#if layoutType?? && layoutType != ''>-${layoutType}</#if> "<#if question.collection.configuration.valueAsBoolean("ui.modern.session")> data-ng-app="Funnelback" data-ng-controller="DefaultCtrl" </#if>>
    <@fb.ViewModeBanner />
    
    <@s.InitialFormOnly>
        <@core_controller.InitialForm image="${largeLogoImg}"/>
    </@s.InitialFormOnly>

    <@s.AfterSearchOnly>
        <@core_controller.NavBar />
        <@core_controller.AdvancedForm />

        <section id="search-main" class="row" data-ng-show="isDisplayed('results')">
          <@core_controller.Facets />
          <div id="search-content" class="col-md-<@s.FacetedSearch>9</@s.FacetedSearch><@s.FacetedSearch negate=true>12</@s.FacetedSearch>">
            <@courses_view.BreadCrumb />
            <@tabs_view.TabMenu />
            <@core_controller.QueryHistory />
            <@core_controller.Scopes />
            <@core_controller.Count />
            <@core_controller.Blending />
            <@core_controller.CuratorExhibits />
            <@core_controller.Spelling />
            <@core_controller.Summary />
            <@core_controller.EntityDefinition />
            <@core_controller.CuratorExhibitsList />
            <@core_controller.BestBets />
            <@core_view.Results />
            <@core_controller.Pagination />
            <@core_controller.ContextualNavigation />
          </div>
        </section>
        <@core_controller.SearchHistory />
        <@core_controller.Cart />
        <@core_controller.Tools />
    </@s.AfterSearchOnly>
    

    <@core_controller.Footer />
    <#-- Javascript-->
    <@core_controller.jsDefault />
    <@experts_controller.jsDefault />
    <@courses_controller.jsDefault />


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
    </#list>
   
  </body>
</html>