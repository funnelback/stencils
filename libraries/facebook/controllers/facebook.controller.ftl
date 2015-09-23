<#ftl encoding="utf-8" />
<#---
	<p>Provides helpers for building Facebook components.</p>
	<p>This includes helpers for Facebook results that extend the data model depending on the content type.</p>

	<h2>Table of Contents</h2>
	<ul>
		<li><strong>General:</strong> General facebook helpers.</li>
		<li><strong>Result:</strong>  Facebook result.</li>
		<li><strong>Post:</strong>   Result type of Facebook 'post'. </li>
		<li><strong>Result Event:</strong>  Result type of Facebook 'event'.</li>
		<li><strong>Result Page:</strong>  Result type of Facebook 'page'.</li>
	</ul>

-->
<#escape x as x?html>
<#-- ################### Configuration ####################### -->
<#-- Import Utilities -->
<#import "/web/templates/modernui/stencils-libraries/stencils.utilities.ftl" as stencils_utilities />

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils=["core","base"] />

<#--
	The following code imports and assigns stencil namespaces automatically eg. core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/web/templates/modernui/stencils-libraries/

 	Note: View files should not be imported to to the controller
-->
<@stencils_utilities.ImportStencilsControllers stencils=stencils>
	<@stencils_utilities.imports?interpret />
</@stencils_utilities.ImportStencilsControllers>

<#-- ###################  Controllers ####################### -->
<#-- @begin  General -->
<#---
	Transofrms hastags in string into facebook hastag links.
	@param nested String to Hashtagify.
-->
<#macro Hashtagify>
	<#local content><#nested></#local>
	<#if content??>
			<#noescape>
				<#list content?matches("\\s#([^:,\\s]+)") as match>
					<#local content>
					${content?replace(match, " <a href='https://www.facebook.com/hashtag/" + match?groups[1] + "' >" + match + "</a>", "f")}
					</#local>
				</#list>
				${content}
			</#noescape>
	<#else>
		${content}
	</#if>
</#macro>

<#---
	Generates the profile facebook URL.
	@param ID Facebook user ID.
	@return string
-->
<#function generateProfileUrl ID="">
	<#return "//facebook.com/${ID?url}" >
</#function>

<#---
	Generates the profile image URL based on the facebook users numeric id.
	@param ID Facebook user ID.
-->
<#function generateProfileImageUrl ID="">
	<#return "//graph.facebook.com/${ID?url}/picture">
</#function>

<#---
	Converts datetime provided into a date object.
	@param dt String of facebook date time e.g. '2015-02-06 22:15:00.0 UTC'
	@return datetime
-->
<#function convertFacebookDateTime dt="">
	<#return dt?datetime("yyyy-MM-dd HH:mm:ss.S z") >
</#function>

<#---
	Returns true is datetime is past current datetime.
	@param dt Datetime to check against current datetime
	@return boolean
-->
<#function isDatePast dt>
	<#assign dtNow = .now?string["yyyymmddhhmmss"]?number>
	<#return dtNow gt dt?string["yyyymmddhhmmss"]?number>
</#function>
<#-- @end -->
<#-- /Category - General -->

<#-- @begin Result -->
<#---
	Check the result type string for facebook and print nested if true.
	@param type Facebook conent type. This either "post","event" or "page".
	@requires core_view.Results
-->
<#macro ResultIsTypeOf type="">
	<#if core_controller.result.metaData.stencilsFacebookType?lower_case =	type>
		<#nested>
	</#if>
</#macro>
<#-- @end -->
<#-- /Category - Result -->

<#-- @begin Post -->
<#---
	Constructor for post.
	@requires core_view.Results
	@provides <code>$&#123;facebook_controller.postuserProfileUrl&#125;</code>  <code>$&#123;facebook_controller.postUserProfileImageUrl&#125;</code>  <code>$&#123;facebook_controller.postText&#125;</code>
-->
<#macro Post>
	<#assign postUserProfileUrl in .namespace><@PostUserProfileUrl /></#assign>
	<#assign postUserProfileImageUrl in .namespace><@PostUserProfileImageUrl /></#assign>
	<#assign postText in .namespace><@PostText /></#assign>

	<#nested>
</#macro>

<#---
	Returns the profile URL from the author of the post. Can also be accessed by <code>$&#123;facebook_controller.postuserProfileUrl&#125;</code>
	@requires Post
-->
<#macro PostUserProfileUrl><#compress>
${generateProfileUrl(core_controller.result.metaData.stencilsFacebookPostUserID)}
</#compress></#macro>

<#---
	Returns the profile image URL from the author of the post. Can also be accessed by <code>$&#123;facebook_controller.postUserProfileImageUrl&#125;</code>
	@requires Post
-->
<#macro PostUserProfileImageUrl><#compress>
${generateProfileImageUrl(core_controller.result.metaData.stencilsFacebookPostUserID)}
</#compress></#macro>

