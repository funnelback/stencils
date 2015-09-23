<#ftl encoding="utf-8" />
<#--
   Stencil: Twitter
   By: Robert Prib
   Description: Display results from social media collections such as Facebook, Twitter, YouTube and Flickr.
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Stencils which are to be included -->
<#assign stencils = ["core","results"] />

<#--
  The following code imports and assigns stencil namespaces automatically eg. core and core_view.
  The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/
  and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/

  Note: The full path has been added to ensure that the correct folder is being picked up
-->
<#list stencils as stencil>
  <#assign controller = "/share/stencils/libraries/${stencil}.controller.ftl" stencilNamespaceController="${stencil?lower_case}_controller" />
  <#assign view ="/conf/${question.collection.id}/${question.profile}/${stencil}.view.ftl" stencilNamespaceView="${stencil?lower_case}_view" />
  <@'<#import controller as ${stencilNamespaceController}>'?interpret />
  <@'<#import view as ${stencilNamespaceView}>'?interpret />
</#list>

<#--
  If for any reason you need to modify a controller (not recommended as it will no longer be upgraded as part of the stencils release cycle), you can remove the stencil from the stencils array, take a copy of the controller and move it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/. You will then need to import it using the following:

  <#import "<stencil name>.controller.ftl" as <stencil name>_controller>
  <#import "<stencil name>.view.ftl" as <stencil name>_view>

  e.g. If you are using the core and base stencil but you want to override the base.controller.ftl

  You will need to:
  - Copy base.controller.ftl from  $SEARCH_HOME/share/stencils/libraries/ and store it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
  - Change 'stencils = ["core", "base"]' to 'stencils = ["core"]'
  - Add '<#import "base.controller.ftl" as base_controller>' to the top of your file
  - Add '<#import "base.view.ftl" as base_view>' to the top of your file
-->

<#-- Import the main macros used to put together this app -->
<#import "/share/stencils/libraries/twitter.controller.ftl" as twitter_controller/>

<#--
	The following functions are generic layout code which can be copied and customised
	to suit individual implementations.

	Note: Before the tab layout can be used, you must enable the full facet list by addition the following to collection.cfg

	ui.modern.full_facets_list=true

	It is also best practice to hide the facet group which has been used to populate the tabs from the list of available facets
--->

<#--
  Results Wrapper
-->
<#macro Result>

  <@base_controller.IfDefCGIEquals value="list" trueIfEmpty=true>
      <@ResultBasic />
  </@base_controller.IfDefCGIEquals>
  <#-- List view -->

  <@base_controller.IfDefCGIEquals value="grid" >
    <#local columnOpen><li class="row"><ol class="list-unstyled"></#local>
    <#local columnClose></ol></li></#local>
    <@base_controller.GroupResults groupSize=3 open=columnOpen close=columnClose>
      <@ResultBasicGrid />
    </@base_controller.GroupResults>
  </@base_controller.IfDefCGIEquals>
  <#-- Grid view -->

  <@base_controller.IfDefCGIEquals value="masonry" >
      <@ResultBasicMasonry />
  </@base_controller.IfDefCGIEquals>
  <#-- Grid view -->

</#macro>

<#--
  Result type: Basic
 -->
<#macro ResultBasic>


  <li data-fb-result=${s.result.indexUrl}>

    <div class="panel panel-default">
        <div class="panel-heading">
        <#-- User Details -->
              <div class="media">

                <div class="pull-left">
                  <a href="<@twitter_controller.profileUrl />">
                      <img class="media-object" src="${s.result.metaData.profileImageUrl}" alt="Profile Image of ${s.result.metaData.name}">
                    </a>
                </div>

                <div class="media-body">

                  <h4 class="media-heading">
                    <a href="<@twitter_controller.profileUrl />">${s.result.metaData.username} <small>@${s.result.metaData.name}</small></a>
                  </h4>

                  <p class="text-muted">
                   <a href="${s.result.clickTrackingUrl}" title="${s.result.liveUrl}"><small  data-date="${s.result.date?date?string("d MMM yyyy")}">Tweeted: ${s.result.date?date?string("d MMM yyyy")}</small></a>
                  </p>

                </div>

              </div>
              <#-- /User details -->

        </div>

      <div class="panel-body">


          <@twitter_controller.hashtagify>${s.result.metaData.tweet}</@twitter_controller.hashtagify>

          <@twitter_controller.linkify>${s.result.metaData.tweet}</@twitter_controller.linkify>

          <#if s.result.metadatapictureUrl??>
            <img src="${s.result.metaData.pictureUrl}"/>
          </#if>
      </div>

    </div>
  </li>
