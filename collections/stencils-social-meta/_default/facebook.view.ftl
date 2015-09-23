<#ftl encoding="utf-8" />
<#---
	<p>Provides views for Facebook components.</p>
	<p>These compontents include items such as result formats for Facebook posts, events and pages.</p>

	<h2>Table of Contents</h2>
	<ul>
		<li><strong>Configuration:</strong> Configuration options for Facebook Stencil.</li>
		<li><strong>General:</strong> General facebook helpers.</li>
		<li><strong>Result:</strong>  Facebook result format shared views.</li>
		<li><strong>Post:</strong>   Result format & Modal format for type of Facebook 'post'. </li>
		<li><strong>Result Event:</strong>  Result format & Modal format for type of Facebook 'event'.</li>
		<li><strong>Result Page:</strong>  Result format & Modal format for type of Facebook 'page'.</li>
	</ul>
-->
<#escape x as x?html>


<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign StencilsLibrariesPrefix = "/share/stencils/libraries/" >
<#assign FacebookResourcesPrefix = "${SearchPrefix}stencils-resources/facebook/" >
<#assign StencilsThirdpartyResourcesPrefix = "${SearchPrefix}stencils-resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${StencilsLibrariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${StencilsLibrariesPrefix}facebook/controllers/facebook.controller.ftl" as facebook_controller/>

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
	<!-- facebook.view.ftl :: CSS -->
	<link rel="stylesheet" href="${FacebookResourcesPrefix}css/stencils.facebook.css">
</#macro>

<#---
	JavaScript dependencies
 -->
<#macro JS>
	<!-- facebook.view.ftl :: JS -->
	<#-- This commented out because stencils.facebook.js is not required currently -->
	<#-- <script src="${FacebookResourcesPrefix}js/stencils.facebook.js"></script> -->
</#macro>
<#-- @end --><#-- /Category - Configuration -->
<#-- ################### Views ####################### -->

<#-- @begin  General -->
<#---
	View for Facebook link
-->
<#macro FacebookLink>
	<!-- facebook.view.ftl :: FacebookLink -->
	<i class="fa fa-facebook-square"></i> <a href="https://www.facebook.com/">Facebook</a>
</#macro>

<#-- @end --><#-- /Category - General -->

<#-- @begin Result -->
<#---
	Shared footer view for result variations.
-->
<#macro ResultFooter>
	<!-- facebook.view.ftl :: ResultFooter -->
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
</#macro>

<#---
	Shared footer view for	result variations.
-->
<#macro ResultModalFooter>
	<!-- facebook.view.ftl :: ResultFooter -->
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
</#macro>
<#-- @end --> <#-- /Category - Result  -->

<#-- @begin Result Post -->

<#---
	View for search result type of Facebook 'post'.

	<h2>Data Model</h2>
	<em>NOTE: Post's have no title attribute.</em>
	<p><strong>core_controller.result;</strong></p>
	<ul>
		<li><strong>date :</strong> Post's created datetime.</li>
	</ul>

	<p><strong>core_controller.result.metaData;</strong></p>
	<ul>
			<li><strong>a (author) :</strong> Name of post author.</li>
			<li><strong>c (description) :</strong> Post's message.</li>
			<li><strong>stencilsFacebookPostID :</strong> ID of Facebook Post record.</li>
			<li><strong>stencilsFacebookPostUserID :</strong> User ID of Facebook Post's author.</li>
			<li><strong>stencilsFacebookPostLink :</strong> Post link.</li>
			<li><strong>stencilsFacebookPostLinkCaption :</strong> Post link caption.</li>
			<li><strong>stencilsFacebookPostLinkDescription :</strong> Post link description.</li>
			<li><strong>stencilsFacebookPostThumbnailUrl :</strong> Post picture url.</li>
			<li><strong>stencilsFacebookPostState :</strong> Post location state.</li>
			<li><strong>stencilsFacebookPostPostcode :</strong> Post location postcode.</li>
			<li><strong>stencilsFacebookPostStreet :</strong> Post location street address.</li>
			<li><strong>stencilsFacebookType :</strong> Type of facebook results e.g 'Post'</li>
			<li><strong>stencilsFacebookPostCountry :</strong> Post location country.</li>
			<li><strong>stencilsFacebookPostCity :</strong> Post location city/suburb.</li>
			<li><strong>stencilsFacebookPostLatlong :</strong> Post location latLong coordinates.</li>
		</ul>

		<p><strong>facebook_controller;</strong></p>
		<ul>
			<li><strong>postUserProfileURL :</strong> URL of user's facebook profile.</li>
			<li><strong>postUserProfileImageURL :</strong> URL of user's facebook profile picture.</li>
		</ul>
	@requires core_controller.Results
