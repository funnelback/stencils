<#ftl encoding="utf-8" output_format="HTML" />

<#import "/share/stencils/libraries/core/controllers/core.controller.ftl" as core_controller />
<#import "/share/stencils/libraries/base/controllers/base.controller.ftl" as base_controller />

<#--- @begin Configuration -->

<#--- Stylesheet dependencies -->
<#macro CSS>
	<!-- facebook.view.ftl :: CSS -->
	<link rel="stylesheet" href="/stencils/resources/facebook/v14.2.0/css/facebook.css">
</#macro>
<#--- @end --><#-- /Category - Configuration -->

<#--- @begin  General -->

<#--- View for Facebook link -->
<#macro FacebookLink>
	<!-- facebook.view.ftl :: FacebookLink -->
	<i class="fa fa-facebook-square"></i> <a href="https://www.facebook.com/">Facebook</a>
</#macro>
<#--- @end --><#-- /General -->

<#--- @begin Result -->

<#--- Shared footer view for result variations. -->
<#macro ResultFooter result=result>
	<!-- facebook.view.ftl :: ResultFooter -->
	<#-- Result tools -->
	<div class="stencils-print__hide row stencils-progressive-disclosure__hiddenBlock stencils-progressive-disclosure__hiddenBlock--showOnSelected stencils-progressive-disclosure__hiddenBlock-showOnHover stencils-animation--fade-in-on-hover">
		<div class="btn-group col-md-8">
			<div class="btn-group">
				<button href="#" class="dropdown-toggle btn btn-default" data-toggle="dropdown" title="More actions&hellip;"><small class="glyphicon glyphicon-chevron-down text-success"></small>
					<span class="sr-only">Result tools</span>
				</button>
				<ul class="dropdown-menu">
					<li>
						<#-- General the cache link which is used to display the version of the document when it was crawled -->
						<#if result.cacheUrl??>
							<a href="${result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="Cached version of ${result.title} (${result.rank})">Cached</a>
						</#if>
					</li>
					<#-- Generate the explore url which is used to find similar results -->
					<@core_controller.Explore result=result>
						<li>
							<a class="fb-explore" href="<@core_controller.ExploreUrl />" alt="Related results"> Explore </a>
						</li>
					</@core_controller.Explore>
					<#-- Show the optimise button when viewed from the admin UI -->
					<@core_controller.Optimise result=result>
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

			<a href="${result.clickTrackingUrl!}" class="btn btn-default" title="View '${result.liveUrl!}'">
				<i class="fa fa-external-link"></i> <span class="sr-only">View '${result.liveUrl!}</span>
			</a>

			<#-- Open modal -->
			<button class="btn btn-primary" data-toggle="modal" data-target="#result-modal-${result.rank!}" title="Expanded view">
				<i class="fa fa-newspaper-o"></i> <span class="sr-only">Expanded view</span>
			</button>

			<#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(result.indexUrl)??>
				<a title="Click history" href="#" class="text-warning btn btn-default" data-ng-click="toggleHistory()">
					<small class="text-warning">
						<span class="glyphicon glyphicon-time"></span>
						Last visited ${prettyTime(session.getClickHistory(result.indexUrl).clickDate)}
					</small>
				</a>
			</#if>
		</div>
	</div>
	<#-- /ResultTools -->
</#macro>

