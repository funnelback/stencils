<#ftl encoding="utf-8" />
<#---
	<p>Provides views for Flickr components.</p>
 	<p>These compontents include items such as result formats for Flickr pcitures.</p>

 	<h2>Table of Contents</h2>
 	<ul>
 		<li><strong>Configuration:</strong> Configuration options for Flickr Stencil.</li>
 		<li><strong>General:</strong> General facebook helpers.</li>
 		<li><strong>Result Picutre:</strong>  Flickr picture result format.</li>
 	</ul>
-->
<#escape x as x?html>
<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign flickrResourcesPrefix = "/stencils/resources/flickr/v14.2.0/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${librariesPrefix}flickr/controllers/flickr.controller.ftl" as flickr_controller/>

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
	<!-- flickr.view.ftl :: CSS -->
	<link rel="stylesheet" href="${flickrResourcesPrefix}css/flickr.css">
</#macro>

<#---
	JavaScript dependencies
 -->
<#macro JS>
	<!-- flickr.view.ftl :: JS -->
	<#-- This commented out because stencils.flickr.js is not required currently -->
	<#-- <script src="${flickrResourcesPrefix}js/stencils.flickr.js"></script> -->
</#macro>
<#-- @end --><#-- /Configuration -->
<#-- ################### Views ####################### -->
<#-- @begin General -->
<#---
	Format for Flickr link.
-->
<#macro FlickrLink>
	<!-- twitter.view.ftl :: TwitterLink -->
	<i class="fab fa-flickr"></i> <a href="https://www.flickr.com/">Flickr</a>
</#macro>
<#-- @end --><#-- / Category - Result General -->

<#-- @begin  Result Picture -->
<#---
	View for search result type of flickr 'image'.

	<h2>Data Model</h2>
		<p><strong>core_controller.result ;</strong></p>
		<ul>
			<li><strong>title :</strong> Photo title.</li>
		</ul>
		<p><strong>core_controller.result.metaData ;</strong></p>
		<ul>
			<li><strong>a (author) :</strong> Photo Owner Full Name.</li>
			<li><strong>	c (description) :</strong> Photo description.</li>
			<li><strong>stencilsFlickrPhotoID</strong></li>
			<li><strong>stencilsFlickrPhotoOwnerUserName</strong></li>
			<li><strong>stencilsFlickrPhotoThumbNailUrl</strong></li>
			<li><strong>stencilsFlickrPhotoSmallImage320Url</strong></li>
			<li><strong>stencilsFlickrPhotoSmallImageSquareUrl</strong></li>
			<li><strong>stencilsFlickrPhotoMediumImageUrl</strong></li>
			<li><strong>stencilsFlickrPhotoMediumImage640Url</strong></li>
			<li><strong>stencilsFlickrPhotoMediumImage800Url</strong></li>
			<li><strong>stencilsFlickrPhotoLargeImageUrl</strong></li>
		</ul>
		<p><strong>flickr_controller ;</strong></p>
		<ul>
			<li><strong>pictureUserProfileUrl</strong></li>
		</ul>
 -->
<#macro Result>
	<@flickr_controller.Picture>
	<!-- flickr.view.ftl :: Result -->
		<div id="result-${core_controller.result.rank!}" class="panel panel-default stencils-progressive-disclosure" data-flickr-photo-id="${core_controller.result.metaData.stencilsFlickrPhotoID!}">

			<div class="panel-heading" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
				<div data-flickr-username="${core_controller.result.metaData.stencilsFlickrPhotoOwnerUserName!}">${core_controller.result.metaData.a!}</div>

				<small class="text-muted">
					<i class="fas fa-pencil-alt"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@FlickrLink />
				</small>

			</div>

			<div class="panel-body" data-mh="group-body-${base_controller.resultsColumnsIndex!}">
				<h4>
					<a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl!}"> ${core_controller.result.title}</a>
				</h4>

				<#if core_controller.result.metaData.stencilsFlickrPhotoSmallImage320Url?? >
					<img src="${core_controller.result.metaData.stencilsFlickrPhotoSmallImage320Url!}" class="stencils-core-thumbnail stencils-flickr-thumbnail pull-right" alt="${core_controller.result.metaData.c!}" />
				</#if>
				<span class="search-summary"><@core_controller.boldicize><@core_controller.Truncate length=200><@core_controller.StripHtml><#noescape>${core_controller.result.metaData.c!}</#noescape></@core_controller.StripHtml></@core_controller.Truncate></@core_controller.boldicize></span>
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
							<i class="far fa-newspaper"></i> <span class="sr-only">Expanded view</span>
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
	</@flickr_controller.Picture>

