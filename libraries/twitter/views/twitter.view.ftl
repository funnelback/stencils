<#ftl encoding="utf-8" />
<#---
	<p>Provides views for Twitter components.</p>
	<p>These compontents include items such as result formats for Twitter tweets.</p>

	<h2>Table of Contents</h2>
	<ul>
		<li><strong>Configuration:</strong> Configuration options for Facebook Stencil.</li>
		<li><strong>General:</strong> General Twitter helpers.</li>
		<li><strong>Result Tweet:</strong>  Twitter tweet result format.</li>
	</ul>
-->
<#escape x as x?html>
<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign twitterResourcesPrefix = "/stencils/resources/twitter/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >


<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${librariesPrefix}twitter/controllers/twitter.controller.ftl" as twitter_controller/>

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
	<!-- twitter.view.ftl :: CSS -->
	<link rel="stylesheet" href="${twitterResourcesPrefix}css/twitter.css">
</#macro>

<#---
	JavaScript dependencies
 -->
<#macro JS>
	<!-- twitter.view.ftl :: JS -->
	<#-- This commented out because stencils.twitter.js is not required currently -->
	<#-- <script src="${twitterResourcesPrefix}js/stencils.twitter.js"></script> -->
</#macro>
<#-- @end --><#-- /Category - Configuration -->
<#-- ################### Views ####################### -->

<#-- @begin Result Tweet -->

<#---
	View for search result type of Twitter 'tweet'.

	<h2>Data Model</h2>
		<p><strong>core_controller.result ;</strong></p>
		<ul>
			<li><strong>date :</strong> Tweet created datetime.</li>
		</ul>
		<p><strong>core_controller.result.metaData ;</strong></p>
		<ul>
			<li><strong>a (author) :</strong> Username of tweet author.</li>
			<li><strong>	c (description) :</strong> Tweet text.</li>
			<li><strong>stencilsTwitterID</strong></li>
			<li><strong>stencilsTwitterScreenName</strong></li>
			<li><strong>stencilsTwitterProfileImageUrl</strong></li>
			<li><strong>stencilsTwitterDisplayUrl</strong></li>
			<li><strong>stencilsTwitterHashtag</strong></li>
			<li><strong>stencilsTwitterPlaceName</strong></li>
			<li><strong>stencilsTwitterCountry</strong></li>
			<li><strong>stencilsTwitterPictureUrl</strong></li>
			<li><strong>stencilsTwitterLatlong</strong></li>
		</ul>
		<p><strong>tweet_controller ;</strong></p>
		<ul>
			<li><strong>tweetUserProfileUrl</strong></li>
			<li><strong>tweetText :</strong> tweet with hashtags, @usernames and URLs converted to links.</li>
		</ul>
	@requires core_controller.Results
-->
<#macro Result>
	<@twitter_controller.Tweet>
	<!-- twitter.view.ftl :: Result -->
		<div id="result-${core_controller.result.rank!}" class="panel panel-default panel-default stencils-progressive-disclosure">

			<div class="panel-heading" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
				<div class="media">
					 <a href="${twitter_controller.tweetUserProfileUrl!}" class="pull-left">
						<img class="media-object" src="${base_controller.stripProtocol(core_controller.result.metaData.stencilsTwitterProfileImageUrl!)}" alt="Profile Image of ${core_controller.result.metaData.a!}">
					</a>
					<div class="media-body">
						<div><@TweetUser /></div>
						<small class="text-muted">
							<i class="fa fa-pencil"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@TwitterLink />
							<#if core_controller.result.metaData.stencilsTwitterCountry?? || core_controller.result.metaData.stencilsTwitterPlaceName??>
								from <i class="fa fa-map-marker"></i> <@TweetAddress />
							</#if>
						</small>
					</div>
				</div>
			</div>

			<div class="panel-body" data-mh="group-body-${base_controller.resultsColumnsIndex!}">
				<h4 class="sr-only">
					Tweet
					<a href="${core_controller.result.clickTrackingUrl}" class="btn btn-default" title="${core_controller.result.liveUrl!}"> "#${core_controller.result.metaData.stencilsTwitterID}"</a>
					from ${core_controller.result.metaData.a!} <#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if>
				</h4>

				<#if core_controller.result.metaData.stencilsTwitterPictureUrl?? >
					<img src="${base_controller.stripProtocol(core_controller.result.metaData.stencilsTwitterPictureUrl!)}" class="stencils-twitter-thumbnail stencils-core-thumbnail pull-right" alt="${core_controller.result.metaData.c!}" />
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
				</div>
				<#-- /ResultTools -->
			</div>
		</div>
	</@twitter_controller.Tweet >