<#--- Shared footer view for result variations. -->
<#macro ResultModalFooter result>
	<!-- facebook.view.ftl :: ResultFooter -->
	<#-- Result tools -->
	<div class="btn-group">
		<div class="btn-group">
			<button href="#" class="dropdown-toggle btn btn-default" data-toggle="dropdown" title="More actions&hellip;"><small class="glyphicon glyphicon-chevron-down text-success"></small>
				<span class="sr-only">Result tools</span>
			</button>
			<ul class="dropdown-menu">
				<li>
					<#-- General the cache link which is used to display the version of the document when it was crawled -->
					<#if result.cacheUrl??>
						<a href="${result.cacheUrl}&amp;hl=${response.resultPacket.queryHighlightRegex!?url}" title="Cached version of ${result.title} (${result.rank})">Cached</a>
					</#if>
				</li>
				<#-- Generate the explore url which is used to find similar results -->
				<@core_controller.Explore result=result>
					<li>
						<a class="fb-explore" href="<@core_controller.ExploreUrl />" alt="Related results"> Explore </a>
					</li>
				</@core_controller.Explore>
				<#-- Show the optimise button when viewed from the admin UI -->
				<@core_controller.Optimise result=result>
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

		<a href="${result.clickTrackingUrl!}" class="btn btn-default" title="View '${result.liveUrl!}'">
			<i class="fa fa-external-link"></i> <span class="sr-only">View '${result.liveUrl!}</span>
		</a>

		<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>

		<#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(result.indexUrl)??>
			<a title="Click history" href="#" class="text-warning btn btn-default" data-ng-click="toggleHistory()">
				<small class="text-warning">
					<span class="glyphicon glyphicon-time"></span>
					Last visited ${prettyTime(session.getClickHistory(result.indexUrl).clickDate)}
				</small>
			</a>
		</#if>
	</div>
	<#-- /ResultTools -->
</#macro>
<#--- @end --> <#-- /Result  -->

<#-- @begin Result Post -->

<#--- View for search result type of Facebook 'post'. -->
<#macro ResultPost result>
	<!-- facebook.view.ftl :: ResultPost -->
	<div class="panel panel-default stencils-progressive-disclosure" id="result-${result.rank!}">

		<div class="panel-heading" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
			<div class="media">
				<#if result.metaData["a"]??>
					<a href="${result.customData["stencilsFacebookProfileUrl"]!}" class="pull-left">
					<#-- *Note: Because	stencilsFacebookProfileImageUrl is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
					<img class="media-object" src="${result.customData["stencilsFacebookProfileImageUrl"]!}?width=40&amp;height=40" alt="Profile Image of ${result.metaData.a!}">
				</a>
				</#if>
				<div class="media-body">
					<div><a href="${result.customData["stencilsFacebookProfileUrl"]!}"><@core_controller.boldicize>${result.metaData.a!}</@core_controller.boldicize></a> </div>
					<small class="text-muted">
						<i class="fa fa-pencil"></i> Published	<#if result.date??><span data-moment="relative" data-moment-datetime="${result.date?datetime?string.iso}">${result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
						<#if result.metaData.stencilsFacebookPostCountry??>
							at <i class="fa fa-map-marker"></i> <@PostFullAddress result=result />
						</#if>
					</small>
				</div>
			</div>
		</div>

		<div class="panel-body" data-mh="group-body-${base_controller.resultsColumnsIndex!}">
			<h4 class="sr-only">
				Facebook post
				<a href="${result.clickTrackingUrl}" class="btn btn-default" title="${result.liveUrl!}"> "#${result.metaData.stencilsFacebookPostID}"</a>
				from ${result.metaData.a!} <#if result.date??><span data-moment="relative" data-moment-datetime="${result.date?datetime?string.iso}">${result.date?date?string("d MMM yyyy")}</span></#if>
			</h4>

			<#if result.metaData.stencilsFacebookPostThumbnailUrl?? && !(result.metaData.stencilsFacebookPostLinkCaption??) >
				<img src="${result.metaData.stencilsFacebookPostThumbnailUrl!}" class="stencils-core-thumbnail pull-right" alt="${result.metaData.c!}" />
			</#if>

			<span class="search-summary lead"><@core_controller.boldicize><@core_controller.Truncate length=200><#outputformat "plainText">${response.customData.stencilsMethods.facebookHashtagify(result.metaData.c!)}</#outputformat></@core_controller.Truncate></@core_controller.boldicize></span>

			<#-- ResultCollaspe Generate the result collapsing link -->
			<@core_controller.Collapsed result=result>
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
			<@ResultFooter result=result/>
		</div>
	</div>
