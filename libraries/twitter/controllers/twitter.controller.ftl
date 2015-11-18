<#ftl encoding="utf-8" />
<#---
	<p>Provides helpers for building Twitter components.</p>
	<p>This includes helpers for Twitter results that extend the data model depending on the content type.</p>

	<h2>Table of Contents</h2>
	<ul>
		<li><strong>General:</strong> General twitter helpers.</li>
		<li><strong>Result Tweet:</strong>  Twitter tweet result.</li>
	</ul>
-->
<#escape x as x?html>
<#-- ################### Configuration ####################### -->
<#-- Import Utilities -->
<#import "/share/stencils/libraries/stencils.utilities.ftl" as stencils_utilities />

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core","base"] />

<#--
	The following code imports and assigns stencil namespaces automatically eg. core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/

 	Note: View files should not be imported to to the controller
-->
<@stencils_utilities.ImportStencilsControllers stencils=stencils>
	<@stencils_utilities.importsControllers?interpret />
</@stencils_utilities.ImportStencilsControllers>

<#-- ################### Controllers ####################### -->
<#-- @begin  General -->
<#---
	Inserts links for Twitter hashtags.
	@param nested The string to transform.
	@return string
-->
<#macro Hashtagify>
	<#local content><#nested></#local>
	<#if content??>
			<#noescape>
				<#list content?matches("\\s#([^:,\\s]+)") as match>
					<#local content>
					${content?replace(match, " <a href='https://twitter.com/hashtag/" + match?groups[1] + "' >" + match + "</a>", "f")}
					</#local>
				</#list>
				${content}
			</#noescape>
	<#else>
		${content}
	</#if>
</#macro>

<#---
	Converts user @ references such as ''@RMIT'	into links twitter hashtag links.
	@param nested The string to transform.
	@return string
-->
<#macro UserLinkify>
	<#local content><#nested></#local>
	<#if content??>
			<#noescape>
				<#list content?matches("\\s@([^:,\\s]+)") as match>
					<#local content>
					${content?replace(match, " <a href='https://twitter.com/" + match?groups[1] + "' >" + match + "</a>", "f")}
					</#local>
				</#list>
				${content}
			</#noescape>
	<#else>
		${content}
	</#if>
</#macro>

<#---
	Generates the profile URL based on the tweets author's screen name. Returns Url of for twitter profile e.g. '//twitter.com/RMIT'
	@param screenName Twitter screen name.
	@return string
-->
<#function generateProfileUrl screenName="">
	<#return "//twitter.com/${screenName?url}">
</#function>

<#-- @end --><#-- / Category - General  -->
<#-- @begin  Result Tweet -->
<#---
	Constructor for tweet.
	@requires core_view.results
	@provides <code>$&#123;twitter_controller.tweetUserProfileUrl&#125;</code> <code>$&#123;twitter_controller.tweetText&#125;</code>
	Defines two new attributes.
	@return nested
-->
<#macro Tweet>
	<#assign tweetUserProfileUrl in .namespace><@TweetUserProfileUrl /></#assign>
	<#assign tweetText in .namespace><@TweetText /></#assign>

	<#nested>
</#macro>

<#---
	Returns the profile URL from the author of the post. Can also be accessed by <code>$&#123;twitter_controller.tweetUserProfileUrl&#125;</code>.
	@requires Tweet
	@return string
-->
<#macro TweetUserProfileUrl><#compress>
${generateProfileUrl(core_controller.result.metaData.stencilsTwitterScreenName)}
</#compress></#macro>

<#---
	Transforms tweet to link hashtags, usernames and URLs. Can also ber access by <code>$&#123;twitter_controller.tweetText&#125;</code>
	@requires Tweet
	@return string
-->
<#macro TweetText><#compress>
<@UserLinkify><@Hashtagify><@base_controller.Linkify>${core_controller.result.metaData.c}</@base_controller.Linkify></@Hashtagify></@UserLinkify>
</#compress></#macro>
<#-- @end --><#-- / Category - Result Tweet -->

</#escape>
