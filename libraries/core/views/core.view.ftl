<#ftl encoding="utf-8" />
<#---
	Contains the presentation component of the vanilla simple.ftl.

	<p>
		It aims to represent the <em> view </em> aspect of Model-View-Control
	</p>

	<h2>Table of Contents</h2>
	<ul>
		<li><strong>Configuration:</strong> Configuration options for Base Stencil.</li>
		<li><strong>General:</strong> General search helpers.</li>
		<li><strong>Search forms:</strong> Advanced search form, simple search form ....</li>
		<li><strong>Sessions:</strong> Favorites/Cart, search history.</li>
		<li><strong>Facets:</strong> Faceted navigation, search breadcrumbs, spelling suggestions</li>
		<li><strong>Result features:</strong> Search view selectors/formaters, best bets, contextual navigation.</li>
		<li><strong>Results:</strong> Results wrapper views </li>
		<li><strong>Result:</strong> Result views e.g. panels ...</li>
	</ul>
-->

<#escape x as x?html>
<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign coreResourcesPrefix = "/stencils/resources/core/v14.2.0/" >
<#assign baseResourcesPrefix = "/stencils/resources/base/v14.2.0/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#-- Import Utilities - Functions used to conveniently load related Stencil libraries -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller - Import the controller relating to this Stencil -->
<#import "${librariesPrefix}core/controllers/core.controller.ftl" as core_controller/>

<#-- Import Stencils -->
<#assign stencils=["base"] />

<#--
	The following code imports and assigns stencil namespaces
	automatically eg. core_view and core_controller. The code
	expects that the controller files are located under
	$SEARCH_HOME/share/stencils/libraries/
	and the view files located under
	$SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
-->
<@stencils_utilities.ImportStencils stencils=stencils>
	<@stencils_utilities.imports?interpret />
</@stencils_utilities.ImportStencils>

<#---
	Prints the markup to include the CSS dependencies suggested by this stencil.
 -->
<#macro CSS>
	<!-- core.view.ftl.view.ftl :: CSS -->
	<link rel="stylesheet" href="${coreResourcesPrefix}css/core.css">
</#macro>

<#---
	Prints the markup to include the JavaScript dependencies suggested by this Stencil.
 -->
<#macro JS>
	<!-- core.view.ftl.view.ftl :: JS -->
	<script src="${GlobalResourcesPrefix}js/jquery/jquery-1.10.2.min.js"></script>
	<script src="${GlobalResourcesPrefix}js/jquery/jquery-ui-1.10.3.custom.min.js"></script>
	<script src="${GlobalResourcesPrefix}js/jquery/jquery.tmpl.min.js"></script>
	<script src="${GlobalResourcesPrefix}js/jquery.funnelback-completion.js"></script>
	<#--
		Include the required session scripts only if they have been specified
		in the collection.cfg
	-->``
	<#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
		<#-- <script src="${thirdPartyResourcesPrefix}angularjs/1.4.7/angular.min.js"></script> -->
		<script src="${GlobalResourcesPrefix}thirdparty/angular-1.0.7/angular.js"></script>
		<script src="${GlobalResourcesPrefix}thirdparty/angular-1.0.7/angular-resource.js"></script>
		<script src="${GlobalResourcesPrefix}js/funnelback-session.js"></script>
	</#if>

	<script src="${coreResourcesPrefix}js/core.js"></script>
</#macro>
<#-- @end Configuration -->
<#-- ################### Views ####################### -->

<#-- ###  General ### -->
<#---
	Prints the title of the search page based on the collection, site and query.

	@param siteName The name of the site which is owns the search implementation
	@param collectionName The collection name that is being called
	@param query The query that has been entered by the user
-->
<#macro pageTitle siteName collectionName query>
	<!-- core.controller.ftl :: pageTitle -->
	<#compress>
		<title>
			<#if query??> ${query}</#if>
			<#if collectionName??>,&nbsp; ${collectionName}</#if>
			<#if sitename??>- ${sitename}</#if>
		</title>
	</#compress>
</#macro>

<#macro element type="div" id="" class="" custom="">
<${type} <#if id?? && id?has_content>id="${id}"</#if><#if class?? && class?has_content> class="${class}"</#if>${custom!}><#compress>
<#nested>
</#compress><#if type!="area" && type!="base" && type!="br" && type!="col" && type!="command" && type!="embed" && type!="hr" && type!="img" && type!="input" && type!="link" && type!="meta" && type!="param" && type!="source"></${type}></#if>
</#macro>

<#---
	Displays any padre or system errors to the user.
-->
<#macro ErrorMessage>
	<!-- core.view.ftl :: ErrorMessage -->
	<@core_controller.Error>
		<div class="alert alert-danger">
			<#-- Display the padre errors if any are found -->
			<@core_controller.ErrorPadre>
				<!-- PADRE return code: [<@core_controller.ErrorPadreCode />], admin message: <@core_controller.ErrorPadreAdminMessage /> -->
				<p class="search-error">
					<@core_controller.ErrorPadreMessage />
				</p>
			</@core_controller.ErrorPadre>

			<#-- Display any other errors if any are found -->
			<@core_controller.ErrorOther>
				<!-- ERROR status: <@core_controller.ErrorOtherReason /> -->
				<!-- ERROR cause: <@core_controller.ErrorOtherCause /> -->
				<p class="search-error">
					<@core_controller.ErrorOtherAdditionalMessage />
				</p>
			</@core_controller.ErrorOther>

			<#-- Placeholder for the default message. It will only display if no other messages are available -->
			<@core_controller.ErrorDefaultMessage showAlways=true>
				An unkown error has occured. Please try again in a few minutes.
			</@core_controller.ErrorDefaultMessage>

		</div>
		<br><br>
	</@core_controller.Error>
</#macro>

<#---
	Displays the time taken by each step of the query processing life cycle.
 -->
<#macro ToolsPerformance>
	<!-- core.controller.ftl :: ToolsPerformance -->
	<div id="search-performance" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button class="close" data-dismiss="modal" data-target="#search-performance">&times;</button>
					<h3>${(response.translations.CORE_TOOLS_PERFORMANCE_TITLE)!"Performance"}</h3>
				</div>
				<div class="modal-body">
					<@PerformanceMetrics class="search-metrics table-striped table table-condensed" tdClass="progress-bar progress-bar-info" width=200 title=""/>
				</div>
			</div>
		</div>
	</div>
</#macro>

<#---
	Displays the syntax tree which describes how the query has
	been interpreted by Funnelback.
-->
<#macro ToolsSyntaxTree>
	<!-- core.controller.ftl :: ToolsSyntaxTree -->
	<div id="search-syntaxtree" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button class="close" data-dismiss="modal" data-target="#search-syntaxtree">&times;</button>
					<h3>${(response.translations.CORE_TOOLS_QUERY_SYNTAX_TITLE)!"Query syntax tree"}</h3>
				</div>
				<div class="modal-body">
					<#-- Display the syntax tree if it exists -->
					<@core_controller.HasSyntaxTree>
						<@core_controller.SyntaxTreeSvgs />
					</@core_controller.HasSyntaxTree>

					<#-- Display an info tip if syntax tree has not been enabled -->
					<@core_controller.HasSyntaxTree negate=true>
						<div class="alert alert-warning">
							${(response.translations.CORE_TOOLS_QUERY_SYNTAX_ERROR_MSG)!"Query syntax tree unavailable. Make sure the <code>-show_qsyntax_tree=on</code> query processor option is set."}
						</div>
					</@core_controller.HasSyntaxTree>
				</div>
			</div>
		</div>
	</div>
</#macro>

<!---
	Grouping the search tools into one macro for modularity
-->
<#macro Tools>
	<!-- core.controller.ftl :: Tools -->
	<section id="search-tools" class="hidden-print">
		<h2 class="sr-only">${(response.translations.CORE_TOOLS_TITLE)!"Tools"}</h2>
		<@ToolsPerformance />
		<@ToolsSyntaxTree />
	</section>
</#macro>

<#---
	Displays basic footer information which typically appears at the bottom of search implementations
-->
<#macro Footer>
	<!-- core.controller.ftl :: Footer -->
	<footer id="search-footer">
		<div class="row">
			<div class="col-xs-12 col-md-3 mw-3"></div>
			<div class="col-xs-12 col-md-9">
				<hr>
				<#if (response.resultPacket.details.collectionUpdated)??>
					<span class="pull-left">
						<p class="text-muted">
							<small>
								${(response.translations.CORE_FOOTER_COLLECTION_LAST_UPDATED_PREFIX)!"Collection last updated"}: ${response.resultPacket.details.collectionUpdated?datetime}.<br>
							</small>
						</p>
					</span>
				</#if>
				<span class="pull-right">
					<a href="https://funnelback.com/">
						<img src="${baseResourcesPrefix}images/funnelback-powered_by_logo-white.png"
							alt="${(response.translations.CORE_FORMS_FUNNELBACK_LOGO_MSG)!'Funnelback logo'}"
							title="${(response.translations.CORE_FOOTER_FUNNELBACK_LOGO_TITLE)!'Search like you’ve never seen it.'}"
						>
					</a>
				</span>

			</div>
		</div>
	</footer>
</#macro>

<#---
	Displays the preview / live banner.

	<p>
		Displays the banner to switch between live and preview mode
		for the current form. Use <code>AdminUIOnly</code> to display it
		only from the Admin UI service.
	</p>
