<#ftl encoding="utf-8" output_format="HTML" />

<#--
  Format a multi-valued metadata field by joining them with a delimiter

  E.g. `A|B|C` gets converted to `A, B, C`

  @param metadata Metadata value to display
  @param delimiter Delimiter to split the metadata value on (defaults to `|`)
  @param displayDelimiter Delimiter to join splitted values on (defaults to `, `)
-->
<#macro MultiValuedMetadataDisplay metadata="" delimiter="|" displayDelimiter=", ">${metadata?split(delimiter)?join(displayDelimiter)}</#macro>

<#--
  Display the first value of a multi-valued metadata field

  E.g. `A|B|C` returns `A`

  @param metadata Metadata value to get the first value for
  @param delimiter Delimiter to split the metadata value on (defaults to `|`)
-->  
<#macro MultiValuedMetadataDisplayFirst metadata="" delimiter="|">${metadata?split(delimiter)[0]}</#macro>

<#---
  Generates a search form for the current collection, passing through the
  relevant parameters like collection, profile, form, scope, ...

  @param preserveTab Boolean indicating if searching via the form should preserve the currently selected tab or not
-->
<#macro SearchForm preserveTab=true>
  <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET">
    <input type="hidden" name="collection" value="${question.collection.id}">

    <#list ["enc", "form", "scope", "lang", "profile"] as parameter>
      <@s.IfDefCGI name=parameter><input type="hidden" name="${parameter}" value="${question.inputParameterMap[parameter]!}"></@s.IfDefCGI>
    </#list>

    <#if preserveTab>
      <#list question.selectedCategoryValues?keys as facetKey>
        <#if facetKey?starts_with("f.Tabs|")>
          <#list question.selectedCategoryValues[facetKey] as value>
            <input type="hidden" name="${facetKey}" value="${value}">
          </#list>
        </#if>
      </#list>
    </#if>

    <#nested>

  </form>
</#macro>

<#--
  Generate an HTML drop-down for sorting results

  @param options Map of sort options, where keys are the `sort` paratmeter (e.g. `date`) and values the label (e.g. `Date (Newest first)`)
-->
<#macro SortDropdown options={
  "": "Relevance",
  "date": "Date (Newest first)",
  "adate": "Date (Oldest first)",
  "title": "Title (A-Z)",
  "dtitle": "Title (Z-A)",
  "prox": "Distance",
  "url": "URL (A-Z)",
  "durl": "URL (Z-A)",
  "shuffle": "Shuffle"} >
  <div class="dropdown float-right">
    <button class="btn btn-secondary btn-sm dropdown-toggle" id="search-sort" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
      <span class="text-muted">Sort:</span> ${options[question.inputParameterMap["sort"]!]}
    </button>
    <div class="dropdown-menu" aria-labelledby="search-sort">
      <#list options as key, value>
        <a class="dropdown-item" title="Sort by ${value}" href="${question.collection.configuration.value("ui.modern.search_link")}?${QueryString}&sort=${key}">${value}</a>
      </#list>
    </div>
  </div>
</#macro>

<#--
  Generate an HTML drop-down to control the number of results

  @param limits Array of number of results to provide (defaults to 10, 20, 50)
-->
<#macro LimitDropdown limits=[10, 20, 50]>
  <div class="dropdown float-right">
    <button class="btn btn-secondary btn-sm dropdown-toggle" id="search-limit" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
      <span class="text-muted">Limit:</span> ${question.inputParameterMap["num_ranks"]!"10"}
    </button>
    <div class="dropdown-menu" aria-labelledby="search-limit">
      <#list limits as limit>
        <a class="dropdown-item" title="Limit to ${limit} results" href="${question.collection.configuration.value("ui.modern.search_link")}?${QueryString}&num_ranks=${limit}">${limit} results</a>
      </#list>
    </div>
  </div>
</#macro>

<#--
  Display result counts
