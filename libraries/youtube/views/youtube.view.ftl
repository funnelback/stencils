<#ftl encoding="utf-8" />
<#-- DEPRECATED - This file has been deprecated. Please avoid using this file going forward -->
<#---
	<p>Provides views for YouTube components.</p>
	<p>These compontents include items such as result formats for YouTube videos.</p>

	<h2>Table of Contents</h2>
	<ul>
		<li><strong>Configuration:</strong> Configuration options for YouTube Stencil.</li>
		<li><strong>General:</strong> General YouTube helpers.</li>
		<li><strong>Result YouTube:</strong>  YouTube video result format.</li>
	</ul>
-->
<#escape x as x?html>


<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign youtubeResourcesPrefix = "/stencils/resources/youtube/v14.2.0/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import controller -->
<#import "${librariesPrefix}youtube/controllers/youtube.controller.ftl" as youtube_controller/>

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
	<!-- youtube.view.ftl :: CSS -->
	<link rel="stylesheet" href="${youtubeResourcesPrefix}css/youtube.css">
</#macro>

<#---
	JavaScript dependencies
 -->
<#macro JS>
	<!-- youtube.view.ftl :: JS -->
	<#-- This commented out because stencils.youtube.js is not required currently -->
	<#-- <script src="${youtubeResourcesPrefix}js/stencils.youtube.js"></script> -->
</#macro>
<#-- @end --><#-- /Cateogry - Configuration -->
<#-- ################### Views ####################### -->
<#-- @begin General -->
<#---
	View for YouTube link.
-->
<#macro YoutubeLink>
	<!-- youtube.view.ftl :: YoutubeLink -->
	<i class="fab fa-youtube-square"></i> <a href="https://www.youtube.com/">Youtube</a>
</#macro>

<#-- @end --><#-- /Categroy - General -->
<#-- @begin Result (Youtube Video) -->

<#---
	View for search result type of Youtube 'video'.

	<h3>Data Model</h3>

	<p><strong>core_controller.result ;</strong></p>
	<ul>
		<li><strong>title :</strong> Name of video.</li>
		<li><strong>date :</strong> Video's created datetime.</li>
	</ul>
	<p><strong>core_controller.result.metaData ;</strong></p>
	<ul>
		<li><strong>a (author) :</strong> Youtube Channel Title</li>
		<li><strong>c (description) :</strong> Video Description.</li>
		<li><strong>stencilsYoutubeViewCount</strong></li>
		<li><strong>stencilsYoutubeLikes</strong></li>
		<li><strong>stencilsYoutubeDislikes</strong></li>
		<li><strong>stencilsYoutubeCategory</strong></li>
		<li><strong>stencilsYoutubeDurationInSeconds</strong></li>
		<li><strong>stencilsYoutubeDurationPretty</strong></li>
		<li><strong>stencilsYoutubeThumbNailUrl</strong></li>
		<li><strong>stencilsYoutubeLatlong</strong></li>
		<li><strong>stencilsYoutubeID</strong></li>
		<li><strong>stencilsYoutubeEmbedHtml</strong></li>
		<li><strong>stencilsYoutubeThumbNailUrlHigh</strong></li>
		<li><strong>stencilsYoutubeThumbNailUrlUrlMed</strong></li>
		<li><strong>stencilsYoutubeChannelID</strong></li>
		<li><strong>stencilsYoutubeChannelUrl</strong></li>
	</ul>