-->
<#macro ViewModeBanner>
	<!-- core.view.ftl :: ViewModeBanner -->
	<@core_controller.AdminUIOnly>
		<#local style="padding: 5px; font-family: Verdana; text-align: right; border: solid 2px #aaa; font-size: small;" />
		<#local returnTo=ContextPath+"/"+question.collection.configuration.value("ui.modern.search_link")+"?"+QueryString />
		<#if question.profile?ends_with("_preview")>
			<div id="funnelback_form_mode" style="background-color: lightblue; ${style}">
				<span id="publish_link"></span>
				&middot; <a href="${SearchPrefix}admin/edit-form.cgi?collection=${question.collection.id}&amp;profile=${question.profile}&amp;f=${question.form}.ftl&amp;return_to=${returnTo?url}" title="Edit this form">edit form</a>
				&middot; <a href="?${changeParam(QueryString, 'profile', question.profile?replace("_preview", ""))?html}" title="View this search with the current live form">switch to live mode</a>
				| <span title="This form file may be edited before publishing to external search users">preview mode</span>
			</div>
			<script type="text/javascript">
				function loadPublishLink() {
					jQuery(function() {
						jQuery("#publish_link").load("${SearchPrefix}admin/ajax_publish_link.cgi?collection=${question.collection.id}&amp;dir=profile-folder-${question.profile}&amp;f=${question.form}.ftl&amp;mode=publish&amp;return_to=${returnTo?url}");
					});
				}

				if (typeof jQuery === 'undefined') {

					// We need to load jQuery first.
					// Slam a script tag into the head. Based on
					// http://stackoverflow.com/questions/4523263#4523417

					var head=document.getElementsByTagName('head')[0];
					var script= document.createElement('script');
					script.type= 'text/javascript';
					script.onreadystatechange = function () {
						if (this.readyState == 'complete' || this.readyState == 'loaded') {
							loadPublishLink();
						}
					}
					script.onload = loadPublishLink;
					script.src = "${GlobalResourcesPrefix}js/jquery/jquery-1.10.2.min.js";
					head.appendChild(script);
				} else {
					loadPublishLink();
				}
			</script>
		<#else>
			<div id="funnelback_form_mode" style="background-color: lightgreen; ${style}">
				<a href="?${changeParam(QueryString, 'profile', question.profile+'_preview')?url}" title="View this search with the current preview form">switch to preview mode</a>
				| <span title="This form file is currently published for external search users">live mode</span>
			</div>
		</#if>
	</@core_controller.AdminUIOnly>
</#macro>

<#---
	Displays a table with the time taken by each step in the query lifecycle.

	@param width Width in pixels to use for the bar graphs
	@msLabel Label to use for &quot;milliseconds&quot;
	@totalLabel Label to use for the &quot;Total&quot; summary row
	@jsOnly Do not display the metrics, only output the processing time in the JS console.
-->
<#macro PerformanceMetrics width=500 msLabel="ms" totalLabel="Total" jsOnly=false class="search-metrics" tdClass="" title="<h3>${(response.translations.CORE_TOOLS_PERFORMANCE_TITLE)!'Performance'}</h3>">
	<!-- coreview :: PerformanceMetrics -->
	<#if response?? && response.performanceMetrics??>
		${response.performanceMetrics.stop()}
		<script type="text/javascript">
			try {
				console.log("Query processing time: ${response.performanceMetrics.totalTimeMillis} ${msLabel}");
			}
			catch (ex) {
			}
		</script>
		<#if ! jsOnly>
			<#assign scale= width / response.performanceMetrics.totalTimeMillis />
			<#assign offset=0 />

			${title}

			<table class="${class}">
				<thead>
					<tr>
						<th>Component</th>
						<th>Time</th>
						<th>Chart</th>
					</tr>
				</thead>
				<tbody>
					<#list response.performanceMetrics.taskInfo as ti>
						<#assign timeTaken = ti.timeMillis * scale />
						<#assign kv = (ti.taskName!":")?split(":") />
						<#assign valueClass=kv[0]! />
						<#assign name=kv[1]! />
						<tr>
							<td>${name}</td>
							<td>${ti.timeMillis!} ${msLabel}</td>
							<td><div class="metric ${tdClass} ${valueClass}" style="width: ${timeTaken?round}px; margin-left: ${offset}px;">&nbsp;</div></td>
						</tr>
						<#assign offset = offset+(timeTaken) />
					</#list>
						<tr>
							<th>${totalLabel}</th>
							<th colspan="2">${response.performanceMetrics.totalTimeMillis} ${msLabel}</th>
						</tr>
				</tbody>
			</table>
		</#if>
	</#if>
</#macro>

<#-- ###  Search Forms ### -->
<#---
	The initial search form is the first html form which is
	displayed to the user before any query has been entered.
-->
<#macro InitialSearchForm>
	<!-- core.view.ftl :: InitialSearchForm -->
	<div class="row search-initial">
		<div class="col-md-6 col-md-offset-3 text-center">

			<#-- Display any padre or system errors returned by Funnelback -->
			<@ErrorMessage />

			<a href="http://funnelback.com/"><img src="${baseResourcesPrefix}images/funnelback-logo-small-v2.png" alt="${(response.translations.CORE_FORMS_FUNNELBACK_LOGO_MSG)!'Funnelback logo'}"></a>
			<br><br>

			<#-- Display the search form used to conduct the query against Funnelback -->
			<form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="search">
				<input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
				<@core_controller.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@core_controller.IfDefCGI>
				<@core_controller.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@core_controller.IfDefCGI>
				<@core_controller.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@core_controller.IfDefCGI>
				<@core_controller.IfDefCGI name="lang"><input type="hidden" name="lang" value="${question.inputParameterMap["lang"]!}"></@core_controller.IfDefCGI>
				<@core_controller.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@core_controller.IfDefCGI>
				<div class="input-group">
					<input required name="query" id="query" title="Search query ${(response.translations.CORE_SEARCH_POWERED_BY_PREFIX)!"powered by"} ${(response.translations.CORE_FUNNELBACK_COMPANY_NAME)!"Funnelback"}" type="text" value="${question.inputParameterMap["query"]!}" accesskey="q" placeholder="${(response.translations.CORE_INITIAL_FORM_SEARCH)!"Search"} <@core_controller.cfg>service_name</@core_controller.cfg>&hellip;
					${(response.translations.CORE_SEARCH_POWERED_BY_PREFIX)!"powered by"} ${(response.translations.CORE_FUNNELBACK_COMPANY_NAME)!"Funnelback"}" class="form-control input-lg query">
					<div class="input-group-btn">
						<button type="submit" class="btn btn-primary input-lg"><span class="glyphicon glyphicon-search"></span> ${(response.translations.CORE_INITIAL_FORM_SEARCH)!"Search"}</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</#macro>

<#---
	Display the navigation bar which is persistent between searches.

	<p>
		The navigation bar aims provides the end user with access to search tools such as:
		<ul>
			<li> Re-query </li>
			<li> Advanced search </li>
			<li> Current session selections </li>
			<li> Performance and syntax tools </li>
			<li> Language options </li>
			<li> and more... </li>
		</ul>
	</p>
-->
<#macro NavBar>
	<!-- core.view.ftl :: NavBar -->
	<nav class="navbar navbar-default" role="navigation">
		<h1 class="sr-only">${(response.translations.CORE_NAVBAR_SR_SEARCH)!"Search"}</h1>
		<#-- Display the mobile tool bar -->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="#"><img src="${baseResourcesPrefix}images/funnelback-logo-small-v2.png" alt="Funnelback" style="height: 17px;"></a>
		</div>

		<div class="collapse navbar-collapse">
			<#-- Displays a search form which has been configured against the user's query -->
			<@AfterSearchForm />

			<#-- Display the various search tools -->
			<ul class="nav navbar-nav navbar-right">
				<#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
					<li data-ng-class="{active: isDisplayed('cart')}">
						<a href="#" data-ng-click="toggleCart()" title="{{cart.length}} ${(response.translations.CORE_NAVBAR_CART_TITLE_SUFFIX)!"item(s) in your selection"}">
							<span class="glyphicon glyphicon-shopping-cart"></span>
							<span class="badge" data-ng-cloak>{{cart.length}}</ng-pluralize --></span>
						</a>
					</li>
				</#if>
				<li class="dropdown">
					<a href="#" title="Advanced Settings" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-cog"></span> <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<#-- Advanced search menu item -->
						<li>
							<a data-toggle="collapse" href="#search-advanced" title="${(response.translations.CORE_NAVBAR_ADVANCED_SEARCH_MSG)!'Advanced search settings'}">
							${(response.translations.CORE_NAVBAR_ADVANCED_SEARCH_TITLE)!'Advanced search'}</a>
						</li>
						<#-- Search history menu item -->
						<#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
							<li data-ng-class="{active: isDisplayed('history')}">
								<a href="#" data-ng-click="toggleHistory()" title="${(response.translations.CORE_NAVBAR_SEARCH_HISTORY_TITLE)!"Search history"}">
									${(response.translations.CORE_NAVBAR_SEARCH_HISTORY_TITLE)!"Search History"}
								</a>
							</li>
						</#if>
					</ul>
				</li>
				<li class="dropdown">
					<a href="#" title="Tools" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-question-sign"></span> <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<#-- Help menu item which will display a infomation page detailed Funnelback advanced search syntax -->
						<li>
							<a href="${SearchPrefix}help/simple_search.html" title="${(response.translations.CORE_NAVBAR_HELP_MSG)!"Search Help"}">
								${(response.translations.CORE_NAVBAR_HELP_TITLE)!"Help"}
							</a>
						</li>
						<#-- Displays the performance menu item which allows the user to view the performance metrices of various phases of the search query	-->
						<li>
							<a data-toggle="modal" href="#search-performance" title="${(response.translations.CORE_NAVBAR_PERFORMANCE_MSG)!"Performance report"}">
								${(response.translations.CORE_NAVBAR_PERFORMANCE_TITLE)!"Performance"}
							</a>
						</li>
						<li>
							<a data-toggle="modal" href="#search-syntaxtree" title="${(response.translations.CORE_NAVBAR_QUERY_SYNTAX_TREE_MST)!"Query syntax tree"}">
								${(response.translations.CORE_NAVBAR_QUERY_SYNTAX_TREE_TITLE)!"Query syntax tree"}
							</a>
						</li>
					</ul>
				</li>

				<#-- Display the language options -->
				<li class="dropdown">
           <a href="#" title="UI Language" class="dropdown-toggle" data-toggle="dropdown">
           	<span class="glyphicon glyphicon-globe text-success"></span> <span class="caret"></span>
           </a>

           <ul class="dropdown-menu">
              <#noescape>
              <li role="presentation" class="dropdown-header">Examples</li>

							<#-- Language options -->
							<li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}"><span lang="en">English</span></a></li>
              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=de_DE&amp;lang=de" title="German"><span lang="de">Deutsch</span></a></li>
              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=es_ES&amp;lang=es" title="Spanish"><span lang="es">Español</span></a></li>
              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=fr_FR&amp;lang=fr" title="French"><span lang="fr">Français</span></a></li>
              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=nl_NL&amp;lang=nl" title="Dutch"><span lang="nl">Nederlands</span></a></li>
              <#--
								Malaysian
								<li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=ml&amp;lang=ml" title="Malaysian"><span lang="ml">Bahasa Malaysia</span></a></li>
							-->
              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=jp_JP" title="Japanese"><span lang="jp">日本語</span></a></li>
              <li role="presentation" class="divider"></li>
              <#--
								Other language which will be completed
	              <li role="presentation" class="dropdown-header">Extended</li>
	              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=zht&amp;lang=zhm" title="Chinese (Simplified)"><span lang="zhs">简体中文</span></a></li>
	              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=zht&amp;lang=zht" title="Chinese (Traditional)"><span lang="zht">繁體中文</span></a></li>
	              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=pl&amp;lang=pl" title="Polish"><span lang="pl">Polski</span></a></li>
	              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=vt&amp;lang=vt" title="Vietnamese"><span lang="vt">Tiếng Việt</span></a></li>
	              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=ko&amp;lang=ko" title="Korean"><span lang="ko">한국어</span></a></li>

	              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=ar&amp;lang=ar" title="Arabic"><span lang="ar">العربية</span></a></li>
	              <li><a href="${question.collection.configuration.value("ui.modern.search_link")?html}?${removeParam(QueryString,["lang.ui","lang"])?html}&amp;lang.ui=th&amp;lang=th" title="Thai"><span lang="th">ไทย</span></a></li>
          		-->
              </#noescape>
            </ul>
        </li>
			</ul>
		</div>
	</nav>
