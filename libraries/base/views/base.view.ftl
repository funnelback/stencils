<#ftl encoding="utf-8" />
<#---
	This contains basic utility views which can be used across all stencils and general implementations.

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
<#assign baseResourcesPrefix = "${SearchPrefix}stencils-resources/base/" >
<#assign thirdPartyResourcesPrefix = "${SearchPrefix}stencils-resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${librariesPrefix}base/controllers/base.controller.ftl" as base_controller/>

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core"] />
	<#--
		The following code imports and assigns stencil namespaces automatically eg. core_view and core_controller.
		The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/
		and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
	-->
<@stencils_utilities.ImportStencils stencils=stencils>
	<@stencils_utilities.imports?interpret />
</@stencils_utilities.ImportStencils>

<#---
	Stylesheet dependencies
 -->
<#macro CSS>
	<!-- base.view.ftl.view.ftl :: CSS -->
	<link rel="stylesheet" href="${thirdPartyResourcesPrefix}bootstrap/v3.3.5/css/bootstrap.min.css">
	<link rel="stylesheet" href="${thirdPartyResourcesPrefix}font-awesome/v4.3.0/css/font-awesome.min.css">
	<link rel="stylesheet" href="${SearchPrefix}stencils-resources/base/css/stencils.base.css">
	<link rel="stylesheet" href="${baseResourcesPrefix}css/stencils.base.css">
</#macro>

<#---
	JavaScript dependencies
-->
<#macro JS>
	<!-- base.view.ftl.view.ftl :: JS -->
	<script src="${thirdPartyResourcesPrefix}matchHeight/jquery.matchHeight.min.js"></script>
	<script src="${thirdPartyResourcesPrefix}bootstrap/v3.3.5/js/bootstrap.min.js"></script>
	<script src="${baseResourcesPrefix}js/stencils.base.js"></script>
</#macro>
<#-- @end --><#-- /Configuration -->
<#-- ###################  Views ####################### -->
<#-- @begin  General -->
<#---
	Container for all modals.
-->
<#macro Modals>
	<!-- base.view.ftl :: ResultsModals -->
	<#-- Modals for results -->
	<@core_controller.Results>
		<#if core_controller.result.class.simpleName == "TierBar">
		<#else>
			<@ResultModal />
		</#if>
	</@core_controller.Results>
</#macro>
<#-- @end --><#-- / Category - General -->
<#-- @begin  Search Forms -->
<#-- @end --><#-- / Category - Search Forms -->
<#-- @begin  Sessions -->
<#-- @end --><#-- / Category - Sessions -->
<#-- @begin  Facets -->
<#-- @end --><#-- / Category - Facets -->
<#-- @begin Results Features -->
<#---
	Facet breadcrumb view which allows users	to remove active facets
-->
<#macro BreadCrumb>
	<@base_controller.BreadCrumbSearch>
		<div class="js-refinements refinements">
			Refined by
			<@base_controller.BreadCrumbs>
					<@base_controller.BreadCrumb>
						<a href="<@base_controller.BreadCrumbUrl />">
							<button type="button" class="btn btn-default">
								<span class="glyphicon glyphicon-remove"></span>
								<@base_controller.BreadCrumbName />
							</button>
						</a>
					</@base_controller.BreadCrumb>
			</@base_controller.BreadCrumbs>
		</div>
	</@base_controller.BreadCrumbSearch>
</#macro>

<#---
	View for UI to switch the results view format layout such as a grid or list format.