-->
<#macro Result>
	<@youtube_controller.Video>
	<!-- youtube.view.ftl :: Result -->
		<div id="result-${core_controller.result.rank!}" class="panel panel-default stencils-progressive-disclosure">

			<div class="panel-heading" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
				<div><@YoutubeChannel /></div>
				<small class="text-muted">
					<i class="fas fa-pencil-alt"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@YoutubeLink />
				</small>
			</div>

			<div class="panel-body" data-mh="group-body-${base_controller.resultsColumnsIndex!}">
				<h4>
					<span class="sr-only">YouTube Video:</span>
					<a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl!}">${core_controller.result.title}</a>
				</h4>

				<p class="text-muted small">
				<@VideoInformation />
				</p>

				<#if core_controller.result.metaData.stencilsYoutubeThumbNailUrlUrlMed?? >
					<img src="${core_controller.result.metaData.stencilsYoutubeThumbNailUrlUrlMed!}" class="stencils-core-thumbnail pull-right" alt="${core_controller.result.metaData.c!}" />
				</#if>

				<span class="search-summary"><@core_controller.boldicize><@core_controller.Truncate length=200>${core_controller.result.metaData.c!}</@core_controller.Truncate></@core_controller.boldicize></span>
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

			<div class="panel-footer">
				<#--	Result tools -->
				<div class="row stencils-progressive-disclosure__hiddenBlock stencils-progressive-disclosure__hiddenBlock--showOnSelected stencils-progressive-disclosure__hiddenBlock-showOnHover stencils-animation--fade-in-on-hover">
					<div class="btn-group col-md-8">
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
										<a class="fb-explore" href="<@core_controller.ExploreUrl />" title="Related results"> Explore </a>
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
							<i class="fas fa-external-link-alt"></i> <span class="sr-only">View '${core_controller.result.liveUrl!}</span>
						</a>

						<#-- Open modal -->
						<button class="btn btn-primary" data-toggle="modal" data-target="#result-modal-${core_controller.result.rank!}" title="Expanded view">
							<i class="fas fa-newspaper"></i> <span class="sr-only">Expanded view</span>
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
				</div>
				<#-- /ResultTools -->
			</div>
		</div>
	</@youtube_controller.Video >
</#macro>
<#-- /Result-->

<#---
	Modal view for search result type of Youtube 'video'.

	<h3>Data Model</h3>

	<p><strong>core_controller.result ;</strong></p>
	<ul>
		<li><strong>title :</strong> Name of video.</li>
		<li><strong>date :</strong> Video's created datetime.</li>
	</ul>
	<p><strong>core_controller.result.metaData ;</strong></p>
	<ul>
		<li><strong>a (author) :</strong> Youtube Channel Title</li>
		<li><strong>c (description) :</strong> Video Description.</li>
		<li><strong>stencilsYoutubeViewCount</strong></li>
		<li><strong>stencilsYoutubeLikes</strong></li>
		<li><strong>stencilsYoutubeDislikes</strong></li>
		<li><strong>stencilsYoutubeCategory</strong></li>
		<li><strong>stencilsYoutubeDurationInSeconds</strong></li>
		<li><strong>stencilsYoutubeDurationPretty</strong></li>
		<li><strong>stencilsYoutubeThumbNailUrl</strong></li>
		<li><strong>stencilsYoutubeLatlong</strong></li>
		<li><strong>stencilsYoutubeID</strong></li>
		<li><strong>stencilsYoutubeEmbedHtml</strong></li>
		<li><strong>stencilsYoutubeThumbNailUrlHigh</strong></li>
		<li><strong>stencilsYoutubeThumbNailUrlUrlMed</strong></li>
		<li><strong>stencilsYoutubeChannelID</strong></li>
		<li><strong>stencilsYoutubeChannelUrl</strong></li>
	</ul>
-->
<#macro ResultModal>
	<@youtube_controller.Video>
	<!-- youtube.view.ftl :: ResultModal -->
		<div data-fb-result="${core_controller.result.liveUrl!}" class="modal fade ng-scope" id="result-modal-${core_controller.result.rank!}" tabindex="-1" role="dialog" aria-labelledby="result-${core_controller.result.rank!}" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<div><@YoutubeChannel /></div>
						<small class="text-muted">
							<i class="fas fa-pencil-alt"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@YoutubeLink />
						</small>
					</div>
					<div class="modal-body">
						<div class="stencils-youtube-video-iframe"><#noescape>${core_controller.result.metaData.stencilsYoutubeEmbedHtml!}</#noescape></div>
						<h4>
							<span class="sr-only">YouTube Video:</span>
							<a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl!}">${core_controller.result.title}</a>
						</h4>
						<p class="text-muted small">
						<@VideoInformation />
						</p>

						<span class="search-summary"><@base_controller.Linkify>${core_controller.result.metaData.c!}</@base_controller.Linkify></span>
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
					<#-- /modal-body -->
					<div class="modal-footer">
						<#--	Result tools -->
						<div class="btn-group">
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
											<a class="fb-explore" href="<@core_controller.ExploreUrl />" title="Related results"> Explore </a>
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
								<i class="fas fa-external-link-alt"></i> <span class="sr-only">View '${core_controller.result.liveUrl!}</span>
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
	</@youtube_controller.Video >
</#macro>
<#-- /ResultModal-->

<#---
	View for Youtube Video as an embeded video element.

	NOTE: Not currently implemented.