</#macro>

<#---
	Displays a search form which has been configured against the user's query
-->
<#macro AfterSearchForm>
	<!-- core.view.ftl :: AfterSearchForm -->
	<form class="navbar-form navbar-left form-inline" action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="search">
		<input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
		<@core_controller.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@core_controller.IfDefCGI>
		<@core_controller.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@core_controller.IfDefCGI>
		<@core_controller.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@core_controller.IfDefCGI>
		<@core_controller.IfDefCGI name="lang"><input type="hidden" name="lang" value="${question.inputParameterMap["lang"]!}"></@core_controller.IfDefCGI>
		<@core_controller.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@core_controller.IfDefCGI>
		<div class="form-group">
			<input required name="query" id="query" title="Search query ${(response.translations.CORE_SEARCH_POWERED_BY_PREFIX)!"powered by"} ${(response.translations.CORE_FUNNELBACK_COMPANY_NAME)!"Funnelback"}" type="text" value="${question.inputParameterMap["query"]!}" accesskey="q" placeholder="Search <@core_controller.cfg>service_name</@core_controller.cfg>&hellip;
			${(response.translations.CORE_SEARCH_POWERED_BY_PREFIX)!"powered by"} ${(response.translations.CORE_FUNNELBACK_COMPANY_NAME)!"Funnelback"}" class="form-control query" data-ng-disabled="isDisplayed('cart') || isDisplayed('history')">
		</div>
		<button type="submit" class="btn btn-primary" data-ng-disabled="isDisplayed('cart') || isDisplayed('history')"><span class="glyphicon glyphicon-search"></span> Search</button>

		<#-- Display the facet scope which allows the user to search within the currently selected facets -->
		<@core_controller.FacetScope>
			<div class="checkbox-inline">
				<input type="checkbox" name="facetScope" id="facetScope" value="<@core_controller.FacetScopeParameter />" checked="checked">
				<label for="facetScope"> ${(response.translations.CORE_FACET_WITHIN_CATEGORY_MSG)!"Within selected categories only"} </label>
			</div>
		</@core_controller.FacetScope>
	</form>
</#macro>

<#---
	Displays an advanced search form allowing the user to
	query against various metadata, data and document format.
