
<#ftl encoding="utf-8" />
<#---
	 <p>Provides views for Courses components.</p>
	 <p>These compontents include items such as ...</p>
	 <p>...</p>

	 <h2>Table of Contents</h2>
	 <ul>
		 <li><strong>Configuration:</strong> Configuration options.</li>
		 <li><strong>Result Course: Views for course type results.</strong></li>
	 </ul>
-->
<#escape x as x?html>

<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign coursesResourcesPrefix = "/stencils/resources/courses/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${librariesPrefix}courses/controllers/courses.controller.ftl" as courses_controller/>

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core","base","collapsedresult"] />
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
	<!-- courses.view.ftl :: CSS -->
	<#-- This commented out because courses.css is not required currently -->
	<#-- <link rel="stylesheet" href="${coursesResourcesPrefix}css/courses.css"> -->
</#macro>

<#---
	JavaScript dependencies
 -->
<#macro JS>
	<!-- courses.view.ftl :: JS -->
	<#-- This commented out because courses.js is not required currently -->
	<#-- <script src="${coursesResourcesPrefix}js/stencils.courses.js"></script> -->
</#macro>
<#-- @end --><#-- /Configuration -->
<#-- ###################  Views ####################### -->

<#-- @begin  Result (Course)  -->

<#---
	Template view for Search Result as a course.

	<h2>Data Model</h2>
		<p><strong>core_controller.result ;</strong></p>
		<ul>
			<li>...</li>
		</ul>
		<p><strong>core_controller.result.metaData ;</strong></p>
		<ul>
			<li><strong>	c (description) :</strong> course summary.</li>
			<li><strong>stencilsCoursesDuration</strong></li>
			<li><strong>stencilsCoursesLevel</strong></li>
			<li><strong>stencilsCoursesCampus</strong></li>
			<li><strong>stencilsCoursesName</strong></li>
			<li><strong>stencilsCoursesCode</strong></li>
			<li><strong>stencilsCoursesMode</strong></li>
		</ul>
		<p><strong>courses_controller ;</strong></p>

	@requires core_controller.Results
