<#ftl encoding="utf-8" />

<#--
   Funnelback App: Careers
   By: Prathima Chandra
   Description: <Description>
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

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
      <a href="http://funnelback.com/"><img src="${image}" alt="Funnelback logo"></a>
      <br><br>
      <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="search">
        <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
        <@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="lang"><input type="hidden" name="lang" value="${question.inputParameterMap["lang"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@s.IfDefCGI>
        <div class="input-group">
          <input required name="query" id="query" title="Search query" type="text" value="${question.inputParameterMap["query"]!}" accesskey="q" placeholder="Search <@s.cfg>service_name</@s.cfg>&hellip;" class="form-control input-lg query">
          <div class="input-group-btn">
            <button type="submit" class="btn btn-primary input-lg"><span class="glyphicon glyphicon-search"></span> Search</button>
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
      
      <a href="${s.result.metaData["a"]?html}" title="${s.result.liveUrl}">
        <@s.boldicize><@s.Truncate length=70>${s.result.title}</@s.Truncate></@s.boldicize>
      </a>&nbsp;
      <#if question.collection.configuration.valueAsBoolean("ui.modern.session")><a href="#" data-ng-click="toggle()" data-toggle="tooltip" data-placement="left" title="Save this Job?" data-cart-link data-css="pushpin|remove" title="{{label}}"><small class="glyphicon glyphicon-{{css}}"></small></a></#if>


      <span class="pull-right date-posted">
       <small><span class="visible-print text-">Posted:</span>  <strong data-toggle="tooltip" data-placement="left" title="Date Posted">${s.result.metaData["p"]}</strong></small> 
      </span>

      <#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(s.result.indexUrl)??><small class="text-warning"><span class="glyphicon glyphicon-time"></span> <a title="Click history" href="#" class="text-warning" data-ng-click="toggleHistory()">Last visited ${prettyTime(session.getClickHistory(s.result.indexUrl).clickDate)}</a></small></#if>
      </h4>
      <#if s.result.metaData["d"]?? >
      <span class="search-summary"><@s.boldicize><#noescape>${s.result.metaData["d"]?html}</#noescape></@s.boldicize></span>
      </#if>
      <div class="search-details clearfix">
       <span class="pull-left">
        <small>
          <span class="glyphicon glyphicon-map-marker"></span><b class="visible-print">Location:</b> ${s.result.metaData["l"]!?replace("|", ", ")}</span> 
          &nbsp; &bull; &nbsp;<span class="glyphicon glyphicon-time"></span> <b class="visible-print">Type:</b> ${s.result.metaData["f"]!?replace("|", ", ")}</span>
     </small>

    <div class="btn-group pull-right">
    <a href="#summarydata-${s.result.rank}" class="btn btn-xs btn-default" data-toggle="collapse" title="Show Details">&nbsp; View Details &nbsp;</a>
  
  <#if s.result.metaData["c"]??><a class="btn btn-xs btn-warning" style="display:inline" href="${s.result.metaData["c"]?html}" title="Apply Now"><strong>&nbsp; Apply Now &nbsp;</strong></a></#if>
</div>

</div>

       <section id="summarydata-${s.result.rank}" class="well row collapse summarydata">
       
      <#if s.result.metaData["d"]??>
      <p>
      
       <#if s.result.metaData["a"]?? || s.result.metaData["s"]?? || s.result.metaData["p"]??>
            <dl class="dl-horizontal text-muted">
        <#if s.result.metaData["r"]??><dt>Required Skills:</dt><dd>${s.result.metaData["r"]!?replace("|", ", ")}</dd></#if>
        <#if s.result.metaData["e"]??><dt>Required Experience:</dt><dd>${s.result.metaData["e"]!?replace("|", ", ")}</dd></#if>
        <#if s.result.metaData["f"]??><dt>Type:</dt><dd>${s.result.metaData["f"]!?replace("|", ", ")}</dd></#if>
        <#if s.result.metaData["j"]??><dt>Job Category:</dt><dd>${s.result.metaData["j"]!?replace("|", ", ")}</dd></#if>
        <#if s.result.metaData["l"]??><dt>Location:</dt><dd>${s.result.metaData["l"]!?replace("|", ", ")}</dd></#if>
        <#if s.result.metaData["s"]??><dt>Salary Range:</dt><dd>${s.result.metaData["s"]!?replace("|", ", ")}</dd></#if>
       </dl>
      </#if>
       <#if s.result.metaData["c"]??><dl class="dl-horizontal text-muted"><dt>Apply:</dt><dd>

       <a class="btn btn-md btn-warning" href="${s.result.metaData["c"]?html}">Apply Now</a>

     <p><small class="text-muted">(Applications Closing: ${s.result.metaData["q"]?html})</small></p>
     </dd></dl></#if>
      </p>
      </#if>
      
     
     </section>

  </li>
    
    </#if>
    </@s.Results>
  </ol>