-->
<#macro AdvancedForm>
	<!-- core.view.ftl :: AdvancedForm -->
	<section id="search-advanced" class="well row collapse <@core_controller.IfDefCGI name="from-advanced">in</@core_controller.IfDefCGI>">
	<h2 class="sr-only">${(response.translations.CORE_ADVANCED_SEARCH_TITLE)!"Advanced Search"}</h2>
	<div class="row">
		<div class="col-md-12">
			<form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="form" class="form-horizontal">
				<input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
				<input type="hidden" name="from-advanced" value="true">

				<@core_controller.FacetScope>
					<input type="hidden" name="facetScope" value="<@core_controller.FacetScopeParameter />">
				</@core_controller.FacetScope>

				<@core_controller.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@core_controller.IfDefCGI>
				<@core_controller.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@core_controller.IfDefCGI>
				<@core_controller.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@core_controller.IfDefCGI>
				<@core_controller.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@core_controller.IfDefCGI>
				<div class="row">
					<div class="col-md-4">
						<fieldset>
							<legend>${(response.translations.CORE_ADVANCED_SEARCH_FIELDSET_CONTENTS_TITLE)!'Contents'}</legend>
							<div class="form-group">
								<label class="col-md-4 control-label" for="query-advanced">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_QUERY_TITLE)!'Any'}</label>
								<div class="col-md-8">
									<input type="text" id="query-advanced" name="query" value="${question.inputParameterMap["query"]!}" class="form-control input-sm" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_QUERY_PLACEHOLDER_MSG)!'e.g. juliet where thou love'}">
								</div>
							</div>
							<div class="form-group">
								<label for="query_and" class="col-md-4 control-label">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_QUERY_AND_TITLE)!'All'}</label>
								<div class="col-md-8">
									<input type="text" id="query_and" name="query_and" value="${question.inputParameterMap["query_and"]!}" class="form-control input-sm" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_QUERY_AND_PLACEHOLDER_MSG)!'e.g. juliet where thou love'}">
								</div>
							</div>
							<div class="form-group">
								<label for="query_phrase" class="col-md-4 control-label">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_QUERY_PHRASE_PLACEHOLDER_TITLE)!'Phrase'}</label>
								<div class="col-md-8">
									<input type="text" id="query_phrase" name="query_phrase" value="${question.inputParameterMap["query_phrase"]!}" class="form-control input-sm" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_QUERY_PHRASE_PLACEHOLDER_MSG)!'e.g. to be or not to be'}">
								</div>
							</div>
							<div class="form-group">
								<label for="query_not" class="col-md-4 control-label">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_QUERY_NOT_TITLE)!'Not'}</label>
								<div class="col-md-8">
									<input type="text" id="query_not" name="query_not" value="${question.inputParameterMap["query_not"]!}" class="form-control input-sm" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_QUERY_NOT_PLACEHOLDER_MSG)!'e.g. brutus othello'}">
								</div>
							</div>
						</fieldset>
					</div>
					<div class="col-md-4">
						<fieldset>
							<legend>${(response.translations.CORE_ADVANCED_SEARCH_FIELDSET_METADATA_TITLE)!'Metadata'}</legend>
							<div class="form-group">
								<label for="meta_t" class="col-md-4 control-label">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_TITLE_TITLE)!'Title'}</label>
								<div class="col-md-8">
									<input type="text" id="meta_t" name="meta_t" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_TITLE_PLACEHOLDER_MSG)!'e.g. A Midsummer Night\'s Dream'}" value="${question.inputParameterMap["meta_t"]!}" class="form-control input-sm">
								</div>
							</div>
							<div class="form-group">
								<label for="meta_a" class="col-md-4 control-label">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_AUTHOR_TITLE)!'Author'}</label>
								<div class="col-md-8">
									<input type="text" id="meta_a" name="meta_a" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_AUTHOR_PLACEHOLDER_MSG)!'e.g. William Shakespeare'}" value="${question.inputParameterMap["meta_a"]!}" class="form-control input-sm">
								</div>
							</div>
							<div class="form-group">
								<label for="meta_s" class="col-md-4 control-label">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SUBJECT_TITLE)!'Subject'}</label>
								<div class="col-md-8">
									<input type="text" id="meta_s" name="meta_s" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SUBJECT_PLACEHOLDER_MSG)!'e.g. comedy'}" value="${question.inputParameterMap["meta_s"]!}" class="form-control input-sm">
								</div>
							</div>
							<div class="form-group">
								<label class="control-label col-md-4" for="meta_f_sand">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_FORMAT_TITLE)!'Format'}</label>
								<div class="col-md-8">
									<#-- Select dropdown for format -->
									<@core_controller.Select name="meta_f_sand" options=["=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_FORMAT_ANY)!'Any'} ", "pdf=PDF  (.pdf) ", "xls=Excel (.xls) ", "ppt=Powerpoint (.ppt) ", "rtf=Rich Text (.rtf) ", "doc=Word (.doc) ", "docx=Word 2007+ (.docx) "]>
										<select name="<@core_controller.SelectName />" id="<@core_controller.SelectName />" class="input-sm">
											<#-- Display the options -->
											<@core_controller.SelectOptions>
												<option value="<@core_controller.SelectOptionValue />" <@core_controller.IsSelectOptionSelected>selected="selected"</@core_controller.IsSelectOptionSelected>>
													<@core_controller.SelectOptionName />
												</option>
											</@core_controller.SelectOptions>
										</select>
									</@core_controller.Select>
								</div>
							</div>
						</fieldset>
					</div>
					<div class="col-md-4">
						<fieldset>
							<legend>${(response.translations.CORE_ADVANCED_SEARCH_FIELDSET_PUBLISHED_TITLE)!'Published'}</legend>
							<div class="form-group">
								<label class="control-label col-md-4">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_AFTER_TITLE)!'After'}</label>

								<#-- Select dropdown for year -->
								<label class="sr-only" for="meta_d1year">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_AFTER_YEAR_SR_TITLE)!'Year'}</label>
								<@core_controller.Select name="meta_d1year" options=["=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_AFTER_YEAR_PlACEHOLDER_MSG)!'Year'}"] range="CURRENT_YEAR - 20..CURRENT_YEAR">
									<select name="<@core_controller.SelectName />" id="<@core_controller.SelectName />" class="input-sm">
										<#-- Display the options -->
										<@core_controller.SelectOptions>
											<option value="<@core_controller.SelectOptionValue />" <@core_controller.IsSelectOptionSelected>selected="selected"</@core_controller.IsSelectOptionSelected>>
												<@core_controller.SelectOptionName />
											</option>
										</@core_controller.SelectOptions>
									</select>
								</@core_controller.Select>

								<#-- Select dropdown for month -->
								<label class="sr-only" for="meta_d1month">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_AFTER_MONTH_SR_TITLE)!'Month'}</label>
								<@core_controller.Select name="meta_d1month" options=["=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_AFTER_MONTH_PlACEHOLDER_MSG)!'Month'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_JANUARY)!'Jan'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_FEBRUARY)!'Feb'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_MARCH)!'Mar'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_APRIL)!'Apr'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_MAY)!'May'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_JUNE)!'Jun'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_JULY)!'Jul'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_AUGUST)!'Aug'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_SEPTEMBER)!'Sep'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_OCTOBER)!'Oct'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_NOVEMBER)!'Nov'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_DECEMBER)!'Dec'}"]>
									<select name="<@core_controller.SelectName />" id="<@core_controller.SelectName />" class="input-sm">
										<#-- Display the options -->
										<@core_controller.SelectOptions>
											<option value="<@core_controller.SelectOptionValue />" <@core_controller.IsSelectOptionSelected>selected="selected"</@core_controller.IsSelectOptionSelected>>
												<@core_controller.SelectOptionName />
											</option>
										</@core_controller.SelectOptions>
									</select>
								</@core_controller.Select>

								<#-- Select dropdown for day -->
								<label class="sr-only" for="meta_d1day">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_AFTER_DAY_SR_TITLE)!'Day'}</label>
								<@core_controller.Select name="meta_d1day" options=["=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_AFTER_DAY_PlACEHOLDER_MSG)!'Day'}"] range="1..31">
									<select name="<@core_controller.SelectName />" id="<@core_controller.SelectName />" class="input-sm">
										<#-- Display the options -->
										<@core_controller.SelectOptions>
											<option value="<@core_controller.SelectOptionValue />" <@core_controller.IsSelectOptionSelected>selected="selected"</@core_controller.IsSelectOptionSelected>>
												<@core_controller.SelectOptionName />
											</option>
										</@core_controller.SelectOptions>
									</select>
								</@core_controller.Select>
							</div>

							<div class="form-group">
								<label class="control-label col-md-4">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_BEFORE_TITLE)!'Before'}</label>

								<#-- Select dropdown for year -->
								<label class="sr-only" for="meta_d2year">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_BEFORE_YEAR_SR_TITLE)!'Year'}</label>
								<@core_controller.Select name="meta_d2year" options=["=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_BEFORE_YEAR_PlACEHOLDER_MSG)!'Year'}"] range="CURRENT_YEAR - 20..CURRENT_YEAR">
									<select name="<@core_controller.SelectName />" id="<@core_controller.SelectName />" class="input-sm">
										<#-- Display the options -->
										<@core_controller.SelectOptions>
											<option value="<@core_controller.SelectOptionValue />" <@core_controller.IsSelectOptionSelected>selected="selected"</@core_controller.IsSelectOptionSelected>>
												<@core_controller.SelectOptionName />
											</option>
										</@core_controller.SelectOptions>
									</select>
								</@core_controller.Select>

								<#-- Select dropdown for month -->
								<label class="sr-only" for="meta_d2month">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_BEFORE_MONTH_SR_TITLE)!'Month'}</label>
								<@core_controller.Select name="meta_d2month" options=["=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_BEFORE_MONTH_PlACEHOLDER_MSG)!'Month'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_JANUARY)!'Jan'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_FEBRUARY)!'Feb'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_MARCH)!'Mar'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_APRIL)!'Apr'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_MAY)!'May'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_JUNE)!'Jun'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_JULY)!'Jul'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_AUGUST)!'Aug'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_SEPTEMBER)!'Sep'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_OCTOBER)!'Oct'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_NOVEMBER)!'Nov'}", "${(response.translations.CORE_ADVANCED_SEARCH_FIELD_MONTH_DECEMBER)!'Dec'}"]>
									<select name="<@core_controller.SelectName />" id="<@core_controller.SelectName />" class="input-sm">
										<#-- Display the options -->
										<@core_controller.SelectOptions>
											<option value="<@core_controller.SelectOptionValue />" <@core_controller.IsSelectOptionSelected>selected="selected"</@core_controller.IsSelectOptionSelected>>
												<@core_controller.SelectOptionName />
											</option>
										</@core_controller.SelectOptions>
									</select>
								</@core_controller.Select>

								<#-- Select dropdown for day -->
								<label class="sr-only" for="meta_d2day">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_BEFORE_DAY_SR_TITLE)!'Day'}</label>
								<@core_controller.Select name="meta_d2day" options=["=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_BEFORE_DAY_PlACEHOLDER_MSG)!'Day'}"] range="1..31">
									<select name="<@core_controller.SelectName />" id="<@core_controller.SelectName />" class="input-sm">
										<#-- Display the options -->
										<@core_controller.SelectOptions>
											<option value="<@core_controller.SelectOptionValue />" <@core_controller.IsSelectOptionSelected>selected="selected"</@core_controller.IsSelectOptionSelected>>
												<@core_controller.SelectOptionName />
											</option>
										</@core_controller.SelectOptions>
									</select>
								</@core_controller.Select>
							</div>
						</fieldset>
					</div>
				</div>
				<div class="row">
					<div class="col-md-4">
						<fieldset>
							<legend>${(response.translations.CORE_ADVANCED_SEARCH_FIELDSET_DISPLAY_TITLE)!'Display'}</legend>
							<div class="form-group">
								<label class="control-label col-md-4" for="sort">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SORT_TITLE)!'Sort'}</label>
								<div class="col-md-8">
								<#-- Select dropdown for sort -->
								<@core_controller.Select name="sort" options=["=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SORT_RELEVANCE_TITLE)!'Relevance'}", "date=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SORT_DATE_TITLE)!'Date (Newest first)'}", "adate=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SORT_ADATE_TITLE)!'Date (Oldest first)'}", "title=Title (A-Z)", "dtitle=Title (Z-A)", "prox=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SORT_PROXIMITY_TITLE)!'Distance'}" "url=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SORT_URL_TITLE)!'URL (a-z)'}", "durl=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SORT_DURL_TITLE)!'URL (z-a)'}", "shuffle=${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SORT_SHUFFLE_TITLE)!'Shuffle'}"]>
									<select name="<@core_controller.SelectName />" id="<@core_controller.SelectName />" class="input-sm">
										<#-- Display the options -->
										<@core_controller.SelectOptions>
											<option value="<@core_controller.SelectOptionValue />" <@core_controller.IsSelectOptionSelected>selected="selected"</@core_controller.IsSelectOptionSelected>>
												<@core_controller.SelectOptionName />
											</option>
										</@core_controller.SelectOptions>
									</select>
								</@core_controller.Select>
								</div>
							</div>
							<div class="form-group">
								<label class="control-label col-md-4" for="num_ranks">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_NUM_RANKS_TITLE)!'Results'}</label>
								<div class="col-md-8">
									<div class="input-group">
										<input type="number" min="1" id="num_ranks" name="num_ranks" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_NUM_RANKS_PlACEHOLDER_MSG)!''}" value="${question.inputParameterMap["num_ranks"]!10}" class="form-control input-sm">
										<span class="input-group-addon">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_NUM_RANKS_SUFFIX)!'per page'}</span>
									</div>
								</div>
							</div>
						</fieldset>
					</div>
					<div class="col-md-4">
						<fieldset>
							<legend>${(response.translations.CORE_ADVANCED_SEARCH_FIELDSET_LOCATION_TITLE)!'Location'}</legend>
							<div class="form-group">
								<label class="control-label col-md-4" for="origin">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_ORIGIN_TITLE)!'Origin'}</label>
								<div class="col-md-8">
									<div class="input-group">
										<span class="input-group-btn"><a class="btn btn-info search-geolocation btn-sm" title="${(response.translations.CORE_ADVANCED_SEARCH_LOCATE_ME_MSG)!'Locate me!'}" ><span class="glyphicon glyphicon-map-marker"></span></a></span>
										<input type="text" id="origin" name="origin" pattern="-?[0-9\.]+,-?[0-9\.]+" title="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_ORIGIN_PlACEHOLDER_MSG)!'Longitude, Latitude'}" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_ORIGIN_PlACEHOLDER_MSG)!'Longitude, Latitude'}" value="${question.inputParameterMap["origin"]!}" class="form-control input-sm">
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="control-label col-md-4" for="maxdist">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_DISTANCE_TITLE)!'Distance'}</label>
								<div class="col-md-8">
									<div class="input-group">
										<input type="number" min="0" id="maxdist" name="maxdist" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_DISTANCE_PlACEHOLDER_MSG)!'e.g. 10'}" value="${question.inputParameterMap["maxdist"]!}" class="form-control input-sm">
										<span class="input-group-addon">
											${(response.translations.CORE_ADVANCED_SEARCH_FIELD_DISTANCE_SUFFIX)!'km'}
										</span>
									</div>
								</div>
							</div>
						</fieldset>
					</div>
					<div class="col-md-4">
						<fieldset>
							<legend>${(response.translations.CORE_ADVANCED_SEARCH_FIELDSET_WITHIN_TITLE)!''}</legend>
							<div class="form-group">
								<label class="control-label col-md-4" for="scope">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SCOPE_TITLE)!'Domain'}</label>
								<div class="col-md-8">
									<input type="text" id="scope" name="scope" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_SCOPE_PlACEHOLDER_MSG)!'e.g. example.com'}" value="${question.inputParameterMap["scope"]!}" class="form-control input-sm">
								</div>
							</div>
							<div class="form-group">
								<label class="control-label col-md-4" for="meta_v">${(response.translations.CORE_ADVANCED_SEARCH_FIELD_PATH_TITLE)!'Path'}</label>
								<div class="col-md-8">
									<input type="text" id="meta_v" name="meta_v" placeholder="${(response.translations.CORE_ADVANCED_SEARCH_FIELD_PATH_PlACEHOLDER_MSG)!'/plays/romeo-juliet'}" value="${question.inputParameterMap["meta_v"]!}" class="form-control input-sm">
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
							<button class="btn btn-primary" type="submit"><span class="glyphicon glyphicon-search"></span> ${(response.translations.CORE_ADVANCED_SEARCH)!'Advanced Search'}</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	</section>
</#macro>

<#-- ###  Sessions ### -->

<#---
	Displays the query history via Angular.

	<p>
		The query history records the past queries which the user has
		entered with the current search implementation.
	</p>

	<p>
		<em>Note:</em> This function needs to be refactor to suit the MVC structure
	</p>