<#---
	Transforms post message to link hashtags, usernames and URLs. Can also be accessed by <code>$&#123;facebook_controller.postText&#125;</code>
	@requires Post
-->
<#macro PostText><#compress>
<@Hashtagify><@base_controller.Linkify>${core_controller.result.metaData.c}</@base_controller.Linkify></@Hashtagify>
</#compress></#macro>
<#-- @end --><#-- /Category - Post -->
<#-- @begin  Event -->
<#---
	Constructor for event.
	@provides <code>$&#123;facebook_controller.eventUserProfileUrl&#125;</code> <code>$&#123;facebook_controller.eventUserProfileImageUrl&#125;</code> <code>$&#123;facebook_controller.eventStartDateTime&#125;</code> <code>$&#123;facebook_controller.eventEndDateTime&#125;</code> <code>$&#123;facebook_controller.eventIsPast&#125;</code>
	@requires core_view.Results
-->
<#macro Event>
	<#assign eventUserProfileUrl in .namespace><@EventUserProfileUrl /></#assign>
	<#assign eventUserProfileImageUrl in .namespace><@EventUserProfileImageUrl /></#assign>
	<#assign eventStartDateTime = getEventStartDateTime() in .namespace>
	<#assign eventEndDateTime = getEventEndDateTime() in .namespace>
	<#assign eventIsPast = getIsEventPast() in .namespace>

	<#nested>
</#macro>

<#--
	Profile URL from the author of the event. Can also be accessed by <code>$&#123;facebook_controller.eventUserProfileUrl&#125;</code>
	@requires Event
-->
<#macro EventUserProfileUrl><#compress>
${generateProfileUrl(core_controller.result.metaData.stencilsFacebookEventUserID)}
</#compress></#macro>

<#---
	Profile image URL from the author of the event. Can also be accessed by <code>$&#123;facebook_controller.eventUserProfileImageUrl&#125;</code>
	@requires Event
-->
<#macro EventUserProfileImageUrl><#compress>
${generateProfileImageUrl(core_controller.result.metaData.stencilsFacebookEventUserID)}
</#compress></#macro>

<#---
	Returns the the start date as a datetime object. This is accesssed by <code>$&#123;facebook_controller.eventStartDateTime&#125;</code>
	@return datetime
	@requires Event
-->
<#function getEventStartDateTime>
	<#return convertFacebookDateTime(core_controller.result.metaData.stencilsFacebookEventStartDateTime) >
</#function>

<#---
	Returns the Event end date as a datetime object. This is accesssed by <code>$&#123;facebook_controller.eventEndDateTime&#125;</code>
	@return datetime
	@requires Event
-->
<#function getEventEndDateTime>
	<#if core_controller.result.metaData.stencilsFacebookEventEndDateTime??>
		<#return convertFacebookDateTime(core_controller.result.metaData.stencilsFacebookEventEndDateTime)>
	<#else>
		<#return "">
	</#if>
</#function>

<#---
	Returns true if event is past. This is accesssed by <code>$&#123;facebook_controller.getIsEventPast&#125;</code>
	@return boolean
	@requires Event
-->
<#function getIsEventPast>
	<#if core_controller.result.metaData.stencilsFacebookEventEndDateTime??>
		<#return isDatePast(eventEndDateTime)>
	<#else>
		<#return isDatePast(eventStartDateTime)>
	</#if>
</#function>

<#---
	Displays content if event is past.
	<br><strong>Example</strong>
	<code>&lt;@facebook_controller.EventIsPast&gt;This is a past event&lt;/@facebook_controller.EventIsPast&gt;</code>
	@requires Event
	@return nested
-->
<#macro EventIsPast>
	<#if eventIsPast>
		<#nested>
	</#if>
</#macro>

<#---
	Displays content if event is upcoming.
	<br><strong>Example</strong>
	<code>&lt;@facebook_controller.EventIsUpcoming&gt;This is a past upcomingt&lt;/@facebook_controller.EventIsUpcoming&gt;</code>
	@requires Event
	@return nested
-->
<#macro EventIsUpcoming>
	<#if !eventIsPast>
		<#nested>
	</#if>
</#macro>
<#-- @end --><#-- /Category - Event -->


<#-- @begin Page -->
<#---
 	Constructor for page.
	@requires core_controller.Results
	@provides <code>$&#123;facebook_controller.pageImageUrl&#125;</code>
-->
<#macro Page>
	<#assign pageImageUrl in .namespace><@PageImageUrl /></#assign>
	<#nested>
</#macro>

<#---
	Returns the image thumbnail URL of the page. This is accesssed by <code>$&#123;facebook_controller.pageImageUrl&#125;</code>
	@requires Page
-->
<#macro PageImageUrl><#compress>
${generateProfileImageUrl(core_controller.result.metaData.stencilsFacebookPageID)}
</#compress></#macro>
<#-- @end --><#-- /Category - Page -->

</#escape>