-->
<#macro ResultPost>
	<@facebook_controller.Post>
	<!-- facebook.view.ftl :: ResultPost -->
		<div class="panel panel-default" id="result-${core_controller.result.rank!}">

			<div class="panel-heading" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
				<div class="media">
					 <a href="${facebook_controller.postUserProfileUrl!}" class="pull-left">
						<#-- *Note: Because	facebook_controller.postUserProfileImageUrl is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
						<img class="media-object" src="${facebook_controller.postUserProfileImageUrl!}?width=40&amp;height=40" alt="Profile Image of ${core_controller.result.metaData.a!}">
					</a>
					<div class="media-body">
						<div><a href="${facebook_controller.postUserProfileUrl!}"><@core_controller.boldicize>${core_controller.result.metaData.a}</@core_controller.boldicize></a> </div>
						<small class="text-muted">
							<i class="fa fa-pencil"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
							<#if core_controller.result.metaData.stencilsFacebookPostCountry??>
								at <i class="fa fa-map-marker"></i> <@PostFullAddress />
							</#if>
						</small>
					</div>
				</div>
			</div>

			<div class="panel-body" data-mh="group-body-${base_controller.resultsColumnsIndex!}">
				<h4 class="sr-only">
					Facebook post
					<a href="${core_controller.result.clickTrackingUrl}" class="btn btn-default" title="${core_controller.result.liveUrl!}"> "#${core_controller.result.metaData.stencilsFacebookPostID}"</a>
					from ${core_controller.result.metaData.a!} <#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if>
				</h4>

				<#if core_controller.result.metaData.stencilsFacebookPostThumbnailUrl?? && !(core_controller.result.metaData.stencilsFacebookPostLinkCaption??) >
					<img src="${core_controller.result.metaData.stencilsFacebookPostThumbnailUrl!}" class="stencils-core-thumbnail pull-right" alt="${core_controller.result.metaData.c!}" />
				</#if>

				<span class="search-summary lead"><@core_controller.boldicize><@core_controller.Truncate length=200>${core_controller.result.metaData.c!}</@core_controller.Truncate></@core_controller.boldicize></span>

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
				<@ResultFooter />
			</div>
		</div>
	</@facebook_controller.Post >
</#macro>
<#-- /ResultPost-->

<#---
	Modal view for search result type of Facebook 'post'.

	<h2>Data Model</h2>
	<em>NOTE: Post's have no title attribute.</em>
	<p><strong>core_controller.result;</strong></p>
	<ul>
		<li><strong>date :</strong> Post's created datetime.</li>
	</ul>

	<p><strong>core_controller.result.metaData;</strong></p>
	<ul>
			<li><strong>a (author) :</strong> Name of post author.</li>
			<li><strong>c (description) :</strong> Post's message.</li>
			<li><strong>stencilsFacebookPostID :</strong> ID of Facebook Post record.</li>
			<li><strong>stencilsFacebookPostUserID :</strong> User ID of Facebook Post's author.</li>
			<li><strong>stencilsFacebookPostLink :</strong> Post link.</li>
			<li><strong>stencilsFacebookPostLinkCaption :</strong> Post link caption.</li>
			<li><strong>stencilsFacebookPostLinkDescription :</strong> Post link description.</li>
			<li><strong>stencilsFacebookPostThumbnailUrl :</strong> Post picture url.</li>
			<li><strong>stencilsFacebookPostState :</strong> Post location state.</li>
			<li><strong>stencilsFacebookPostPostcode :</strong> Post location postcode.</li>
			<li><strong>stencilsFacebookPostStreet :</strong> Post location street address.</li>
			<li><strong>stencilsFacebookType :</strong> Type of facebook results e.g 'Post'</li>
			<li><strong>stencilsFacebookPostCountry :</strong> Post location country.</li>
			<li><strong>stencilsFacebookPostCity :</strong> Post location city/suburb.</li>
			<li><strong>stencilsFacebookPostLatlong :</strong> Post location latLong coordinates.</li>
		</ul>

		<p><strong>facebook_controller ;</strong></p>
		<ul>
			<li><strong>postUserProfileURL :</strong> URL of user's facebook profile.</li>
			<li><strong>postUserProfileImageURL :</strong> URL of user's facebook profile picture.</li>
		</ul>

	@requires core_controller.Results