</#macro>

<#macro AdvancedFormORIGINALFORREFERENCE>
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

<#macro Footer>
  <footer id="search-footer">
    <div class="row">
      
      <div class="col-xs-12">
        <hr>
        <p class="text-muted"><small>
        <#if (response.resultPacket.details.collectionUpdated)??>Collection last updated: ${response.resultPacket.details.collectionUpdated?datetime}.</#if>
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

<#macro SearchHistory>
    <section id="search-history" data-ng-cloak>
      <div>
        <h2><span class="glyphicon glyphicon-time"></span> History</h2>
          <div>
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
                  <li><a href="?${h.searchParams}">${h.queryAsProcessed?replace('|f:','')?replace('|l:','')?replace('|j:','')} <small>(${h.totalMatching})</small></a> &middot; <span class="text-warning">${prettyTime(h.searchDate)}</span></li>
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
    </section>
  
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
    <ul class="pagination pagination-sm">
      <@fb.Prev><li><a href="${fb.prevUrl}" rel="prev"><small><span class="glyphicon glyphicon-chevron-left"></span></small> Prev</a></li></@fb.Prev>
      <@fb.Page numPages=5><li <#if fb.pageCurrent> class="active"</#if>><a href="${fb.pageUrl}">${fb.pageNumber}</a></li></@fb.Page>
      <@fb.Next><li><a href="${fb.nextUrl}" rel="next">Next <small><span class="glyphicon glyphicon-chevron-right"></span></small></a></li></@fb.Next>
    </ul>
  </div>
</#macro>