-->
<#macro ResultsViewSelectorView>
<!-- base.view.ftl :: ResultsViewSelectorView -->
<@core_controller.Select name="resultsView" options=["=List", "grid=Grid"]>
	<span class="label label-default">View</span>
	<div name="ResultsViewSelectorSort" id="ResultsViewSelectorSort" class="btn-group">
		<@core_controller.SelectOptions>
			<#switch core_controller.selectOptionValue>
				<#case "grid">
					<#local icon><span class="glyphicon glyphicon-th"></span></#local>
					<#local href><@base_controller.CreateSearchUrl cgis=["${core_controller.selectName}=${core_controller.selectOptionValue}","num_ranks=${base_controller.setResultsLimitGrid(10)}"] /></#local>
					<#break>
				<#case ""> <#-- Case List -->
				<#default>
					<#local icon><span class="glyphicon glyphicon-th-list"></#local>
					<#local href><@base_controller.CreateSearchUrl cgis=["${core_controller.selectName}=${core_controller.selectOptionValue}"] /></#local>
			</#switch>
			<#noescape>
				<a class="btn btn-default <@core_controller.IsSelectOptionSelected>active</@core_controller.IsSelectOptionSelected>" href="${href!}">
					${icon!} <@core_controller.SelectOptionName />
				</a>
			</#noescape>
		</@core_controller.SelectOptions>
	</div>
</@core_controller.Select>
</#macro>

<#---
	View for select widget to change the number of results shown per page.
-->
<#macro ResultsViewSelectorLimit>
	<!-- base.view.ftl :: ResultsViewSelectorLimit -->
	<#-- Options for view limit -->
	<#local options=["=10", "50=50", "100=100"] >
	<@base_controller.IfDefCGIEquals name="resultsView" value="grid">
		<#-- If we are using a Grid layout calulcate a new number of for limit based on columns times	 -->
		<#local options = ["${base_controller.setResultsLimitGrid(10)}=${base_controller.setResultsLimitGrid(10)}",
											"${base_controller.setResultsLimitGrid(20)}=${base_controller.setResultsLimitGrid(20)}",
											"${base_controller.setResultsLimitGrid(30)}=${base_controller.setResultsLimitGrid(30)}"] />
	</@base_controller.IfDefCGIEquals>
	<@core_controller.Select name="num_ranks" options=options>
		<div name="ResultsViewSelectorLimit" id="ResultsViewSelectorLimit" class="btn-group">
			<@core_controller.SelectOptions>
				<@core_controller.IsSelectOptionSelected>
				<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
					<span class="label label-default">Limit:</span>
						<@core_controller.SelectOptionName />
					&nbsp;&nbsp;
					<span class="caret"></span>
				</button>
				</@core_controller.IsSelectOptionSelected>
			</@core_controller.SelectOptions>

			<ul class="dropdown-menu" role="menu">
			<#-- Display the options -->
			<@core_controller.SelectOptions>
				<@core_controller.IsSelectOptionSelected negate=true>
				<li>
					<a href="<@base_controller.CreateSearchUrl cgis=["${core_controller.selectName}=${core_controller.selectOptionValue}"] />">
						<@core_controller.SelectOptionName />
					</a>
				</li>
				</@core_controller.IsSelectOptionSelected>
			</@core_controller.SelectOptions>
			</ul>
		</div>
	</@core_controller.Select>
</#macro>

<#---
	View for select UI that allows the user to select to group results by numeric amount per row.
-->
<#macro ResultsViewSelectorColumns>
<!-- base.view.ftl :: ResultsViewSelectorColumns -->
<@base_controller.IfDefCGIEquals name="resultsView" value="grid">
	<@core_controller.Select name="resultsColumns" options=["=2", "3=3", "4=4"]>
		<div name="ResultsViewSelectorSort" id="ResultsViewSelectorSort" class="btn-group">
			<@core_controller.SelectOptions>
				<@core_controller.IsSelectOptionSelected>
				<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
					<span class="label label-default">Columns:</span>
						<@core_controller.SelectOptionName />
					&nbsp;&nbsp;
					<span class="caret"></span>
				</button>
				</@core_controller.IsSelectOptionSelected>
			</@core_controller.SelectOptions>

			<ul class="dropdown-menu" role="menu">
			<#-- Display the options -->
			<@core_controller.SelectOptions>
				<@core_controller.IsSelectOptionSelected negate=true>
				<li>
					<#if core_controller.selectOptionValue == "">
						<#local columns = 2 >
					<#else>
						<#local columns = core_controller.selectOptionValue?number >
					</#if>

					<a href="<@base_controller.CreateSearchUrl cgis=["${core_controller.selectName}=${core_controller.selectOptionValue}","num_ranks=${base_controller.setResultsLimitGrid(10,columns)}" ] />">
						<@core_controller.SelectOptionName />
					</a>
				</li>
				</@core_controller.IsSelectOptionSelected>
			</@core_controller.SelectOptions>
			</ul>
		</div>
	</@core_controller.Select>