</#macro>
<#-- /ResultPost-->

<#--- Modal view for search result type of Facebook 'post'. -->
<#macro ResultPostModal result>
	<!-- facebook.view.ftl :: ResultPostModal -->
	<div data-fb-result="${result.liveUrl!}" class="modal fade ng-scope" id="result-modal-${result.rank!}" tabindex="-1" role="dialog" aria-labelledby="result-${result.rank!}" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
					<div class="media">
							<a href="${result.customData["stencilsFacebookProfileUrl"]!}" class="pull-left">
							<#-- *Note: Because	stencilsFacebookProfileImageUrl is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
							<img class="media-object" src="${result.customData["stencilsFacebookProfileImageUrl"]!}?width=40&amp;height=40" alt="Profile Image of ${result.metaData.a!}">
						</a>
						<div class="media-body">
							<#if result.metaData.a??>
					<div><a href="${result.customData["stencilsFacebookProfileUrl"]!}"><@core_controller.boldicize>${result.metaData.a!}</@core_controller.boldicize></a> </div>
							</#if>
							<small class="text-muted">
								<i class="fa fa-pencil"></i> Published	<#if result.date??><span data-moment="relative" data-moment-datetime="${result.date?datetime?string.iso}">${result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
								<#if result.metaData.stencilsFacebookPostCountry??>
									at <i class="fa fa-map-marker"></i> <@PostFullAddress result=result/>
								</#if>
							</small>
						</div>
					</div>
				</div>
				<div class="modal-body">
					<h4 class="sr-only">
						Facebook post
						<a href="${result.clickTrackingUrl!}" class="btn btn-default" title="${result.liveUrl!}"> "#${result.metaData.stencilsFacebookPostID!}"</a>
						from ${result.metaData.a!} <#if result.date??><span data-moment="relative" data-moment-datetime="${result.date?datetime?string.iso}">${result.date?date?string("d MMM yyyy")}</span></#if>
					</h4>
					<div class="media">
						<div class="pull-right" style="max-width:40%">
							<#if result.metaData.stencilsFacebookPostThumbnailUrl?? && !(result.metaData.stencilsFacebookPostLinkCaption??) >
								<img src="${result.metaData.stencilsFacebookPostThumbnailUrl!}" class="stencils-core-thumbnail medi-object" alt="${result.metaData.c!}" />
							</#if>
							<@PostLinkSnippet result=result/>
						</div>
						<div class="media-body">
							<span class="search-summary lead"><#outputformat "plainText">${response.customData.stencilsMethods.facebookHashtagify(result.metaData["c"]!)}</#outputformat></span>
							<#-- ResultCollaspe -	Generate the result collapsing link -->
							<@core_controller.Collapsed result=result>
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
					<@ResultModalFooter result=result/>
				</div>
			</div><#-- /modal-content-->
		</div><#-- /modal-dialog -->
	</div><#-- /modal -->
</#macro>
<#-- /ResultPostModal-->

<#---
	Facebook Post full address format.

	<h3>Example Output</h3>
	<code>
		&lt;address class="stencils-core-location"	&gt;
			45 Flinders Lane, Melbourne VIC 3000, Australia
		&lt;/address&gt;
	</code>
-->
<#macro PostFullAddress result>
	<#if result.metaData.stencilsFacebookPostCountry??>
	<!-- facebook.view.ftl :: PostAddress -->
	<address class="stencils-core-location" <#if result.metaData.stencilsFacebookPostLatlong??>data-latLng="${result.metaData.stencilsFacebookPostLatlong!}"</#if> >
		<#if result.metaData.stencilsFacebookPostStreet??>${result.metaData.stencilsFacebookPostStreet!},</#if>
		${result.metaData.stencilsFacebookPostCity!}
		${result.metaData.stencilsFacebookPostState!}
		${result.metaData.stencilsFacebookPostPostcode!},
		${result.metaData.stencilsFacebookPostCountry!}
	</address>
	</#if>
</#macro>