</#macro>
<#-- /Result Twitter-->

<#--
  Result type: Basic Grid
 -->
<#macro ResultBasicGrid>


  <li data-fb-result=${s.result.indexUrl} class="col-md-4">

    <div class="panel panel-default">
        <div class="panel-heading">
        <#-- User Details -->
              <div class="media">

                <div class="pull-left">
                  <a href="<@twitter_controller.profileUrl />">
                      <img class="media-object" src="${s.result.metaData.profileImageUrl}" alt="Profile Image of ${s.result.metaData.name}">
                    </a>
                </div>

                <div class="media-body">

                  <h4 class="media-heading">
                    <a href="<@twitter_controller.profileUrl />">${s.result.metaData.username} <small>@${s.result.metaData.name}</small></a>
                  </h4>

                  <p class="text-muted">
                   <a href="${s.result.clickTrackingUrl}" title="${s.result.liveUrl}"><small  data-date="${s.result.date?date?string("d MMM yyyy")}">Tweeted: ${s.result.date?date?string("d MMM yyyy")}</small></a>
                  </p>

                </div>

              </div>
              <#-- /User details -->

        </div>

      <div class="panel-body">


          <@twitter_controller.hashtagify>${s.result.metaData.tweet}</@twitter_controller.hashtagify>

          <@twitter_controller.linkify>${s.result.metaData.tweet}</@twitter_controller.linkify>

          <#if s.result.metadatapictureUrl??>
            <img src="${s.result.metaData.pictureUrl}"/>
          </#if>
      </div>

    </div>
  </li>
</#macro>
<#-- /Result Basic Grid-->

<#--
  Result type: Basic Masonry
 -->
<#macro ResultBasicMasonry>


  <li data-fb-result=${s.result.indexUrl} class="col-md-4 js-masonry-item">

    <div class="panel panel-default">
        <div class="panel-heading">
        <#-- User Details -->
              <div class="media">

                <div class="pull-left">
                  <a href="<@twitter_controller.profileUrl />">
                      <img class="media-object" src="${s.result.metaData.profileImageUrl}" alt="Profile Image of ${s.result.metaData.name}">
                    </a>
                </div>

                <div class="media-body">

                  <h4 class="media-heading">
                    <a href="<@twitter_controller.profileUrl />">${s.result.metaData.username} <small>@${s.result.metaData.name}</small></a>
                  </h4>

                  <p class="text-muted">
                   <a href="${s.result.clickTrackingUrl}" title="${s.result.liveUrl}"><small  data-date="${s.result.date?date?string("d MMM yyyy")}">Tweeted: ${s.result.date?date?string("d MMM yyyy")}</small></a>
                  </p>

                </div>

              </div>
              <#-- /User details -->

        </div>

      <div class="panel-body">


          <@twitter_controller.hashtagify>${s.result.metaData.tweet}</@twitter_controller.hashtagify>

          <@twitter_controller.linkify>${s.result.metaData.tweet}</@twitter_controller.linkify>

          <#if s.result.metadatapictureUrl??>
            <img src="${s.result.metaData.pictureUrl}"/>
          </#if>
      </div>

    </div>
  </li>
</#macro>
<#-- /Result Basic Masonry-->


</#escape>