-->
<#macro Result>
<!-- base.view.ftl :: ResultPanel -->
<div id="result-${core_controller.result.rank!}" class="panel panel-default stencils-progressive-disclosure">
	<div class="panel-heading no-padding" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
		<a class="js-stencils-popout panel-heading-clickable"
			data-toggle="collapse" data-parent="[data-fb-result]" href="#result-open-${core_controller.result.rank!}"
			data-stencils-popout-target="#result-${core_controller.result.rank!}" data-stencils-popout-group="results" >
		<#-- ResultTitle -->

			<div class="stencils-print__hide pull-right
				stencils-progressive-disclosure__hiddenBlock stencils-progressive-disclosure__hiddenBlock--showOnSelected
				stencils-progressive-disclosure__hiddenBlock-showOnHover stencils-animation--fade-in-on-hover" >
					 <span class="stencils-popout__hide-when-selected">Expand</span>
					 <span class="stencils-hide stencils-popout__show-when-selected">Close</span>
					 <i class="fa fa-expand"></i>
			</div>

			<h4>
					<@core_controller.boldicize>
						<@core_controller.Truncate length=70>${core_controller.result.metaData.stencilsCoursesName!}</@core_controller.Truncate>
					</@core_controller.boldicize>
					<#if core_controller.result.metaData.stencilsCoursesCode??>
					 <@core_controller.boldicize><small class="badge">${core_controller.result.metaData.stencilsCoursesCode!}</small></@core_controller.boldicize>
					</#if>
			</h4>
			<#if core_controller.result.metaData.stencilsCoursesLevel??><small class="text-muted"><em>
				${core_controller.result.metaData.stencilsCoursesLevel!}
			</em></small></#if>
		</a>
		<#-- /ResultTitle -->
	</div>

	<#-- /panel-heading -->
	<div class="panel-body no-padding-bottom" data-mh="group-body-${base_controller.resultsColumnsIndex!}">

		<#-- Display the result summary -->
		<#if core_controller.result.summary?has_content>
			<p>
				<span class="search-summary">
					<@core_controller.boldicize>
						<#noescape>
							<@core_controller.Truncate length=255>${core_controller.result.summary}</@core_controller.Truncate>
						</#noescape>
					</@core_controller.boldicize>
				</span>
			</p>
		</#if>

		<#-- Metadata summary based on fields mapped to the metadata "c" -->
		<#if core_controller.result.metaData["c"]?has_content><p><@core_controller.boldicize><@core_controller.Truncate length=255>${core_controller.result.metaData["c"]!}</@core_controller.Truncate></@core_controller.boldicize></p></#if>

	</div>

	<div id="result-open-${core_controller.result.rank}" class="panel-body panel-collapse collapse">

		<#-- Course details -->
		<div class="text-muted">
			<small>Study</small>

			<#if core_controller.result.metaData.stencilsCoursesMode??>
			<small>
				 as <i class="fa fa-info-circle"></i> <strong>${core_controller.result.metaData.stencilsCoursesMode!}</strong>
			</small>
			</#if>

			<#if core_controller.result.metaData.stencilsCoursesCampus??>
			<small>
				at <i class="fa fa-map-marker"></i> <strong>${core_controller.result.metaData.stencilsCoursesCampus!} Campus</strong>
			</small>
			</#if>

			<#if core_controller.result.metaData.stencilsCoursesDuration??><br><small><em>
				<i class="fa fa-clock-o"></i> ${core_controller.result.metaData.stencilsCoursesDuration!}
			</em></small></#if>
		</div>

		<#-- ResultThumbnail -->
		<#if core_controller.result.metaData.stencilsCoreThumbnailUrl?? >
			<img src="${core_controller.result.metaData.stencilsCoreThumbnailUrl!}" class="stencils-core-result-thumbnail pull-right" alt="${core_controller.result.metaData.c!}" />
		</#if>
		<#-- /ResultThumbnail -->

		<#--	ResultQuicklinks -->
		<@core_controller.Quicklinks>
			<ul class="list-inline stencils-print__hide">
					<@core_controller.QuickRepeat><li><a href="${core_controller.ql.url}" title="${core_controller.ql.text}">${core_controller.ql.text}</a></li></@core_controller.QuickRepeat>
			</ul>
			<#if question.collection.quickLinksConfiguration["quicklinks.domain_searchbox"]??
			&& question.collection.quickLinksConfiguration["quicklinks.domain_searchbox"] == "true">
				<#if core_controller.result.quickLinks.domain?matches("^[^/]*/?[^/]*$", "r")>
					<form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" role="search" class="stencils-print__hide">
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
	</div>
	<#-- /panel-body -->

	<div class="panel-body no-padding-top">
		<@CollapsedResults />
	</div>

	<div class="panel-footer">
		<#--	Result tools -->
		<div class="row stencils-progressive-disclosure__hiddenBlock stencils-progressive-disclosure__hiddenBlock--showOnSelected stencils-progressive-disclosure__hiddenBlock-showOnHover stencils-animation--fade-in-on-hover">
			<div class="btn-group col-md-8">
				<div class="btn-group stencils-print__hide">
					<button class="dropdown-toggle btn btn-default" data-toggle="dropdown" title="More actions&hellip;"><small class="glyphicon glyphicon-chevron-down text-success"></small>
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
					<button data-ng-click="toggle()" data-cart-link data-css="pushpin|remove" title="{{label}}" class="btn btn-default stencils-print__hide">
						<small class="glyphicon glyphicon-{{css}}"></small> <span class="sr-only">Save to shortlist</span>
					</button>
				</#if>

				<#-- Open modal -->
				<button class="btn btn-default stencils-print__hide" data-toggle="modal" data-target="#result-modal-${core_controller.result.rank!}" title="Expanded view">
					<i class="fa fa-newspaper-o"></i> <span class="sr-only">Expanded view</span>
				</button>

				<#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(core_controller.result.indexUrl)??>
					<a title="Click history" href="#" class="text-warning btn btn-default stencils-print__hide" data-ng-click="toggleHistory()">
						<small class="text-warning">
							<span class="glyphicon glyphicon-time"></span>
							Last visited ${prettyTime(session.getClickHistory(core_controller.result.indexUrl).clickDate)}
						</small>
					</a>
				</#if>

				<a href="${core_controller.result.clickTrackingUrl!}" class="btn btn-default stencils-print__show-title" title="'${core_controller.result.liveUrl!}'">
					<i class="fa fa-external-link"></i> <span >View Course</span>
				</a>
			</div>
			<#-- /ResultTools -first column -->

			<div class="col-md-4 stencils-print__hide">
				<@base_view.ShareTools url=core_controller.result.liveUrl! title=core_controller.result.metaData.stencilsCoursesName! />
			</div>
			<#-- /ResultTools - second column -->
		</div><#-- / ResultTools - Wrapper for Progressive discolure -->
	</div><#-- /panel-footer -->