<#--- Facebook Post Link format. -->
<#macro PostLinkSnippet result>
	<#if result.metaData.stencilsFacebookPostLinkCaption??>
	<!-- facebook.view.ftl :: PostLinkSnippet -->
	<div class="thumbnail media-object">
		<#if result.metaData.stencilsFacebookPostThumbnailUrl??>
			<img src="${result.metaData.stencilsFacebookPostThumbnailUrl!}" alt="${result.metaData.c!}" />
		</#if>
		<div class="caption">
			<strong><a href="${result.metaData.stencilsFacebookPostLink}">${result.metaData.stencilsFacebookPostLinkCaption!}</a></strong><br>
			<#if result.metaData.stencilsFacebookPostLinkDescription??><p>${result.metaData.stencilsFacebookPostLinkDescription!}</p></#if>
		</div>
	 </div>
	</#if>
</#macro>


<#-- @end --><#-- /Result Post -->

<#-- @begin  Result Event -->

<#--- View for search result type of Facebook 'event'. -->
<#macro ResultEvent result>
	<!-- facebook.view.ftl :: ResultEvent -->
	<div class="panel panel-default stencils-progressive-disclosure" id="result-${result.rank!}">

		<div class="panel-heading" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
			<div class="media">
				<#if result.metaData.a??>
					<a href="${result.customData["stencilsFacebookProfileUrl"]!}" class="pull-left">
					<#-- *Note: Because	stencilsFacebookProfileImageUrl is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
					<img class="media-object" src="${result.customData["stencilsFacebookProfileImageUrl"]!}?width=40&amp;height=40" alt="Profile Image of ${result.metaData.a!}">
				</a>
				</#if>
				<div class="media-body">
					<div><a href="${result.customData["stencilsFacebookProfileUrl"]!}"><@core_controller.boldicize>${result.metaData.a!}</@core_controller.boldicize></a> </div>
					<small class="text-muted">
						<i class="fa fa-pencil"></i> Published	<#if result.date??><span data-moment="relative" data-moment-datetime="${result.date?datetime?string.iso}">${result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
					</small>

				</div>
			</div>
		</div>

		<div class="panel-body" data-mh="group-body-${base_controller.resultsColumnsIndex!}">
			<h4>
				<a href="${result.clickTrackingUrl!}" title="${result.liveUrl!}">
					<@core_controller.boldicize>${result.title!}</@core_controller.boldicize>
				</a>
			</h4>
			<small class="text-muted">

				<#if result.customData["stencilsFacebookEventIsPast"]!true>
					<i class="fa fa-calendar"></i> Event occurred
					<i class="fa fa-clock-o"></i> <@EventOccurredDateTime result=result />
				<#else>
					<i class="fa fa-calendar"></i> Upcoming Event on
					<i class="fa fa-clock-o"></i> <@EventDateTime result=result />
				</#if>

				<#if result.metaData.stencilsFacebookEventVenueCountry?? || result.metaData.stencilsFacebookEventLocation??>
					at <i class="fa fa-map-marker"></i> <@EventVenueFullAddress result=result />
				</#if>

			</small>

			<#if result.metaData.c??>
			<p><@core_controller.boldicize><@core_controller.Truncate length=200>${result.metaData.c!}</@core_controller.Truncate></@core_controller.boldicize></p>
			</#if>

			<#-- ResultCollaspe Generate the result collapsing link -->
			<@core_controller.Collapsed result=result>
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
			<@ResultFooter result=result/>
		</div>
	</div>
</#macro>
<#-- /ResultEvent-->

