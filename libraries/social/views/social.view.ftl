<#ftl encoding="utf-8" />
<#---
	 <p>Provides views for Social media components.</p>
	 <p>These compontents include items such as ... well just not much at the moment.</p>
	 <p>This should generally not include to anything componets specific to a singluar social media source, these should be added to the invidual social media stencils.</p>

	 <h2>Table of Contents</h2>
	 <ul>
		 <li><strong>Configuration:</strong> Configuration options for Social Media Stencil.</li>
	 </ul>
-->
<#escape x as x?html>

<#-- ################### Configuration ####################### -->
<#-- @begin Configuration -->
<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign socialResourcesPrefix = "/stencils/resources/social/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#-- Import Utilities -->
<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />

<#-- Import Controller -->
<#import "${librariesPrefix}social/controllers/social.controller.ftl" as social_controller/>

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core","base","facebook","twitter","youtube","flickr"] />
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
	<!-- social.view.ftl :: CSS -->
	<link rel="stylesheet" href="${socialResourcesPrefix}css/social.css">
</#macro>

<#---
	JavaScript dependencies
 -->
<#macro JS>
	<!-- social.view.ftl :: JS -->
	<#-- This commented out because stencils.social.js is not required currently -->
	<#-- <script src="${socialResourcesPrefix}js/stencils.social.js"></script> -->
</#macro>
<#-- @end --><#-- /Configuration -->
<#-- ###################  Views ####################### -->

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
								<div ng-switch-when="POST"><@facebook_view.CartResultPost /></div>
								<div ng-switch-when="EVENT"><@facebook_view.CartResultEvent /></div>
								<div ng-switch-when="PAGE"><@facebook_view.CartResultPage /></div>
							</ng-switch>

							<div ng-if=" item.metaData.collection == 'stencils-twitter-custom' ">
								<@twitter_view.CartResult />
							</div>

							<div ng-if=" item.metaData.collection == 'stencils-youtube-custom' ">
								<@youtube_view.CartResult />
							</div>

							<div ng-if=" item.metaData.collection == 'stencils-flickr-custom' ">
								<@flickr_view.CartResult />
							</div>

						</li>
					</ul>
				</div>
			</div>
		</div>
	</#if>
</#macro>

</#escape>