-->
<#macro QueryHistory>
	<!-- core.view.ftl :: QueryHistory -->
	<#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session.searchHistory?? && session.searchHistory?size &gt; 0>
		<#-- Build a list of previous queries -->
		<#assign qsSignature = computeQueryStringSignature(QueryString) />
		<#if session.searchHistory?? &&
			(session.searchHistory?size &gt; 1 || session.searchHistory[0].searchParamsSignature != qsSignature)>
			<div class="breadcrumb" data-ng-controller="SearchHistoryCtrl" data-ng-show="!searchHistoryEmpty">
					<#-- Query history more button -->
					<button class="btn btn-link pull-right" data-ng-click="toggleHistory()">
						<small class="text-muted">
							<span class="glyphicon glyphicon-plus"></span>
							${(response.translations.CORE_SESSION_QUERY_HISTORY_MORE)!'More'}
						</small>
					</button>
					<ol class="list-inline" >
						<li class="text-muted">${(response.translations.CORE_SESSION_QUERY_HISTORY_RECENT_PREFIX)!'Recent'}:</li>

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

<#---
	Displays the search history.

	<p>
		The search history contains all the urls which the user has
		clicked on with the current search implementation.
	</p>
-->
<#macro SearchHistory>
	<!-- core.controller.ftl :: SearchHistory -->
	<#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
		<div id="search-history-info" data-ng-cloak data-ng-show="isDisplayed('history')">
			<div class="row">
				<div class="col-md-12">
					<a href="#" data-ng-click="hideHistory()">
						<span class="glyphicon glyphicon-arrow-left"></span>
						${(response.translations.CORE_SESSION_HISTORY_BACK_TO_RESULTS_MSG)!'Back to results'}
					</a>

					<h2><span class="glyphicon glyphicon-time"></span> ${(response.translations.CORE_SESSION_HISTORY_TITLE)!'History'}</h2>

					<div class="row">
						<#-- Click history -->
						<div class="col-md-6" data-ng-controller="ClickHistoryCtrl">
							<div data-ng-show="!clickHistoryEmpty && <@core_controller.HasClickHistory />">
								<h3><span class="glyphicon glyphicon-heart"></span> ${(response.translations.CORE_SESSION_HISTORY_CLICK_TITLE)!'Recently clicked results'}
									<button class="btn btn-danger btn-xs" title="${(response.translations.CORE_SESSION_HISTORY_CLICK_CLEAR_TITLE)!'Clear click history'}" data-ng-click="clear('${(response.translations.CORE_SESSION_HISTORY_CLICK_CLEAR_MSG)!'Your history will be cleared'}')">
										<span class="glyphicon glyphicon-remove"></span> ${(response.translations.CORE_SESSION_HISTORY_CLICK_CLEAR)!'Clear'}
									</button>
								</h3>
								<ul class="list-unstyled">
									<@core_controller.ClickHistory>
										<li>
											<a href="${core_controller.clickHistory.indexUrl}">${core_controller.clickHistory.title}</a> &middot;
											<span class="text-warning">${prettyTime(core_controller.clickHistory.clickDate)}</span>
											<#if core_controller.clickHistory.query??>
												<span class="text-muted">
													for &quot;${core_controller.clickHistory.query!}&quot;
												</span>
											</#if>
										</li>
									</@core_controller.ClickHistory>
								</ul>
							</div>
							<div data-ng-show="clickHistoryEmpty || !<@core_controller.HasClickHistory />">
								<h3><span class="glyphicon glyphicon-heart"></span> ${(response.translations.CORE_SESSION_HISTORY_CLICK_TITLE)!'Recently clicked results'}</h3>
								<p class="text-muted">${(response.translations.CORE_SESSION_HISTORY_CLICK_EMPTY_MSG)!'Your click history is empty'}</p>
							</div>
						</div>
						<#-- Search History -->
						<div class="col-md-6" data-ng-controller="SearchHistoryCtrl">
							<div data-ng-show="!searchHistoryEmpty && <@core_controller.HasSearchHistory />">
								<h3>
									<span class="glyphicon glyphicon-search"></span> ${(response.translations.CORE_SESSION_SEARCH_HISTORY_TITLE)!'Recent searches'}
									<button class="btn btn-danger btn-xs" title="${(response.translations.CORE_SESSION_SEARCH_HISTORY_CLEAR_TITLE)!'Clear recent searches'}" data-ng-click="clear('${(response.translations.CORE_SESSION_SEARCH_HISTORY_CLEAR_MSG)!'Your history will be cleared'}')"><span class="glyphicon glyphicon-remove"></span>
										${(response.translations.CORE_SESSION_SEARCH_HISTORY_CLEAR)!'Clear'}
									</button>
								</h3>
								<ul class="list-unstyled">
									<@core_controller.SearchHistory>
										<li>
											<a href="?${core_controller.searchHistory.searchParams}">${core_controller.searchHistory.originalQuery}
												<small>(${core_controller.searchHistory.totalMatching})</small>
											</a> &middot;
											<span class="text-warning">${prettyTime(core_controller.searchHistory.searchDate)}</span>
										</li>
									</@core_controller.SearchHistory>
								</ul>
							</div>
							<div data-ng-show="searchHistoryEmpty || !<@core_controller.HasSearchHistory />">
								<h3><span class="glyphicon glyphicon-search"></span> ${(response.translations.CORE_SESSION_SEARCH_HISTORY_TITLE)!'Recent searches'}</h3>
								<p class="text-muted">${(response.translations.CORE_SESSION_SEARCH_HISTORY_EMPTY_MSG)!'Your search history is empty'}</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</#if>
</#macro>

<#---
	Displays the session cart.

	The cart feature allows users to save inidividual search results so
	that they viewed later and compared side by side.
-->
<#macro Cart>
	<!-- core.controller.ftl :: Cart -->
	<#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
		<div id="search-cart" data-ng-cloak data-ng-show="isDisplayed('cart')" data-ng-controller="CartCtrl">
			<div class="row">
				<div class="col-md-12">
					<a href="#" data-ng-click="hideCart()"><span class="glyphicon glyphicon-arrow-left"></span> ${(response.translations.CORE_CART_BACK_TO_RESULTS_MSG)!'Back to results'} </a>
					<h2>
						<span class="glyphicon glyphicon-pushpin"></span> ${(response.translations.CORE_CART_SAVED)!'Saved'}
						<button class="btn btn-danger btn-xs" title="${(response.translations.CORE_CART_CLEAR_TITLE)!'Clear selections'}" data-ng-click="clear('${(response.translations.CORE_CART_CLEAR_MSG)!'Your selections will be cleared'}')">
							<span class="glyphicon glyphicon-remove"></span> ${(response.translations.CORE_CART_CLEAR)!'Clear'}
						</button>
					</h2>

					<ul class="list-unstyled">
						<li data-ng-repeat="item in cart">
							<h4>
								<a title="${(response.translations.CORE_CART_REMOVE_TITLE)!'Remove'}" data-ng-click="remove(item.indexUrl)" href="javascript:;"><small class="glyphicon glyphicon-remove"></small></a>
								<a href="{{item.indexUrl}}">{{item.title|truncate:70}}</a>
							</h4>
							<cite class="text-success">{{item.indexUrl|cut:'http://'}}</cite>
							<p>{{item.summary|truncate:255}}</p>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</#if>
</#macro>

<#-- ###  Facets ### -->
<#---
	Displays faceted navigation.

	<p>
		The faceted navigation feature helps users find more relevant
		information by providing them with the capability to refine their
		queries based on any existing structure that may be present in
		your information base. This allows users to explore large volumes
		of content in ways that are difficult to do with standard search
		interfaces.
	</p>
-->
<#macro Facets name="" names=[]>
	<!-- core.controller.ftl :: Facets -->
	<@core_controller.FacetedSearch>
		<div class="col-md-3 col-md-pull-9 hidden-print" id="search-facets">
			<h2 class="sr-only">${(response.translations.CORE_FACET_SR_TITLE)!'Refine'}</h2>
			<@core_controller.Facets name=name names=names>
				<div class="facet">
					<div class="panel panel-default">
						<div class="panel-heading">
							<#-- Display each individual facet -->
							<@core_controller.Facet>
								<#-- Display the facet name otherwise known as the heading -->
								<@core_controller.FacetLabel />

								<!-- Tooltips -->
								<@core_controller.IsFacetLabel name="Author">
									<@base_view.HelpToolTip>${(response.translations.CORE_FACET_AUTHOR_DESC)!'Filter by name of the creator of the document.'}</@base_view.HelpToolTip>
								</@core_controller.IsFacetLabel>

								<@core_controller.IsFacetLabel name="Date">
									<@base_view.HelpToolTip>${(response.translations.CORE_FACET_DATE_DESC)!'Filter by published date of documents.'}</@base_view.HelpToolTip>
								</@core_controller.IsFacetLabel>

								<#--
									Display the summary. In this case, it is the clear all link which removes
									all facet selections for the current facet
								-->
								<@core_controller.FacetSummary>
									<span class="pull-right">
										<a href="<@core_controller.FacetSummaryClearCurrentSelectionUrl />" alt="Clear the current facet selection">
											<small class="text-muted"><span class="glyphicon glyphicon-remove"></span> Clear all </small>
										</a>
									</span>
								</@core_controller.FacetSummary>
							</div>
							<div class="panel-body">
								<@core_controller.FacetSummary>
									<#--
										Generate the facet selection breadcrumb which displays the currently selected facet (or facets
										for hierarchical facet)
									-->
									<@core_controller.FacetBreadCrumb>
										<div>
											<a href="<@core_controller.FacetBreadCrumbUrl />">
												<span class="glyphicon glyphicon-remove"></span>
												<@core_controller.FacetBreadCrumbName />
											</a>
											<#-- Display a marker in between each breadcrumb -->
											<@core_controller.IsLastFacetBreadCrumb negate=true>
												<div><span class="glyphicon glyphicon-arrow-down"></span></div>
											</@core_controller.IsLastFacetBreadCrumb>
										 </div>
									</@core_controller.FacetBreadCrumb>
								<hr />
								</@core_controller.FacetSummary>

								<ul class="list-unstyled">
									<#-- Print all the facet categories associated with each facet -->
									<@core_controller.FacetCategories >
										<@core_controller.FacetCategory>
											<li class="category">
												<span>
													<a href="<@core_controller.FacetCategoryUrl />">
														<@core_controller.FacetCategoryLabel />
													</a>
												</span>
												<span class="badge pull-right">
													<@core_controller.FacetCategoryCount />
												</span>
											</li>
										</@core_controller.FacetCategory>
									</@core_controller.FacetCategories>
								</ul>
							</@core_controller.Facet>

							<#--
								Generate the more/less categories button which will show and hide additonal categories respective
							-->
							<button type="button" class="btn btn-link btn-sm search-toggle-more-categories" style="display: none;" data-more="${(response.translations.CORE_FACET_MORE)!'more'}" data-less="${(response.translations.CORE_FACET_LESS)!'less'}" data-state="more" title="${(response.translations.CORE_FACET_MORE_TITLE)!'Show more categories from this facet'}">
								<small class="glyphicon glyphicon-plus"></small>
								&nbsp;<span>${(response.translations.CORE_FACET_MORE)!'more'}</span>
							</button>
						</div>
					</div>
				</div><!--//.facet-->
			</@core_controller.Facets>
		</div>
	</@core_controller.FacetedSearch>
