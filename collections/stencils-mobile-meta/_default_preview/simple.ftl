<#ftl encoding="utf-8" />
<#--
   Funnelback App: mobile
   By: <Tien NGuyen>
   Description: <Description>
-->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#--Paths -->
<#assign basePath>/s/resources/<@s.cfg>collection</@s.cfg></#assign>
<#assign webPath>${basePath}/${question.profile}</#assign>

<#--FunnelBack Apps used -->
<#assign FBApps = ["mobile"] />

<#-- Import and assign app namespaces eg. mobile and mobile_custom -->
<#list FBApps as app>
    <#assign appTemplate="${app}.default.ftl" appNamespace="${app?lower_case}" />
    <#assign appTemplateCustom="${app}.ftl" appNamespaceCustom="${app?lower_case}_custom" />
    <@'<#import appTemplate as ${appNamespace}>'?interpret />
    <@'<#import appTemplateCustom as ${appNamespaceCustom}>'?interpret />
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
    <@s.AfterSearchOnly>
        <link rel="alternate" type="application/rss+xml" title="Search results for ${question.inputParameterMap["query"]!}<@s.IfDefCGI name="query">,&nbsp;</@s.IfDefCGI><@s.cfg>service_name</@s.cfg>" href="?collection=<@s.cfg>collection</@s.cfg>&amp;query=${question.inputParameterMap["query"]!?url}&amp;form=rss&amp;sort=date">
    </@s.AfterSearchOnly>
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
  <body id="funnelback-search" class="container<#if layoutType?? && layoutType != ''>-${layoutType}</#if> "<#if question.collection.configuration.valueAsBoolean("ui.modern.session")> data-ng-app="Funnelback" data-ng-controller="DefaultCtrl" </#if> data-ng-show="isDisplayed('results')">
    <@fb.ViewModeBanner />
    
    <@s.InitialFormOnly>
        <@mobile.InitialForm image="${largeLogoImg}"/>
    </@s.InitialFormOnly>

    <@s.AfterSearchOnly>
        <@mobile.NavBar />
        <@mobile.AdvancedForm />
        <@mobile_custom.NavButton />
        <@mobile_custom.NavMenu />
        <section id="search-main" class="row">


            <@mobile.Facets />
          <div id="search-content" class="col-md-<@s.FacetedSearch>9</@s.FacetedSearch><@s.FacetedSearch negate=true>12</@s.FacetedSearch>">

            <@mobile.SearchHistory />
            <@mobile.Scopes />
            <@mobile.Count />
            <@mobile.Blending />
            <@mobile.CuratorExhibits />
            <@mobile.Spelling />
            <@mobile.Summary />
            <@mobile.EntityDefinition />
            <@mobile.CuratorExhibitsList />
            <@mobile.BestBets />
            <@mobile.Results />
            <@mobile.Pagination />
            <@mobile.ContextualNavigation />
          </div>
        </section>
        <@mobile.SearchHistory />
        <@mobile.Cart />
        <@mobile.Tools />
    </@s.AfterSearchOnly>


    <@mobile.Footer />
    <#-- Javascript-->
    <@mobile.jsDefault />

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

<script>
     console.log("everything is in order");
</script>
  </body>
</html>