<#--- Modal view for search result type of Facebook 'event'. -->
<#macro ResultEventModal result>
	<!-- facebook.view.ftl :: ResultEventModal -->
	<div data-fb-result="${result.liveUrl!}" class="modal fade ng-scope" id="result-modal-${result.rank!}" tabindex="-1" role="dialog" aria-labelledby="result-${result.rank!}" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
					<div class="media">
						<#if result.metaData.a??>
						<a href="${result.customData["stencilsFacebookProfileUrl"]!}" class="pull-left">
							<#-- *Note: Because	stencilsFacebookProfileImageUrl is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
							<img class="media-object" src="${result.customData["stencilsFacebookProfileImageUrl"]!}?width=40&amp;height=40" alt="Profile Image of ${result.metaData.a!}">
						</a>
						</#if>
						<div class="media-body">
							<div><a href="${result.customData["stencilsFacebookProfileUrl"]!}"><@core_controller.boldicize>${result.metaData.a!}</@core_controller.boldicize></a> </div>
							<small class="text-muted">
								<i class="fa fa-pencil"></i> Published	<#if result.date??><span data-moment="relative" data-moment-datetime="${result.date?datetime?string.iso}">${result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
							</small>

						</div>
					</div>
				</div>
				<div class="modal-body">
						<h4>
							<a href="${result.clickTrackingUrl!}" title="${result.liveUrl!}">
								${result.title!}
							</a>
						</h4>
						<small class="text-muted">

							<#if result.customData["stencilsFacebookEventIsPast"]!true>
								<i class="fa fa-calendar"></i> Event occurred
								<i class="fa fa-clock-o"></i> <@EventOccurredDateTime result=result />
							<#else>
								<i class="fa fa-calendar"></i> Upcoming Event on
								<i class="fa fa-clock-o"></i> <@EventDateTime result=result />
							</#if>


							<#if result.metaData.stencilsFacebookEventVenueCountry?? || result.metaData.stencilsFacebookEventLocation??>
								at <i class="fa fa-map-marker"></i> <@EventVenueFullAddress result=result />
							</#if>

						</small>

						<#if result.metaData.c??>
						<p><@base_controller.Linkify><@core_controller.Truncate length=512>${result.metaData.c!}</@core_controller.Truncate></@base_controller.Linkify></p>
						</#if>

						<#-- ResultCollaspe Generate the result collapsing link -->
						<@core_controller.Collapsed result=result>
							<div class="search-collapsed">
								<small>
									<span class="glyphicon glyphicon-expand text-muted"></span>&nbsp;
									<a class="search-collapsed" href="<@resultedUrl />">
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
					<@ResultModalFooter result=result />
				</div>
			</div>
		</div>
	</div>
</#macro>
<#-- /ResultEventModal-->

<#---
	Facebook Event start and end datetime format.

	<h3>Example Outputs</h3>
	<h4>No end date</h4>
	<p>Saturday, August 22 at 10:00pm</p>
	<h4>End date is day after start date.</h4>
	<p>Saturday, August 22 at 10:00pm ending at 4:00am</p>
	<h4>End date is more than one day after start date.</h4>
	<p>Saturday, August 22 at 10:00pm ending Saturday, August 28 at 4:00am</p>