-->
<#macro ResultPostModal>
	<@facebook_controller.Post>
	<!-- facebook.view.ftl :: ResultPostModal -->
		<div data-fb-result="${core_controller.result.liveUrl!}" class="modal fade ng-scope" id="result-modal-${core_controller.result.rank!}" tabindex="-1" role="dialog" aria-labelledby="result-${core_controller.result.rank!}" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<div class="media">
							 <a href="${facebook_controller.postUserProfileUrl!}" class="pull-left">
								<#-- *Note: Because	facebook_controller.postUserProfileImageUrl is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
								<img class="media-object" src="${facebook_controller.postUserProfileImageUrl!}?width=40&amp;height=40" alt="Profile Image of ${core_controller.result.metaData.a!}">
							</a>
							<div class="media-body">
								<div><a href="${facebook_controller.postUserProfileUrl!}">${core_controller.result.metaData.a!}</a> </div>
								<small class="text-muted">
									<i class="fa fa-pencil"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
									<#if core_controller.result.metaData.stencilsFacebookPostCountry??>
										at <i class="fa fa-map-marker"></i> <@PostFullAddress />
									</#if>
								</small>
							</div>
						</div>
					</div>
					<div class="modal-body">
						<h4 class="sr-only">
							Facebook post
							<a href="${core_controller.result.clickTrackingUrl!}" class="btn btn-default" title="${core_controller.result.liveUrl!}"> "#${core_controller.result.metaData.stencilsFacebookPostID!}"</a>
							from ${core_controller.result.metaData.a!} <#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if>
						</h4>
						<div class="media">
							<div class="pull-right" style="max-width:40%">
								<#if core_controller.result.metaData.stencilsFacebookPostThumbnailUrl?? && !(core_controller.result.metaData.stencilsFacebookPostLinkCaption??) >
									<img src="${core_controller.result.metaData.stencilsFacebookPostThumbnailUrl!}" class="stencils-core-thumbnail medi-object" alt="${core_controller.result.metaData.c!}" />
								</#if>
								<@PostLinkSnippet />
							</div>
							<div class="media-body">
								<span class="search-summary lead"><#noescape>${facebook_controller.postText!}</#noescape></span>
								<#-- ResultCollaspe -	Generate the result collapsing link -->
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
						</div>
					</div>
					<div class="modal-footer">
						<@ResultModalFooter />
					</div>
				</div><#-- /modal-content-->
			</div><#-- /modal-dialog -->
		</div><#-- /modal -->
	</@facebook_controller.Post >
</#macro>
<#-- /ResultPostModal-->

<#---
	View for Facebook Post as a facebook embed elment.

	<em>NOTE: Not currently implemented</em>
-->
<#macro ResultPostEmbed>
	<#-- RP - TODO: Re-implement with new variable names -->
	<#-- <div class="fb-post" style="margin-bottom:0.5em" <#if groupSize?number lte 2>data-href="${core_controller.result.liveUrl}"</#if> data-width="<#if groupSize?number = 1>500<#else>350</#if>"><div class="fb-xfbml-parse-ignore"><blockquote cite="${core_controller.result.liveUrl}"><p>${core_controller.result.metaData.postMessage}</p>Posted by ${core_controller.result.metaData.name} <#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if></blockquote></div></div> -->

	<#-- Facebook emebed script. -->
	<#-- <div id="fb-root"></div>
	<script>
	(function(d, s, id) {
		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id)) return;
		js = d.createElement(s); js.id = id;
		js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.3&appId=1444644072494648";
		fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));
	</script> -->
</#macro>
<#-- /ResultPostEmbed -->

<#---
	Facebook Post full address format.

	<h3>Example Output</h3>
	<code>
		&lt;address class="stencils-core-location"	&gt;
			45 Flinders Lane, Melbourne VIC 3000, Australia
		&lt;/address&gt;
	</code>

	@requires facebook_controller.Post
-->
<#macro PostFullAddress>
	<#if core_controller.result.metaData.stencilsFacebookPostCountry??>
	<!-- facebook.view.ftl :: PostAddress -->
	<address class="stencils-core-location" <#if core_controller.result.metaData.stencilsFacebookPostLatlong??>data-latLng="${core_controller.result.metaData.stencilsFacebookPostLatlong!}"</#if> >
		<#if core_controller.result.metaData.stencilsFacebookPostStreet??>${core_controller.result.metaData.stencilsFacebookPostStreet!},</#if>
		${core_controller.result.metaData.stencilsFacebookPostCity!}
		${core_controller.result.metaData.stencilsFacebookPostState!}
		${core_controller.result.metaData.stencilsFacebookPostPostcode!},
		${core_controller.result.metaData.stencilsFacebookPostCountry!}
	</address>
	</#if>
</#macro>

<#---
	Facebook Post Link format.
	@requires facebook_controller.Post
-->
<#macro PostLinkSnippet>
	<#if core_controller.result.metaData.stencilsFacebookPostLinkCaption??>
	<!-- facebook.view.ftl :: PostLinkSnippet -->
	<div class="thumbnail media-object">
		<#if core_controller.result.metaData.stencilsFacebookPostThumbnailUrl??>
			<img src="${core_controller.result.metaData.stencilsFacebookPostThumbnailUrl!}" alt="${core_controller.result.metaData.c!}" />
		</#if>
		<div class="caption">
			<strong><a href="${core_controller.result.metaData.stencilsFacebookPostLink}">${core_controller.result.metaData.stencilsFacebookPostLinkCaption!}</a></strong><br>
			<#if core_controller.result.metaData.stencilsFacebookPostLinkDescription??><p>${core_controller.result.metaData.stencilsFacebookPostLinkDescription!}</p></#if>
		</div>
	 </div>
	</#if>
</#macro>


<#-- @end --><#-- /Category - Result Post -->

<#-- @begin  Result Event -->