<#macro Spelling>
  <@s.CheckSpelling prefix="<h3 id=\"search-spelling\"><span class=\"glyphicon glyphicon-question-sign text-muted\"></span> Did you mean <em>" suffix="</em>?</h3>" />
  
   <#-- applied facets block -->
          <#if question.selectedCategoryValues?has_content>
                <@fbf.ClearFacetsLink  class="btn btn-xs btn-danger"/>
                <@fbf.AppliedFacets class="btn btn-xs btn-warning" group=true/>
          </#if>

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
    <span id="search-total-matching">${response.resultPacket.resultsSummary.totalMatching?string.number}</span>
    <#if question.inputParameterMap["s"]?? && question.inputParameterMap["s"]?contains("?:")><em>collapsed</em> </#if>jobs matching your criteria
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

  
  <form style="float:right" action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="form">
        <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
        <input type="hidden" name="facetScope" value="<@s.FacetScope input=false />">
        <@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@s.IfDefCGI>
         <@s.IfDefCGI name="query"><input type="hidden" name="query" value="${question.inputParameterMap["query"]!}"></@s.IfDefCGI>
         <@s.IfDefCGI name="meta_f_sand"><input type="hidden" name="meta_f_sand" value="${question.inputParameterMap["meta_f_sand"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="meta_I_sand"><input type="hidden" name="meta_I_sand" value="${question.inputParameterMap["meta_I_sand"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="meta_j_sand"><input type="hidden" name="meta_j_sand" value="${question.inputParameterMap["meta_j_sand"]!}"></@s.IfDefCGI>
     
       
         <label class="control-label" for="sort">Sort &nbsp;</label>
               
                  <@s.Select id="sort" name="sort" onchange="this.form.submit()" options=["=Relevance ", "dmetap=Date Posted", "metal=Location", "title=Title (A-Z)", "dtitle=Title (Z-A)"] />
        
              
                </form>
  </div>
</#macro>
<#macro Cart>
    <section id="search-cart" data-ng-cloak data-ng-controller="CartCtrl">
       <ul class="list-unstyled">
            <li data-ng-repeat="item in cart">
              <hr>
              <h4>
                <button class="btn btn-danger btn-xs" title="Clear selection" data-ng-click="clear('Your selection will be cleared')"><span class="glyphicon glyphicon-remove"></span> Clear</button>
              
              <a href="{{item.metaData["p"]}}">{{item.title|truncate:70}}</a>
              </h4>
              <cite class="text-success">Posted Date: {{item.metaData["p"]}}</cite>
              <p>{{item.metaData["d"]}}</p>
              <a class="btn btn-xs btn-warning" title="Apply Now" href="{{item.metaData["c"]}}">Apply Now</a> <em><small class="text-muted"> - Applications close: {{item.metaData["q"]}}</small></em>
              
            </li>
          </ul>
       </section>
 </#macro>
<#macro Scopes>
  <#if question.inputParameterMap["scope"]!?length != 0>
    <div class="breadcrumb">
      <span class="text-muted"><span class="glyphicon glyphicon-resize-small"></span> Scope:</span> <@s.Truncate length=80>${question.inputParameterMap["scope"]!}</@s.Truncate>
      <a class="button btn-xs" title="Remove scope: ${question.inputParameterMap["scope"]!}" href="?collection=${question.inputParameterMap["collection"]!}<#if question.inputParameterMap["form"]??>&amp;form=${question.inputParameterMap["form"]!}</#if>&amp;query=<@s.URLEncode><@s.QueryClean /></@s.URLEncode>"><span class="glyphicon glyphicon-remove text-muted"></span></a>
    </div>
  </#if>
</#macro>


<#macro Facets>

     <@fbf.FacetedSearch>
        <div class="col-md-3 col-lg-2 hidden-print" id="search-facets">
          <h2 class="sr-only">Refine</h2>
            <@fbf.Facet checkbox=true  checkboxMode="form">
            <div class="panel panel-default">
              <div class="panel-heading"><@fbf.FacetLabel tag="h3" summary=false/></div>
              <div class="panel-body">
               <@fbf.CheckboxForm>
                <ul class="list-unstyled">
                  <li><@fbf.ResetFacetLink/></li>
                  <@fbf.Category tag="li" class="dfgg">
                    <@fbf.CategoryName class="XX" />&nbsp;<span class="badge pull-right"><@fbf.CategoryCount /></span>
                  </@fbf.Category>
                </ul>
                <button type="button" class="btn btn-link btn-sm search-toggle-more-categories" style="display: none;" data-more="More&hellip;" data-less="Less&hellip;"
 data-state="more" title="Show more categories from this facet"><small class="glyphicon glyphicon-plus"></small>&nbsp;<span>More&hellip;</span></button>
 </@fbf.CheckboxForm>
              </div>
            </div>
          </@fbf.Facet>
        </div>
      </@fbf.FacetedSearch>

</#macro>

<#macro NavBar>
  <nav class="navbar navbar-default navbar-top row" role="navigation">
    <h1 class="sr-only">Search</h1>
   
<div id="search-nav-top" class="clearfix">

  <div id="search-branding" class="pull-left clearfix"><a href="#"><img src="${SearchPrefix}images/funnelback-logo-small.png" alt="Funnelback" style="height:20px; margin-top:15px"></a></div>


<div class="pull-right">
      <div class="btn-group btn-group-sm pull-right" style="margin-top:10px">
        <a href="#search-advanced" class="btn btn-default" data-toggle="collapse" title="Advanced search"><span class="glyphicon glyphicon-cog"></span> <span class="visible-md-inline visible-lg-inline">Advanced Search</span></a>
        
       
      
         <div class="btn-group btn-group-sm dropdown pull-right">
          <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
          <span class="glyphicon glyphicon-question-sign"></span>
         
          </button>
          <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
            <li role="presentation"><a role="menuitem" tabindex="-1" href="${SearchPrefix}help/simple_search.html" title="Search help">Help</a></li>
          </ul>
        </div>
      </div>
    </div>

</div>

    

    <div id="search-form-query">
      <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="search">
        

        <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
        <@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="lang"><input type="hidden" name="lang" value="${question.inputParameterMap["lang"]!}"></@s.IfDefCGI>
        <@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@s.IfDefCGI>
        
        <div class="clearfix">
        
        <div class="col-sm-4 form-group">
        <label for="query">Keywords</label>
        <input name="query" id="query" title="Search query" type="text" value="${question.inputParameterMap["query"]!}" accesskey="q" placeholder="Search Keywords" class="form-control query">
        
        <div class="checkbox-inline check-select-cats">
          <@fbf.FacetScope> Within selected categories only</@fbf.FacetScope>
        </div>

        </div>  
 

       <div class="col-sm-4 form-group">
        <label for="meta_j_sand">Category</label>
 <@s.Select name="meta_j_sand" options=["=Any ", "Finance", "Human Resources", "Production", "Research & Development", "Sales"] class="form-control input-sm"/>    </div>


      <div class="col-sm-4 form-group">
       <label for="meta_l_sand">Location</label>
         <@s.Select name="meta_l_sand" options=["=Any", "Brisbane","Canberra","Melbourne","Sydney","London"] class="form-control input-sm"/>

         <button type="submit" class="btn btn-sm btn-primary" data-ng-disabled="isDisplayed('cart') || isDisplayed('history')"><span class="glyphicon glyphicon-search"></span> <span>Search</span></button>
         
      </div>

        

      </form>
    </div>
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
                <label class="col-md-2 control-label" for="query-advanced">Any</label>
                <div class="col-md-7">
                  <input type="text" id="query-advanced" name="query" value="${question.inputParameterMap["query"]!}" class="input-sm" placeholder="e.g. juliet where thou love">
                </div>
              </div>
              <div class="form-group">
                <label for="query_and" class="col-md-2 control-label">All</label>
                <div class="col-md-7">
                  <input type="text" id="query_and" name="query_and" value="${question.inputParameterMap["query_and"]!}" class="input-sm" placeholder="e.g. juliet where thou love">
                </div>
              </div>
              <div class="form-group">
                <label for="query_phrase" class="col-md-2 control-label">Phrase</label>
                <div class="col-md-7">
                  <input type="text" id="query_phrase" name="query_phrase" value="${question.inputParameterMap["query_phrase"]!}" class="input-sm" placeholder="e.g. to be or not to be">
                </div>
              </div>
              <div class="form-group">
                <label for="query_not" class="col-md-2 control-label">Not</label>
                <div class="col-md-7">
                  <input type="text" id="query_not" name="query_not" value="${question.inputParameterMap["query_not"]!}" class="input-sm" placeholder="e.g. brutus othello">
                </div>
              </div>
            </fieldset>
          </div>
          <div class="col-md-4">
            <fieldset>
            <legend>Metadata</legend>
              <div class="form-group">        
                    <label class="control-label col-md-2" for="meta_f_sand">Job Type</label>
                    <div class="col-md-7">
                      <@s.Select name="meta_f_sand" id="meta_f_sand" options=["=Any ", "Full Time ", "Part Time", "Contract"] class="input-sm"/>
                    </div>
                  </div>    			                	

            <div class="form-group">        
                    <label class="control-label col-md-2" for="meta_l_sand">Location</label>
                    <div class="col-md-7">
                       <@s.Select name="meta_l_sand" options=["=Any", "Brisbane","Canberra","Melbourne","Sydney","London"] class="input-sm"/>
                    </div>
                  </div>
             
             
             <div class="form-group">        
                    <label class="control-label col-md-2" for="meta_j_sand">Category</label>
                    <div class="col-md-7">
                       <@s.Select name="meta_j_sand" options=["=Any ", "Finance", "Human Resources", "Production", "Research & Development", "Sales"] class="input-sm"/>
                    </div>
                  </div>
             
            </fieldset>
          </div>
          <div class="col-md-4">
            <fieldset>
              <legend>Posted</legend>
              <div class="form-group">
                <label class="control-label col-md-2">After</label>
                <label class="sr-only" for="meta_d1year">Year</label>
                <@s.Select id="meta_d1year" name="meta_d1year" id="meta_d1year" options=["=Year"] range="CURRENT_YEAR - 20..CURRENT_YEAR" class="input-sm" />
                <label class="sr-only" for="meta_d1month">Month</label>
                <@s.Select id="meta_d1month" name="meta_d1month" options=["=Month", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"] class="input-sm" />
                <label class="sr-only" for="meta_d1day">Day</label>
                <@s.Select id="meta_d1day" name="meta_d1day" options=["=Day"] range="1..31" class="input-sm"/>
              </div>
              
              <div class="form-group">
                <label class="control-label col-md-2">Before</label>
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
          <div class="col-md-2">
            <fieldset>
              <legend>Display</legend>
               <div class="form-group">
                <label class="control-label col-md-2" for="num_ranks">Results</label>
                <div class="col-md-7">
                  <div class="input-group">
                    <input type="number" min="1" id="num_ranks" name="num_ranks" placeholder="e.g. 10" value="${question.inputParameterMap["num_ranks"]!10}" class="input-sm">
                    <span class="input-group-addon">per page</span>
                  </div>
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
<#macro jsDefault>
  <script src="${SearchPrefix}js/jquery/jquery-1.10.2.min.js"></script>
  <script src="${SearchPrefix}js/jquery/jquery-ui-1.10.3.custom.min.js"></script>
  <script src="${SearchPrefix}thirdparty/bootstrap-3.0.0/js/bootstrap.min.js"></script>
  <script src="${SearchPrefix}js/jquery/jquery.tmpl.min.js"></script>
  <script src="${SearchPrefix}js/jquery.funnelback-completion.js"></script>
  <script src="/s/resources/searchapp-careers/funnelback-faceted-navigation.js"></script>
  
  <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
    <script src="${SearchPrefix}thirdparty/angular-1.0.7/angular.js"></script>
    <script src="${SearchPrefix}thirdparty/angular-1.0.7/angular-resource.js"></script>
    <script src="${SearchPrefix}js/funnelback-session.js"></script>
  </#if>
</#macro>

</#escape>
