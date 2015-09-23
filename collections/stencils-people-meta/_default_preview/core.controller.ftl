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

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#macro pageTitle  siteName collectionName query>
<title><#if query??>${query} </#if><#if collectionName??>,&nbsp; ${collectionName} </#if> <#if sitename??>- ${sitename}</#if></title>
</#macro>

<#macro element type="div" id="" class="" custom="">
<${type} <#if id?? && id?has_content>id="${id}"</#if><#if class?? && class?has_content> class="${class}"</#if>${custom!}><#compress>
<#nested>
</#compress><#if type!="area" && type!="base" && type!="br" && type!="col" && type!="command" && type!="embed" && type!="hr" && type!="img" && type!="input" && type!="link" && type!="meta" && type!="param" && type!="source"></${type}></#if>
</#macro>

<#macro InitialForm image>
  <div class="row search-initial">
        <div class="col-md-6 col-md-offset-3 text-center">

            <#if error?? || (response.resultPacket.error)??>
                <div class="alert alert-danger"><@fb.ErrorMessage /></div>
                <br><br>
            </#if>

            <a href="http://funnelback.com/"><img src="${SearchPrefix}funnelback.png" alt="Funnelback logo"></a>
            <br><br>

            <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET"
                  role="search">
                <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
                <@s.IfDefCGI name="enc"><input type="hidden" name="enc"
                                               value="${question.inputParameterMap["enc"]!}"></@s.IfDefCGI>
                <@s.IfDefCGI name="form"><input type="hidden" name="form"
                                                value="${question.inputParameterMap["form"]!}"></@s.IfDefCGI>
                <@s.IfDefCGI name="scope"><input type="hidden" name="scope"
                                                 value="${question.inputParameterMap["scope"]!}"></@s.IfDefCGI>
                <@s.IfDefCGI name="lang"><input type="hidden" name="lang"
                                                value="${question.inputParameterMap["lang"]!}"></@s.IfDefCGI>
                <@s.IfDefCGI name="profile"><input type="hidden" name="profile"
                                                   value="${question.inputParameterMap["profile"]!}"></@s.IfDefCGI>
                <div class="input-group">
                    <input required name="query" id="query" title="Search query" type="text"
                           value="${question.inputParameterMap["query"]!}" accesskey="q"
                           placeholder="Search <@s.cfg>service_name</@s.cfg>        "
                           class="form-control input-lg query">

                    <div class="input-group-btn">
                        <button type="submit" class="btn btn-primary input-lg"><span
                                class="glyphicon glyphicon-search"></span> Search
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</#macro>

<#macro CuratorExhibitsList >
  <#if (exhibits)!?size &gt; 0>
    <ol id="search-curator" class="list-unstyled">
      <#list response.curator.exhibits as exhibit>
        <#if exhibit.titleHtml?? && exhibit.linkUrl??>
        <li>
          <h4><a href="${exhibit.linkUrl}"><@s.boldicize><#noescape>${exhibit.titleHtml}</#noescape></@s.boldicize></a></h4>
          <#if exhibit.displayUrl??><cite class="text-success">${exhibit.displayUrl}</cite></#if>
          <#if exhibit.descriptionHtml??><p><@s.boldicize><#noescape>${exhibit.descriptionHtml}</#noescape></@s.boldicize></p></#if>
        </li>
        </#if>
      </#list>
    </ol>
  </#if>
</#macro>

<#macro BestBets >
  <#if (response.resultPacket.bestBets)!?size &gt; 0>
    <ol id="search-best-bets" class="list-unstyled">
      <@s.BestBets>
      <li class="alert alert-warning">
        <#if s.bb.title??><h4><a href="${s.bb.clickTrackingUrl}"><@s.boldicize>${s.bb.title}</@s.boldicize></a></h4></#if>
        <#if s.bb.title??><cite class="text-success">${s.bb.link}</cite></#if>
        <#if s.bb.description??><p><@s.boldicize><#noescape>${s.bb.description}</#noescape></@s.boldicize></p></#if>
        <#if ! s.bb.title??><p><strong>${s.bb.trigger}:</strong> <a href="${s.bb.link}">${s.bb.link}</a></#if>
      </li>
      </@s.BestBets>
    </ol>
  </#if>
</#macro>