<#---
	View for search result type of Facebook 'event'.

	<H2>Data Model</h2>
	<p><strong>core_controller.result ;</strong></p>
	<ul>
		<li><strong>title :</strong> Name of the event.</li>
	</ul>

	<p><strong>core_controller.result.metaData ;</strong></p>
	<ul>
		<li><strong>a (author) :</strong> Name of event author.</li>
		<li><strong>c (description) :</strong> Event deescription.</li>
		<li><strong>stencilsFacebookEventID</strong></li>
		<li><strong>stencilsFacebookType</strong></li>
		<li><strong>stencilsFacebookEventUserID :</strong> ID of Facebook Post record.</li>
		<li><strong>stencilsFacebookEventStartDateTime</strong></li>
		<li><strong>stencilsFacebookEventEndDateTime</strong></li>
		<li><strong>stencilsFacebookEventLocation</strong></li>
		<li><strong>stencilsFacebookEventVenueStreet</strong></li>
		<li><strong>stencilsFacebookEventVenueCity</strong></li>
		<li><strong>stencilsFacebookEventVenueState</strong></li>
		<li><strong>stencilsFacebookEventVenuePostCode</strong></li>
		<li><strong>stencilsFacebookEventVenueCountry</strong></li>
		<li><strong>stencilsFacebookEventPrivacy</strong></li>
	</ul>

	<p><strong>facebook_controller ;</strong></p>
	<ul>
		<li><strong>eventUserProfileURL :</strong> URL of user's facebook profile.</li>
		<li><strong>eventUserProfileImageURL :</strong> URL of user's facebook profile picture.</li>
		<li><strong>eventStartDateTime :</strong> stencilsFacebookEventStartDateTime date string converted to ftl date object</li>
		<li><strong>eventEndDateTime :</strong> stencilsFacebookEventEndDateTime date string converted to ftl date object</li>
	</ul>
	@requires core_controller.Results
-->
<#macro ResultEvent>
	<@facebook_controller.Event>
	<!-- facebook.view.ftl :: ResultEvent -->
		<div class="panel panel-default" id="result-${core_controller.result.rank!}">

			<div class="panel-heading" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
				<div class="media">
					 <a href="${facebook_controller.eventUserProfileUrl!}" class="pull-left">
						<#-- *Note: Because	facebook_controller.eventUserProfileImageUrl is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
						<img class="media-object" src="${facebook_controller.eventUserProfileImageUrl!}?width=40&&amp;height=40" alt="Profile Image of ${core_controller.result.metaData.a!}">
					</a>
					<div class="media-body">
						<div><a href="${facebook_controller.eventUserProfileUrl!}"><@core_controller.boldicize>${core_controller.result.metaData.a!}</@core_controller.boldicize></a> </div>
						<small class="text-muted">
							<i class="fa fa-pencil"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
						</small>

					</div>
				</div>
			</div>

			<div class="panel-body" data-mh="group-body-${base_controller.resultsColumnsIndex!}">
				<h4>
					<a href="${core_controller.result.clickTrackingUrl!}" title="${core_controller.result.liveUrl!}">
						<@core_controller.boldicize>${core_controller.result.title!}</@core_controller.boldicize>
					</a>
				</h4>
				<small class="text-muted">

					<@facebook_controller.EventIsUpcoming>
						<i class="fa fa-calendar"></i> Upcoming Event on
						<i class="fa fa-clock-o"></i> <@EventDateTime />
					</@facebook_controller.EventIsUpcoming>

					<@facebook_controller.EventIsPast>
						<i class="fa fa-calendar"></i> Event occurred
						<i class="fa fa-clock-o"></i> <@EventOccurredDateTime />
					</@facebook_controller.EventIsPast>

					<#if core_controller.result.metaData.stencilsFacebookEventVenueCountry?? || core_controller.result.metaData.stencilsFacebookEventLocation??>
						at <i class="fa fa-map-marker"></i> <@EventVenueFullAddress />
					</#if>

				</small>

				<#if core_controller.result.metaData.c??>
				<p><@core_controller.boldicize><@core_controller.Truncate length=200>${core_controller.result.metaData.c!}</@core_controller.Truncate></@core_controller.boldicize></p>
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

			<div class="panel-footer">
				<@ResultFooter />
			</div>
		</div>
 </@facebook_controller.Event >
</#macro>
<#-- /ResultEvent-->