</@base_controller.IfDefCGIEquals>
</#macro>

<#---
	View for a select UI that allows the user to sort results by different options
-->
<#macro ResultsViewSelectorSort>
<!-- base.view.ftl :: ResultsViewSelectorSort -->
<@core_controller.Select name="sort" options=["=Relevance ", "date=Date (Newest first)", "adate=Date (Oldest first)", "title=Title (A-Z)", "dtitle=Title (Z-A)", "prox=Distance" "url=Url (A-Z)", "durl=Url (Z-A)", "shuffle=Shuffle"]>
	<div name="ResultsViewSelectorSort" id="ResultsViewSelectorSort" class="btn-group">
		<@core_controller.SelectOptions>
			<@core_controller.IsSelectOptionSelected>
			<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
				<span class="label label-default">Sort:</span>
					<@core_controller.SelectOptionName />
				&nbsp;&nbsp;
				<span class="caret"></span>
			</button>
			</@core_controller.IsSelectOptionSelected>
		</@core_controller.SelectOptions>

		<ul class="dropdown-menu" role="menu">
		<#-- Display the options -->
		<@core_controller.SelectOptions>
			<@core_controller.IsSelectOptionSelected negate=true>
			<li>
				<a href="<@base_controller.CreateSearchUrl cgis=["${core_controller.selectName}=${core_controller.selectOptionValue}"] />">
					<@core_controller.SelectOptionName />
				</a>
			</li>
			</@core_controller.IsSelectOptionSelected>
		</@core_controller.SelectOptions>
		</ul>
	</div>
</@core_controller.Select>
</#macro>

<#---
	View for the group of UI select components to display above the search results area.
-->
<#macro ResultsViewSelectors>
	<#if (response.resultPacket.resultsWithTierBars)!?has_content>
	<!-- base.view.ftl :: ResultsViewSelectors -->
	<div class="row" style="margin-bottom:0.5em">
		<div class="col-md-12">
			<div class="pull-right">
				<@ResultsViewSelectorLimit />
				<@ResultsViewSelectorSort />
			</div>
		</div>
	</div>
	</#if>
</#macro>
<#-- @end --><#-- / Category - Results Features -->
<#-- @begin  Results -->
<#-- ### V1.1 Results View List ### -->
<#---
	Template view for results view as a list layout.
-->
<#macro ResultsViewList>
	<@base_controller.IfDefCGIEquals name="resultsView" value="list" trueIfEmpty=true>
	<!-- base.view.ftl :: ResultsViewList -->
		<li data-fb-result=${core_controller.result.indexUrl}>
			<@ResultPanel />
		</li>
	</@base_controller.IfDefCGIEquals>
</#macro>

<#-- ### V1.2 Results View Grid ### -->
<#---
	Template view for results view as a grid layout.
-->
<#macro ResultsViewGrid>
	<@base_controller.IfDefCGIEquals name="resultsView" value="grid">
	<!-- base.view.ftl :: ResultsViewGrid -->
		<@base_controller.ResultsColumns>
			<@base_controller.ResultsColumnsIsOpen>
			<li class="row" data-results-column-rank="${base_controller.resultsColumnsIndex!}">
				<ol class="list-unstyled">
			</@base_controller.ResultsColumnsIsOpen>
					<#local cssColWidth = (12/base_controller.resultsColumnsNumber!1)?floor?c >
					<li data-fb-result=${core_controller.result.indexUrl} class="col-md-${cssColWidth!} columns-${base_controller.resultsColumnsNumber!}">
						<@ResultPanel />
					</li>
			<@base_controller.ResultsColumnsIsClosed>
				</ol>
			</li>
			</@base_controller.ResultsColumnsIsClosed>
		</@base_controller.ResultsColumns>
	</@base_controller.IfDefCGIEquals>