<#macro Results >
  <ol id="search-results" class="list-unstyled" start="${response.resultPacket.resultsSummary.currStart}">
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
    <li data-fb-result="${s.result.indexUrl}">
      <h4>
      <#if question.collection.configuration.valueAsBoolean("ui.modern.session")><a href="#" data-ng-click="toggle()" data-cart-link data-css="pushpin|remove" title="{{label}}"><small class="glyphicon glyphicon-{{css}}"></small></a></#if>
      <a href="${s.result.clickTrackingUrl}" title="${s.result.liveUrl}">
        <@s.boldicize><@s.Truncate length=70>${s.result.title}</@s.Truncate></@s.boldicize>
      </a>
      <#if s.result.fileType!?matches("(doc|docx|ppt|pptx|rtf|xls|xlsx|xlsm|pdf)", "r")>
      <small class="text-muted">${s.result.fileType?upper_case} (${filesize(s.result.fileSize!0)})</small>
      </#if>
      <#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(s.result.indexUrl)??><small class="text-warning"><span class="glyphicon glyphicon-time"></span> <a title="Click history" href="#" class="text-warning" data-ng-click="toggleHistory()">Last visited ${prettyTime(session.getClickHistory(s.result.indexUrl).clickDate)}</a></small></#if>
      </h4>
      <cite data-url="${s.result.displayUrl}" class="text-success"><@s.cut cut="http://"><@s.boldicize>${s.result.displayUrl}</@s.boldicize></@s.cut></cite>
      <div class="btn-group">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown" title="More actions&hellip;"><small class="glyphicon glyphicon-chevron-down text-success"></small></a>
        <ul class="dropdown-menu">
          <li><#if s.result.cacheUrl??><a href="${s.result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="Cached version of ${s.result.title} (${s.result.rank})">Cached</a></#if></li>
          <li><@s.Explore /></li>
          <@fb.AdminUIOnly><li><@fb.Optimise /></li></@fb.AdminUIOnly>
        </ul>
      </div>
      <@s.Quicklinks>
      <ul class="list-inline">
        <@s.QuickRepeat><li><a href="${s.ql.url}" title="${s.ql.text}">${s.ql.text}</a></li></@s.QuickRepeat>
      </ul>
      <#if question.collection.quickLinksConfiguration["quicklinks.domain_searchbox"]?? && question.collection.quickLinksConfiguration["quicklinks.domain_searchbox"] == "true">
      <#if s.result.quickLinks.domain?matches("^[^/]*/?[^/]*$", "r")>
      <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="search">
        <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
        <input type="hidden" name="meta_u_sand" value="${s.result.quickLinks.domain}">
        <@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@s.IfDefCGI>
        <div class="row">
          <div class="col-md-4">
            <div class="input-group input-sm">
              <input required title="Search query" name="query" type="text" class="form-control" placeholder="Search ${s.result.quickLinks.domain}&hellip;">
              <div class="input-group-btn">
                <button type="submit" class="btn btn-info"><span class="glyphicon glyphicon-search"></span></button>
              </div>
            </div>
          </div>
        </div>
      </form>
      </#if>
      </#if>
      </@s.Quicklinks>
      <#if s.result.summary??>
      <p>
      <#if s.result.date??><small class="text-muted">${s.result.date?date?string("d MMM yyyy")}:</small></#if>
      <span class="search-summary"><@s.boldicize><#noescape>${s.result.summary}</#noescape></@s.boldicize></span>
      </p>
      </#if>
      <#if s.result.metaData["c"]??><p><@s.boldicize>${s.result.metaData["c"]!}</@s.boldicize></p></#if>
      <#if s.result.collapsed??>
      <div class="search-collapsed"><small><span class="glyphicon glyphicon-expand text-muted"></span>&nbsp; <@fb.Collapsed /></small></div>
      </#if>
      <#if s.result.metaData["a"]?? || s.result.metaData["s"]?? || s.result.metaData["p"]??>
      <dl class="dl-horizontal text-muted">
        <#if s.result.metaData["a"]??><dt>by</dt><dd>${s.result.metaData["a"]!?replace("|", ", ")}</dd></#if>
        <#if s.result.metaData["s"]??><dt>Keywords:</dt><dd>${s.result.metaData["s"]!?replace("|", ", ")}</dd></#if>
        <#if s.result.metaData["p"]??><dt>Publisher:</dt><dd>${s.result.metaData["p"]!?replace("|", ", ")}</dd></#if>
      </dl>
      </#if>
    </li>
    </#if>
    </@s.Results>
  </ol>
</#macro>

<#macro Footer>
  <footer id="search-footer">
    <div class="row">
      <div class="col-xs-12 col-md-3 mw-3"></div>
      <div class="col-xs-12 col-md-9">
        <p class="text-muted"><small>
        <#if (response.resultPacket.details.collectionUpdated)??>Collection last updated: ${response.resultPacket.details.collectionUpdated?datetime}.<br></#if>
        Search powered by <a href="http://www.funnelback.com">Funnelback</a>.
        </small></p>
      </div>
    </div>
  </footer>