<#---
	Modal view for search result type of Facebook 'event'.

	<H2>Data Model</h2>
	<p><strong>core_controller.result ;</strong></p>
	<ul>
		<li><strong>title :</strong> Name of the event.</li>
	</ul>

	<p><strong>core_controller.result.metaData ;</strong></p>
	<ul>
		<li><strong>a (author) :</strong> Name of event author.</li>
		<li><strong>c (description) :</strong> Event deescription.</li>
		<li><strong>stencilsFacebookEventID</strong></li>
		<li><strong>stencilsFacebookType</strong></li>
		<li><strong>stencilsFacebookEventUserID :</strong> ID of Facebook Post record.</li>
		<li><strong>stencilsFacebookEventStartDateTime</strong></li>
		<li><strong>stencilsFacebookEventEndDateTime</strong></li>
		<li><strong>stencilsFacebookEventLocation</strong></li>
		<li><strong>stencilsFacebookEventVenueStreet</strong></li>
		<li><strong>stencilsFacebookEventVenueCity</strong></li>
		<li><strong>stencilsFacebookEventVenueState</strong></li>
		<li><strong>stencilsFacebookEventVenuePostCode</strong></li>
		<li><strong>stencilsFacebookEventVenueCountry</strong></li>
		<li><strong>stencilsFacebookEventPrivacy</strong></li>
	</ul>

	<p><strong>facebook_controller ;</strong></p>
	<ul>
		<li><strong>eventUserProfileURL :</strong> URL of user's facebook profile.</li>
		<li><strong>eventUserProfileImageURL :</strong> URL of user's facebook profile picture.</li>
		<li><strong>eventStartDateTime :</strong> stencilsFacebookEventStartDateTime date string converted to ftl date object</li>
		<li><strong>eventEndDateTime :</strong> stencilsFacebookEventEndDateTime date string converted to ftl date object</li>
	</ul>

	@requires core_controller.Results
-->
<#macro ResultEventModal>
	<@facebook_controller.Event>
	<!-- facebook.view.ftl :: ResultEventModal -->
		<div data-fb-result="${core_controller.result.liveUrl!}" class="modal fade ng-scope" id="result-modal-${core_controller.result.rank!}" tabindex="-1" role="dialog" aria-labelledby="result-${core_controller.result.rank!}" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<div class="media">
							 <a href="${facebook_controller.eventUserProfileUrl!}" class="pull-left">
								<#-- *Note: Because	facebook_controller.eventUserProfileImageUrl is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
								<img class="media-object" src="${facebook_controller.eventUserProfileImageUrl!}?width=40&amp;height=40" alt="Profile Image of ${core_controller.result.metaData.a!}">
							</a>
							<div class="media-body">
								<div><a href="${facebook_controller.eventUserProfileUrl!}">${core_controller.result.metaData.a!}</a> </div>
								<small class="text-muted">
									<i class="fa fa-pencil"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
								</small>

							</div>
						</div>
					</div>
					<div class="modal-body">
							<h4>
								<a href="${core_controller.result.clickTrackingUrl!}" title="${core_controller.result.liveUrl!}">
									${core_controller.result.title!}
								</a>
							</h4>
							<small class="text-muted">

								<@facebook_controller.EventIsUpcoming>
									<i class="fa fa-calendar"></i> Upcoming Event on
									<i class="fa fa-clock-o"></i> <@EventDateTime />
								</@facebook_controller.EventIsUpcoming>

								<@facebook_controller.EventIsPast>
									<i class="fa fa-calendar"></i> Event occurred
									<i class="fa fa-clock-o"></i> <@EventOccurredDateTime />
								</@facebook_controller.EventIsPast>

								<#if core_controller.result.metaData.stencilsFacebookEventVenueCountry?? || core_controller.result.metaData.stencilsFacebookEventLocation??>
									at <i class="fa fa-map-marker"></i> <@EventVenueFullAddress />
								</#if>

							</small>

							<#if core_controller.result.metaData.c??>
							<p><@base_controller.Linkify><@core_controller.Truncate length=512>${core_controller.result.metaData.c!}</@core_controller.Truncate></@base_controller.Linkify></p>
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
						<@ResultModalFooter />
					</div>
				</div>
			</div>
		</div>
	</@facebook_controller.Event >
</#macro>
<#-- /ResultEventModal-->

<#---
	Facebook Event start and end datetime format.

	Displays start date with end date if it has event has an end date.

	<h3>Example Outputs</h3>
	<h4>Has no end date</h4>
	<p>Aug 22 at 10:00pm</p>
	<h4>Has end date</h4>
	<p>Aug 22 at 10:00pm to Aug 23 at 4:00am</p>
	@requires facebook_controller.Event
-->
<#macro EventStartEndDateTime>
	<#-- Start Date -->
	<time datetime="${facebook_controller.eventStartDateTime!?string.xs}">
		${facebook_controller.eventStartDateTime!?string["MMM d"]} at ${facebook_controller.eventStartDateTime!?string["h:mma"]}
	</time>

	<#-- End Date: Display end date it the event has one. -->
	<#if core_controller.result.metaData.stencilsFacebookEventEndDateTime??>
	<time datetime="${facebook_controller.eventEndDateTime!?string.xs}">
		to ${facebook_controller.eventEndDateTime!?string["MMM d"]} at ${facebook_controller.eventEndDateTime!?string["h:mma"]}
	</time>
	</#if>
</#macro>