-->
<#macro EventDateTime result>
	<#-- Start date	-->
	<time datetime="${result.customData["stencilsFacebookEventStartDate"]!?datetime?string.xs}">
		${result.customData["stencilsFacebookEventStartDate"]!?string["EEEE, MMMM d"]} at ${result.customData["stencilsFacebookEventStartDate"]!?string["h:mma"]}
	</time>

	<#--	End Date: Display end date and time if the event has one.	-->
	<#if result.metaData.stencilsFacebookEventEndDateTime??>
		<time datetime="${result.customData["stencilsFacebookEventEndDate"]!?datetime?string.xs}">
			ending
			<#-- End Date: Display Day and Month -->
			<#if ( result.customData["stencilsFacebookEventStartDate"]!?string["YYYYd"] == result.customData["stencilsFacebookEventEndDate"]!?string["YYYYd"] )>
				<#-- End Date: If the event end date is day after start date do not print end date day and month.-->
			<#else>
				<#-- End Date: Print the day and month if end date is more than one day after start date. -->
				${result.customData["stencilsFacebookEventEndDate"]!?string["EEEE, MMMM d"]} at
			</#if>
			<#-- Time of event end -->
			${result.customData["stencilsFacebookEventEndDate"]!?string["h:mma"]}
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
-->
<#macro EventOccurredDateTime result>
	<#-- Start Date -->
	<time datetime="${result.customData["stencilsFacebookEventStartDate"]!?datetime?string.xs}">
		${result.customData["stencilsFacebookEventStartDate"]!?string["EEEE, MMMM d"]} at ${result.customData["stencilsFacebookEventStartDate"]!?string["h:mma"]}<#if !result.metaData.stencilsFacebookEventEndDateTime??>,</#if>
	</time>

	<#--	End Date: Display end date and time if the event has one.	-->
	<#if result.metaData.stencilsFacebookEventEndDateTime??>
	<time datetime="${result.customData["stencilsFacebookEventEndDate"]!?datetime?string.xs}">
		to
		<#if ( result.customData["stencilsFacebookEventStartDate"]!?string["YYYYd"] == result.customData["stencilsFacebookEventEndDate"]!?string["YYYYd"] )>
			<#-- End Date: If the event end date is day after start date do not print end date day and month.-->
		<#else>
			<#-- End Date: Print the day and month if end date is more than one day after start date. -->
			${result.customData["stencilsFacebookEventEndDate"]!?string["EEEE, MMMM d"]} at
		</#if>
		<#-- Time of event end -->
		 ${result.customData["stencilsFacebookEventEndDate"]!?string["h:mma"]},
	</time>
	</#if>

	<#-- Year event occured on
		If the event has an end date use, end date Year as the date the event occured on, other wise use start date year.
	-->
	<#if result.metaData.stencilsFacebookEventEndDateTime??>
		${result.customData["stencilsFacebookEventEndDate"]?string["yyyy"]}
	<#else>
		${result.customData["stencilsFacebookEventStartDate"]!?string["yyyy"]}
	</#if>
</#macro>

<#--- Facebook Event full address format. -->
<#macro EventVenueFullAddress result>
	<!-- facebook.view.ftl :: EventFullAddress -->

	<#-- Venue Location Name-->
	<#if result.metaData.stencilsFacebookEventLocation??>
	<strong>${result.metaData.stencilsFacebookEventLocation}</strong>
	</#if>

	<#-- If Event Has both location and country display separator -->
	<#if result.metaData.stencilsFacebookEventLocation?? && result.metaData.stencilsFacebookEventVenueCountry??>
		,
	</#if>

	<#--	Venue Area/Address -->
	<#if result.metaData.stencilsFacebookEventVenueCountry??>
	<address class="stencils-core-location" >
		<#if result.metaData.stencilsFacebookEventVenueStreet??>${result.metaData.stencilsFacebookEventVenueStreet},</#if>
		${result.metaData.stencilsFacebookEventVenueCity!}
		${result.metaData.stencilsFacebookEventVenueState!}
		${result.metaData.stencilsFacebookEventVenuePostCode!},
		${result.metaData.stencilsFacebookEventVenueCountry!}
	</address>
	</#if>
</#macro>
<#-- @end --><#-- /Result Event -->

<#-- @begin	 Result Page -->