</#macro>
<#-- @end --><#-- / Category - Results -->
<#-- @begin  Result -->
<#---
	Template view for Search Result as a panel variation.
-->
<#macro ResultPanel>
<!-- base.view.ftl :: ResultPanel -->
<div class="panel panel-default">
	<div class="panel-heading" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
		<small class="text-muted">
			<i class="fa fa-pencil"></i> Published
			<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if>
			<#-- ResultAuthor -->
			<#if core_controller.result.metaData.a??>
				by <@core_controller.boldicize>${core_controller.result.metaData.a}</@core_controller.boldicize>
			<#elseif core_controller.result.metaData.p?? >
				by <@core_controller.boldicize>${core_controller.result.metaData.p}</@core_controller.boldicize>
			</#if>
			<#-- /ResultAuthor -->
			<#-- ResultSource -->
			via
			<cite data-url="${core_controller.result.displayUrl}" class="text-success">
				<@core_controller.cut cut="http://">
					<@core_controller.boldicize>
						${core_controller.result.displayUrl}
					</@core_controller.boldicize>
				</@core_controller.cut>
			</cite>
			<#--	/ResultSource -->
		</small>
	</div>
	<#-- /panel-heading -->
	<div class="panel-body" data-mh="group-body-${base_controller.resultsColumnsIndex!}">
		<#-- ResultTitle -->
		<h4>
			<a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl}">
				<@core_controller.boldicize><@core_controller.Truncate length=70>${core_controller.result.title}</@core_controller.Truncate></@core_controller.boldicize>
			</a>
			<#if core_controller.result.fileType!?matches("(doc|docx|ppt|pptx|rtf|xls|xlsx|xlsm|pdf)", "r")>
				<small class="text-muted">${core_controller.result.fileType?upper_case} (${filesize(core_controller.result.fileSize!0)})</small>
			</#if>
		</h4>
		<#-- /ResultTitle -->

		<#-- ResultThumbnail -->
		<#if core_controller.result.metaData.stencilsCoreThumbnailUrl?? >
			<img src="${core_controller.result.metaData.stencilsCoreThumbnailUrl!}" class="stencils-core-result-thumbnail pull-right" alt="${core_controller.result.metaData.c!}" />
		</#if>
		<#-- /ResultThumbnail -->

		<#--	ResultQuicklinks -->
		<@core_controller.Quicklinks>
			<ul class="list-inline">
					<@core_controller.QuickRepeat><li><a href="${core_controller.ql.url}" title="${core_controller.ql.text}">${core_controller.ql.text}</a></li></@core_controller.QuickRepeat>
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
									<input required title="Search query" name="query" type="text" class="form-control" placeholder="Search ${core_controller.result.quickLinks.domain}&hellip;">
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
		<#--	/ResultQuicklinks -->

		<#-- Display the result summary -->
		<#if core_controller.result.summary??>
			<p>
				<span class="search-summary">
					<@core_controller.boldicize>
						<#noescape>
							${core_controller.result.summary}
						</#noescape>
					</@core_controller.boldicize>
				</span>
			</p>
		</#if>

		<#-- Metadata summary based on fields mapped to the metadata "c" -->
		<#if core_controller.result.metaData["c"]??><p><@core_controller.boldicize>${core_controller.result.metaData["c"]!}</@core_controller.boldicize></p></#if>

		<#-- ResultCollaspe Generate the result collapsing link -->
		<@core_controller.Collapsed>
			<div class="search-collapsed">
				<small>
					<span class="glyphicon glyphicon-expand text-muted"></span>&nbsp;
					<a class="search-collapsed" href="<@core_controller.CollapsedUrl />">
						<!-- Message for exact count -->
						<@core_controller.CollapsedLabel>
							<@core_controller.CollapsedCount /> very similar results
						</@core_controller.CollapsedLabel>

						<!-- Alternative message for approximate count -->
						<@core_controller.CollapsedApproximateLabel>
							About <@core_controller.CollapsedCount /> very similar results
						</@core_controller.CollapsedApproximateLabel>
					</a>
				</small>
			</div>
		</@core_controller.Collapsed>
		<#-- /ResultCollaspe -->

		<#-- ResultMetadataSummary -->
		<#if core_controller.result.metaData["a"]?? || core_controller.result.metaData["s"]?? || core_controller.result.metaData["p"]??>
			<dl class="<#if (base_controller.resultsColumnsNumber!1)?number lt 3>dl-horizontal</#if> text-muted">
				<#if core_controller.result.metaData["a"]??>
					<dt>by</dt>
					<dd>${core_controller.result.metaData["a"]!?replace("|", ", ")}</dd>
				</#if>
				<#if core_controller.result.metaData["s"]??>
					<dt>Keywords:</dt>
					<dd>${core_controller.result.metaData["s"]!?replace("|", ", ")}</dd>
				</#if>
				<#if core_controller.result.metaData["p"]??>
					<dt>Publisher:</dt>
					<dd>${core_controller.result.metaData["p"]!?replace("|", ", ")}</dd>
				</#if>
			</dl>
		</#if>
		<#-- /ResultMetadataSummary	-->
	</div>
	<#-- /panel-body -->
	<div class="panel-footer">
		<#--	Result tools -->
		<div class="btn-group">
			<div class="btn-group">
				<button href="#" class="dropdown-toggle btn btn-default" data-toggle="dropdown" title="More actions&hellip;"><small class="glyphicon glyphicon-chevron-down text-success"></small>
					<span class="sr-only">Result tools</span>
				</button>
				<ul class="dropdown-menu">
					<li>
						<#-- General the cache link which is used to display the version of the document when it was crawled -->
						<#if core_controller.result.cacheUrl??>
							<a href="${core_controller.result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="Cached version of ${core_controller.result.title} (${core_controller.result.rank})">Cached</a>
						</#if>
					</li>
					<#-- Generate the explore url which is used to find similar results -->
					<@core_controller.Explore>
						<li>
							<a class="fb-explore" href="<@core_controller.ExploreUrl />" alt="Related results"> Explore </a>
						</li>
					</@core_controller.Explore>
					<#-- Show the optimise button when viewed from the admin UI -->
					<@core_controller.Optimise>
						<li>
							<a class="search-optimise" href="<@core_controller.OptimiseUrl />">
								Optimise
							</a>
						</li>
					</@core_controller.Optimise>
				</ul>
			</div>

			<#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
				<button data-ng-click="toggle()" data-cart-link data-css="pushpin|remove" title="{{label}}" class="btn btn-default">
					<small class="glyphicon glyphicon-{{css}}"></small> <span class="sr-only">Save to Cart</span>
				</button>
			</#if>

			<a href="${core_controller.result.clickTrackingUrl!}" class="btn btn-default" title="View '${core_controller.result.liveUrl!}'">
				<i class="fa fa-external-link"></i> <span class="sr-only">View '${core_controller.result.liveUrl!}</span>
			</a>

			<#-- Open modal -->
			<button class="btn btn-primary" data-toggle="modal" data-target="#result-modal-${core_controller.result.rank!}" title="Expanded view">
				<i class="fa fa-newspaper-o"></i> <span class="sr-only">Expanded view</span>
			</button>

			<#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(core_controller.result.indexUrl)??>
				<a title="Click history" href="#" class="text-warning btn btn-default" data-ng-click="toggleHistory()">
					<small class="text-warning">
						<span class="glyphicon glyphicon-time"></span>
						Last visited ${prettyTime(session.getClickHistory(core_controller.result.indexUrl).clickDate)}
					</small>
				</a>
			</#if>
		</div>
		<#-- /ResultTools -->
	</div>
	<#-- /panel-footer -->
