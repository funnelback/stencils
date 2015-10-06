<#ftl encoding="utf-8" />
<#---
	 <p>Provides views for Courses components.</p>
	 <p>These compontents include items such as ...</p>
	 <p>...</p>

	 <h2>Table of Contents</h2>
	 <ul>
		 <li><strong>Configuration:</strong> Configuration options.</li>
		 <li><strong>Results:</strong></li>
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
<#assign stencils=["core","base"] />
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
	<#-- <link rel="stylesheet" href="${coursesResourcesPrefix}css/courses.css"> -->
</#macro>

<#---
	JavaScript dependencies
 -->
<#macro JS>
	<!-- courses.view.ftl :: JS -->
	<#-- This commented out because stencils.courses.js is not required currently -->
	<#-- <script src="${coursesResourcesPrefix}js/stencils.courses.js"></script> -->
</#macro>
<#-- @end --><#-- /Configuration -->
<#-- ###################  Views ####################### -->

<#-- @begin  Result -->
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
<div class="panel panel-default">
	<div class="panel-heading" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
		<#-- ResultTitle -->
		<h4>
			<a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl}">
				<@core_controller.boldicize>
					<@core_controller.Truncate length=70>${core_controller.result.metaData.stencilsCoursesName}</@core_controller.Truncate>
					<#if core_controller.result.metaData.stencilsCoursesCode??><small class="badge">${core_controller.result.metaData.stencilsCoursesCode}</small></#if>
				</@core_controller.boldicize>
			</a>
		</h4>
		<#if core_controller.result.metaData.stencilsCoursesLevel??><small class="text-muted"><em>
			${core_controller.result.metaData.stencilsCoursesLevel}
		</em></small></#if>

		<#-- /ResultTitle -->
	</div>
	<#-- /panel-heading -->
	<div class="panel-body" data-mh="group-body-${base_controller.resultsColumnsIndex!}">

		<#-- Course details -->
		<div class="text-muted">
			<small>Study</small>

			<#if core_controller.result.metaData.stencilsCoursesMode??>
			<small>
				 as <i class="fa fa-info-circle"></i> <strong>${core_controller.result.metaData.stencilsCoursesMode}</strong>
			</small>
			</#if>

			<#if core_controller.result.metaData.stencilsCoursesCampus??>
			<small>
				at <i class="fa fa-map-marker"></i> <strong>${core_controller.result.metaData.stencilsCoursesCampus} Campus</strong>
			</small>
			</#if>

			<#if core_controller.result.metaData.stencilsCoursesDuration??><br><small><em>
				<i class="fa fa-clock-o"></i> ${core_controller.result.metaData.stencilsCoursesDuration}
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
						<#-- ResultTitle -->
						<h4>
							<a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl}">
								<@core_controller.boldicize>
									<@core_controller.Truncate length=70>${core_controller.result.metaData.stencilsCoursesName}</@core_controller.Truncate>
									<#if core_controller.result.metaData.stencilsCoursesCode??><small class="badge">${core_controller.result.metaData.stencilsCoursesCode}</small></#if>
								</@core_controller.boldicize>
							</a>
						</h4>
						<#if core_controller.result.metaData.stencilsCoursesLevel??><small class="text-muted"><em>
							${core_controller.result.metaData.stencilsCoursesLevel}
						</em></small></#if>

						<#-- /ResultTitle -->
					</div>
					<div class="modal-body">
						<#-- Course details -->
						<div class="text-muted">
							<small>Study</small>

							<#if core_controller.result.metaData.stencilsCoursesMode??>
							<small>
								 as <i class="fa fa-info-circle"></i> <strong>${core_controller.result.metaData.stencilsCoursesMode}</strong>
							</small>
							</#if>

							<#if core_controller.result.metaData.stencilsCoursesCampus??>
							<small>
								at <i class="fa fa-map-marker"></i> <strong>${core_controller.result.metaData.stencilsCoursesCampus} Campus</strong>
							</small>
							</#if>

							<#if core_controller.result.metaData.stencilsCoursesDuration??><br><small><em>
								<i class="fa fa-clock-o"></i> ${core_controller.result.metaData.stencilsCoursesDuration}
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