</#macro>
<#-- /Result -->

<#---
	Modal View for search result type of flickr 'image'.

	<h2>Data Model</h2>
		<p><strong>core_controller.result ;</strong></p>
		<ul>
			<li><strong>title :</strong> Photo title.</li>
			<li><strong>date :</strong> Tweet created datetime.</li>
		</ul>
		<p><strong>core_controller.result.metaData ;</strong></p>
		<ul>
			<li><strong>a (author) :</strong> Photo Owner Full Name.</li>
			<li><strong>	c (description) :</strong> Photo description.</li>
			<li><strong>stencilsFlickrPhotoID</strong></li>
			<li><strong>stencilsFlickrPhotoOwnerUserName</strong></li>
			<li><strong>stencilsFlickrPhotoThumbNailUrl</strong></li>
			<li><strong>stencilsFlickrPhotoSmallImage320Url</strong></li>
			<li><strong>stencilsFlickrPhotoSmallImageSquareUrl</strong></li>
			<li><strong>stencilsFlickrPhotoMediumImageUrl</strong></li>
			<li><strong>stencilsFlickrPhotoMediumImage640Url</strong></li>
			<li><strong>stencilsFlickrPhotoMediumImage800Url</strong></li>
			<li><strong>stencilsFlickrPhotoLargeImageUrl</strong></li>
		</ul>
		<p><strong>flickr_controller ;</strong></p>
		<ul>
			<li><strong>pictureUserProfileUrl</strong></li>
		</ul>
	@requires core_view.Results
 -->
<#macro ResultModal>
	<@flickr_controller.Picture>
	<!-- flickr.view.ftl :: ResultModal -->
	<div data-fb-result="${core_controller.result.liveUrl!}" class="modal fade ng-scope" id="result-modal-${core_controller.result.rank!}" tabindex="-1" role="dialog" aria-labelledby="result-${core_controller.result.rank!}" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
					<div data-flickr-username="${core_controller.result.metaData.stencilsFlickrPhotoOwnerUserName!}">${core_controller.result.metaData.a!}</div>

					<small class="text-muted">
						<i class="fas fa-pencil-alt"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@FlickrLink />
					</small>
				</div>
				<div class="modal-body">
					<h4>
						<a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl!}"> ${core_controller.result.title}</a>
					</h4>
					<span class="search-summary"><#noescape>${core_controller.result.metaData.c!}</#noescape></span>

					<#if core_controller.result.metaData.stencilsFlickrPhotoMediumImage800Url?? >
					<div class="text-center">
						<img src="${core_controller.result.metaData.stencilsFlickrPhotoMediumImage800Url!}" class="" alt="${core_controller.result.metaData.c!}" />
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
	</@flickr_controller.Picture>
</#macro>
<#-- /ResultModal -->

<#-- @end --><#-- / Category - Result -->

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
					<h2><i class="fas fa-heart"></i> Favourites
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
		<a data-ng-href="{{item.indexUrl}}" data-ng-show="item.title" title="{{item.indexUrl}}">Flickr Image: {{item.title}}</a>
	</h4>
	<p data-ng-hide="!item.summary">{{item.summary|truncate:255}}</p>
	<p data-ng-hide="!item.metaData.c">{{item.metaData.c|truncate:255}}</p>
</#macro>

<#-- @end -->
<#-- / Category - Cart -->

</#escape>