</#macro>


<#---
	Displays the faceted navigation breadcrumb which allows users to remove any active facets.

	<p>
		This macro is very similar to the faceted navigation macro except it
		only outputs the breadcrumn aspects.
	</p>
-->
<#macro FacetedBreadCrumbSummary name="" names=[]>
	<@core_controller.HasSelectedFacets>
		<@core_controller.FacetedSearch>
			<div class="js-refinements refinements">
				${(response.translations.CORE_FACET_BREADCRUMB_PREFIX)!'Refined by'}
				<@core_controller.Facets name="" names=[]>
					<@core_controller.Facet>
						<@core_controller.FacetSummary>
							<@core_controller.FacetBreadCrumb>
								<a href="<@core_controller.FacetBreadCrumbUrl />">
									<button type="button" class="btn btn-default"	>
										<span class="glyphicon glyphicon-remove"></span>
										<@core_controller.FacetBreadCrumbName />
									</button>
								</a>
							</@core_controller.FacetBreadCrumb>
						</@core_controller.FacetSummary>
					</@core_controller.Facet>
				</@core_controller.Facets>
			</div>
		</@core_controller.FacetedSearch>
	</@core_controller.HasSelectedFacets>
</#macro>

<#-- ###  Results Features ### -->
<#---
	Displays the scope.

	<p>
		The scope markup allows the user to choose whether to search within
		the current specified scope or to remove it and search the entire
		collection. The scope is typically enabled via the <code>scope</code>
		cgi parameter.
	</p>
-->
<#macro Scope>
	<!-- core.view.ftl :: Scope -->
	<#if question.inputParameterMap["scope"]!?length != 0>
		<div class="breadcrumb">
			<span class="text-muted"><span class="glyphicon glyphicon-resize-small"></span> ${(response.translations.CORE_SCOPE_PREFIX)!'Scope'}:</span>
			<@core_controller.Truncate length=80>${question.inputParameterMap["scope"]!}</@core_controller.Truncate>
			<a class="button btn-xs" title="${(response.translations.CORE_SCOPE_REMOVE_PREFIX)!'Remove scope'}: ${question.inputParameterMap["scope"]!}" href="?collection=${question.inputParameterMap["collection"]!}<#if question.inputParameterMap["form"]??>&amp;form=${question.inputParameterMap["form"]!}</#if>&amp;query=<@core_controller.UrlEncode><@core_controller.QueryClean /></@core_controller.UrlEncode>">
				<span class="glyphicon glyphicon-remove text-muted"></span>
			</a>
		</div>
	</#if>
</#macro>

<#---
	Displays the count of the current search results.

	<p>
		The count is the summary of all the results which have been
		returned by the current query. It summarises both exact
		matching and partially matching results.
	</p>
-->
<#macro Count>
	<!-- core.view.ftl :: Count -->
	<div id="search-result-count" class="text-muted">
		<#-- No match results -->
		<#if response.resultPacket.resultsSummary.totalMatching == 0>
			<span id="search-total-matching">0</span> ${(response.translations.CORE_COUNT_SEARCH_THAT_MATCH_MSG)!'search results for'} <strong><@core_controller.QueryClean /></strong>
		</#if>

		<#-- Show the result summary for exact matching results -->
		<#if response.resultPacket.resultsSummary.totalMatching != 0>
			<span id="search-page-start">${response.resultPacket.resultsSummary.currStart}</span> -
			<span id="search-page-end">${response.resultPacket.resultsSummary.currEnd}</span> ${(response.translations.CORE_COUNT_OF)!'of'}
			<span id="search-total-matching">${response.resultPacket.resultsSummary.totalMatching?string.number}</span>
			<#if question.inputParameterMap["s"]?? && question.inputParameterMap["s"]?contains("?:")>
				<em>${(response.translations.CORE_COUNT_COLLAPSED)!'collapsed'}</em>
			</#if>
			${(response.translations.CORE_COUNT_SEARCH_THAT_MATCH_MSG)!'search results for'} <strong><@core_controller.QueryClean></@core_controller.QueryClean></strong>
		</#if>

		<#-- Show the result summary for partially matching results -->
		<#if (response.resultPacket.resultsSummary.partiallyMatching!0) != 0>
			${(response.translations.CORE_COUNT_WHERE)!'where'} <span id="search-fully-matching">${response.resultPacket.resultsSummary.fullyMatching?string.number}</span>
			${(response.translations.CORE_COUNT_MATCH_ALL_WORDS_MSG)!'match all words and'} <span id="search-partially-matching">${response.resultPacket.resultsSummary.partiallyMatching?string.number}</span>
			${(response.translations.CORE_COUNT_MATCH_SOME_WORDS_MSG)!'match some words'}.
		</#if>

		<#-- Show the result summary for collapse results -->
		<#if (response.resultPacket.resultsSummary.collapsed!0) != 0>
			<span id="search-collapsed">${response.resultPacket.resultsSummary.collapsed}</span>
			very similar results included.
		</#if>
	</div>
</#macro>

<#---
	Display the blending summary

	<p>
		Query blending allows multiple variants of a query to be run
		and then blended into a single result set. Query blending can
		be performed based on a number of sources as defined in the
		<code> -qsup </code> query processor option.
	</p>
-->
<#macro Blending>
	<!-- core.view.ftl :: Blending -->
	<@core_controller.Blending>
		<div class="text-muted">
			<span class="glyphicon glyphicon-info-sign"></span>
			${(response.translations.CORE_BLENDING_MSG)!"You're query has been expanded to:"} <strong><@core_controller.BlendingTerms /></strong>.
			<span>
				${(response.translations.CORE_BLENDING_PREFIX)!'Search for'}
				<a href="<@core_controller.BlendingDisabledUrl />" alt="Disable blending">
					<em>${question.originalQuery}</em>
				</a>
				${(response.translations.CORE_BLENDING_SUFFIX)!'instead'}.
			</span>
		</div>
	</@core_controller.Blending>
</#macro>

<#---
	Displays the curator exhibits messages.

	<p>
		Exhibits are individual 'blocks' of information made available for display within
		search results by the curator system.
	</p>
-->
<#macro CuratorExhibits>
	<!-- core.view.ftl :: CuratorExhibits -->
	<@core_controller.CuratorExhibits>
		<@core_controller.CuratorExhibit>
			<blockquote class="search-curator-message">
				<@core_controller.CuratorExhibitsMessageHtml />
			</blockquote>
		</@core_controller.CuratorExhibit>
	</@core_controller.CuratorExhibits>
</#macro>

<#---
	Displays the spelling suggestions.

	<p>
		The spelling suggestions feature of Funnelback is capable of making
		alternative query suggestions to the user based on content.
		It is typically used to correct user's query which have been misspelt.
	</p>
-->
<#macro Spelling>
	<!-- core.view.ftl :: Spelling -->
	<@core_controller.CheckSpelling>
		<h3 id="search-spelling"><span class="glyphicon glyphicon-question-sign text-muted"></span> ${(response.translations.CORE_SPELLING_PREFIX)!'Did you mean'}
			<em>
				<a href="<@core_controller.CheckSpellingUrl />" alt="spelling suggestion">
					<span class="funnelback-highlight">
						<@core_controller.CheckSpellingText />
					</span>
				</a>
			</em>
		</h3>
	</@core_controller.CheckSpelling>
</#macro>

<#---
	Display a message when no results are found.

	<p>
		The no results page is displayed to the user when there are no
		results found for the user's query.
	</p>
-->
<#macro NoResultSummary>
	<!-- core.view.ftl :: NoResultSummary -->
	<h2 class="visible-print">${(response.translations.CORE_ZERO_RESULT_TITLE)!'Results'}</h2>

	<#if response.resultPacket.resultsSummary.totalMatching == 0>
		<h3><span class="glyphicon glyphicon-warning-sign"></span> ${(response.translations.CORE_ZERO_RESULT_TITLE_2)!'No results'}</h3>
		<p>${(response.translations.CORE_ZERO_RESULT_YOUR_SEARCH_FOR)!'Your search for'} <strong>${question.originalQuery!}</strong> ${(response.translations.CORE_ZERO_RESULT_DID_NOT_RETURN_MSG)!'did not return any results'}. ${(response.translations.CORE_ZERO_RESULT_ENSURE_MSG)!'Please ensure that you:'}</p>
		<ul>
			<li>${(response.translations.CORE_ZERO_RESULT_ADVANCED_OPERATORS_MSG)!'are not using any advanced search operators like + - | " etc.'}</li>
			<li>${(response.translations.CORE_ZERO_RESULT_EXPECT_THIS_DOCUMENT_MSG)!'expect this document to exist within the'} <em><@core_controller.cfg>service_name</@core_controller.cfg></em> collection <@core_controller.IfDefCGI name="scope"> ${(response.translations.CORE_ZERO_RESULT_AND_WITHIN)!'and within'} <em><@core_controller.Truncate length=80>${question.inputParameterMap["scope"]!}</@core_controller.Truncate></em></@core_controller.IfDefCGI></li>
			<li>${(response.translations.CORE_ZERO_RESULT_HAVE_PERMISSION_MSG)!'have permission to see any documents that may match your query'}</li>
		</ul>
	</#if>
</#macro>

<#---
	Display the text miner entry

	<p>
		Text Mining in Funnelback involves extracting entities and definitions
		from textual data. Named entities include person names, organisations,
		products, geographic locations etc, as well as acronyms.
	</p>