<#---
	Facebook Event start and end datetime format.

	<h3>Example Outputs</h3>
	<h4>No end date</h4>
	<p>Saturday, August 22 at 10:00pm</p>
	<h4>End date is day after start date.</h4>
	<p>Saturday, August 22 at 10:00pm ending at 4:00am</p>
	<h4>End date is more than one day after start date.</h4>
	<p>Saturday, August 22 at 10:00pm ending Saturday, August 28 at 4:00am</p>

	@requires facebook_controller.Event
-->
<#macro EventDateTime>
	<#-- Start date	-->
	<time datetime="${facebook_controller.eventStartDateTime!?string.xs}">
		${facebook_controller.eventStartDateTime!?string["EEEE, MMMM d"]} at ${facebook_controller.eventStartDateTime!?string["h:mma"]}
	</time>

	<#--	End Date: Display end date and time if the event has one.	-->
	<#if core_controller.result.metaData.stencilsFacebookEventEndDateTime??>
	<time datetime="${facebook_controller.eventEndDateTime?string.xs}">
		ending
		<#-- End Date: Display Day and Month -->
		<#if ( facebook_controller.eventStartDateTime?string["YYYYd"] == facebook_controller.eventEndDateTime?string["YYYYd"] )>
			<#-- End Date: If the event end date is day after start date do not print end date day and month.-->
		<#else>
			<#-- End Date: Print the day and month if end date is more than one day after start date. -->
			${facebook_controller.eventEndDateTime?string["EEEE, MMMM d"]} at
		</#if>
		<#-- Time of event end -->
		${facebook_controller.eventEndDateTime?string["h:mma"]}
	</time>
	</#if>
</#macro>

<#---
	Facebook Event occured datetime format.

	<h3>Example Outputs</h3>
	<h4>No end date</h4>
	<p>Saturday, August 22 at 10:00pm, 2016</p>
	<h4>End date is day after start date.</h4>
	<p>Saturday, August 22 at 10:00pm ending at 4:00am, 2016</p>
	<h4>End date is more than one day after start date.</h4>
	<p>Saturday, August 22 at 10:00pm ending Saturday, August 28 at 4:00am, 2016</p>

	@requires facebook_controller.Event
-->
<#macro EventOccurredDateTime>
	<#-- Start Date -->
	<time datetime="${facebook_controller.eventStartDateTime!?string.xs}">
		${facebook_controller.eventStartDateTime?string["EEEE, MMMM d"]} at ${facebook_controller.eventStartDateTime!?string["h:mma"]}<#if !core_controller.result.metaData.stencilsFacebookEventEndDateTime??>,</#if>
	</time>

	<#--	End Date: Display end date and time if the event has one.	-->
	<#if core_controller.result.metaData.stencilsFacebookEventEndDateTime??>
	<time datetime="${facebook_controller.eventEndDateTime?string.xs}">
		to
		<#if ( facebook_controller.eventStartDateTime?string["YYYYd"] == facebook_controller.eventEndDateTime?string["YYYYd"] )>
			<#-- End Date: If the event end date is day after start date do not print end date day and month.-->
		<#else>
			<#-- End Date: Print the day and month if end date is more than one day after start date. -->
			${facebook_controller.eventEndDateTime?string["EEEE, MMMM d"]} at
		</#if>
		<#-- Time of event end -->
		 ${facebook_controller.eventEndDateTime?string["h:mma"]},
	</time>
	</#if>

	<#-- Year event occured on
		If the event has an end date use, end date Year as the date the event occured on, other wise use start date year.
	-->
	<#if core_controller.result.metaData.stencilsFacebookEventEndDateTime??>
		${facebook_controller.eventEndDateTime?string["yyyy"]}
	<#else>
		${facebook_controller.eventStartDateTime!?string["yyyy"]}
	</#if>
</#macro>

<#---
	Facebook Event full address format.
	@requires facebook_controller.Event
-->
<#macro EventVenueFullAddress>
	<!-- facebook.view.ftl :: EventFullAddress -->

	<#-- Venue Location Name-->
	<#if core_controller.result.metaData.stencilsFacebookEventLocation??>
	<strong>${core_controller.result.metaData.stencilsFacebookEventLocation}</strong>
	</#if>

	<#-- If Event Has both location and country display separator -->
	<#if core_controller.result.metaData.stencilsFacebookEventLocation?? && core_controller.result.metaData.stencilsFacebookEventVenueCountry??>
		,
	</#if>

	<#--	Venue Area/Address -->
	<#if core_controller.result.metaData.stencilsFacebookEventVenueCountry??>
	<address class="stencils-core-location" >
		<#if core_controller.result.metaData.stencilsFacebookEventVenueStreet??>${core_controller.result.metaData.stencilsFacebookEventVenueStreet},</#if>
		${core_controller.result.metaData.stencilsFacebookEventVenueCity!}
		${core_controller.result.metaData.stencilsFacebookEventVenueState!}
		${core_controller.result.metaData.stencilsFacebookEventVenuePostCode!},
		${core_controller.result.metaData.stencilsFacebookEventVenueCountry!}
	</address>
	</#if>
</#macro>
<#-- @end --><#-- /Category - Result Event -->