</div>
</#macro>
<#-- /ResultPanel-->

<#---
	Template view for search result modal.
-->
<#macro ResultModal>
<!-- base.view.ftl :: ResultDefaultModal -->
<div data-fb-result="${core_controller.result.liveUrl!}" class="modal fade ng-scope" id="result-modal-${core_controller.result.rank!}" tabindex="-1" role="dialog" aria-labelledby="result-modal-${core_controller.result.rank!}" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="btn btn-default pull-right" data-dismiss="modal"><i class="fa fa-times"></i> Close</button>
				<#-- ResultTitle -->
				<h4>
					<a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl}">
						${core_controller.result.metaData.stencilsCoursesName!}
					</a>
						<#if core_controller.result.metaData.stencilsCoursesCode??>
						 <small class="badge">${core_controller.result.metaData.stencilsCoursesCode!}</small>
						</#if>
				</h4>
				<#-- /ResultTitle -->
			</div>
			<div class="modal-body">
				<#-- Course details -->
				<div class="text-muted">
					<small>Study</small>

					<#if core_controller.result.metaData.stencilsCoursesMode??>
					<small>
						 as <i class="fa fa-info-circle"></i> <strong>${core_controller.result.metaData.stencilsCoursesMode!}</strong>
					</small>
					</#if>

					<#if core_controller.result.metaData.stencilsCoursesCampus??>
					<small>
						at <i class="fa fa-map-marker"></i> <strong>${core_controller.result.metaData.stencilsCoursesCampus!} Campus</strong>
					</small>
					</#if>

					<#if core_controller.result.metaData.stencilsCoursesDuration??><br><small><em>
						<i class="fa fa-clock-o"></i> ${core_controller.result.metaData.stencilsCoursesDuration!}
					</em></small></#if>
				</div>

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

				<@CollapsedResults />
			</div>
			<#-- /Modal Body -->
			<div class="modal-footer">
				<#--	Result tools -->
				<div class="row">
					<div class="col-md-8 btn-group">
						<div class="btn-group">
							<button class="dropdown-toggle btn btn-default" data-toggle="dropdown" title="More actions&hellip;"><small class="glyphicon glyphicon-chevron-down text-success"></small>
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
								<small class="glyphicon glyphicon-{{css}}"></small> <span class="sr-only">Save to shortlist</span>
							</button>
						</#if>

						<a href="${core_controller.result.clickTrackingUrl!}" class="btn btn-default" title="View '${core_controller.result.liveUrl!}'">
							<i class="fa fa-external-link"></i> <span >View Course</span>
						</a>

						<#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(core_controller.result.indexUrl)??>
							<a title="Click history" href="#" class="text-warning btn btn-default" data-ng-click="toggleHistory()">
								<small class="text-warning">
									<span class="glyphicon glyphicon-time"></span>
									Last visited ${prettyTime(session.getClickHistory(core_controller.result.indexUrl).clickDate)}
								</small>
							</a>
						</#if>
					</div>
					<#-- /ResultTools -first column -->
					<div class="col-md-4">
						<@base_view.ShareTools url=core_controller.result.liveUrl! title=core_controller.result.metaData.stencilsCoursesName! />
					</div>
					<#-- /ResultTools - second column -->
				</div> <#-- /ResultTools - Wrapper-->
			</div><#-- /ResultTools -->
		</div><#-- /modal-content-->
	</div><#-- /modal-dialog -->