-->
<#macro Counts>
  <#if response.resultPacket.resultsSummary.totalMatching == 0>
    <span class="search-counts-total-matching">0</span> search results for <strong><@s.QueryClean /></strong>
  </#if>
  <#if response.resultPacket.resultsSummary.totalMatching != 0>
    <span class="search-counts-page-start">${response.resultPacket.resultsSummary.currStart}</span> -
    <span class="search-counts-page-end">${response.resultPacket.resultsSummary.currEnd}</span> of
    <span class="search-counts-total-matching">${response.resultPacket.resultsSummary.totalMatching?string.number}</span>
    <#if question.inputParameterMap["s"]?? && question.inputParameterMap["s"]?contains("?:")><em>collapsed</em> </#if>search results for <strong><@s.QueryClean></@s.QueryClean></strong>
  </#if>

  <#if (response.resultPacket.resultsSummary.partiallyMatching!0) != 0>
    where <span class="search-counts-fully-matching">${response.resultPacket.resultsSummary.fullyMatching?string.number}</span>
    match all words and <span class="search-counts-partially-matching">${response.resultPacket.resultsSummary.partiallyMatching?string.number}</span>
    match some words.
  </#if>
  <#if (response.resultPacket.resultsSummary.collapsed!0) != 0>
    <span class="search-counts-collapsed">${response.resultPacket.resultsSummary.collapsed}</span>
    very similar results included.
  </#if>
</#macro>

<#--
  Display query blending notice
-->
<#macro Blending>
  <#if (response.resultPacket.QSups)!?size &gt; 0>
    <blockquote class="blockquote">
      <span class="fa fa-info-circle"></span>
      Your query has been expanded to <strong><#list response.resultPacket.QSups as qsup> ${qsup.query}<#if qsup_has_next>, </#if></#list></strong>.
      &nbsp;Search for <a href="?${QueryString}&amp;qsup=off" title="Turn off query expansion"><em>${question.originalQuery}</em></a> instead.
    </blockquote>
  </#if>
</#macro>

<#--
  Display spelling suggestion notice
-->
<#macro Spelling>
    <#if (response.resultPacket.spell)??>
      <div class="search-spelling">
        <span class="fa fa-question-circle"></span>
        Did you mean <em><a href="${question.collection.configuration.value("ui.modern.search_link")}?${response.resultPacket.spell.url}" title="Spelling suggestion">${response.resultPacket.spell.text}</a></em>?
      </div>
    </#if>
</#macro>

<#--
  Message to display when there are no results
-->
<#macro NoResults>
  <#if (response.resultPacket.resultsSummary.totalMatching)! == 0>
    <h3><span class="glyphicon glyphicon-warning-sign"></span> No results</h3>
    <p>Your search for <strong>${question.originalQuery!}</strong> did not return any results. Please ensure that you:</p>
    <ul>
      <li>are not using any advanced search operators like + - | " etc.</li>
      <li>expect this document to exist within the <em><@s.cfg>service_name</@s.cfg></em> collection <@s.IfDefCGI name="scope"> and within <em><@s.Truncate length=80>${question.inputParameterMap["scope"]!}</@s.Truncate></em></@s.IfDefCGI></li>
      <li>have permission to see any documents that may match your query</li>
    </ul>
  </#if>
</#macro>

<#--
  Display the contextual navigation panel
-->
<#macro ContextualNavigation>
  <#if ((response.resultPacket.contextualNavigation.categories)![])?size gt 0>
    <div class="card search-contextual-navigation">
      <div class="card-block">
        <div class="card-title">
          <h3>Related searches for <strong><@s.QueryClean /></strong></h3>
        </div>

        <div class="card-text">
          <div class="row">
            <#list (response.resultPacket.contextualNavigation.categories)![] as category>
              <div class="col">
                <h4 class="text-muted">By ${category.name}</h4>
                <ul class="list-unstyled">
                  <#list category.clusters as cluster>
                    <li class="list-item-unstyled"><a href="${cluster.href}">${cluster.label?replace("...", " <strong>${response.resultPacket.contextualNavigation.searchTerm} </strong> ")?no_esc}</a></li>
                  </#list>
                </ul>
              </div>
            </#list>
          </div>
        </div>
      </div>
    </div>
  </#if>
</#macro>

<#--
  Display Curator messages

  @param position Position attribute to consider from the Curator message.
    Only messages with a position attribute matching this will be displayed. Can be empty to display all messages regardless of position.
-->
<#macro CuratorExhibits position>
  <#list (response.curator.exhibits)![] as exhibit>
    <#-- Skip best bets -->
    <#if exhibit.category != "BEST_BETS">
      <#if !position?? || (exhibit.additionalProperties.position)! == position>

        <#if exhibit.messageHtml??>
          <#-- Simple message -->
          <blockquote class="blockquote search-exhibit">
            ${exhibit.messageHtml?no_esc}
          </blockquote>
        <#elseif exhibit.descriptionHtml??>
          <#-- Rich message -->
          <div class="card search-exhibit ${(exhibit.additionalProperties.class)!}">
            <div class="card-header">
              <h4><a href="${exhibit.linkUrl!}">${exhibit.titleHtml!}</a></h4>
            </div>
            <div class="card-block">
              <#if exhibit.displayUrl?? && exhibit.displayUrl != "-"><cite class="text-success">${exhibit.displayUrl}</cite></#if>
              <#if exhibit.descriptionHtml??>${exhibit.descriptionHtml?no_esc}</#if>
            </div>
          </div>
        </#if>
      </#if>
    </#if>
  </#list>