-->
<#macro EntityDefinition>
	<!-- core.view.ftl :: EntityDefinition -->
	<@core_controller.TextMiner>
		<blockquote id="search-text-miner">
			<h3>
				<span class="glyphicon glyphicon-hand-right text-muted"></span> <@core_controller.QueryClean/>
			</h3>
			<div>
				<a href="<@core_controller.TextMinerUrl />">
					<@core_controller.boldicize><@core_controller.TextMinerEntity /></@core_controller.boldicize>
				</a>
				<span><@core_controller.TextMinerDefinition /></span>
			</div>
		</blockquote>
	</@core_controller.TextMiner>
</#macro>

<#---
	Displays the curator version of best bets.

	<p>
		Curator exhibit list is equivalent to best bets allowing
		search administrators to promote arbitrary URLs based on
		certain triggers.
	</p>
-->
<#macro CuratorExhibitsList >
	<!-- core.view.ftl :: CuratorExhibitsList -->
	<#if (response.curator.exhibits)!?size &gt; 0>
		<ol id="search-curator" class="list-unstyled">
			<#list response.curator.exhibits as exhibit>
				<#if exhibit.titleHtml?? && exhibit.linkUrl??>
					<li>
						<h4>
							<a href="${exhibit.linkUrl}">
								<@core_controller.boldicize><#noescape>${exhibit.titleHtml}</#noescape></@core_controller.boldicize>
							</a>
						</h4>
						<#if exhibit.displayUrl??>
							<cite class="text-success">
								${exhibit.displayUrl}
							</cite>
						</#if>
						<#if exhibit.descriptionHtml??>
							<p>
								<#noescape>${exhibit.descriptionHtml}</#noescape>
							</p>
						</#if>
					</li>
				</#if>
		</#list>
		</ol>
	</#if>
</#macro>

<#---
	Displays the best bets.

	<p>
		The best bets mechanism allows you to specify that certain
		specified URLs should be displayed in the result page whenever
		a set of trigger words is present in the query.
	</p>
-->
<#macro BestBets >
	<!-- core.view.ftl :: BestBets -->
	<@core_controller.BestBets>
		<ol id="search-best-bets" class="list-unstyled">
			<@core_controller.BestBet>
				<li class="alert alert-warning">
					<#-- Title -->
					<#if core_controller.bestBet.title??>
						<h4>
							<a href="${core_controller.bestBet.clickTrackingUrl}">
								<@core_controller.boldicize>${core_controller.bestBet.title}</@core_controller.boldicize>
							</a>
						</h4>
						<cite class="text-success">${core_controller.bestBet.link}</cite>
					</#if>
					<#-- Description -->
					<#if core_controller.bestBet.description??>
						<p>
							<@core_controller.boldicize>
								<#noescape>${core_controller.bestBet.description}</#noescape>
							</@core_controller.boldicize>
						</p>
					</#if>
					<#-- Only display the link if no title has been provided -->
					<#if !core_controller.bestBet.title??>
						<p>
							<strong>${core_controller.bestBet.trigger}:</strong>
							<a href="${core_controller.bestBet.link}">${core_controller.bestBet.link}</a>
						</p>
					</#if>
				</li>
			</@core_controller.BestBet>
		</ol>
	</@core_controller.BestBets>
</#macro>

<#---
	Displays the contextual navigation entries.

	<p>
		Funnelback's contextual navigation engine provides users
		with a road-sign style navigation panel to rapidly discover
		all topics related to their search query.
	</p>

	<p>
		It is also known as related searches.
	</p>
-->
<#macro ContextualNavigation>
	<!-- core.controller.ftl :: ContextualNavigation -->
	<@core_controller.ContextualNavigation>
		<@core_controller.ClusterNavLayout />
			<@core_controller.NoClustersFound />
			<@core_controller.ClusterLayout>
				<div class="well" id="search-contextual-navigation">
					<h3>${(response.translations.CORE_CONTEXTUAL_NAV_TITLE)!'Related searches for'} <strong><@core_controller.QueryClean /></strong></h3>
					<div class="row">
						<@core_controller.ContextualNavigationCategories name="type">
							<div class="col-md-4 search-contextual-navigation-type">
								<h4>${(response.translations.CORE_CONTEXTUAL_NAV_TYPE_TITLE)!'By type'} <strong>${core_controller.contextualNavigation.searchTerm}</strong></h4>
								<ul class="list-unstyled">
									<@core_controller.Clusters>
										<li>
											<a href="${core_controller.cluster.href}">
												<#noescape>
													${core_controller.cluster.label?html?replace("...", " <strong>"+core_controller.contextualNavigation.searchTerm?html+"</strong> ")}
												</#noescape>
											</a>
										</li>
									</@core_controller.Clusters>
									<@core_controller.ShowMoreClusters category="type">
										<li>
											<a rel="more" href="${changeParam(core_controller.category.moreLink, "type_max_clusters", "40")}" class="btn btn-link btn-sm">
												<small class="glyphicon glyphicon-plus"></small> ${(response.translations.CORE_CONTEXTUAL_NAV_MORE)!'more'}
											</a>
										</li>
									</@core_controller.ShowMoreClusters>
									<@core_controller.ShowFewerClusters category="type" />
								</ul>
							</div>
						</@core_controller.ContextualNavigationCategories>

						<@core_controller.ContextualNavigationCategories name="topic">
							<div class="col-md-4 search-contextual-navigation-topic">
								<h4>${(response.translations.CORE_CONTEXTUAL_NAV_TOPIC_TITLE)!'By topic'} <strong>${core_controller.contextualNavigation.searchTerm}</strong></h4>
								<ul class="list-unstyled">
									<@core_controller.Clusters>
										<li>
											<a href="${core_controller.cluster.href}">
												<#noescape>
													${core_controller.cluster.label?html?replace("...", " <strong>"+core_controller.contextualNavigation.searchTerm?html+"</strong> ")}
												</#noescape>
											</a>
										</li>
									</@core_controller.Clusters>
									<@core_controller.ShowMoreClusters category="topic">
										<li>
											<a rel="more" href="${changeParam(core_controller.category.moreLink, "topic_max_clusters", "40")}" class="btn btn-link btn-sm">
												<small class="glyphicon glyphicon-plus"></small>
												${(response.translations.CORE_CONTEXTUAL_NAV_MORE)!'more'}
											</a>
										</li>
									</@core_controller.ShowMoreClusters>
									<@core_controller.ShowFewerClusters category="topic" />
								</ul>
							</div>
						</@core_controller.ContextualNavigationCategories>

						<@core_controller.ContextualNavigationCategories name="site">
							<div class="col-md-4 search-contextual-navigation-site">
								<h4><strong>${core_controller.contextualNavigation.searchTerm}</strong> ${(response.translations.CORE_CONTEXTUAL_NAV_SITE_TITLE)!'By site'}</h4>
								<ul class="list-unstyled">
									<@core_controller.Clusters>
										<li>
											<a href="${core_controller.cluster.href}">
												${core_controller.cluster.label}
											</a>
										</li>
									</@core_controller.Clusters>
									<@core_controller.ShowMoreClusters category="site">
										<li>
											<a rel="more" href="${changeParam(core_controller.category.moreLink, "site_max_clusters", "40")}" class="btn btn-link btn-sm">
												<small class="glyphicon glyphicon-plus"></small> ${(response.translations.CORE_CONTEXTUAL_NAV_MORE)!'more'}
											</a>
										</li>
									</@core_controller.ShowMoreClusters>
									<@core_controller.ShowFewerClusters category="site" />
								</ul>
							</div>
						</@core_controller.ContextualNavigationCategories>
					</div>
				</div>
			</@core_controller.ClusterLayout>
	</@core_controller.ContextualNavigation>
</#macro>

<#---
	Displays the pagination.

	<p>
		Pagination is the process of dividing a document into discrete pages.
		Generally, we do not wish to create pagination links when there is
		only one page of results.
	</p>
-->
<#macro Pagination>
	<!-- core.controller.ftl :: Pagination -->
	<@core_controller.Pagination>
		<div class="text-center hidden-print">
			<h2 class="sr-only">${(response.translations.CORE_PAGINATION_SR_TITLE)!'Pagination'}</h2>
			<ul class="pagination pagination-lg">
				<#--
					Display the previous tag which allows the user to navigate
					back one page
				-->
				<@core_controller.Previous>
					<li>
						<a href="<@core_controller.PreviousUrl />" rel="${(response.translations.CORE_PAGINATION_PREV)!'Prev'}">
							<small>
								<span class="glyphicon glyphicon-chevron-left"></span>
							</small>
							<span class="sr-only">${(response.translations.CORE_PAGINATION_SR_GO_TO_MSG)!'Go to the'}</span>
							${(response.translations.CORE_PAGINATION_PREV)!'Prev'}
							<span class="sr-only">${(response.translations.CORE_PAGINATION_SR_SEARCH_RESULT_PAGE_MSG)!'Search result page'}</span>
						</a>
					</li>
				</@core_controller.Previous>
				<#--
					Displays the pages allowing the user to navigate to different
					position within the search results
				-->
				<@core_controller.Page numPages=5>
					<li <@core_controller.IsCurrentPage> class="active" </@core_controller.IsCurrentPage>>
						<a href="<@core_controller.PageUrl />">
							<span class="sr-only">${(response.translations.CORE_PAGINATION_SR_SEARCH_PAGE_MSG)!'You are reading search result page'} </span>
							<@core_controller.PageNumber />

							<#-- Identify the current page for screen readers -->
							<@core_controller.IsCurrentPage>
								<span class="sr-only">${(response.translations.CORE_PAGINATION_SR_CURRENT_PAGE_MSG)!'The current search result page'}</span>
							</@core_controller.IsCurrentPage>
						</a>
					</li>
				</@core_controller.Page>
				<#--
					Display the next tag which allows the user to navigate
					forward one page
				-->
				<@core_controller.Next>
					<li>
						<a href="<@core_controller.NextUrl />" rel="${(response.translations.CORE_PAGINATION_NEXT)!'Next'}">
							<span class="sr-only">${(response.translations.CORE_PAGINATION_SR_GO_TO_MSG)!'Go to the'}</span>
							${(response.translations.CORE_PAGINATION_NEXT)!'Next'}
							<span class="sr-only">${(response.translations.CORE_PAGINATION_SR_SEARCH_RESULT_PAGE)!'Search result page'}</span>
							<small>
								<span class="glyphicon glyphicon-chevron-right"></span>
							</small>
						</a>
					</li>
				</@core_controller.Next>
			</ul>
		</div>
	</@core_controller.Pagination>