</#macro>

<#macro EntityDefinition>
  <#if response.entityDefinition??>
    <blockquote id="search-text-miner">
      <h3><span class="glyphicon glyphicon-hand-right text-muted"></span> <@s.QueryClean/></h3>
      <div><@fb.TextMiner /></div>
    </blockquote>
  </#if>
</#macro>

<#macro Summary>
  <h2 class="visible-print">Results</h2>
  <#if response.resultPacket.resultsSummary.totalMatching == 0>
    <h3><span class="glyphicon glyphicon-warning-sign"></span> No results</h3>
    <p>Your search for <strong>${question.originalQuery!}</strong> did not return any results. Please ensure that you:</p>
    <ul>
      <li>are not using any advanced search operators like + - | " etc.</li>
      <li>expect this document to exist within the <em><@s.cfg>service_name</@s.cfg></em> collection <@s.IfDefCGI name="scope"> and within <em><@s.Truncate length=80>${question.inputParameterMap["scope"]!}</@s.Truncate></em></@s.IfDefCGI></li>
      <li>have permission to see any documents that may match your query</li>
    </ul>
  </#if>
</#macro>

<#macro ToolsPerformance>
  <div id="search-performance" class="modal fade">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button class="close" data-dismiss="modal" data-target="#search-performance">&times;</button>
          <h3>Performance</h3>
        </div>
        <div class="modal-body">
          <@fb.PerformanceMetrics class="search-metrics table-striped table table-condensed" tdClass="progress-bar progress-bar-info" width=200 title=""/>
        </div>
      </div>
    </div>
  </div>
</#macro>

<#macro ToolsSyntaxTree>
  <div id="search-syntaxtree" class="modal fade">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button class="close" data-dismiss="modal" data-target="#search-syntaxtree">&times;</button>
          <h3>Query syntax tree</h3>
        </div>
        <div class="modal-body">
          <#if response?? && response.resultPacket??
          && response.resultPacket.svgs??
          && response.resultPacket.svgs["syntaxtree"]??>
          ${response.resultPacket.svgs["syntaxtree"]}
          <#else>
          <div class="alert alert-warning">Query syntax tree unavailable. Make sure the <code>-show_qsyntax_tree=on</code> query processor option is set.</div>
          </#if>
        </div>
      </div>
    </div>
  </div>
</#macro>

<!-- Search Tools into one macro -->
<#macro Tools>
  <section id="search-tools" class="hidden-print">
    <h2 class="sr-only">Tools</h2>
    <@ToolsPerformance />
    <@ToolsSyntaxTree />
  </section>
</#macro>

<#macro Cart>
  <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
    <section id="search-cart" data-ng-cloak data-ng-show="isDisplayed('cart')" data-ng-controller="CartCtrl">
      <div class="row">
        <div class="col-md-12">
          <a href="#" data-ng-click="hideCart()"><span class="glyphicon glyphicon-arrow-left"></span> Back to results</a>
          <h2><span class="glyphicon glyphicon-pushpin"></span> Saved
            <button class="btn btn-danger btn-xs" title="Clear selection" data-ng-click="clear('Your selection will be cleared')"><span class="glyphicon glyphicon-remove"></span> Clear</button>
          </h2>

          <ul class="list-unstyled">
            <li data-ng-repeat="item in cart">
              <h4>
                <a title="Remove" data-ng-click="remove(item.indexUrl)" href="javascript:;"><small class="glyphicon glyphicon-remove"></small></a>
                <a href="{{item.indexUrl}}">{{item.title|truncate:70}}</a>
              </h4>

              <cite class="text-success">{{item.indexUrl|cut:'http://'}}</cite>
              <p>{{item.summary|truncate:255}}</p>
            </li>
          </ul>
        </div>
      </div>
    </section>
  </#if>
</#macro>