<#--- View for search result type of Facebook 'page'. -->
<#macro ResultPage result>
	<!-- facebook.view.ftl :: ResultPage -->
	<div class="panel panel-default stencils-progressive-disclosure" id="result-${result.rank!}">
		<div class="panel-heading" data-mh="group-heading-${base_controller.resultsColumnsIndex!}">
			<div class="media">
				<a href="${result.clickTrackingUrl!}" title="${result.liveUrl!}" class="pull-left stencils-facebook-page-info media-object">
						<#-- *Note: Because	this is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
						<img src="${result.customData["stencilsFacebookPageImageUrl"]!}?width=40&amp;height=40" alt="Thumbnail image for ${result.title!}'s facebook page.">
				</a>

				<div class="media-body">
					<h4 class="h3">
						<a href="${result.clickTrackingUrl!}" title="${result.liveUrl!}">
							<@core_controller.boldicize>${result.title!}</@core_controller.boldicize>
						</a>
					</h4>
					<small class="text-muted">
						<i class="fa fa-pencil"></i> Published	<#if result.date??><span data-moment="relative" data-moment-datetime="${result.date?datetime?string.iso}">${result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
					</small>
				</div>
			</div>
		</div>
		<div class="panel-body" data-mh="group-body-${base_controller.resultsColumnsIndex!}">
			<@base_controller.IfDefCGIEquals name="resultsView" value="grid">
				<#if base_controller.resultsColumnsNumber gt 2>
				<img src="${result.customData["stencilsFacebookPageImageUrl"]!}?width=150&amp;height=150" alt="Thumbnail image for ${result.title!}'s facebook page." class="stencils-core-thumbnail pull-right" />
				</#if>
			</@base_controller.IfDefCGIEquals>

			<#if result.metaData.c??>
			 <p><@core_controller.boldicize><@core_controller.Truncate length=200>${result.metaData.c!}</@core_controller.Truncate></@core_controller.boldicize></p>
			<#else>
				<#if result.metaData.stencilsFacebookPageAbout??>
					<p><@core_controller.Truncate length=200> ${result.metaData.stencilsFacebookPageAbout}</@core_controller.Truncate></p>
				</#if>
			</#if>

			<#-- ResultCollaspe Generate the result collapsing link -->
			<@core_controller.Collapsed result=result>
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
			<@ResultFooter result=result />
		</div>
	</div>
</#macro>
<#-- /ResultPage-->

<#--- Modal view for search result type of Facebook 'Page'. -->
<#macro ResultPageModal result>
	<!-- facebook.view.ftl :: ResultPageModal -->
	<div data-fb-result="${result.liveUrl!}" class="modal fade ng-scope" id="result-modal-${result.rank!}" tabindex="-1" role="dialog" aria-labelledby="result-${result.rank!}" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
					<div class="media">
						<a href="${result.clickTrackingUrl!}" title="${result.liveUrl!}" class="pull-left media-object">
								<#-- *Note: Because	this is a facebook pciture URL you can pass through height and width cgi parameters to set size see https://developers.facebook.com/docs/graph-api/reference/profile-picture-source/ -->
								<img src="${result.customData["stencilsFacebookPageImageUrl"]!}?width=40&amp;height=40" alt="Thumbnail image for ${result.title!}'s facebook page.">
						</a>

						<div class="media-body">
							<h4 class="h3">
								<a href="${result.clickTrackingUrl!}" title="${result.liveUrl!}">
									${result.title!}
								</a>
							</h4>
							<small class="text-muted">
								<i class="fa fa-pencil"></i> Published	<#if result.date??><span data-moment="relative" data-moment-datetime="${result.date?datetime?string.iso}">${result.date?date?string("d MMM yyyy")}</span></#if> via <@FacebookLink />
							</small>
						</div>
					</div>
				</div>
				<div class="modal-body">

						<#if result.metaData.c??>
							<p><@base_controller.Linkify><@core_controller.Truncate length=512>${result.metaData.c!}</@core_controller.Truncate></@base_controller.Linkify></p>
						</#if>

						<#if result.metaData.stencilsFacebookPageAbout??>
							<h5 class="small">About</h5>
							<p class="small"><@core_controller.Truncate length=200> ${result.metaData.stencilsFacebookPageAbout}</@core_controller.Truncate></p>
						</#if>

						<#if result.metaData.stencilsFacebookPageMission??>
							<h5 class="small">Mission</h5>
							<p class="small"><@core_controller.Truncate length=200>${result.metaData.stencilsFacebookPageMission}</@core_controller.Truncate>
							</p>
						</#if>

						<p class="text-muted small">
							<#if result.metaData.stencilsFacebookPageCategory??>
								<strong>Category:</strong> ${result.metaData.stencilsFacebookPageCategory} &bull;
							</#if>
							<#if result.metaData.stencilsFacebookPageFounded??>
								<strong>Founded:</strong> ${result.metaData.stencilsFacebookPageFounded} &bull;
							</#if>
							<#if result.metaData.stencilsFacebookPagePhone??>
								<strong>Phone:</strong> ${result.metaData.stencilsFacebookPagePhone} &bull;
							</#if>

							<#if result.metaData.stencilsFacebookPageProducts??>
								<strong>Products:</strong> ${result.metaData.stencilsFacebookPageProducts} &bull;
							</#if>
						</p>

						<#if result.metaData.stencilsFacebookPageCountry??>
							<div class="text-muted small"> <i class="fa fa-map-marker"></i> <@PageFullAddress result=result/></div>
						</#if>

						<#-- ResultCollaspe Generate the result collapsing link -->
						<@core_controller.Collapsed result=result>
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
					<@ResultModalFooter result=result />
				</div>
			</div>
		</div>
	</div>