</#macro>

<#--@begin Results -->

<#--
	Displays each result which is returned by Funnelback.

	<p>
		This macro is responsible for looping through each result which is returned
		by Funnelback based on the query.
	</p>
-->
<#macro Results>
	<!-- core.controller.ftl :: Results -->
	<ol id="search-results" class="list-unstyled stencils-core-results" start="${response.resultPacket.resultsSummary.currStart}">
		<@core_controller.Results>
			<#if core_controller.result.class.simpleName == "TierBar">
				<#-- A tier bar -->
				<#if core_controller.result.matched != core_controller.result.outOf>
					<li class="search-tier">
						<h3 class="text-muted">
							${(response.translations.CORE_RESULT_SUMMARY_THAT_MATCH_MSG)!'Results that match'} ${core_controller.result.matched} ${(response.translations.CORE_RESULT_SUMMARY_OF)!'of'} ${core_controller.result.outOf} ${(response.translations.CORE_RESULT_SUMMARY_WORDS)!'words'}
						</h3>
					</li>
				<#else>
					<li class="search-tier"><h3 class="hidden">${(response.translations.CORE_RESULT_SUMMARY_FULLY_MATCHING_MSG)!'Fully match results'}</h3></li>
				</#if>
				<#-- Print event tier bars if they exist -->
				<#if core_controller.result.eventDate??>
					<h2 class="fb-title">Events on ${core_controller.result.eventDate?date}</h2>
				</#if>
			<#else>
				<li data-fb-result=${core_controller.result.indexUrl}>
						<@Result/>
				</li>
			</#if>
		</@core_controller.Results>
	</ol>
</#macro>
<#-- @end --><#-- / Category - Results -->
<#-- @begin Result -->
<#---
	Displays the individual search results.

	<p>
		Search results are entries returned by Funnelback in response to the user's query.
	</p>
-->
<#macro Result>
	<!-- core.view.ftl :: Result -->
	<#-- ResultTitle -->
	<#-- Displays the result title which can be used to navigate to the source page -->
	<h4>
		<#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
			<a href="#" data-ng-click="toggle()" data-cart-link data-css="pushpin|remove" title="{{label}}" class="stencils-print__hide">
				<small class="glyphicon glyphicon-{{css}}"></small>
			</a>
		</#if>

		<a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl}">
			<@core_controller.boldicize><@core_controller.Truncate length=70>${core_controller.result.title}</@core_controller.Truncate></@core_controller.boldicize>
		</a>
		<#if core_controller.result.fileType!?matches("(doc|docx|ppt|pptx|rtf|xls|xlsx|xlsm|pdf)", "r")>
			<small class="text-muted">${core_controller.result.fileType?upper_case} (${filesize(core_controller.result.fileSize!0)})</small>
		</#if>
		<#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(core_controller.result.indexUrl)??>
			<small class="text-warning stencils-print__hide">
				<span class="glyphicon glyphicon-time"></span>
				<a title="${(response.translations.CORE_RESULT_SESSION_HISTORY_TITLE)!'Click history'}" href="#" class="text-warning" data-ng-click="toggleHistory()">
				${(response.translations.CORE_RESULT_SESSION_HISTORY_LAST_VISITED)!'Last visited'} ${prettyTime(session.getClickHistory(core_controller.result.indexUrl).clickDate)}
				</a>
			</small>
		</#if>
	</h4>
	<#-- /ResultTitle -->

	<#-- Display the url which belongs to the search result providing the user with additional context  -->
	<cite data-url="${core_controller.result.displayUrl}" class="text-success">
		<@core_controller.cut cut="http://">
			<@core_controller.boldicize>
				${core_controller.result.displayUrl}
			</@core_controller.boldicize>
		</@core_controller.cut>
	</cite>

	<#-- ResultTools -->
	<div class="btn-group stencils-print__hide">
		<a href="#" class="dropdown-toggle" data-toggle="dropdown" title="${(response.translations.CORE_RESULT_MORE_ACTIONS)!'More actions'}"><small class="glyphicon glyphicon-chevron-down text-success"></small></a>

		<ul class="dropdown-menu">
			<#-- General the cache link which is used to display the version of the document when it was crawled -->
			<li>
				<#if core_controller.result.cacheUrl??>
					<a href="${core_controller.result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="${(response.translations.CORE_CACHED_PREFIX)!'Cached version of'} ${core_controller.result.title} (${core_controller.result.rank})">${(response.translations.CORE_CACHED)!'Cached'}</a>
				</#if>
			</li>

			<#-- Generate the explore url which is used to find similar results -->
			<@core_controller.Explore>
				<li>
					<a class="fb-explore" href="<@core_controller.ExploreUrl />" alt="${(response.translations.CORE_EXPLORE_TITLE_ALT)!'Related results'}"> ${(response.translations.CORE_EXPLORE_TITLE)!'Explore'} </a>
				</li>
			</@core_controller.Explore>

			<#-- Show the optimise button when viewed from the admin UI which will guide the user to the SEO optimiser -->
			<@core_controller.Optimise>
				<li>
					<a class="search-optimise" href="<@core_controller.OptimiseUrl />">
						Optimise
					</a>
				</li>
			</@core_controller.Optimise>
		</ul>
	</div>
	<#-- /ResultTools -->

	<#--  ResultQuicklinks -->
	<@core_controller.Quicklinks>
		<ul class="list-inline stencils-print__hide">
			<@core_controller.QuickLink>
				<li>
					<a href="<@core_controller.QuickLinkUrl />" title="<@core_controller.QuickLinkText />"><@core_controller.QuickLinkText /></a>
				</li>
			</@core_controller.QuickLink>
		</ul>
		<#if question.collection.quickLinksConfiguration["quicklinks.domain_searchbox"]??
		&& question.collection.quickLinksConfiguration["quicklinks.domain_searchbox"] == "true">
			<#if core_controller.result.quickLinks.domain?matches("^[^/]*/?[^/]*$", "r")>
				<form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="search">
						<input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!}">
						<input type="hidden" name="meta_u_sand" value="${core_controller.result.quickLinks.domain}">
						<@core_controller.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!}"></@core_controller.IfDefCGI>
						<@core_controller.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!}"></@core_controller.IfDefCGI>
						<@core_controller.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!}"></@core_controller.IfDefCGI>
						<@core_controller.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!}"></@core_controller.IfDefCGI>
						<div class="row">
							<div class="col-md-4">
							<div class="input-group input-sm">
								<input required title="${(response.translations.CORE_QUICKLINK_SEARCH_QUERY_TITLE)!'Search title'}" name="query" type="text" class="form-control" placeholder="${(response.translations.CORE_QUICKLINK_SEARCH_PLACEHOLDER_MSG)!'Search'} ${s.result.quickLinks.domain}&hellip;">

								<div class="input-group-btn">
									<button type="submit" class="btn btn-info"><span class="glyphicon glyphicon-search"></span></button>
								</div>
							</div>
						</div>
					</div>
				</form>
			</#if>
		</#if>
	</@core_controller.Quicklinks>

	<#-- ResultSummary: Display the generated intelligent result summary -->
	<#if core_controller.result.summary??>
		<p>
			<#if core_controller.result.date??>
				<small class="text-muted">
					${core_controller.result.date?date?string("d MMM yyyy")}:
				</small>
			</#if>
			<span class="search-summary">
				<@core_controller.boldicize>
					<#noescape>
						${core_controller.result.summary}
					</#noescape>
				</@core_controller.boldicize>
			</span>
		</p>
	</#if>

	<#-- ResultSummary - Metadata summary based on fields mapped to the description metadata field "c" -->
	<#if core_controller.result.metaData["c"]??>
		<p>
			<@core_controller.boldicize>
				${core_controller.result.metaData["c"]!}
			</@core_controller.boldicize>
		</p>
	</#if>
	<#-- /ResultSummary -->

	<#-- ResultCollased - Display the link to access collapse results which represents similar results which have been hidden for clarity -->
	<@core_controller.Collapsed>
		<div class="search-collapsed stencils-print__hide">
			<small>
				<span class="glyphicon glyphicon-expand text-muted"></span>&nbsp;
				<a class="search-collapsed" href="<@core_controller.CollapsedUrl />">
					<#-- Message for exact count -->
					<@core_controller.CollapsedLabel>
						<@core_controller.CollapsedCount /> ${(response.translations.CORE_RESULT_COLLAPSED_SIMILAR_MSG)!'Very similar results'}
					</@core_controller.CollapsedLabel>

					<#-- Alternative message for approximate count -->
					<@core_controller.CollapsedApproximateLabel>
						${(response.translations.CORE_RESULT_COLLAPSED_ABOUT)!'About'} <@core_controller.CollapsedCount /> ${(response.translations.CORE_RESULT_COLLAPSED_SIMILAR_MSG)!'Very similar results'}
					</@core_controller.CollapsedApproximateLabel>
				</a>
			</small>
		</div>
	</@core_controller.Collapsed>

	<#-- ResultMetadataSummary -->
	<#if core_controller.result.metaData["a"]?? || core_controller.result.metaData["s"]?? || core_controller.result.metaData["p"]??>
		<dl class="dl-horizontal text-muted">
			<#if core_controller.result.metaData["a"]??>
				<dt>${(response.translations.CORE_RESULT_METADATA_AUTHOR_TITLE)!'By'}</dt>
				<dd>${core_controller.result.metaData["a"]!?replace("|", ", ")}</dd>
			</#if>
			<#if core_controller.result.metaData["s"]??>
				<dt>${(response.translations.CORE_RESULT_METADATA_KEYWORDS_TITLE)!'Keywords'}:</dt>
				<dd>${core_controller.result.metaData["s"]!?replace("|", ", ")}</dd>
			</#if>
			<#if core_controller.result.metaData["p"]??>
				<dt>${(response.translations.CORE_RESULT_METADATA_PUBLISHER_TITLE)!'Publisher'}:</dt>
				<dd>${core_controller.result.metaData["p"]!?replace("|", ", ")}</dd>
			</#if>
		</dl>
	</#if>
	<#-- /ResultMetadataSummary -->
</#macro>
<#-- @end Result -->
<#-- /Category - Result -->
</#escape>