<#macro SearchHistory>
  <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
    <section id="search-history" data-ng-cloak data-ng-show="isDisplayed('history')">
      <div class="row">
        <div class="col-md-12">
          <a href="#" data-ng-click="hideHistory()"><span class="glyphicon glyphicon-arrow-left"></span> Back to results</a>
          <h2><span class="glyphicon glyphicon-time"></span> History</h2>

          <div class="row">
            <div class="col-md-6" data-ng-controller="ClickHistoryCtrl">
              <div data-ng-show="!clickHistoryEmpty && <@fb.HasClickHistory />">
                <h3><span class="glyphicon glyphicon-heart"></span> Recently clicked results
                  <button class="btn btn-danger btn-xs" title="Clear click history" data-ng-click="clear('Your history will be cleared')"><span class="glyphicon glyphicon-remove"></span> Clear</button>
                </h3>
                <ul class="list-unstyled">
                  <#list session.clickHistory as h>
                    <li><a href="${h.indexUrl}">${h.title}</a> &middot; <span class="text-warning">${prettyTime(h.clickDate)}</span><#if h.query??><span class="text-muted"> for &quot;${h.query!}&quot;</#if></span></li>
                  </#list>
                </ul>
              </div>
              <div data-ng-show="clickHistoryEmpty || !<@fb.HasClickHistory />">
                <h3><span class="glyphicon glyphicon-heart"></span> Recently clicked results</h3>
                <p class="text-muted">Your click history is empty.</p>
              </div>
            </div>
            <div class="col-md-6" data-ng-controller="SearchHistoryCtrl">
              <div data-ng-show="!searchHistoryEmpty && <@fb.HasSearchHistory />">
                <h3><span class="glyphicon glyphicon-search"></span> Recent searches
                  <button class="btn btn-danger btn-xs" title="Clear search history" data-ng-click="clear('Your history will be cleared')"><span class="glyphicon glyphicon-remove"></span> Clear</button>
                </h3>
                <ul class="list-unstyled">
                  <#list session.searchHistory as h>
                    <li><a href="?${h.searchParams}">${h.originalQuery} <small>(${h.totalMatching})</small></a> &middot; <span class="text-warning">${prettyTime(h.searchDate)}</span></li>
                  </#list>
                </ul>
              </div>
              <div data-ng-show="searchHistoryEmpty || !<@fb.HasSearchHistory />">
                <h3><span class="glyphicon glyphicon-search"></span> Recent searches</h3>
                <p class="text-muted">Your search history is empty.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </#if>
</#macro>

<#macro ContextualNavigation>
  <@s.ContextualNavigation>
  <@s.ClusterNavLayout />
  <@s.NoClustersFound />
  <@s.ClusterLayout>
  <div id="search-contextual-navigation">
    <hr>
    <h3>Related searches for <strong><@s.QueryClean /></strong></h3>
    <div class="row">
      <@s.Category name="type">
      <div class="col-md-4 search-contextual-navigation-type">
        <h4>Types of <strong>${s.contextualNavigation.searchTerm}</strong></h4>
        <ul class="list-unstyled">
          <@s.Clusters><li><a href="${s.cluster.href}"> <#noescape>${s.cluster.label?html?replace("...", " <strong>"+s.contextualNavigation.searchTerm?html+"</strong> ")}</#noescape></a></li></@s.Clusters>
          <@s.ShowMoreClusters category="type"><li><a rel="more" href="${changeParam(s.category.moreLink, "type_max_clusters", "40")}" class="btn btn-link btn-sm"><small class="glyphicon glyphicon-plus"></small> More&hellip;</a></li></@s.ShowMoreClusters>
          <@s.ShowFewerClusters category="type" />
        </ul>
      </div>
      </@s.Category>
      <@s.Category name="topic">
      <div class="col-md-4 search-contextual-navigation-topic">
        <h4>Topics on <strong>${s.contextualNavigation.searchTerm}</strong></h4>
        <ul class="list-unstyled">
          <@s.Clusters><li><a href="${s.cluster.href}"> <#noescape>${s.cluster.label?html?replace("...", " <strong>"+s.contextualNavigation.searchTerm?html+"</strong> ")}</#noescape></a></li></@s.Clusters>
          <@s.ShowMoreClusters category="topic"><li><a rel="more" href="${changeParam(s.category.moreLink, "topic_max_clusters", "40")}" class="btn btn-link btn-sm"><small class="glyphicon glyphicon-plus"></small> More&hellip;</a></li></@s.ShowMoreClusters>
          <@s.ShowFewerClusters category="topic" />
        </ul>
      </div>
      </@s.Category>
      <@s.Category name="site">
      <div class="col-md-4 search-contextual-navigation-site">
        <h4><strong>${s.contextualNavigation.searchTerm}</strong> by site</h4>
        <ul class="list-unstyled">
          <@s.Clusters><li><a href="${s.cluster.href}">${s.cluster.label}</a></li></@s.Clusters>
          <@s.ShowMoreClusters category="site"><li><a rel="more" href="${changeParam(s.category.moreLink, "site_max_clusters", "40")}" class="btn btn-link btn-sm"><small class="glyphicon glyphicon-plus"></small> More&hellip;</a></li></@s.ShowMoreClusters>
          <@s.ShowFewerClusters category="site" />
        </ul>
      </div>
      </@s.Category>
    </div>
  </div>
  </@s.ClusterLayout>
  </@s.ContextualNavigation>