</#macro>
<#-- /Result-->

<#---
	Modal view for search result type of Twitter 'tweet'.

	<h2>Data Model</h2>
		<p><strong>core_controller.result ;</strong></p>
		<ul>
			<li><strong>date :</strong> Tweet created datetime.</li>
		</ul>
		<p><strong>core_controller.result.metaData ;</strong></p>
		<ul>
			<li><strong>a (author) :</strong> Username of tweet author.</li>
			<li><strong>	c (description) :</strong> Tweet text.</li>
			<li><strong>stencilsTwitterID</strong></li>
			<li><strong>stencilsTwitterScreenName</strong></li>
			<li><strong>stencilsTwitterProfileImageUrl</strong></li>
			<li><strong>stencilsTwitterDisplayUrl</strong></li>
			<li><strong>stencilsTwitterHashtag</strong></li>
			<li><strong>stencilsTwitterPlaceName</strong></li>
			<li><strong>stencilsTwitterCountry</strong></li>
			<li><strong>stencilsTwitterPictureUrl</strong></li>
			<li><strong>stencilsTwitterLatlong</strong></li>
		</ul>
		<p><strong>tweet_controller ;</strong></p>
		<ul>
			<li><strong>tweetUserProfileUrl</strong></li>
			<li><strong>tweetText :</strong> tweet with hashtags, @usernames and URLs converted to links.</li>
		</ul>
		@requires core_controller.Result
-->
<#macro ResultModal>
	<@twitter_controller.Tweet>
	<!-- twitter.view.ftl :: ResultModal -->
		<div data-fb-result="${core_controller.result.liveUrl!}" class="modal fade ng-scope" id="result-modal-${core_controller.result.rank!}" tabindex="-1" role="dialog" aria-labelledby="result-${core_controller.result.rank!}" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<div class="media">
							 <a href="${twitter_controller.tweetUserProfileUrl!}" class="pull-left">
								<img class="media-object" src="${base_controller.stripProtocol(core_controller.result.metaData.stencilsTwitterProfileImageUrl!)}" alt="Profile Image of ${core_controller.result.metaData.a!}">
							</a>
							<div class="media-body">
								<div><@TweetUser /></div>
								<small class="text-muted">
									<i class="fa fa-pencil"></i> Published	<#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if> via <@TwitterLink />
									<#if core_controller.result.metaData.stencilsTwitterCountry?? || core_controller.result.metaData.stencilsTwitterPlaceName??>
										from <i class="fa fa-map-marker"></i> <@TweetAddress />
									</#if>
								</small>
							</div>
						</div>
					</div>
					<div class="modal-body">
						 <h4 class="sr-only">
							Tweet
							<a href="${core_controller.result.clickTrackingUrl}" class="btn btn-default" title="${core_controller.result.liveUrl!}"> "#${core_controller.result.metaData.stencilsTwitterID}"</a>
							from ${core_controller.result.metaData.a!} <#if core_controller.result.date??><span data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</span></#if>
						</h4>
						<div class="media">
							<div class="pull-right" style="max-width:40%">
								<#if core_controller.result.metaData.stencilsTwitterPictureUrl??>
									<img src="${base_controller.stripProtocol(core_controller.result.metaData.stencilsTwitterPictureUrl!)}" class="stencils-core-modal-thumbnail media-object" alt="${core_controller.result.metaData.c!}" />
								</#if>
							</div>
							<div class="media-body">
								<span class="search-summary lead"><#noescape>${twitter_controller.tweetText!}</#noescape></span>
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
						</div>
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
	</@twitter_controller.Tweet >
</#macro>
<#-- /ResultModal-->