</div>
</#macro>
<#-- /ResultPanel-->

<#---
	Template view for search result modal.
-->
<#macro ResultModal>
	<!-- base.view.ftl :: ResultDefaultModal -->
		<div data-fb-result="${core_controller.result.liveUrl!}" class="modal fade ng-scope" id="result-modal-${core_controller.result.rank!}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<small class="text-muted">
							<i class="fa fa-pencil"></i> Published
							<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if>
							<#-- ResultAuthor -->
							<#if core_controller.result.metaData.a??>
								by <@core_controller.boldicize>${core_controller.result.metaData.a}</@core_controller.boldicize>
							<#elseif core_controller.result.metaData.p?? >
								by <@core_controller.boldicize>${core_controller.result.metaData.p}</@core_controller.boldicize>
							</#if>
							<#-- /ResultAuthor -->
							<#-- ResultSource -->
							via
							<cite data-url="${core_controller.result.displayUrl}" class="text-success">
								<@core_controller.cut cut="http://">
									<@core_controller.boldicize>
										${core_controller.result.displayUrl}
									</@core_controller.boldicize>
								</@core_controller.cut>
							</cite>
							<#--	/ResultSource -->
						</small>
					</div>
					<div class="modal-body">
						<#-- ResultTitle -->
						<h4>
							<a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl}">
								<@core_controller.boldicize><@core_controller.Truncate length=70>${core_controller.result.title}</@core_controller.Truncate></@core_controller.boldicize>
							</a>
							<#if core_controller.result.fileType!?matches("(doc|docx|ppt|pptx|rtf|xls|xlsx|xlsm|pdf)", "r")>
								<small class="text-muted">${core_controller.result.fileType?upper_case} (${filesize(core_controller.result.fileSize!0)})</small>
							</#if>
						</h4>
						<#-- /ResultTitle -->

						<#-- ResultThumbnail -->
						<#if core_controller.result.metaData.stencilsCoreThumbnailUrl?? >
							<img src="${core_controller.result.metaData.stencilsCoreThumbnailUrl!}" class="stencils-core-result-thumbnail pull-right" alt="${core_controller.result.metaData.c!}" />
						</#if>
						<#-- /ResultThumbnail -->

						<#--	ResultQuicklinks -->
						<@core_controller.Quicklinks>
							<ul class="list-inline">
									<@core_controller.QuickRepeat><li><a href="${core_controller.ql.url}" title="${core_controller.ql.text}">${core_controller.ql.text}</a></li></@core_controller.QuickRepeat>
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
													<input required title="Search query" name="query" type="text" class="form-control" placeholder="Search ${core_controller.result.quickLinks.domain}&hellip;">
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
						<#--	/ResultQuicklinks -->

						<#-- Display the result summary -->
						<#if core_controller.result.summary??>
						<div class="search-summary">
								<#noescape>
									<@base_controller.Linkify>${core_controller.result.summary}</@base_controller.Linkify>
								</#noescape>
						</div>
						</#if>

						<#-- Metadata summary based on fields mapped to the metadata "c" -->
						<#if core_controller.result.metaData["c"]??>
						<div class="search-summary">
								<#noescape>
									<@base_controller.Linkify>${core_controller.result.metaData["c"]}</@base_controller.Linkify>
								</#noescape>
						</div>
						</#if>

						<#-- ResultCollaspe Generate the result collapsing link -->
						<@core_controller.Collapsed>
							<div class="search-collapsed">
								<small>
									<span class="glyphicon glyphicon-expand text-muted"></span>&nbsp;
									<a class="search-collapsed" href="<@core_controller.CollapsedUrl />">
										<!-- Message for exact count -->
										<@core_controller.CollapsedLabel>
											<@core_controller.CollapsedCount /> very similar results
										</@core_controller.CollapsedLabel>

										<!-- Alternative message for approximate count -->
										<@core_controller.CollapsedApproximateLabel>
											About <@core_controller.CollapsedCount /> very similar results
										</@core_controller.CollapsedApproximateLabel>
									</a>
								</small>
							</div>
						</@core_controller.Collapsed>
						<#-- /ResultCollaspe -->

						<#-- ResultMetadataSummary -->
						<#if core_controller.result.metaData["a"]?? || core_controller.result.metaData["s"]?? || core_controller.result.metaData["p"]??>
							<dl class="dl-horizontal text-muted">
								<#if core_controller.result.metaData["a"]??>
									<dt>by</dt>
									<dd>${core_controller.result.metaData["a"]!?replace("|", ", ")}</dd>
								</#if>
								<#if core_controller.result.metaData["s"]??>
									<dt>Keywords:</dt>
									<dd>${core_controller.result.metaData["s"]!?replace("|", ", ")}</dd>
								</#if>
								<#if core_controller.result.metaData["p"]??>
									<dt>Publisher:</dt>
									<dd>${core_controller.result.metaData["p"]!?replace("|", ", ")}</dd>
								</#if>
							</dl>
						</#if>
						<#-- /ResultMetadataSummary	-->
					</div>
					<div class="modal-footer">
						<#--	Result tools -->
						<div class="btn-group">
							<div class="btn-group">
								<button href="#" class="dropdown-toggle btn btn-default" data-toggle="dropdown" title="More actions&hellip;"><small class="glyphicon glyphicon-chevron-down text-success"></small>
									<span class="sr-only">Result tools</span>
								</button>
								<ul class="dropdown-menu">
									<li>
										<#-- General the cache link which is used to display the version of the document when it was crawled -->
										<#if core_controller.result.cacheUrl??>
											<a href="${core_controller.result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="Cached version of ${core_controller.result.title} (${core_controller.result.rank})">Cached</a>
										</#if>
									</li>
									<#-- Generate the explore url which is used to find similar results -->
									<@core_controller.Explore>
										<li>
											<a class="fb-explore" href="<@core_controller.ExploreUrl />" alt="Related results"> Explore </a>
										</li>
									</@core_controller.Explore>
									<#-- Show the optimise button when viewed from the admin UI -->
									<@core_controller.Optimise>
										<li>
											<a class="search-optimise" href="<@core_controller.OptimiseUrl />">
												Optimise
											</a>
										</li>
									</@core_controller.Optimise>
								</ul>
							</div>

							<#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
								<button data-ng-click="toggle()" data-cart-link data-css="pushpin|remove" title="{{label}}" class="btn btn-default">
									<small class="glyphicon glyphicon-{{css}}"></small> <span class="sr-only">Save to Cart</span>
								</button>
							</#if>

							<a href="${core_controller.result.clickTrackingUrl!}" class="btn btn-default" title="View '${core_controller.result.liveUrl!}'">
								<i class="fa fa-external-link"></i> <span class="sr-only">View '${core_controller.result.liveUrl!}</span>
							</a>

							<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>

							<#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(core_controller.result.indexUrl)??>
								<a title="Click history" href="#" class="text-warning btn btn-default" data-ng-click="toggleHistory()">
									<small class="text-warning">
										<span class="glyphicon glyphicon-time"></span>
										Last visited ${prettyTime(session.getClickHistory(core_controller.result.indexUrl).clickDate)}
									</small>
								</a>
							</#if>
						</div>
						<#-- /ResultTools -->
					</div>
				</div><#-- /modal-content-->
			</div><#-- /modal-dialog -->
		</div><#-- /modal -->
</#macro>
<#-- /ResultDefaultModal-->
<#-- @end --><#-- / Category - Result -->
</#escape>