</#macro>

<#macro Pagination>
  <div id="search-pagination" class="hidden-print">
    <h2 class="sr-only">Pagination</h2>
    <ul class="pagination">
      <@fb.Prev><li><a href="${fb.prevUrl}" rel="prev"><small><span class="glyphicon glyphicon-chevron-left"></span></small> Prev</a></li></@fb.Prev>
      <@fb.Page numPages=5><li <#if fb.pageCurrent> class="active"</#if>><a href="${fb.pageUrl}">${fb.pageNumber}</a></li></@fb.Page>
      <@fb.Next><li><a href="${fb.nextUrl}" rel="next">Next <small><span class="glyphicon glyphicon-chevron-right"></span></small></a></li></@fb.Next>
    </ul>
  </div>
</#macro>

<#macro Spelling>
  <@s.CheckSpelling prefix="<h3 id=\"search-spelling\"><span class=\"glyphicon glyphicon-question-sign text-muted\"></span> Did you mean <em>" suffix="</em>?</h3>" />
</#macro>

<#macro CuratorExhibits>
  <#if (response.curator.exhibits)!?size &gt; 0>
    <#list response.curator.exhibits as exhibit>
      <#if exhibit.messageHtml??>
        <blockquote class="search-curator-message">
          <#noescape>${exhibit.messageHtml}</#noescape>
        </blockquote>
      </#if>
    </#list>
  </#if>
</#macro>


<#macro Blending>
  <#if (response.resultPacket.QSups)!?size &gt; 0>
    <div class="alert alert-info">
      <@fb.CheckBlending linkText="Search for <em>"+question.originalQuery+"</em> instead." tag="strong" />
    </div>
  </#if>
</#macro>

<#macro Count>
  <div id="search-result-count" class="text-muted">
    <#if response.resultPacket.resultsSummary.totalMatching == 0>
    <span id="search-total-matching">0</span> search results for <strong><@s.QueryClean /></strong>
    </#if>
    <#if response.resultPacket.resultsSummary.totalMatching != 0>
    <span id="search-page-start">${response.resultPacket.resultsSummary.currStart}</span> -
    <span id="search-page-end">${response.resultPacket.resultsSummary.currEnd}</span> of
    <span id="search-total-matching">${response.resultPacket.resultsSummary.totalMatching?string.number}</span>
    <#if question.inputParameterMap["s"]?? && question.inputParameterMap["s"]?contains("?:")><em>collapsed</em> </#if>search results for <strong><@s.QueryClean></@s.QueryClean></strong>
    </#if>
    <#if (response.resultPacket.resultsSummary.partiallyMatching!0) != 0>
    where <span id="search-fully-matching">${response.resultPacket.resultsSummary.fullyMatching?string.number}</span>
    match all words and <span id="search-partially-matching">${response.resultPacket.resultsSummary.partiallyMatching?string.number}</span>
    match some words.
    </#if>
    <#if (response.resultPacket.resultsSummary.collapsed!0) != 0>
    <span id="search-collapsed">${response.resultPacket.resultsSummary.collapsed}</span>
    very similar results included.
    </#if>
  </div>
</#macro>

<#macro Scopes>
  <#if question.inputParameterMap["scope"]!?length != 0>
    <div class="breadcrumb">
      <span class="text-muted"><span class="glyphicon glyphicon-resize-small"></span> Scope:</span> <@s.Truncate length=80>${question.inputParameterMap["scope"]!}</@s.Truncate>
      <a class="button btn-xs" title="Remove scope: ${question.inputParameterMap["scope"]!}" href="?collection=${question.inputParameterMap["collection"]!}<#if question.inputParameterMap["form"]??>&amp;form=${question.inputParameterMap["form"]!}</#if>&amp;query=<@s.URLEncode><@s.QueryClean /></@s.URLEncode>">r<span class="glyphicon glyphicon-remove text-muted"></span></a>
    </div>
  </#if>
</#macro>