<#-- @begin	 Result Page -->

<#---
	View for search result type of Facebook 'page'.

	<h2>Data Model</h2>

	<p><strong>core_controller.result ;</strong></p>
	<ul>
		<li><strong>title :</strong> Name of the page.</li>
	</ul>

	<p><strong>core_controller.result.metaData ;</strong></p>
	<ul>
		<li><strong>c (description) :</strong> Page description.</li>
		<li><strong>stencilsFacebookPageID</strong></li>
		<li><strong>stencilsFacebookPageAbout</strong></li>
		<li><strong>stencilsFacebookPageCategory</strong></li>
		<li><strong>stencilsFacebookPageFounded</strong></li>
		<li><strong>stencilsFacebookPageMission</strong></li>
		<li><strong>stencilsFacebookPagePhone</strong></li>
		<li><strong>stencilsFacebookPageProducts</strong></li>
		<li><strong>stencilsFacebookPageState</strong></li>
		<li><strong>stencilsFacebookPagePostcode</strong></li>
		<li><strong>stencilsFacebookPageStreet</strong></li>
		<li><strong>stencilsFacebookType</strong></li>
		<li><strong>stencilsFacebookPageCountry</strong></li>
		<li><strong>stencilsFacebookPageCity</strong></li>
	</ul>
	<p><strong>facebook_controller ;</strong></p>
	<ul>
		<li><strong>pageImageUrl</strong></li>
	</ul>
	@requires core_controller.Results
-->
<#macro ResultPage>
	<@facebook_controller.Page>
	<!-- facebook.view.ftl :: ResultPage -->
	<div class="panel panel-default" id="result-${core_controller.result.rank!}">
		<div class="panel-heading" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
			<div class="media">
				<a href="${core_controller.result.clickTrackingUrl!}" title="${core_controller.result.liveUrl!}" class="pull-left stencils-facebook-page-info media-object">
						<#-- *Note: Because	this is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
						<img src="${facebook_controller.pageImageUrl!}?width=60&&amp;height=60" alt="Thumbnail image for ${core_controller.result.title!}'s facebook page.">
				</a>

				<div class="media-body">
					<h4 class="h3">
						<a href="${core_controller.result.clickTrackingUrl!}" title="${core_controller.result.liveUrl!}">
							<@core_controller.boldicize>${core_controller.result.title!}</@core_controller.boldicize>
						</a>
					</h4>
					<small class="text-muted">
						<i class="fa fa-pencil"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
					</small>
				</div>
			</div>
		</div>
		<div class="panel-body" data-mh="group-body-${base_controller.resultsColumnsIndex!}">
			<@base_controller.IfDefCGIEquals name="resultsView" value="grid">
				<#if base_controller.resultsColumnsNumber gt 2>
				<img src="${facebook_controller.pageImageUrl!}?width=150&amp;height=150" alt="Thumbnail image for ${core_controller.result.title!}'s facebook page." class="stencils-core-thumbnail pull-right" />
				</#if>
			</@base_controller.IfDefCGIEquals>

			<#if core_controller.result.metaData.c??>
			 <p><@core_controller.boldicize><@core_controller.Truncate length=200>${core_controller.result.metaData.c!}</@core_controller.Truncate></@core_controller.boldicize></p>
			<#else>
				<#if core_controller.result.metaData.stencilsFacebookPageAbout??>
					<p><@core_controller.Truncate length=200> ${core_controller.result.metaData.stencilsFacebookPageAbout}</@core_controller.Truncate></p>
				</#if>
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

		<div class="panel-footer">
			<@ResultFooter />
		</div>
	</div>
	</@facebook_controller.Page >
</#macro>
<#-- /ResultPage-->

<#---
	Modal view for search result type of Facebook 'Page'.

	<h2>Data Model</h2>

	<p><strong>core_controller.result ;</strong></p>
	<ul>
		<li><strong>title :</strong> Name of the page.</li>
	</ul>

	<p><strong>core_controller.result.metaData ;</strong></p>
	<ul>
		<li><strong>c (description) :</strong> Page deescription.</li>
		<li><strong>stencilsFacebookPageID</strong></li>
		<li><strong>stencilsFacebookPageAbout</strong></li>
		<li><strong>stencilsFacebookPageCategory</strong></li>
		<li><strong>stencilsFacebookPageFounded</strong></li>
		<li><strong>stencilsFacebookPageMission</strong></li>
		<li><strong>stencilsFacebookPagePhone</strong></li>
		<li><strong>stencilsFacebookPageProducts</strong></li>
		<li><strong>stencilsFacebookPageState</strong></li>
		<li><strong>stencilsFacebookPagePostcode</strong></li>
		<li><strong>stencilsFacebookPageStreet</strong></li>
		<li><strong>stencilsFacebookType</strong></li>
		<li><strong>stencilsFacebookPageCountry</strong></li>
		<li><strong>stencilsFacebookPageCity</strong></li>
	</ul>
	<p><strong>facebook_controller ;</strong></p>
	<ul>
		<li><strong>pageImageUrl</strong></li>
	</ul>
	@requires core_controller.Results