</#macro>
<#-- /ResultPageModal-->

<#--- Page full Adress format. -->
<#macro PageFullAddress result>
	<!-- facebook.view.ftl :: PageFullAddress -->
	<#if result.metaData.stencilsFacebookPageCountry??>
	<address class="stencils-core-location" >
		<#if result.metaData.stencilsFacebookPageStreet??>${result.metaData.stencilsFacebookPageStreet},</#if> ${result.metaData.stencilsFacebookPageCity!} ${result.metaData.stencilsFacebookPageState!} ${result.metaData.stencilsFacebookPagePostCode!}, ${result.metaData.stencilsFacebookPageCountry!}
	</address>
	</#if>
</#macro>

<#-- @end --><#-- /Result Page -->

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
							<ng-switch on="item.metaData.stencilsFacebookType">
							  <div ng-switch-when="POST"><@CartResultPost /></div>
							  <div ng-switch-when="EVENT"><@CartResultEvent /></div>
								<div ng-switch-when="PAGE"><@CartResultPage /></div>
							</ng-switch>
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
<#macro CartResultPost>
	<h4>
		<a title="Remove" data-ng-click="remove(item.indexUrl)" href="javascript:;"><small class="glyphicon glyphicon-remove"></small></a>
		<a href="{{item.indexUrl}}" data-ng-show="item.metaData.stencilsFacebookPostID" title="{{item.indexUrl}}">Facebook post: {{item.metaData.stencilsFacebookPostID}}</a>
	</h4>
	<p data-ng-hide="!item.summary">{{item.summary|truncate:255}}</p>
	<p data-ng-hide="!item.metaData.c">{{item.metaData.c|truncate:255}}</p>
</#macro>

<#---
	View for result format in cart. Uses angular templating.
  -->
<#macro CartResultEvent>
	<h4>
		<a title="Remove" data-ng-click="remove(item.indexUrl)" href="javascript:;"><small class="glyphicon glyphicon-remove"></small></a>
		<a href="{{item.indexUrl}}" data-ng-show="item.title" title="{{item.indexUrl}}">Facebook event: {{item.title|truncate:150}}</a>
	</h4>
	<p data-ng-hide="!item.summary">{{item.summary|truncate:255}}</p>
	<p data-ng-hide="!item.metaData.c">{{item.metaData.c|truncate:255}}</p>
</#macro>

<#---
	View for result format in cart. Uses angular templating.
  -->
<#macro CartResultPage>
	<h4>
		<a title="Remove" data-ng-click="remove(item.indexUrl)" href="javascript:;"><small class="glyphicon glyphicon-remove"></small></a>
		<a href="{{item.indexUrl}}" data-ng-show="item.title" title="{{item.indexUrl}}">Facebook page: {{item.title|truncate:150}}</a>
	</h4>
	<p data-ng-hide="!item.summary">{{item.summary|truncate:255}}</p>
	<p data-ng-hide="!item.metaData.c">{{item.metaData.c|truncate:255}}</p>
</#macro>

<#-- @end -->
<#-- / Category - Cart -->