<#macro QueryHistory>
  <#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session.searchHistory?? && session.searchHistory?size &gt; 0>
    <#-- Build list of previous queries -->

    <#assign qsSignature = computeQueryStringSignature(QueryString) />
    <#if session.searchHistory?? &&
      (session.searchHistory?size &gt; 1 || session.searchHistory[0].searchParamsSignature != qsSignature)>
      <div class="breadcrumb" data-ng-controller="SearchHistoryCtrl" data-ng-show="!searchHistoryEmpty">
          <button class="btn btn-link pull-right" data-ng-click="toggleHistory()"><small class="text-muted"><span class="glyphicon glyphicon-plus"></span> More&hellip;</small></button>
          <ol class="list-inline" >
            <li class="text-muted">Recent:</li>

            <#list session.searchHistory as h>
              <#if h.searchParamsSignature != qsSignature>
                <#assign facetDescription><#compress>
                <#list h.searchParams?matches("f\\.([^=]+)=([^&]+)") as f>
                    ${urlDecode(f?groups[1])?split("|")[0]} = ${urlDecode(f?groups[2])}<#if f_has_next><br></#if>
                </#list>
                </#compress></#assign>
                <li>
                  <a <#if facetDescription != ""> data-toggle="tooltip" data-placement="bottom" title="${facetDescription}"</#if> title="${prettyTime(h.searchDate)}" href="${question.collection.configuration.value("ui.modern.search_link")}?${h.searchParams}">${h.originalQuery} <small>(${h.totalMatching})</small></a>
                  <#if facetDescription != ""><i class="glyphicon glyphicon-filter"></i></a></#if>
                </li>
              </#if>
            </#list>
          </ol>
      </div>
    </#if>
  </#if>
</#macro>

<#macro Facets>
  <@s.FacetedSearch>
  <div id="search-refine" class="hidden-md hidden-lg">
  <button data-target="#search-facets" data-toggle="collapse" type="button" class="btn btn-default btn-sm" style="margin:0 0 0 15px">
  <span class="glyphicon glyphicon-filter"></span> Refine
  </button>
  <hr>
  </div>
  <div id="search-facets" class="col-md-3 hidden-print collapse in">
  <h2 class="sr-only">Refine</h2>
  <@s.Facet>
    <@s.FacetLabel tag="h3"/>
    <div class="panel-body">
      <ul class="list-unstyled">
        <@s.Category tag="li">
        <@s.CategoryName class="" />&nbsp;<small class="text-muted">(<@s.CategoryCount />)</small>
        </@s.Category>
      </ul>
      <button type="button" class="btn btn-search-toggle-more-categories" style="display: none;" data-more="More&hellip;" data-less="Less&hellip;" data-state="more" title="Show more categories from this facet"><small class="glyphicon glyphicon-plus"></small>&nbsp;<span>More&hellip;</span></button>
    </div>
    </@s.Facet>
  </div>
  </@s.FacetedSearch>
</#macro>

<#macro NavBar>
  <nav class="navbar navbar-default row" role="navigation" style="padding-bottom: 6px;">
    <h1 class="sr-only">Search</h1>
    <div id="search-branding" class="col-xs-5 col-md-3 clearfix"><a href="#"><img src="${SearchPrefix}images/funnelback-logo-small.png" alt="Funnelback" style="height:20px; margin-top:15px"></a></div>
    <div class="col-xs-7 col-md-4 pull-right">
      <div class="btn-group btn-group-sm pull-right" style="margin-top:10px">
        <a href="#search-advanced" class="btn btn-default" data-toggle="collapse" title="Advanced search"><span class="glyphicon glyphicon-cog"></span> <span class="visible-md-inline visible-lg-inline">Advanced Search</span></a>
        
        <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
        <a href="#" class="btn btn-default" data-ng-class="{active: isDisplayed('history')}" data-ng-click="toggleHistory()" title="Search History"><span class="glyphicon glyphicon-time"></span></a>
        </#if>
        <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
        <a href="#" class="btn btn-default" data-ng-class="{active: isDisplayed('cart')}" data-ng-click="toggleCart()" title="{{cart.length}} item(s) in your selection"><span class="glyphicon glyphicon-shopping-cart"></span> <span class="badge" data-ng-cloak>{{cart.length}}</ng-pluralize --></span></a>
        </#if>
        
        <div class="btn-group btn-group-sm dropdown pull-right">
          <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
          <span class="glyphicon glyphicon-question-sign"></span>
          <span class="caret hidden-xs"></span>
          </button>
          <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
            <li role="presentation"><a role="menuitem" tabindex="-1" href="${SearchPrefix}help/simple_search.html" title="Search help">Help</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" data-toggle="modal" href="#search-performance" title="Performance report">Performance</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" data-toggle="modal" href="#search-syntaxtree" title="Query syntax tree">Query syntax tree</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div id="search-form-query" class="col-xs-12 col-md-5">
      <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="search" style="margin-top:8px;">
        <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
        <@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="lang"><input type="hidden" name="lang" value="${question.inputParameterMap["lang"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@s.IfDefCGI>
        <div class="input-group" style="margin-bottom:5px">
          <input required name="query" id="query" title="Search query" type="text" value="${question.inputParameterMap["query"]!}" accesskey="q" placeholder="Search <@s.cfg>service_name</@s.cfg>&hellip;" class="form-control query" data-ng-disabled="isDisplayed('cart') || isDisplayed('history')">
          <span class="input-group-btn">
          <button type="submit" class="btn btn-primary" data-ng-disabled="isDisplayed('cart') || isDisplayed('history')"><span class="glyphicon glyphicon-search"></span> <span class="visible-sm-inline visible-md-inline visible-lg-inline">Search</span></button></span>
        </div>
        <div class="input-inline">
          <@s.FacetScope> <small>Within selected categories only</small></@s.FacetScope>
        </div>
      </form>
    </div>
  </nav>