</#macro>

<#--
  Display best bets
-->
<#macro BestBets>
  <#list (response.curator.exhibits)![] as exhibit>
    <#if exhibit.category == "BEST_BETS">
    <div class="alert alert-warning" role="alert">
      <strong><a class="text-warning" href="${exhibit.linkUrl!}">${exhibit.titleHtml!}</a></strong>
      <#if exhibit.descriptionHtml??><p>${exhibit.descriptionHtml?no_esc}</p></#if>
      <#if exhibit.displayUrl?? && exhibit.displayUrl != "-"><cite><a class="text-muted" href="${exhibit.linkUrl!}">${exhibit.displayUrl}</a></cite></#if>
    </div>
    </#if>
  </#list>
</#macro>

<#--
  Iterate over results and choose the right template depending
  on the results type and what is configured in collection.cfg

  @param rootNamespace Root namespace from the main template, so that
    it can access imported macro libraries containing result-specific template.
    Call with <code>rootNamespace=.namespace</code>
-->
<#macro ResultList rootNamespace>
  <ol class="list-unstyled">
    <#list (response.resultPacket.resultsWithTierBars)![] as result>
      <#if result.class.simpleName == "TierBar">
        <@TierBar result=result />
      <#else>
        <#-- Get result template depending on collection name -->
        <#assign resultDisplayLibrary = question.collection.configuration.value("stencils.template.result.${result.collection}", "") />

        <#-- If not defined, attempt to get it depending on the gscopes the result belong to -->
        <#if !resultDisplayLibrary?has_content>
          <#list (result.gscopesSet)![] as gscope>
            <#assign resultDisplayLibrary = question.collection.configuration.value("stencils.template.result.${gscope}", "") />
            <#if resultDisplayLibrary?has_content>
              <#break>
            </#if>
          </#list>
        </#if>

        <#if rootNamespace[resultDisplayLibrary]??>
          <@rootNamespace[resultDisplayLibrary].Result result=result />
        <#elseif rootNamespace["Result"]??>
          <#-- Default Result macro in current namespace -->
          <@rootNamespace.Result result=result />
        <#else>
          <div class="alert alert-danger" role="alert">
            <strong>Result template not found</strong>: Template <code>&lt;@<#if resultDisplayLibrary?has_content>${resultDisplayLibrary}<#else>(default namespace)</#if>.Result /&gt;</code>
            not found for result from collection <em>${result.collection}</em>.
          </div>
        </#if>
      </#if>
    </#list>
  </ol>
</#macro>

<#--
  Display a tier bar
-->
<#macro TierBar result>
  <#-- A tier bar -->
  <#if result.matched != result.outOf>
    <li class="search-tier"><h3 class="text-muted">Results that match ${result.matched} of ${result.outOf} words</h3></li>
  <#else>
    <li class="search-tier"><h3 class="sr-only">Fully-matching results</h3></li>
  </#if>
  <#-- Print event tier bars if they exist -->
  <#if result.eventDate??>
    <li class="event-tier">
      <h3 class="text-muted">Events on ${result.eventDate?date}</h3>
    </li>
  </#if>
</#macro>

<#--
  Display paging controls
-->
<#macro Paging>
  <#if (response.customData.stencilsPaging)??>
    <nav aria-label="pagination">
      <ul class="pagination pagination-lg justify-content-center">

        <#-- First page -->
        <#if response.customData.stencilsPaging.previousUrl??>
          <li class="page-item">
            <a class="page-link" href="${response.customData.stencilsPaging.previousUrl}"><span class="fa fa-caret-left"></span> Prev</a>
          </li>
        </#if>

        <#-- Sibling pages -->
        <#list response.customData.stencilsPaging.pages as page>
          <li class="page-item<#if page.selected> active</#if>">
            <a class="page-link" href="${page.url}">${page.number}</a>
          </li>
        </#list>

        <#-- Last page -->
        <#if response.customData.stencilsPaging.nextUrl??>
          <li class="page-item">
            <a class="page-link" href="${response.customData.stencilsPaging.nextUrl}">Next <span class="fa fa-caret-right"></span></a>
          </li>
        </#if>

      </ul>
    </nav>
  </#if>
</#macro>
<#-- vim: set expandtab ts=2 sw=2 sts=2 :-->