</div><#-- /modal -->
</#macro>
<#-- /ResultDefaultModal-->
<#-- @end --><#-- / Category - Result (Course) -->

<#-- @begin Result Collasping  -->
<#---
	View for Collapsed Results
  -->
<#macro CollapsedResults>
<#--  course.view.ftl::CollapsedResults -->
<#-- ResultCollaspe Generate the result collapsing link -->
	<@collapsedresult_controller.Collapsed>
	<div class="search-collapsed row" id="search-collapsed-modal-${core_controller.result.rank}">

		<h5>
			<a data-toggle="collapse" data-parent="#search-collapsed-modal-${core_controller.result.rank}" href="#collapseOne-modal-${core_controller.result.rank}">
				<span class="glyphicon glyphicon-expand text-muted"></span>&nbsp;
				<small>
				<!-- Message for exact count -->
				<@collapsedresult_controller.CollapsedHasExactCount>
					<@core_controller.CollapsedCount /> very similar courses
				</@collapsedresult_controller.CollapsedHasExactCount>

				<!-- Alternative message for approximate count -->
				<@collapsedresult_controller.CollapsedHasExactCount negate=true>
					About <@core_controller.CollapsedCount /> very similar courses
				</@collapsedresult_controller.CollapsedHasExactCount>
				</small>
			</a>
		</h5>

		<div id="collapseOne-modal-${core_controller.result.rank}" class="panel-collapse collapse">
			<div class="list-group ">
				<@CollapsedResult />
			</div>

			<@collapsedresult_controller.ResultsHasMoreResults>
			<div class="pull-right" style="margin-top:0.5em">
				<a class="search-collapsed  btn btn-default" href="<@core_controller.CollapsedUrl />">See all similar courses</a>
			</div>
			</@collapsedresult_controller.ResultsHasMoreResults>
		</div>
	</div>
	</@collapsedresult_controller.Collapsed>
</#macro>
<#---
	View of a collapsed result
	-->
<#macro CollapsedResult>
<#--  course.view.ftl::CollaspedResult -->
	<@collapsedresult_controller.Results>
	<a class="list-group-item col-md-3" data-mh="collapsed-result" href="${collapsedresult_controller.result.clickTrackingUrl}" title="${collapsedresult_controller.result.liveUrl}">
		<#-- ResultTitle -->
		<h6 class="list-group-item-heading">
			<@core_controller.boldicize>
				<@core_controller.Truncate length=70>${collapsedresult_controller.result.metaData.stencilsCoursesName!}</@core_controller.Truncate>
			</@core_controller.boldicize>
		</h6>

		<#if collapsedresult_controller.result.metaData.stencilsCoursesCode??>
		<div>
		 <@core_controller.boldicize><small class="badge">${collapsedresult_controller.result.metaData.stencilsCoursesCode!}</small></@core_controller.boldicize>
	 	</div>
		</#if>
		<#if collapsedresult_controller.result.metaData.stencilsCoursesLevel??>
		<div>
			<small class="text-muted">
				<em>${collapsedresult_controller.result.metaData.stencilsCoursesLevel!}</em>
			</small>
		</div>
		</#if>

	</a>
	</@collapsedresult_controller.Results>
</#macro>
<#-- @end -->
<#--  / Catgegory - Result Collasping -->

</#escape>