</#macro>

<#macro AdvancedForm>
  <section id="search-advanced" class="well row collapse <@s.IfDefCGI name="from-advanced">in</@s.IfDefCGI>">
  <h2 class="sr-only">Advanced Search</h2>
  <div class="row">
    <div class="col-md-12">
      <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="form" class="form-horizontal">
        <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
        <input type="hidden" name="from-advanced" value="true">
        <input type="hidden" name="facetScope" value="<@s.FacetScope input=false />">
        <@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@s.IfDefCGI>
        <div class="row">
          <div class="col-md-4">
            <fieldset>
              <legend>Contents</legend>
              <div class="form-group">
                <label class="col-md-4 control-label" for="query-advanced">Any</label>
                <div class="col-md-8">
                  <input type="text" id="query-advanced" name="query" value="${question.inputParameterMap["query"]!}" class="form-control input-sm" placeholder="e.g. juliet where thou love">
                </div>
              </div>
              <div class="form-group">
                <label for="query_and" class="col-md-4 control-label">All</label>
                <div class="col-md-8">
                  <input type="text" id="query_and" name="query_and" value="${question.inputParameterMap["query_and"]!}" class="form-control input-sm" placeholder="e.g. juliet where thou love">
                </div>
              </div>
              <div class="form-group">
                <label for="query_phrase" class="col-md-4 control-label">Phrase</label>
                <div class="col-md-8">
                  <input type="text" id="query_phrase" name="query_phrase" value="${question.inputParameterMap["query_phrase"]!}" class="form-control input-sm" placeholder="e.g. to be or not to be">
                </div>
              </div>
              <div class="form-group">
                <label for="query_not" class="col-md-4 control-label">Not</label>
                <div class="col-md-8">
                  <input type="text" id="query_not" name="query_not" value="${question.inputParameterMap["query_not"]!}" class="form-control input-sm" placeholder="e.g. brutus othello">
                </div>
              </div>
            </fieldset>
          </div>
          <div class="col-md-4">
            <fieldset>
              <legend>Metadata</legend>
              <div class="form-group">
                <label for="meta_t" class="col-md-4 control-label">Title</label>
                <div class="col-md-8">
                  <input type="text" id="meta_t" name="meta_t" placeholder="e.g. A Midsummer Night's Dream" value="${question.inputParameterMap["meta_t"]!}" class="form-control input-sm">
                </div>
              </div>
              <div class="form-group">
                <label for="meta_a" class="col-md-4 control-label">Author</label>
                <div class="col-md-8">
                  <input type="text" id="meta_a" name="meta_a" placeholder="e.g. William Shakespeare" value="${question.inputParameterMap["meta_a"]!}" class="form-control input-sm">
                </div>
              </div>
              <div class="form-group">
                <label for="meta_s" class="col-md-4 control-label">Subject</label>
                <div class="col-md-8">
                  <input type="text" id="meta_s" name="meta_s" placeholder="e.g. comedy" value="${question.inputParameterMap["meta_s"]!}" class="form-control input-sm">
                </div>
              </div>
              <div class="form-group">
                <label class="control-label col-md-4" for="meta_f_sand">Format</label>
                <div class="col-md-8">
                  <@s.Select name="meta_f_sand" id="meta_f_sand" options=["=Any ", "pdf=PDF  (.pdf) ", "xls=Excel (.xls) ", "ppt=Powerpoint (.ppt) ", "rtf=Rich Text (.rtf) ", "doc=Word (.doc) ", "docx=Word 2007+ (.docx) "] class="form-control input-sm"/>
                </div>
              </div>
            </fieldset>
          </div>
          <div class="col-md-4">
            <fieldset>
              <legend>Published</legend>
              <div class="form-group">
                <label class="control-label col-md-4">After</label>
                <label class="sr-only" for="meta_d1year">Year</label>
                <@s.Select id="meta_d1year" name="meta_d1year" id="meta_d1year" options=["=Year"] range="CURRENT_YEAR - 20..CURRENT_YEAR" class="input-sm" />
                <label class="sr-only" for="meta_d1month">Month</label>
                <@s.Select id="meta_d1month" name="meta_d1month" options=["=Month", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"] class="input-sm" />
                <label class="sr-only" for="meta_d1day">Day</label>
                <@s.Select id="meta_d1day" name="meta_d1day" options=["=Day"] range="1..31" class="input-sm"/>
              </div>
              
              <div class="form-group">
                <label class="control-label col-md-4">Before</label>
                <label class="sr-only" for="meta_d2year">Year</label>
                <@s.Select id="meta_d2year" name="meta_d2year"  options=["=Year"] range="CURRENT_YEAR - 20..CURRENT_YEAR + 1" class="input-sm" />
                <label class="sr-only" for="meta_d2month">Month</label>
                <@s.Select id="meta_d2month" name="meta_d2month" options=["=Month", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"] class="input-sm" />
                <label class="sr-only" for="meta_d2day">Day</label>
                <@s.Select id="meta_d2day" name="meta_d2day" options=["=Day"] range="1..31" class="input-sm" />
              </div>
            </fieldset>
          </div>
        </div>
        <div class="row">
          <div class="col-md-4">
            <fieldset>
              <legend>Display</legend>
              <div class="form-group">
                <label class="control-label col-md-4" for="sort">Sort</label>
                <div class="col-md-8">
                  <@s.Select id="sort" name="sort" class="form-control" options=["=Relevance ", "date=Date (Newest first)", "adate=Date (Oldest first)", "title=Title (A-Z)", "dtitle=Title (Z-A)", "prox=Distance" "url=URL (A-Z)", "durl=URL (Z-A)", "shuffle=Shuffle"] />
                </div>
              </div>
              <div class="form-group">
                <label class="control-label col-md-4" for="num_ranks">Results</label>
                <div class="col-md-8">
                  <div class="input-group">
                    <input type="number" min="1" id="num_ranks" name="num_ranks" placeholder="e.g. 10" value="${question.inputParameterMap["num_ranks"]!10}" class="form-control input-sm">
                    <span class="input-group-addon">per page</span>
                  </div>
                </div>
              </div>
            </fieldset>
          </div>
          <div class="col-md-4">
            <fieldset>
              <legend>Located</legend>
              <div class="form-group">
                <label class="control-label col-md-4" for="origin">Origin</label>
                <div class="col-md-8">
                  <div class="input-group">
                    <span class="input-group-btn"><a class="btn btn-info search-geolocation btn-sm" title="Locate me!" ><span class="glyphicon glyphicon-map-marker"></span></a></span>
                    <input type="text" id="origin" name="origin" pattern="-?[0-9\.]+,-?[0-9\.]+" title="Latitude,longitude" placeholder="Latitude, Longitude" value="${question.inputParameterMap["origin"]!}" class="form-control input-sm">
                  </div>
                </div>
              </div>
              <div class="form-group">
                <label class="control-label col-md-4" for="maxdist">Distance</label>
                <div class="col-md-8">
                  <div class="input-group">
                    <input type="number" min="0" id="maxdist" name="maxdist" placeholder="e.g. 10" value="${question.inputParameterMap["maxdist"]!}" class="form-control input-sm">
                    <span class="input-group-addon">km</span>
                  </div>
                </div>
              </div>
            </fieldset>
          </div>
          <div class="col-md-4">
            <fieldset>
              <legend>Within</legend>
              <div class="form-group">
                <label class="control-label col-md-4" for="scope">Domain</label>
                <div class="col-md-8">
                  <input type="text" id="scope" name="scope" placeholder="e.g. example.com" value="${question.inputParameterMap["scope"]!}" class="form-control input-sm">
                </div>
              </div>
              <div class="form-group">
                <label class="control-label col-md-4" for="meta_v">Path</label>
                <div class="col-md-8">
                  <input type="text" id="meta_v" name="meta_v" placeholder="e.g. /plays/romeo-juliet" value="${question.inputParameterMap["meta_v"]!}" class="form-control input-sm">
                </div>
              </div>
            </fieldset>
            
          </div>
        </div>
        <hr>
        <div class="row">
          <div class="col-md-12">
            <div class="pull-right">
              <button type="button" data-toggle="collapse" data-target="#search-advanced" class="btn btn-link">Cancel</button>
              <button class="btn btn-primary" type="submit"><span class="glyphicon glyphicon-search"></span> Advanced Search</button>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
  </section>
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