-->
<#macro ResultEmbed>
<@youtube_controller.Video>
	<#-- <iframe width="100%" height="350" src="https://www.youtube.com/embed/${core_controller.result.metaData.id}" frameborder="0" allowfullscreen></iframe>

	 <p>
					<small class="text-muted"><i class="fab fa-youtube"></i> <a href="https://www.youtube.com/">Youtube</a> &bull;</small>
					<small class="text-muted">${core_controller.result.metaData.viewCount} views &bull;</small>
					<#if core_controller.result.date??>
						<small class="text-muted" data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime}">${core_controller.result.date?date?string("d MMM yyyy")}
						</small>
					</#if>
					<small class="text-muted">:</small>
					<#if core_controller.result.metadatadescription??><span class="search-summary">${core_controller.result.metaData.description}</span> </#if>
				</p>
				<hr> -->
</@youtube_controller.Video>
</#macro>
<#-- /ResultEmbed-->
<#---
	Format for YouTube channel.
	@requires youtube_controller.Video
-->
<#macro YoutubeChannel>
	<!-- youtube.view.ftl :: YoutubeChannel -->
	 <a href="${core_controller.result.metaData.stencilsYoutubeChannelUrl}"><@core_controller.boldicize>${core_controller.result.metaData.a}</@core_controller.boldicize></a>
</#macro>

<#---
	View for Displaying Information about the video.
	@requires youtube_controller.Video
-->
<#macro VideoInformation>
	<!-- youtube.view.ftl :: VideoInformation -->
	<#if core_controller.result.metaData.stencilsYoutubeViewCount?? >
		${core_controller.result.metaData.stencilsYoutubeViewCount} views &bull;
	</#if>
	<#if core_controller.result.metaData.stencilsYoutubeLikes?? >
		${core_controller.result.metaData.stencilsYoutubeLikes} <i class="far fa-thumbs-up"><span class="sr-only">likes</span></i>
	</#if>
	<#if core_controller.result.metaData.stencilsYoutubeDislikes?? >
		 ${core_controller.result.metaData.stencilsYoutubeDislikes} <i class="far fa-thumbs-down"><span class="sr-only">dislikes</span></i> &bull;
	</#if>
	<#if core_controller.result.metaData.stencilsYoutubeCategory?? >
		${core_controller.result.metaData.stencilsYoutubeCategory} <span class="sr-only">category</span> &bull;
	</#if>
	<#if core_controller.result.metaData.stencilsYoutubeDurationPretty?? >
		${core_controller.result.metaData.stencilsYoutubeDurationPretty} <i class="far fa-clock"><span class="sr-only">duration</span></i>
	</#if>

</#macro>

<#-- @end --><#-- /Category - Result (Youtube Video) -->

<#-- @begin Cart -->

<#---
	Displays the session cart.

	The cart feature allows users to save inidividual search results so
	that they viewed later and compared side by side.

	This has been altered to be a shortlist view.
-->
<#macro Cart>
	<!-- core.controller.ftl :: Cart -->
	<#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
		<div id="search-cart" data-ng-cloak data-ng-show="isDisplayed('cart')" data-ng-controller="CartCtrl">
			<div class="row">
				<div class="col-md-12">
					<a href="#" data-ng-click="hideCart()"><span class="glyphicon glyphicon-arrow-left"></span> Back to results</a>
					<h2><i class="far fa-heart"></i> Favourites
						<button class="btn btn-danger btn-xs" title="Clear selection" data-ng-click="clear('Your selection will be cleared')"><span class="glyphicon glyphicon-remove"></span> Clear</button>
					</h2>

					<ul class="list-unstyled">
						<li data-ng-repeat="item in cart">
								<@CartResult />
						</li>
					</ul>
				</div>
			</div>
		</div>
	</#if>
</#macro>


<#---
	View for result format in cart. Uses angular templating.
  -->
<#macro CartResult>
	<h4>
		<a title="Remove" data-ng-click="remove(item.indexUrl)" href="javascript:;"><small class="glyphicon glyphicon-remove"></small></a>
		<a data-ng-href="{{item.indexUrl}}" data-ng-show="item.title" title="{{item.indexUrl}}">YouTube Video: {{item.title}}</a>
	</h4>
	<p data-ng-hide="!item.summary">{{item.summary|truncate:255}}</p>
	<p data-ng-hide="!item.metaData.c">{{item.metaData.c|truncate:255}}</p>
</#macro>

<#-- @end -->
<#-- / Category - Cart -->


</#escape>