<#---
	View for search result type of Twitter 'tweet' as embeded tweet.

	<h2>Data Model</h2>
		<p><strong>core_controller.result ;</strong></p>
		<ul>
			<li><strong>date :</strong> Tweet created datetime.</li>
		</ul>
		<p><strong>core_controller.result.metaData ;</strong></p>
		<ul>
			<li><strong>a (author) :</strong> Username of tweet author.</li>
			<li><strong>	c (description) :</strong> Tweet text.</li>
			<li><strong>stencilsTwitterID</strong></li>
			<li><strong>stencilsTwitterScreenName</strong></li>
			<li><strong>stencilsTwitterProfileImageUrl</strong></li>
			<li><strong>stencilsTwitterDisplayUrl</strong></li>
			<li><strong>stencilsTwitterHashtag</strong></li>
			<li><strong>stencilsTwitterPlaceName</strong></li>
			<li><strong>stencilsTwitterCountry</strong></li>
			<li><strong>stencilsTwitterPictureUrl</strong></li>
			<li><strong>stencilsTwitterLatlong</strong></li>
		</ul>
		<p><strong>tweet_controller ;</strong></p>
		<ul>
			<li><strong>tweetUserProfileUrl</strong></li>
			<li><strong>tweetText :</strong> tweet with hashtags, @usernames and URLs converted to links.</li>
		</ul>
		@requires core_controller.Result
-->
<#macro ResultEmbed>
	<@twitter_controller.Tweet>
		<div data-tweet-embed="${core_controller.result.metaData.stencilsTwitterID}" class="clearfix">
			<blockquote class="twitter-tweet" lang="en">
				<p lang="en" dir="ltr"><#noescape>${twitter_controller.tweetText}</#noescape></p>
				<@TweetUser />
				<a href="${core_controller.result.liveUrl}" data-moment="relative" data-moment-datetime="${core_controller.result.date?datetime?string.iso}">${core_controller.result.date?date?string("d MMM yyyy")}</a>
				<br>
				<#if core_controller.result.metaData.stencilsTwitterPictureUrl??>
					<img src="${base_controller.stripProtocol(core_controller.result.metaData.stencilsTwitterPictureUrl!)}" alt="tweet picture"/>
				</#if>
			</blockquote>
		</div>
	</@twitter_controller.Tweet>
</#macro>
<#-- /ResultEmbed-->

<#---
	Tweet adress format.
	@requires Tweet
-->
<#macro TweetAddress>
	<!-- twitter.view.ftl :: TweetAddress -->
	<#if core_controller.result.metaData.stencilsTwitterCountry?? || core_controller.result.metaData.stencilsTwitterPlaceName?? >
	<address class="stencils-twitter-location stencils-core-location" <#if core_controller.result.metaData.stencilsTwitterLatlong??>data-latLng="${core_controller.result.metaData.stencilsTwitterLatlong!}"</#if> >
		<#t>${core_controller.result.metaData.stencilsTwitterPlaceName!}
		<#t><#if core_controller.result.metaData.stencilsTwitterCountry?? && core_controller.result.metaData.stencilsTwitterPlaceName?? >,</#if>
		${core_controller.result.metaData.stencilsTwitterCountry!}
	</address>
	</#if>
</#macro>

<#---
	Format for tweet user.
	@requires Tweet
-->
<#macro TweetUser>
	<!-- twitter.view.ftl :: TweetUser -->
	 <a href="${twitter_controller.tweetUserProfileUrl}"><@core_controller.boldicize>${core_controller.result.metaData.a}</@core_controller.boldicize></a> <a href="${twitter_controller.tweetUserProfileUrl}" class="small text-muted"><@core_controller.boldicize>@${core_controller.result.metaData.stencilsTwitterScreenName}</@core_controller.boldicize></a>
</#macro>

<#-- @end --><#-- / Result (Tweet) -->

<#-- @begin  General -->
<#---
	Format for Twitter link.
-->
<#macro TwitterLink>
	<!-- twitter.view.ftl :: TwitterLink -->
	<i class="fa fa-twitter-square"></i> <a href="https://www.twitter.com/">Twitter</a>
</#macro>
<#-- @end --><#-- /Category - General -->

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
					<h2><i class="fa fa-heart"></i> Favourites
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
		<a data-ng-href="{{item.indexUrl}}" data-ng-show="item.metaData.stencilsTwitterID" title="{{item.indexUrl}}">Twitter Tweet: {{item.metaData.stencilsTwitterID}}</a>
	</h4>
	<p data-ng-hide="!item.summary">{{item.summary|truncate:255}}</p>
	<p data-ng-hide="!item.metaData.c">{{item.metaData.c|truncate:255}}</p>
</#macro>

<#-- @end -->
<#-- / Category - Cart -->

</#escape>