-->
<#macro ResultPageModal>
	<@facebook_controller.Page>
	<!-- facebook.view.ftl :: ResultPageModal -->
		<div data-fb-result="${core_controller.result.liveUrl!}" class="modal fade ng-scope" id="result-modal-${core_controller.result.rank!}" tabindex="-1" role="dialog" aria-labelledby="result-${core_controller.result.rank!}" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<div class="media">
							<a href="${core_controller.result.clickTrackingUrl!}" title="${core_controller.result.liveUrl!}" class="pull-left media-object">
									<#-- *Note: Because	this is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
									<img src="${facebook_controller.pageImageUrl!}?width=40&amp;height=40" alt="Thumbnail image for ${core_controller.result.title!}'s facebook page.">
							</a>

							<div class="media-body">
								<h4 class="h3">
									<a href="${core_controller.result.clickTrackingUrl!}" title="${core_controller.result.liveUrl!}">
										${core_controller.result.title!}
									</a>
								</h4>
								<small class="text-muted">
									<i class="fa fa-pencil"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
								</small>
							</div>
						</div>
					</div>
					<div class="modal-body">

							<#if core_controller.result.metaData.c??>
							 <p><@base_controller.Linkify><@core_controller.Truncate length=512>${core_controller.result.metaData.c!}</@core_controller.Truncate></@base_controller.Linkify></p>
							</#if>

							<#if core_controller.result.metaData.stencilsFacebookPageAbout??>
								<h5 class="small">About</h5>
								<p class="small"><@core_controller.Truncate length=200> ${core_controller.result.metaData.stencilsFacebookPageAbout}</@core_controller.Truncate></p>
							</#if>

							<#if core_controller.result.metaData.stencilsFacebookPageMission??>
								<h5 class="small">Mission</h5>
								<p class="small"><@core_controller.Truncate length=200>${core_controller.result.metaData.stencilsFacebookPageMission}</@core_controller.Truncate>
								</p>
							</#if>

							<p class="text-muted small">
								<#if core_controller.result.metaData.stencilsFacebookPageCategory??>
									<strong>Category:</strong> ${core_controller.result.metaData.stencilsFacebookPageCategory} &bull;
								</#if>
								<#if core_controller.result.metaData.stencilsFacebookPageFounded??>
									<strong>Founded:</strong> ${core_controller.result.metaData.stencilsFacebookPageFounded} &bull;
								</#if>
								<#if core_controller.result.metaData.stencilsFacebookPagePhone??>
									<strong>Phone:</strong> ${core_controller.result.metaData.stencilsFacebookPagePhone} &bull;
								</#if>

								<#if core_controller.result.metaData.stencilsFacebookPageProducts??>
									<strong>Products:</strong> ${core_controller.result.metaData.stencilsFacebookPageProducts} &bull;
								</#if>
							</p>

							<#if core_controller.result.metaData.stencilsFacebookPageCountry??>
							 <div class="text-muted small"> <i class="fa fa-map-marker"></i> <@PageFullAddress /></div>
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
						<@ResultModalFooter />
					</div>
				</div>
			</div>
		</div>
	</@facebook_controller.Page >

</#macro>
<#-- /ResultPageModal-->

<#---
	Page full Adress format.
	@requires facebook_controller.Page
-->
<#macro PageFullAddress>
	<!-- facebook.view.ftl :: PageFullAddress -->
	<#if core_controller.result.metaData.stencilsFacebookPageCountry??>
	<address class="stencils-core-location" >
		<#if core_controller.result.metaData.stencilsFacebookPageStreet??>${core_controller.result.metaData.stencilsFacebookPageStreet},</#if> ${core_controller.result.metaData.stencilsFacebookPageCity!} ${core_controller.result.metaData.stencilsFacebookPageState!} ${core_controller.result.metaData.stencilsFacebookPagePostCode!}, ${core_controller.result.metaData.stencilsFacebookPageCountry!}
	</address>
	</#if>
</#macro>


<#---
	Facebook Embed View for result type of facebook 'Page'.

	<em>NOTE: Macro currently note implemented</em>
-->
<#macro ResultPageEmbed>
	 <#-- RP - TODO: Re-implement with new variable names -->
 <#--	<div class="fb-page" style="margin-bottom:0.5em" <#if groupSize?number lte 2>data-href="${core_controller.result.liveUrl}"</#if> data-width="<#if groupSize?number = 1>500<#else>350</#if>"><div class="fb-xfbml-parse-ignore"><blockquote cite="${core_controller.result.liveUrl}"><#if core_controller.result.metadatadescription??><p>${core_controller.result.metaData.description}</p></#if>Facebook page for ${core_controller.result.metaData.name} </blockquote></div></div> -->
</#macro>
<#-- /ResultPageEmbed -->
<#-- @end --><#-- /Category - Result Page -->

</#escape>
