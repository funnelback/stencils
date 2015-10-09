<#ftl encoding="utf-8" />
<#---
	This contains the stardard out of the box macros refactored into Model-View-Control framework
	required for Stencils.

	This includes macros from from <code>funnelback_classic.ftl</code> and <code>funnelback.ftl</code>.
	The <code>core.controller.ftl</code> contains only the application logic.

	<h2>Table of Contents</h2>
	<ul>
		<li><strong>General:</strong> General search helpers.</li>
		<li><strong>Search forms:</strong> Advanced search form, simple search form ....</li>
		<li><strong>Sessions:</strong> Favorites/Cart, search history.</li>
		<li><strong>Facets:</strong> Faceted navigation, search breadcrumbs.</li>
		<li><strong>Result features:</strong> Search view selectors/formaters, best bets, contextual navigation.</li>
		<li><strong>Result:</strong> Result helpers e.g. panels ...</li>
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
<#assign stencils = [] />

<#--
	The following code imports and assigns stencil namespaces automatically eg. core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/

	Note: View files should not be imported to to the controller
-->
<@stencils_utilities.ImportStencilsControllers stencils=stencils>
	<@stencils_utilities.imports?interpret />
</@stencils_utilities.ImportStencilsControllers>

<#-- ################### Controllers ####################### -->

<#---
	Conditional display, content is evaluated only when there are results.
-->
<#macro AfterSearchOnly>
	<#if (response.resultPacket.resultsSummary.totalMatching)??>
		<#nested>
	</#if>
</#macro>

<#---
	Generates an Open Search link.

	@provides <code>${core_controller.openSearchUrl}</code>
-->
<#macro OpenSearch>
	<#assign openSearchUrl = "open-search.xml?${QueryString?html}" in .namespace>
	<#nested>
</#macro>

<#---
	Prints the title for a link to the open search page which displays Funnelback search information.

	@requires OpenSearch
-->
<#macro OpenSearchTitle><#compress>
 <#local title><#nested></#local>
	<#if ! title?? || title == "">
		"Search " + ${question.collection.configuration.value("service_name")}
	</#if>
</#compress></#macro>

<#---
	Prints the url for a link to the open a search page which displays
	Funnelback search information.
-->
<#macro OpenSearchUrl><#compress>
	<#if (.namespace.openSearchUrl)!?has_content>
		<#noescape>
			${.namespace.openSearchUrl!}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Read a configuration parameter.

	<p>Reads a <code>collection.cfg</code> parameter for the
	current collection being searched and displays it.

	@nested Name of the parameter.
-->
<#macro cfg><#compress>
	<#local key><#nested></#local>
	<#if key?? && key != ""
		&& question.collection.configuration.value(key)??>
		${question.collection.configuration.value(key)}
	</#if>
</#compress></#macro>

<#---
	Conditional display - Runs the nested content
	if the specified CGI parameter is present.

	<p>
		The nested content will be evaluated only if the desired
		parameter exists.
	</p>

	@param name Name of the parameter to test.
-->
<#macro IfDefCGI name><#compress>
	<#if question??
		&& question.inputParameterMap??
		&& question.inputParameterMap?keys?seq_contains(name)>
		<#nested>
	</#if>
</#compress></#macro>

<#---
	Conditional display - Runs the nested content
	if the specified CGI parameter is <em>NOT</em> present.

	<p>
		The nested content will be evaluated only if the desired
		parameter is <strong>not</strong> set.
	</p>

	@param name Name of the parameter to test.
-->
<#macro IfNotDefCGI name><#compress>
	<#if question??
		&& question.inputParameterMap??
		&& question.inputParameterMap?keys?seq_contains(name)>
	<#else>
		<#nested>
	</#if>
</#compress></#macro>

<#---
	Retrieves a cgi parameter value.

	@nested Name of the parameter.
-->
<#macro cgi><#compress>
	<#local key><#nested></#local>
	<#if question??
		&& question.inputParameterMap??
		&& question.inputParameterMap[key]??>
		<#-- Return first element only, to mimic Perl UI behavior -->
		${question.inputParameterMap[key]?html!}
	</#if>
</#compress></#macro>

<#---
	Cut the left part of a string if it matches the given pattern.

	@param cut Pattern to look for.
-->
<#macro cut cut><#compress>
	<#noescape>
		<#if cut??>
			<#local value><#nested></#local>
			${value?replace("^"+cut, "", "r")}
		</#if>
	</#noescape>
</#compress></#macro>

<#---
	Truncate a string on word boundaries.

	@param length Length to keep.
-->
<#macro Truncate length><#compress>
	<#noescape>
		<#local value><#nested></#local>
		${truncate(value, length)}
	</#noescape>
</#compress></#macro>

<#---
	Truncate a string on word boundaries.

	<p>If the string contains HTML it'll try to preserve its validity.</p>

	@param length Length to keep.
-->
<#macro TruncateHTML length><#compress>
	<#noescape>
		<#local value><#nested></#local>
		${truncateHTML(value, length)}
	</#noescape>
</#compress></#macro>

<#---
	Truncate an URL in a sensible way.

	<p>
		This tag will attempt to break the Url up over maximum of
		two lines, only breaking on slashes.
	</p>

	@param length Length to keep.
-->
<#macro TruncateUrl length><#compress>
	<#noescape>
		<#local value><#nested></#local>
		${truncateUrl(value, length)}
	</#noescape>
</#compress></#macro>

<#---
	Wraps words into strong tags.

	@param bold The words to boldicize, space separated. If not set it will automatically boldicize the query terms.
-->
<#macro boldicize bold=""><#compress>
	<#noescape>
		<#local content><#nested></#local>
		<#if bold != "">
			${tagify("strong", bold, content)}
		<#else>
			<#-- Pass the regular expression returned by PADRE -->
			${tagify("strong", response.resultPacket.queryHighlightRegex!, content, true)}
		</#if>
	</#noescape>
</#compress></#macro>

<#---
	Wraps words into emphasis tags.

	@param italics The words to italicize, space separated. If not set it will automatically italicize the query terms.
-->
<#macro italicize italics=""><#compress>
	<#local content><#nested></#local>
	<#if italics != "">
		${tagify("em", italics, content)}
	<#else>
		<#-- Pass the regular expression returned by PADRE -->
		${tagify("em", response.resultPacket.queryHighlightRegex!, content, true)}
	</#if>
</#compress></#macro>

<#---
	Displays the <em>cleaned</em> query.

	<p>The <em>cleaned</em> query contains only query expressions
	entered by the user, without the one dynamically generated for
	other purposes like faceted navigation.</p>
-->
<#macro QueryClean><#compress>
	<#if (response.resultPacket)!?has_content>
		${response.resultPacket.queryCleaned!}
	</#if>
</#compress></#macro>

<#---
	Encodes a String in Url format.

	@nested Content to encode.
-->
<#macro UrlEncode><#compress>
	<#assign content><#nested></#assign>
	${content?url}
</#compress></#macro>

<#---
	Decodes a String from HTML.

	@nested Content to decode.
-->
<#macro HtmlDecode><#compress>
	<#assign content><#nested></#assign>
	${htmlDecode(content)}
</#compress></#macro>

<#---
	Strips html from string.

	@nested Content to strip html from.
-->
<#macro StripHtml><#compress>
	<#assign content><#nested></#assign>
	${content?replace("<[^>]*>","","rm")}
</#compress></#macro>

<#--- @begin Select element-->

<#---
	Generates a HTML <code>&lt;select /&gt;</code> tags with options.

	@param name Name of the select.
	@param defaultValue Default value to set when there's no CGI value.
	@param options List of option, either single strings that will be used as the name and value, or <code>value=label</code> strings.
	@param range Optional range expression to generate options.

	@provides <code>${core_controller.selectName}</code> <br /> <code>${core_controller.selectOptions}</code> <br /> <code>${core_controller.selectOptionRange}</code> <br /> <code>${core_controller.selectDefaultValue}</code>
-->
<#macro Select name defaultValue="" options=[] range="" >
	<#assign selectName = name in .namespace>
	<#assign selectOptions = options in .namespace>
	<#assign selectOptionRange = parseRange(range) in .namespace>
	<#assign selectDefaultValue = defaultValue in .namespace />

	<#-- Get the selected value -->
	<#local selectedValue = defaultValue />
	<#if question.inputParameterMap[name]?? && question.inputParameterMap[name] != "">
			<#local selectedValue = question.inputParameterMap[name] />
	</#if>

	<#assign selectSelectedValue = selectedValue in .namespace>

	<#nested>
</#macro>

<#---
	Sets up the namespace variables required for creating select options by iterating
	through each option that has been provided by the user.

	<p>The nested content will be evaluated once per option.</p>

	@requires Select

	@provides <code>${core_controller.selectOptionValue}</code> <br /> <code>${core_controller.selectOptionName}</code>
-->
<#macro SelectOptions>
	<#-- Used the options that is specified by the user -->
	<#if (.namespace.selectOptions)?has_content && .namespace.selectOptions?size &gt; 0>
		<#list .namespace.selectOptions as option>
			<#-- Option is in the format of <name>=<value> -->
			<#if option?contains("=")>
				<#local valueAndLabel = option?split("=")>

				<#-- Ensure that the correct format has been used -->
				<#if valueAndLabel?size == 2>
					<#assign selectOptionValue = parseRelativeDate(valueAndLabel[0]) in .namespace>
					<#assign selectOptionName = parseRelativeDate(valueAndLabel[1]) in .namespace>
					<#nested>
				</#if>
			<#-- Option's name and value are the same -->
			<#else>
				<#assign selectOptionValue = parseRelativeDate(option) in .namespace>
				<#assign selectOptionName = parseRelativeDate(option) in .namespace>

				<#nested>
			</#if>
		</#list>
	</#if>

	<#-- Used the range that is specified by the user -->
	<#if (.namespace.selectOptionRange)?has_content>
		<#list (.namespace.selectOptionRange.start)..(.namespace.selectOptionRange.end) as i>
				<#--
					?c -This built-in converts a number to string for a "computer language"
					as opposed to for human audience.
				-->
				<#assign selectOptionValue = i?c in .namespace>
				<#assign selectOptionName = i?c in .namespace>

				<#nested>
		</#list>
	</#if>
</#macro>

<#---
	Prints the name of the select.

	@requires Select
-->
<#macro SelectName><#compress>
	<#if (.namespace.selectName)!?has_content>
		${.namespace.selectName}
	</#if>
</#compress></#macro>

<#---
	Prints the option name.

	@requires Select
-->
<#macro SelectOptionName><#compress>
	<#if (.namespace.selectOptionName)!?has_content>
		${.namespace.selectOptionName}
	</#if>
</#compress></#macro>

<#---
	Prints the option value.

	@requires Select
-->
<#macro SelectOptionValue><#compress>
	<#if (.namespace.selectOptionValue)!?has_content>
		${.namespace.selectOptionValue}
	</#if>
</#compress></#macro>

<#---
	Prints the value that has currently been selected.

	@requires Select
-->
<#macro SelectSelectedValue><#compress>
	<#if (.namespace.selectSelectedValue)!?has_content>
		${.namespace.selectSelectedValue}
	</#if>
</#compress></#macro>

<#---
	Conditional Display - Runs the nested code if the current option is selected.

	@requires Select

	@param negate Set this to true to reverse the logic of this macro. i.e. Run the nested code
		if the option has not been selected.
-->
<#macro IsSelectOptionSelected negate=false>
	<#if .namespace.selectOptionValue == .namespace.selectSelectedValue && negate == false>
		<#nested>
	<#elseif .namespace.selectOptionValue != .namespace.selectSelectedValue && negate == true>
		<#nested>
	</#if>
</#macro>

<#---
		Displays the current date and time.
-->
<#macro CurrentDate><#compress>
	${currentDate()?datetime?string}
</#compress></#macro>

<#---
	Displays the last updated date of the collection being searched.
-->
<#macro Date><#compress>
	<#if question?? && question.collection??>
		<#local updDate = updatedDate(question.collection.id)!"">
		<#if updDate?is_date>
			${updatedDate(question.collection.id)?datetime?string}
		<#else>
			Meta colllection
		</#if>
	</#if>
</#compress></#macro>

<#--- @begin RSS -->

<#---
	Sets up the namespace variables used to generate RSS links or buttons.

	@provides <code>${core_controller.rssModernUrl}</code> <br /> <code>${core_controller.rssClassicUrl}</code>
-->
<#macro RSS>
	<#assign rssModernUrl = "${SearchPrefix}rss.cgi?${changeParam(QueryString, 'form', 'rss')}" in .namespace>
	<#assign rssClassicUrl = "${SearchPrefix}rss.cgi?${QueryString!}" in .namespace>
	<#nested>
</#macro>

<#---
	Prints the modern ui url for the RSS feed

	@requires RSS
-->
<#macro RSSModernUrl><#compress>
	<#if (.namespace.rssModernUrl)!?has_content>
		${.namespace.rssModernUrl}
	</#if>
</#compress></#macro>

<#---
	Prints the classic ui url for the RSS feed

	@requires RSS
-->
<#macro RSSClassicUrl><#compress>
	<#if (.namespace.rssClassicUrl)!?has_content>
		${.namespace.rssClassicUrl}
	</#if>
</#compress></#macro>

<#--- @end -->

<#--- @begin Administration -->

<#---
	Conditional display - Runs the nested code only if the current session is
	beign view via an admin server.

	<p>
		Executes nested content only if the page is viewed
		from the Admin UI service (Based on the HTTP port used)
	</p>
-->
<#macro AdminUIOnly>
	<#if isAdminUI(Request)>
		<#nested />
	</#if>
</#macro>

<#--- @end -->

<#--- @begin Error handling -->

<#---
		Conditional display - Runs the nested code only if there are errors to be displayed

		<p>Displays the error to the user and the technical message in an <code>HTML</code> comment + JS console.</p>
-->
<#macro Error>
	<#if error!?has_content || (response.resultPacket.error)!?has_content>
		<#nested>
	</#if>
</#macro>

<#---
	Sets up the name space variables required to display the padre errors

	@requires Error

	@provides <code>${core_controller.errorPadreMessage}</code> <br /> <code>${core_controller.errorPadreCode}</code> <br /> <code>${core_controller.errorPadreAdminMessage}</code>
-->
<#macro ErrorPadre>
	<#-- PADRE error -->
	<#if (response.resultPacket.error)!?has_content>
		<#assign errorPadreMessage = response.resultPacket.error.userMsg in .namespace>
		<#assign errorPadreCode = response.returnCode in .namespace>
		<#assign errorPadreAdminMessage = response.resultPacket.error.adminMsg in .namespace>

		<#nested>
	</#if>
</#macro>

<#---
	Prints the message for padre errors .

	@requires ErrorPadre
-->
<#macro ErrorPadreMessage><#compress>
	<#if (.namespace.errorPadreMessage)!?has_content>
		${.namespace.errorPadreMessage}
	</#if>
</#compress></#macro>

<#---
	Prints the error code for padre errors.

	@requires ErrorPadre
-->
<#macro ErrorPadreCode><#compress>
	<#if (.namespace.errorPadreCode)!?has_content>
		${.namespace.errorPadreCode}
	</#if>
</#compress></#macro>

<#---
	Prints the admin message for padre errors.

	@requires ErrorPadre
-->
<#macro ErrorPadreAdminMessage><#compress>
	<#if (.namespace.errorPadreAdminMessage)!?has_content>
		${.namespace.errorPadreAdminMessage}
	</#if>
</#compress></#macro>

<#---
	Sets up the namespace variables required to display the miscellaneous errors.

	@provides <code>${core_controller.errorOtherReason}</code> <br /> <code>${core_controller.errorOtherAdditionalMessage}</code> <br /> <code>${core_controller.errorOtherCause}</code>
-->
<#macro ErrorOther>
	<#-- Other errors -->
	<#if error!?has_content>
		<#assign errorOtherReason = error.reason in .namespace>
		<#if error.additionalData!?has_content>
			<#assign errorOtherAdditionalMessage = error.additionalData.message in .namespace>
			<#assign errorOtherCause = error.additionalData.cause in .namespace>
		</#if>
		<#nested>
	</#if>
</#macro>

<#---
	Prints the reason for miscellaneous errors.

	@requires ErrorOther
-->
<#macro ErrorOtherReason><#compress>
	<#if (.namespace.errorOtherReason)!?has_content>
		${.namespace.errorOtherReason}
	</#if>
</#compress></#macro>

<#---
	Prints the additional message for miscellaneous errors.

	@requires ErrorOther
-->
<#macro ErrorOtherAdditionalMessage><#compress>
	<#if (.namespace.errorOtherAdditionalMessage)!?has_content>
		${.namespace.errorOtherAdditionalMessage}
	</#if>
</#compress></#macro>

<#---
	Prints the cause for miscellaneous errors.

	@requires ErrorOther
-->
<#macro ErrorOtherCause><#compress>
	<#if (.namespace.errorOtherCause)!?has_content>
		${.namespace.errorOtherCause}
	</#if>
</#compress></#macro>

<#---
	Prints the default message for miscellaneous errors.

	@requires ErrorOther
-->
<#macro ErrorDefaultMessage showAlways=false><#compress>
	<#if showAlways || ((.namespace.errorPadreMessage)!?has_content == false
		&& (.namespace.errorOtherAdditionalMessage)!?has_content == false)>
		<#nested>
	</#if>
</#compress></#macro>

<#--- @end -->

<#---
	Includes remote content from an Url.

	<p>Content is cached to avoid firing an HTTP request for each search results page.</p>

	@param url : Url to request. This is the only mandatory parameter.
	@param expiry : Cache time to live, in .namespaceeconds (default = 3600). This is a number so you must pass the parameters without quotes: <tt>expiry=3600</tt>.
	@param start : Regular expression pattern (Java) marking the beginning of the content to include. Double quotes must be escaped: <tt>start=&quot;start \&quot;pattern\&quot;&quot;</tt>.
	@param end : Regular expression pattern (Java) marking the end of the content to include. Double quotes must be escaped too.
	@param username : Username if the remote server requires authentication.
	@param password : Password if the remote server requires authentication.
	@param useragent : User-Agent string to use.
	@param timeout : Time to wait, in .namespaceeconds, for the remote content to be returned.
	@param convertrelative: Boolean, whether relative links in the included content should be converted to absolute ones.
-->
<#macro IncludeUrl url params...>
		<@IncludeUrlInternal url=url
				expiry=params.expiry
				start=params.start
				end=params.end
				username=params.username
				password=params.password
				useragent=params.useragent
				timeout=params.timeout
				convertRelative=params.convertRelative
				convertrelative=params.convertrelative />
</#macro>

<#---
	Formats a string according to a Locale.

	<p>This tag is usually used with internationalisation.</p>
	<p>Either <tt>key</tt> or <tt>str</tt> must be provided. Using <tt>key</tt> will
	lookup the corresponding translation key in the data model. Using <tt>str</tt> will
	format the <tt>str</tt> string directly.</p>
	<p>When <tt>key</tt> is used, <tt>str</tt> can be used with it as a fallback value if
	the key is not found in the data model. For example <code>&lt;@fb.Format key=&quot;results&quot; str=&quot;Results for %s&quot; args=[question.query] /&gt;</code>
	will lookup the key <em>results</em> in the translations. If the key is not present,
	then the literal string <em>Results for %s</em> will be used instead.</p>

	<p>See the <em>Modern UI localisation guidelines</em> for more information and examples.</p>

	@param locale The <tt>java.util.Locale</tt> to use, defaults to the current Locale in the <tt>question</tt>.
	@param key Takes the string to format from the translations in the data model (<tt>response.translations</tt>).
	@param str Use a literal string instead of a translation key. For example <em>&quot;%d results match the query %s&quot;</em>. See <tt>java.util.Formatter</tt> for the format specifier documentation.
	@param args Array of arguments to be formatted, for example <tt>[42, &quot;funnelback&quot;]</tt>.
-->
<#macro Format args=[] str="" key="" locale=question.locale>
	<#if key != "">
		<#local s = response.translations[key]!str />
	<#else>
		<#local s = str />
	</#if>

	<#if args??>
		${format(locale, s, args)}
	<#else>
		${format(locale, s)}
	</#if>
</#macro>

<#--- @begin Syntax tree -->

<#---
	Conditional Display - Runs the nested code if the Funnelback data model contains data to produce a syntax tree.

	@param negate Set this to true to reverse the logic of this macro. i.e. Runs the code if no data
	can be to produce a for syntax tree
#-->
<#macro HasSyntaxTree negate=false>
	<#if (response.resultPacket.svgs["syntaxtree"])!?has_content && negate == false>
		<#nested>
	<#elseif (response.resultPacket.svgs["syntaxtree"])!?has_content == false && negate == true>
		<#nested>
	</#if>
</#macro>

<#---
	Prints the SVGs used for the syntax tree.
-->
<#macro SyntaxTreeSvgs><#compress>
	<#if (response.resultPacket.svgs["syntaxtree"])!?has_content>
		<#noescape>
			${response.resultPacket.svgs["syntaxtree"]}
		</#noescape>
	</#if>
</#compress></#macro>

<#--- @end -->

<#---
	Generates an authentication token suitable for click tracking redirection,
	based on the globally configured <tt>server_secret</tt>.

	@nested Url to generate the token for.
-->
<#macro AuthToken><#compress>
	<#assign content><#nested></#assign>
	${authToken(content)}
</#compress></#macro>

<#-- ### Search Forms ### -->

<#---
	Conditional display - Runs the nested content only when there is no search query.
-->
<#macro InitialFormOnly><#compress>
	<#if (response.resultPacket.resultsSummary.totalMatching)??>
	<#else>
		<#nested>
	</#if>
</#compress></#macro>

<#--- @begin Form choice -->

<#---
		Sets up the namespace variables required to provide links to collection search forms.

		<p>
			This will iterate over every existing search forms
			for the current collection and display a link to access every
			one of them.
		</p>

		@provides <code>${core_controller.formChoiceForms}</code> <br /> <code>${core_controller.formChoiceUrl}</code>
-->
<#macro FormChoice>
	<#if (question.collection)!?has_content>
		<#assign formChoiceForms = formList(question.collection.id, question.profile) in .namespace />
		<#assign formChoiceUrl = question.collection.configuration.value("ui.modern.search_link")
				+ "?collection=" + question.collection.id
				+ "&amp;profile=" + question.profile />
		<#nested>
	</#if>
</#macro>

<#---
	Conditional display - Runs the nested code and exposes the form url and form name if form choices are available

	<p>The nested content will be evaluated once per form choice.</p>

	@requires FormChoice

	@provides <code>${core_controller.formChoiceForm}</code>
-->
<#macro FormChoiceForms>
	<#if (.namespace.formChoiceForms)!?has_content>
		<#list formChoiceForms as form>
			<#-- Ensure we do not print the current form or any backups -->
			<#if form != question.form && !form?matches("^.*-\\d{12}$")>
				<#assign formChoiceForm = form in .namespace />
				<#nested>
			</#if>
		</#list>
	</#if>
</#macro>

<#---
	Prints the form choice url.

	@requires FormChoice
-->
<#macro FormChoiceUrl><#compress>
	<#if (.namespace.formChoiceUrl)!?has_content>
		${.namespace.formChoiceUrl}
	</#if>
</#compress></#macro>

<#---
	Prints the name of the form.

	@requires FormChoice
-->
<#macro FormChoiceForm><#compress>
	<#if (.namespace.formChoiceForm)!?has_content>
		${.namespace.formChoiceForm}
	</#if>
</#compress></#macro>

<#--- @end -->

<#--- @begin Sessions -->

<#---
		Check if the user click history is empty or not. Writes 'true' if it is, 'false' otherwise.
-->
<#macro HasClickHistory><#compress>
	<#if session?? && session.clickHistory?size &gt; 0>
		true
	<#else>
		false
	</#if>
</#compress></#macro>

<#---
	Runs the nested code for each click history entry available under sesssions.

	<p>The content will be evaluated once per click history entry.</p>

	@provides <code>${core_controller.clickHistory}</code>
-->
<#macro ClickHistory>
	<#list session.clickHistory as clickHistory>
		<#assign clickHistory = clickHistory in .namespace>
		<#nested>
	</#list>
</#macro>

<#---
	Check if the user search history is empty or not. Writes 'true' if it is, 'false' otherwise.
-->
<#macro HasSearchHistory><#compress>
	<#if session?? && session.searchHistory?size &gt; 0>
		true
	<#else>
		false
	</#if>
</#compress></#macro>

<#---
	Runs the nested code for each search history entry available under sesssions

	<p>The content will be evaluated once per search history entry.</p>

	@provides <code>${core_controller.searchHistory}</code>
-->
<#macro SearchHistory>
	<#list session.searchHistory as searchHistory>
		<#assign searchHistory = searchHistory in .namespace>
		<#nested>
	</#list>
</#macro>

<#-- @end -->

<#--- @begin Faceted navigation -->

<#---
	Conditional display against faceted navigation.

	<p>
		The content will be evaluated only if faceted navigation is configured.
	</p>

	@param negate Whether to negate the tag, i.e. evaluate the content if faceted navigation is not configured.
-->
<#macro FacetedSearch negate=false>
	<#if !negate>
		<#if question??
			&& facetedNavigationConfig(question.collection, question.profile)?? >
			<#nested>
		</#if>
	<#else>
		<#if !question??
			|| !facetedNavigationConfig(question.collection, question.profile)?? >
			<#nested>
		</#if>
	</#if>
</#macro>

<#---
	Displays a facet, a list of facets, or all facets.

	<p>
		If both <code>name</code> and <code>names</code> are not set
		this tag iterates over all the facets.
	</p>

	@requires FacetedSearch

	@param name Name of a specific facet to display, optional.
	@param names A list of specific facets to display, optional. Won't affect facet display order (defined in <code>faceted_navigation.cfg</code>).

	@provides <code>${core_controller.facet}</code> <br /> <code>${core_controller.facetIndex}</code> <br /> <code>${core_controller.facetHasNext}</code>
-->
<#macro Facets name="" names=[]>
	<#if response?? && response.facets??>
		<#if name == "" && names?size == 0>
			<#-- Iterate over all facets -->
			<#list response.facets as f>
				<#if f.hasValues() || question.selectedFacets?seq_contains(f.name)>
					<#assign facet = f in .namespace>
					<#assign facetIndex = f_index in .namespace>
					<#assign facetHasNext = f_has_next in .namespace>
					<#nested>
				</#if>
			</#list>
		<#else>
			<#-- Iterate only over the specified facets -->
			<#list response.facets as f>
				<#if (f.name == name || names?seq_contains(f.name) ) && (f.hasValues() || question.selectedFacets?seq_contains(f.name))>
					<#assign facet = f in .namespace>
					<#assign facetIndex = f_index in .namespace>
					<#assign facetHasNext = f_has_next in .namespace>
					<#nested>
				</#if>
			</#list>
		</#if>
	</#if>
</#macro>

<#---
	Prints the facet value.

	@requires Facets
-->
<#macro FacetValue><#compress>
	<#if (.namespace.facet)!?has_content>
		${.namespace.facet}
	</#if>
</#compress></#macro>

<#---
	Prints the facet index.

	@requires Facets
-->
<#macro FacetIndex><#compress>
	<#if (.namespace.facetIndex)!?has_content>
		${.namespace.facetIndex}
	</#if>
</#compress></#macro>

<#---
	Prints true indicating if there is facet which follows the current facet.

	@requires Facets
-->
<#macro FacetHasNext><#compress>
	<#if (.namespace.facetHasNext)!?has_content>
		${.namespace.facetHasNext}
	</#if>
</#compress></#macro>

<#---
	Sets up the namespace variables for each individual facet.

	@requires Facets

	@provides <code>${core_controller.facetDefinition}</code> <br /> <code>${core_controller.facetDefinitionIndex}</code> <br /> <code>${core_controller.facetDefinitionHasNext}</code> <br /> <code>${core_controller.facetLabel}</code>
-->
<#macro Facet>
	<#local fn = facetedNavigationConfig(question.collection, question.profile) >
	<#if fn??>
		<#--
			Find facet definition in the configuration corresponding
			to the facet we're currently displaying
		-->
		<#list fn.facetDefinitions as fdef>
			<#if fdef.name == .namespace.facet.name>
				<#assign facetDefinition = fdef in .namespace />
				<#assign facetDefinitionIndex = fdef_index in .namespace />
				<#assign facetDefinitionHasNext = fdef_has_next in .namespace />
				<#assign facetLabel = facet.name in .namespace />
				<#nested>
			</#if>
		</#list>
	</#if>
</#macro>

<#---
	Prints the definition for the current facet.

	@requires Facet
-->
<#macro FacetDefinition><#compress>
	<#if (.namespace.facetDefinition)!?has_content>
		${.namespace.facetDefinition}
	</#if>
</#compress></#macro>

<#---
	Prints the definition index for the current facet.

	@requires Facet
-->
<#macro FacetDefinitionIndex><#compress>
	<#if (.namespace.facetDefinitionIndex)!?has_content>
		${.namespace.facetDefinitionIndex}
	</#if>
</#compress></#macro>

<#---
	Prints true if there is a facet definition which follows the current facet definition.

	<p>Else prints false when there is no facet definition<p>

	@requires Facet
-->
<#macro FacetDefinitionHasNext><#compress>
	<#if (.namespace.facetDefinitionHasNext)!?has_content>
		${.namespace.facetDefinitionHasNext}
	</#if>
</#compress></#macro>

<#---
	Prints the label for the current facet.

	@requires Facet
-->
<#macro FacetLabel><#compress>
	<#if (.namespace.facetDefinitionHasNext)!?has_content>
		${.namespace.facetLabel}
	</#if>
</#compress></#macro>

<#---
	Sets up the namespace variables to display the facet summary
	otherwise known as the facet breadcrumb or list of selected facets.

	@provides <code>${core_controller.facetSummaryCategoryDefinitions}</code> <br /> <code>${core_controller.facetSummarySelectedCategoryValues}</code> <br /> <code>${core_controller.facetSummaryClearCurrentSelectionUrl}</code>
-->
<#macro FacetSummary>
	<#--
		We must test various combinations here as different browsers will encode
		some characters differently (i.e. '/' will sometimes be preserved, sometimes
		encoded as '%2F'

		@requires Facet
	-->
	<#assign facetSummaryCategoryDefinitions = .namespace.facetDefinition.categoryDefinitions in .namespace>
	<#assign facetSummarySelectedCategoryValues = question.selectedCategoryValues in .namespace>

	<#if QueryString?contains("f." + .namespace.facetDefinition.name?url)
		|| urlDecode(QueryString)?contains("f." + .namespace.facetDefinition.name)
		|| urlDecode(QueryString)?contains("f." + .namespace.facetDefinition.name?url)>

		<#assign facetSummaryClearCurrentSelectionUrl = '${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(facetScopeRemove(QueryString, .namespace.facetDefinition.allQueryStringParamNames), ["start_rank"] + .namespace.facetDefinition.allQueryStringParamNames)?html}' in .namespace>

		<#nested>
	</#if>

</#macro>

<#---
	Prints the categories for the current facet definition.

	@requires FacetSummary
-->
<#macro FacetSummaryCategoryDefinitions><#compress>
	<#if (.namespace.facetSummaryCategoryDefinitions)!?has_content>
		${.namespace.facetSummaryCategoryDefinitions}
	</#if>
</#compress></#macro>

<#---
	Prints the selected value for the current facet.

	@requires FacetSummary
-->
<#macro FacetSummarySelectedCategoryValues><#compress>
	<#if (.namespace.facetSummarySelectedCategoryValues)!?has_content>
		${.namespace.facetSummarySelectedCategoryValues}
	</#if>
</#compress></#macro>

<#---
	Prints the url for the current facet.

	@requires FacetSummary
-->
<#macro FacetSummaryClearCurrentSelectionUrl><#compress>
	<#if (.namespace.facetSummaryClearCurrentSelectionUrl)!?has_content>
		<#noescape>
			${.namespace.facetSummaryClearCurrentSelectionUrl}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Sets up the namespace variables to display the facet title or value of the current category.

	<p>
		For hierarchical facets, displays the latest selected category.
	</p>

	@requires Facets

	@provides <code>${core_controller.shortFacetLabelName}</code>
-->
<#macro ShortFacetLabel>
	<#local deepest = .namespace.facet.findDeepestCategory(question.selectedCategoryValues?keys)!"">

	<#if deepest != "">
		<#assign shortFacetLabelName = question.selectedCategoryValues[deepest.queryStringParamName]?first in .namespace>
	<#else>
		<#assign shortFacetLabelName = .namespace.facet.name!"" in .namespace>
	</#if>

	<#nested>
</#macro>

<#---
	Displays the short facet label for the current facet.

	@requires ShortFacetLabel
-->
<#macro ShortFacetLabelName><#compress>
	<#if (.namespace.shortFacetLabelName)!?has_content>
		${.namespace.shortFacetLabelName}
	</#if>
</#compress></#macro>

<#---
	Conditional Display - Runs the nested code if there is at least one selected facet.

	<p>
		Aims to provide a means for the user to unselect facet categories
	</p>
-->
<#macro HasSelectedFacets>
	<#if (question.selectedFacets)!?has_content
		&& question.selectedFacets?size &gt; 0>
		<#nested>
	</#if>
</#macro>

<#---
	Sets up the namespace variables to display the facet breadcrumb which
	includes nested selected values for hierarchical facets.

	@requires FacetSummary

	@provides <code>${core_controller.facetBreadCrumbUrl}</code>
-->
<#macro FacetBreadCrumb>
	<#-- Generate the root URL which will remove all the selection for the current facets i.e. A clear all link -->
	<#assign facetBreadCrumbUrl = .namespace.facetSummaryClearCurrentSelectionUrl in .namespace>

	<@NestedFacetBreadCrumb categoryDefinitions=.namespace.facetDefinition.categoryDefinitions selectedCategoryValues=question.selectedCategoryValues>
		<#nested>
	</@NestedFacetBreadCrumb>
</#macro>

<#---
	Recursively generates the breadcrumbs for a facet.

	<p>
		This is an internal macro which should not be called directly from any other templates.
	</p>

	@requires FacetBreadCrumb

	@param categoryDefinitions List of sub categories (hierarchical).
	@param selectedCategoryValues List of selected values.

	@provides <code>${core_controller.facetBreadCrumbLastFlag}</code> <br /> <code>${core_controller.facetBreadCrumbName}</code> <br /> <code>${core_controller.facetBreadCrumbUrl}</code>
-->
<#macro NestedFacetBreadCrumb categoryDefinitions selectedCategoryValues>
	<#list categoryDefinitions as def>
		<#if def.class.simpleName == "UrlFill" && selectedCategoryValues?keys?seq_contains(def.queryStringParamName)>
			<#-- Special case for URL Fill facets: Split on slashes -->
			<#assign path = selectedCategoryValues[def.queryStringParamName][0]>
			<#assign pathBuilding = "">
			<#list path?split("/", "r") as part>
				<#assign pathBuilding = pathBuilding + "/" + part>
				<#-- Don't display bread crumb for parts that are part of the root Url -->
				<#if ! def.data?lower_case?matches(".*[/\\\\]"+part?lower_case+"[/\\\\].*")>
					<#--
						part needs to be url-decoded to be displayed nicely
						e.g. "with spaces" rather than "with%20spaces"
					-->
					<#assign facetBreadCrumbName = urlDecode(part) in .namespace>

					<#--
						The "last" flag signifies if the current selected facet is the last node in the breadcrumb
						Url Fill facets are always the last/leaf node since they cannot have sub facets
					-->
					<#assign facetBreadCrumbLastFlag = true in .namespace>

					<#nested>
				</#if>
			</#list>
		<#else>
			<#if selectedCategoryValues?keys?seq_contains(def.queryStringParamName)>
				<#--
					Find the label for this category. For nearly all categories the label is equal
					to the value returned by the query processor, but not for date counts for example.
					With date counts the label is the actual year "2003" or a "past 3 weeks" but the
					value is the constraint to apply like "d=2003" or "d>12Jun2012"
				-->

				<#-- Use value by default if we can't find a label -->
				<#local valueLabel = selectedCategoryValues[def.queryStringParamName][0] />

				<#-- Iterate over generated facets -->
				<#list response.facets as facet>
					<#if def.facetName == facet.name>
						<#-- Facet located, find current working category -->
						<#assign fCat = facet.findDeepestCategory([def.queryStringParamName])!"" />

						<#if fCat != "">
							<#list fCat.values as catValue>
								<#--
									Find the category value for which the query string param
									matches the currently selected value
								-->
								<#local kv = catValue.queryStringParam?split("=") />

								<#if valueLabel == urlDecode(kv[1])>
									<#local valueLabel = catValue.label />
									<#--
										No need to loop through the rest of the facet categories as we already found
										the value we need
									-->
									<#break>
								</#if>

							</#list>
						</#if>
					</#if>
				</#list>

				<#-- Find if we are processing the last selected value (leaf node) -->
				<#local last = true>
				<#list def.allQueryStringParamNames as param>
					<#if param != def.queryStringParamName && selectedCategoryValues?keys?seq_contains(param)>
						<#local last = false>
						<#break>
					</#if>
				</#list>

				<#-- Last flag signifies if the current selected facet is the last node in the breadcrimb -->
				<#assign facetBreadCrumbLastFlag = last in .namespace>
				<#assign facetBreadCrumbName = valueLabel in .namespace>

				<#nested>

				<#if last != true>
					<#assign facetBreadCrumbUrl = '${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(facetScopeRemove(QueryString, def.allQueryStringParamNames), ["start_rank"] + def.allQueryStringParamNames)?html}&amp;${def.queryStringParamName}=${selectedCategoryValues[def.queryStringParamName][0]?url}' in .namespace>
					<@NestedFacetBreadCrumb categoryDefinitions=def.subCategories selectedCategoryValues=selectedCategoryValues>
						<#nested>
					</@NestedFacetBreadCrumb>
				</#if>

				<#-- We've displayed one step in the breadcrumb, no need to inspect other category definitions -->
				<#break />
			</#if>
		</#if>
	</#list>
</#macro>

<#---
	Prints the name of the current selected facet.

	@requires FacetBreadCrumb, NestedFacetBreadCrumb
-->
<#macro FacetBreadCrumbName><#compress>
	<#if (.namespace.facetBreadCrumbName)!?has_content>
		${.namespace.facetBreadCrumbName}
	</#if>
</#compress></#macro>

<#---
	Prints the url of the current selected facet

	@requires FacetBreadCrumb, NestedFacetBreadCrumb
-->
<#macro FacetBreadCrumbUrl><#compress>
	<#if (.namespace.facetBreadCrumbUrl)!?has_content>
		<#noescape>
			${.namespace.facetBreadCrumbUrl}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Runs the nested code if it is the last facet breadcrumb in the chain.

	@requires FacetBreadCrumb, NestedFacetBreadCrumb

	@param negate Set this to true to reverse the logic of this macro.
-->
<#macro IsLastFacetBreadCrumb negate=false>
	<#if facetBreadCrumbLastFlag == true && negate == false>
		<#nested>
	<#elseif facetBreadCrumbLastFlag == false && negate == true>
		<#nested>
	</#if>
</#macro>

<#---
	Displays a faceted navigation category.

	<p>
		For faceted navigation the <tt>max</tt> parameter sets the maximum number of
		categories to return. If you need to display only a few number of them with a <em>more...</em>
		link for expansion, you'll need to use Javascript.
	</p>

	@requires Facet

	@param name Name of the category for contextual navigation. Can be <code>type</code>, <code>type</code> or <code>topic</code>. Empty for a faceted navigation category.
	@param max Maximum number of categories to display, for faceted navigation.
	@param nbCategories (Internal parameter, do not use) Current number of categories displayed (used in recursion for faceted navigation).
	@param recursionCategories (Internal parameter, do not use) List of categories to process when recursing for faceted navigation).

	@provides <code>${core_controller.facetCategory}</code> <br /> <code>${core_controller.facetCategory_has_next}</code> <br /> <code>${core_controller.facetCategory_index}</code>
-->
<#macro FacetCategories max=16 nbCategories=0 recursionCategories=[] >
	<#-- Find if we are working at the root level (facet) or in a sub category -->
	<#if recursionCategories?? && recursionCategories?size &gt; 0>
			<#local categories = recursionCategories />
	<#else>
			<#local categories = .namespace.facet.categories />
	</#if>
	<#if categories?? && categories?size &gt; 0>
		<#list categories as c>
			<#-- Store the current facet category so that it can be used by nested functions -->
			<#assign facetCategory = c in .namespace>
			<#assign facetCategory_has_next = c_has_next in .namespace>
			<#assign facetCategory_index = c_index in .namespace>

			<#--
				Display the available facet category values for the current facet category.
				Find if this category has been selected. If it's the case, don't display
				it in the list, except if it's an Url fill facet as we must display sub-folders
				of the currently selected folder
			-->
			<#list c.values as cv>
				<#if ! question.selectedCategoryValues?keys?seq_contains(urlDecode(cv.queryStringParam?split("=")[0]))
					|| c.queryStringParamName?contains("|url")>
					<#assign facetCategoryValue = cv in .namespace>
					<#assign facetCategoryValue_has_next = cv_has_next in .namespace>
					<#assign facetCategoryValue_index = cv_index in .namespace>

					<#local nbCategories = nbCategories+1 />
					<#if nbCategories &gt; max><#return></#if>

					<#nested>
				</#if>
			</#list>

			<#--
				Recursively display nested categories (hierarchical facets - facet categories themselves can have facet categories)
			-->
			<#if (.namespace.facetCategory.categories)!?has_content && .namespace.facetCategory.categories?size &gt; 0>
				<@FacetCategories recursionCategories=.namespace.facetCategory.categories max=max nbCategories=nbCategories>
					<#nested>
				</@FacetCategories>
			</#if>

		</#list>
	</#if>
</#macro>

<#---
	Sets up the namespace variables in order to print the facet category values

	@requires FacetCategories

	@provides <code>${core_controller.facetCategoryUrl}</code> <br /> <code>${core_controller.facetCategoryLabel}</code> <br /> <code>${core_controller.facetCategoryCount}</code>
-->
<#macro FacetCategory>
	<#if .namespace.facetCategoryValue??>
		<#local paramName = .namespace.facetCategoryValue.queryStringParam?split("=")[0]>

		<#assign facetCategoryUrl = "${question.collection.configuration.value('ui.modern.search_link')}?${removeParam(facetScopeRemove(QueryString, paramName), ['start_rank', paramName])?html}&amp;${.namespace.facetCategoryValue.queryStringParam?html}" in .namespace>
		<#assign facetCategoryLabel = .namespace.facetCategoryValue.label in .namespace>
		<#assign facetCategoryCount = .namespace.facetCategoryValue.count in .namespace>

		<#nested>

	</#if>
</#macro>

<#---
	Prints the url for the current facet category.

	@requires FacetCategories
-->
<#macro FacetCategoryUrl><#compress>
	<#if (.namespace.facetCategoryUrl)!?has_content>
		<#noescape>
			${.namespace.facetCategoryUrl}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Prints the label for the current facet category.

	@requires FacetCategories
-->
<#macro FacetCategoryLabel ><#compress>
	<#if (.namespace.facetCategoryLabel)!?has_content>
			${.namespace.facetCategoryLabel}
	</#if>
</#compress></#macro>

<#---
	Displays the result count for the current facet category.

	@requires FacetCategories
-->
<#macro FacetCategoryCount><#compress>
	<#if (.namespace.facetCategoryCount)!?has_content>
		${.namespace.facetCategoryCount}
	</#if>
</#compress></#macro>

<#---
	Sets up the namespace variable to display the <em>facet scope</em> checkbox.

	<p>
		Provides a means to constrain search to the currently selected facet(s) only.
	</p>

	@provides <code>${core_controller.facetScopeParameter}</code>
-->
<#macro FacetScope>
	<@AfterSearchOnly>
		<#if question?? && question.selectedCategoryValues?size &gt; 0>
			<#local facetScope = "" />
			<#list question.selectedCategoryValues?keys as key>
				<#list question.selectedCategoryValues[key] as value>
					<#local facetScope = facetScope + key?url+"="+value?url />
					<#if value_has_next><#local facetScope = facetScope + "&" /></#if>
				</#list>
				<#if key_has_next><#local facetScope = facetScope + "&" /></#if>
			</#list>
			<#-- Expose the generated facet scope parameter and run the nested code -->
			<#assign facetScopeParameter = facetScope in .namespace>
			<#nested>
		</#if>
	</@AfterSearchOnly>
</#macro>

<#---
	Prints the parameter name for the current facet scope.

	@requires FacetScope
-->
<#macro FacetScopeParameter><#compress>
	<#if (.namespace.facetScopeParameter)!?has_content>
		${.namespace.facetScopeParameter}
	</#if>
</#compress></#macro>

<#-- @end -->

<#--- @begin Spelling suggestions -->

<#---
	Sets up the namespace variables to display spelling suggestions.

	<p>
		Funnelback's spelling suggestion system has the following features:

		<ul>
			<li>
				It is capable of making suggestions even if all words are
				correctly spelled.
			</li>
			<li>
				It is not based on standard language-based dictionaries and can
				make suggestions in non-English and multi-lingual environments.
			</li>
			<li>
				It takes advantage of query context.
			</li>
			<li>
				It will not make suggestions which do not match the collection
				being searched.
			</li>
			<li>
				It mines suggestions from the document text, document metadata,
				and external annotations, in order to work in the initial absence
				of search logs.
			</li>
			<li>
				It learns and improves as users interact with the system.
			</li>
		</ul>
	<p>

	@provides <code>${core_controller.checkSpellingUrl}</code> <br /> <code>${core_controller.checkSpellingText}</code>
-->
<#macro CheckSpelling>
	<#if (question.collection.configuration.value("spelling_enabled"))!?has_content
		&& is_enabled(question.collection.configuration.value("spelling_enabled"))
		&& (response.resultPacket.spell.text)!?has_content>

		<#assign checkSpellingUrl = "${question.collection.configuration.value('ui.modern.search_link')}?${changeParam(QueryString, 'query', response.resultPacket.spell.text?url)?html}" in .namespace>
		<#assign checkSpellingText = response.resultPacket.spell.text in .namespace>

		<#nested>
	</#if>
</#macro>

<#---
	Prints the url for the spelling suggestion.

	@requires CheckSpelling
-->
<#macro CheckSpellingUrl><#compress>
	<#if (.namespace.checkSpellingUrl)!?has_content>
		<#noescape>
			${.namespace.checkSpellingUrl!}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Prints the text for the spelling suggestion.

	@requires CheckSpelling
-->
<#macro CheckSpellingText><#compress>
	<#if (.namespace.checkSpellingText)!?has_content>
		${.namespace.checkSpellingText!}
	</#if>
</#compress></#macro>

<#-- @end -->

<#--- @begin Best bets -->

<#---
	Conditional display - Runs the nested code only if best bets
	are configured and have been triggered.

	<p>
		The best bets mechanism allows you to specify that certain
		specified URLs should be displayed in the result page whenever
		a set of trigger words is present in the query.
	</p>

	<p>
		For example you might wish to say that whenever a query containing
		the words gene and sequencing is submitted, attention should be
		drawn to the <code>www.dna.com</code> site.
	</p>

-->
<#macro BestBets>
	<#if (response.resultPacket.bestBets)!?has_content
		&& response.resultPacket.bestBets?size &gt; 0>
		<#nested>
	</#if>
</#macro>

<#---
	Sets up the namespace variables required to display best bets.

	<p>
		The content will be evaluated once per best bet.
	</p>

	@requires BestBets

	@provides <code>${core_controller.bestBets}</code>
-->
<#macro BestBet>
	<#list response.resultPacket.bestBets as bestBet>
		<#assign bestBet = bestBet in .namespace />
		<#assign bestBet_index = bestBet_index in .namespace />
		<#assign bestBet_has_next = bestBet_has_next in .namespace />
		<#nested>
	</#list>
</#macro>

<#--- @end -->

<#--- @begin Contextual navigation -->

<#---
	<p>
		Funnelback's contextual navigation engine provides users
		with a road-sign style navigation panel to rapidly discover
		all topics related to their search query.
	</p>

	<p>
		It is also known as related searches.
	</p>

	<p>
		The content is always evaluated, regardless of the
		presence of contextual navigation suggestions.
	</p>
-->
<#macro ContextualNavigation>
	<#nested>
</#macro>

<#---
	Conditional display - Runs the nested code only if there are
	no presence of clusters.

	<p>
		The content will be evaluated only if no contextual navigation
		clusters were found.
	</p>

	@requires ContextualNavigation
-->
<#macro NoClustersFound>
	<#if (response.resultPacket)!?has_content
		&& (!response.resultPacket.contextualNavigation??
		|| response.resultPacket.contextualNavigation.categories?size == 0)>
		<#nested>
	</#if>
</#macro>

<#---
	Displays previously followed clusters.

	@requires ContextualNavigation
-->
<#macro ClusterNavLayout>
	<#if question?? && question.cnPreviousClusters?size &gt; 0>
			<#nested>
	</#if>
</#macro>

<#---
	Sets up the namespace variables for contextual navigation by iterating overs previously followed clusters.

	<p>
		The content will be evaluated once per contextual navigation cluster.
	</p>

	@requires ContextualNavigation

	@provides <code>${core_controller.previousCluster}</code> <br /> <code>${core_controller.previousCluster_index}</code> <br /> <code>${core_controller.previousCluster_has_next}</code>
-->
<#macro ContextualNavigationNav>
	<#if question?? && question.cnPreviousClusters?size &gt; 0>
		<#list question.cnPreviousClusters as cluster>
			<#assign previousCluster = cluster in .namespace>
			<#assign previousCluster_index = cluster_index in .namespace>
			<#assign previousCluster_has_next = cluster_has_next in .namespace>
			<#nested>
		</#list>
	</#if>
</#macro>

<#---
	Runs the nested code of there are contextual navigation clusters.

	<p>
		The content will be evaluated only if there are contextual
		navigation clusters, except if there is only one of the <em>site</em>
		type.
	</p>

	@requires ContextualNavigation

	@provides <code>${core_controller.contextualNavigation}</code>
-->
<#macro ClusterLayout>
	<#if (response.resultPacket.contextualNavigation)!?has_content
		&& response.resultPacket.contextualNavigation.categories?size &gt; 0>
		<#assign contextualNavigation = response.resultPacket.contextualNavigation in .namespace />

		<#if contextualNavigation.categories?size == 1 && contextualNavigation.categories[0].name == "site"
			&& contextualNavigation.categories[0].clusters?size &lt; 2>
			<#-- Do nothing if we only have a site category with only 1 site -->
		<#else>
			<#nested>
		</#if>
	</#if>
</#macro>

<#---
	Displays a contextual navigation category.

	@requires ContextualNavigation

	@param name Name of the category for contextual navigation. Can be <code>type</code>, <code>type</code> or <code>topic</code>

	@provides <code>${core_controller.category}</code> <br /> <code>${core_controller.category_hax_next}</code> <br /> <code>${core_controller.category_index}</code>
-->
<#macro ContextualNavigationCategories name>
	<#list response.resultPacket.contextualNavigation.categories as c>
		<#if c.name?? && c.name == name>
			<#assign category = c in .namespace />
			<#assign category_hax_next = c_has_next in .namespace />
			<#assign category_index = c_index in .namespace />
			<#if c.name != "site" || c.clusters?size &gt; 1>
				<#nested>
			</#if>
		</#if>
	</#list>
</#macro>

<#---
	Sets up the namespace variables for clusters by iterating over contextual navigation clusters.

	<p>
		The content will be evaluated once per contextual navigation cluster.
	</p>

	@requires ContextualNavigationCategories

	@provides <code>${core_controller.cluster}</code> <br /> <code>${core_controller.cluster_has_next}</code> <br /> <code>${core_controller.cluster_index}</code>
-->
<#macro Clusters>
	<#if .namespace.category??>
		<#list .namespace.category.clusters as c>
			<#assign cluster = c in .namespace />
			<#assign cluster_has_next = c_has_next in .namespace />
			<#assign cluster_index = c_index in .namespace />
			<#nested>
		</#list>
	</#if>
</#macro>

<#---
	Conditional display - Runs the nested code if there is a more link available for the current contextual navigation cluster.

	@requires Clusters

	@param category Name of the category for contextual navigation (<code>type</code> , <code>site</code>, <code>topic</code>).
-->
<#macro ShowMoreClusters category>
	<#if .namespace.category?? && .namespace.category.name == category && .namespace.category.moreLink??>
		<#nested>
	</#if>
</#macro>

<#---
	Conditional display - Runs the nested code if there is a less link available for the current contextual navigation cluster.

	@requires Clusters

	@param category Name of the category for contextual navigation (<code>type</code> , <code>site</code>, <code>topic</code>).
-->
<#macro ShowFewerClusters category>
	<#if .namespace.category?? && .namespace.category.name == category && .namespace.category.fewerLink??>
		<#nested>
	</#if>
</#macro>

<#--- @end -->

<#--- @begin Pagination -->

<#---
	Conditional display - Execute the nested code only if there are more than two pages.

	<p>
		Pagination is the process of dividing a document into discrete pages.
		Generally, we do not wish to create pagination links when there is only one page
		of results.
	</p>
-->
<#macro Pagination>
	<#if (response.resultPacket.resultsSummary)!?has_content>
		<#local resultsSummary = response.resultPacket.resultsSummary>
		<#if resultsSummary.totalMatching &gt; resultsSummary.numRanks>
			<#nested>
		</#if>
	</#if>
</#macro>

<#---
	Generates a link to the previous page of results.

	<p>Example:

			<pre>
				&lt;@fb.Prev&gt;
					&lt;a href="${fb.prevUrl}"&gt;Previous ${fb.prevRanks} results&lt;/p&gt;
&lt;/@fb.Prev&gt;
			</pre>
	</p>

	@requires Pagination

	@provides <code>${core_controller.previousUrl}</code> <br /> <code>${core_controller.previousRanks}</code>
-->
<#macro Previous link=question.collection.configuration.value("ui.modern.search_link")>
	<#if response?? && response.resultPacket?? && response.resultPacket.resultsSummary??>
		<#if response.resultPacket.resultsSummary.prevStart??>
			<#assign previousUrl = link + "?"
					+ changeParam(QueryString, "start_rank", response.resultPacket.resultsSummary.prevStart) in .namespace />
			<#assign previousRanks = response.resultPacket.resultsSummary.numRanks in .namespace />
			<#nested>
		</#if>
	</#if>
</#macro>

<#--
	Prints the url for the previous pagination button.

	@requires Previous
-->
<#macro PreviousUrl><#compress>
	<#if (.namespace.previousUrl)!?has_content>
		<#noescape>
			${.namespace.previousUrl}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Prints the rank for the previous pagination button.

	@requires Previous
-->
<#macro PreviousRanks><#compress>
	<#if (.namespace.previousRanks)!?has_content>
		${.namespace.previousRanks}
	</#if>
</#compress></#macro>

<#---
	Generates a link to the next page of results.

	<p>Example:

			<pre>
&lt;@fb.Next&gt;
	&lt;a href="${fb.nextUrl}"&gt;Next ${fb.nextRanks} results&lt;/p&gt;
&lt;/@fb.Next&gt;
			</pre>
	</p>

	@requires Pagination

	@provides <code>${core_controller.nextUrl}</code> <br /> <code>${core_controller.nextRanks}</code>
-->
<#macro Next link=question.collection.configuration.value("ui.modern.search_link")>
	<#if response?? && response.resultPacket?? && response.resultPacket.resultsSummary??>
		<#if response.resultPacket.resultsSummary.nextStart??>
			<#assign nextUrl = link + "?"
					+ changeParam(QueryString, "start_rank", response.resultPacket.resultsSummary.nextStart) in .namespace />
			<#assign nextRanks = response.resultPacket.resultsSummary.numRanks in .namespace />
			<#nested>
		</#if>
	</#if>
</#macro>

<#---
	Prints the url for the next pagination button.

	@requires Next
-->
<#macro NextUrl><#compress>
	<#if (.namespace.nextUrl)!?has_content>
		<#noescape>
			${.namespace.nextUrl}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Prints the url for the next pagination button.

	@requires Next
-->
<#macro NextRanks><#compress>
	<#if (.namespace.nextRanks)!?has_content>
		${.namespace.nextRanks}
	</#if>
</#compress></#macro>

<#---
	Generates links to result pages.

	<p>Iterate over the nested content for each available page</p>

	<p>
			Three variables will be set in the template:
			<ul>
					<li><code><namespace>.pageUrl</code>: Url of the page.</li>
					<li><code><namespace>.pageCurrent</code>: boolean, whether the current page is the one currently displayed.</li>
					<li><code><namespace>.pageNumber</code>: Number of the current page.</li>
			</ul>
	</p>

	<p>Example:

			<pre>
&lt;@<namespace>.Page&gt;
	&lt;#if <namespace>.pageCurrent&gt;
			${<namespace>.pageNumber}
	&lt;#else&gt;
			&lt;a href="${<namespace>.pageUrl}"&gt;${<namespace>.pageNumber}&lt;/a&gt;
	&lt;/#if&gt;
&lt;/@<namespace>.Page&gt;
			</pre>

	</p>

	@requires Pagination

	@param numPages Number of pages links to display (default = 5)

	@provides <code>${core_controller.pageNumber}</code> <br /> <code>${core_controller.pageUrl}</code> <br /> <code>${core_controller.pageCurrent}</code>
-->
<#macro Page numPages=5 link=question.collection.configuration.value("ui.modern.search_link")>
	<#local rs = response.resultPacket.resultsSummary />
	<#local pages = 0 />
	<#if rs.fullyMatching??>
		<#if rs.fullyMatching &gt; 0>
			<#local pages = (rs.fullyMatching + rs.partiallyMatching + rs.numRanks - 1) / rs.numRanks />
		<#else>
			<#local pages = (rs.totalMatching + rs.numRanks - 1) / rs.numRanks />
		</#if>
	<#else>
		<#-- Event search -->
		<#local pages = (rs.totalMatching + rs.numRanks - 1) / rs.numRanks />
	</#if>

	<#local currentPage = 1 />
	<#if rs.currStart &gt; 0 && rs.numRanks &gt; 0>
		<#local currentPage = (rs.currStart + rs.numRanks -1) / rs.numRanks />
	</#if>

	<#local firstPage = 1 />
	<#if currentPage &gt; ((numPages-1)/2)?floor>
		<#local firstPage = currentPage - ((numPages-1)/2)?floor />
	</#if>

	<#list firstPage..firstPage+(numPages-1) as pg>
		<#if pg &gt; pages><#break /></#if>
		<#assign pageNumber = pg in .namespace />
		<#assign pageUrl = link + "?" + changeParam(QueryString, "start_rank", (pg-1) * rs.numRanks+1) in .namespace />

		<#if pg == currentPage>
			<#assign pageCurrent = true in .namespace />
		<#else>
			<#assign pageCurrent = false in .namespace />
		</#if>

		<#nested>
	</#list>
</#macro>

<#---
	Conditional display - Runs the nested code if the current page is selected.

	@requires Page

	@param negate Reverses the logic of this macro. i.e. Runs the nested code if the current page is not selected
-->
<#macro IsCurrentPage negate=false>
	<#if .namespace.pageCurrent == true && negate==false>
		<#nested>
	<#elseif .namespace.pageCurrent == false && negate==true>
		<#nested>
	</#if>
</#macro>

<#---
	Prints the page number.

	@requires Page
-->
<#macro PageNumber><#compress>
	<#if (.namespace.pageNumber)!?has_content>
		${.namespace.pageNumber}
	</#if>
</#compress></#macro>

<#---
	Prints the page url

	@requires Page
-->
<#macro PageUrl><#compress>
	<#if (.namespace.pageUrl)!?has_content>
		<#noescape>
			${.namespace.pageUrl}
		</#noescape>
	</#if>
</#compress></#macro>

<#--- @end -->

<#--- @begin Blending -->

<#---
	Sets up the namespace variables for blending.

	<p>
		This macro checks if a query blending occurred
		and provide a link to cancel it.
	</p>

	@provides <code>${core_controller.blendingTerms}</code> <br /> <code>${core_controller.blendingDisabledUrl}</code>
-->
<#macro Blending link=question.collection.configuration.value('ui.modern.search_link')>
	<#if (response.resultPacket.QSups)!?has_content && response.resultPacket.QSups?size &gt; 0>
		<#local blendingTerms = "">
		<#list response.resultPacket.QSups as qsup>
			<#local blendingTerms = blendingTerms + qsup.query>
			<#if qsup_has_next>
				<#local blendingTerms = blendingTerms + ", ">
			</#if>
		</#list>

		<#assign blendingTerms = blendingTerms in .namespace>
		<#assign blendingDisabledUrl = "${link}?${QueryString}&amp;qsup=off" in .namespace>
		<#nested>
	</#if>
</#macro>

<#---
	Prints the terms which have been blended into the results.

	@requires Blending
-->
<#macro BlendingTerms><#compress>
	<#if (.namespace.blendingTerms)!?has_content>
		${.namespace.blendingTerms}
	</#if>
</#compress></#macro>

<#---
	Prints the url which can be used to disable blending.

	@requires Blending
-->
<#macro BlendingDisabledUrl><#compress>
	<#if (.namespace.blendingDisabledUrl)!?has_content>
		<#noescape>
			${.namespace.blendingDisabledUrl}
		</#noescape>
	</#if>
</#compress></#macro>

<#--- @end -->


<#--- @begin Curator -->

<#---
	Conditional display - Runs the nested code only when exhibits have been defined.

	<p>
		Exhibits are individual 'blocks' of information made available for display within
		search results by the curator system.
	</p>
-->
<#macro CuratorExhibits>
	<#if (response.curator.exhibits)!?size &gt; 0>
		<#nested>
	</#if>
</#macro>

<#---
	Sets up the namespace variables to display exhibits.

	<p>
		The content will be evaluated once per exhibit.
	</p>

	@requires CuratorExhibits

	@provides <code>${core_controller.curatorExhibitsMessageHtml}</code>
-->
<#macro CuratorExhibit>
	<#list response.curator.exhibits as exhibit>
		<#if exhibit.messageHtml??>
			<#assign curatorExhibitsMessageHtml = exhibit.messageHtml in .namespace>
			<#nested>
		</#if>
	</#list>
</#macro>

<#---
	Prints the message belonging to the the exhibit.

	@requires CuratorExhibit
-->
<#macro CuratorExhibitsMessageHtml>
	<#if (.namespace.curatorExhibitsMessageHtml)!?has_content>
		<#noescape>
			${.namespace.curatorExhibitsMessageHtml}
		</#noescape>
	</#if>
</#macro>

<#--- @end -->

<#--- @begin Textminer -->

<#---
	Setups the namespace variables to display Text Mining suggestions.

	<p>
		Text Mining in Funnelback involves extracting entities and definitions
		from textual data. Named entities include person names, organisations,
		products, geographic locations etc, as well as acronyms.
	</p>

	@provides <code>${core_controller.textMinerUrl}</code> <br /> <code>${core_controller.textMinerEntity}</code> <br /> <code>${core_controller.textMinerDefinition}</code>
-->
<#macro TextMiner>
	<#if response.entityDefinition??>
		<#assign textMinerUrl = response.entityDefinition.url>
		<#assign textMinerEntity = response.entityDefinition.entity>
		<#assign textMinerDefinition = response.entityDefinition.definition>
		<#nested>
	</#if>
</#macro>

<#---
	Prints the url for the text miner entry.

	@requires TextMiner
-->
<#macro TextMinerUrl><#compress>
	<#if (.namespace.textMinerUrl)!?has_content>
		<#noescape>
			${.namespace.textMinerUrl}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Prints the entity for the text miner entry.

	@requires TextMiner
-->
<#macro TextMinerEntity><#compress>
	<#if (.namespace.textMinerEntity)!?has_content>
			${.namespace.textMinerEntity}
	</#if>
</#compress></#macro>

<#---
	Prints the definition for the text miner entry.

	@requires TextMiner
-->
<#macro TextMinerDefinition><#compress>
	<#if (.namespace.textMinerDefinition)!?has_content>
			${.namespace.textMinerDefinition}
	</#if>
</#compress></#macro>

<#--- @end -->

<#---
	Conditional display against results and results looping.

	<p>The content will be evaluated only if there are results,
	and once per result found.</p>

	<p>
		<strong>Note:</strong> This will loop over a list containing
		a list of TierBar and Result objects, so you need to check the
		object type in the loop before trying to access its fields like
		title, etc.
	</p>

	@provides <code>${core_controller.result}</code> <br /> <code>${core_controller.result_has_next}</code> <br /> <code>${core_controller.result_index}</code>
-->
<#macro Results>
	<#if (response.resultPacket.resultsWithTierBars)!?has_content>
		<#list response.resultPacket.resultsWithTierBars as r>
			<#assign result = r in .namespace />
			<#assign result_has_next = r_has_next in .namespace />
			<#assign result_index = r_index in .namespace />
			<#nested>
		</#list>
	</#if>
</#macro>

<#--- @begin Explore -->

<#---
	Sets up the namespace variable required to create an "explore" link for
	a search result.

	<p>
		Explore links can be used to drill deeper into a particular topic,
		giving you more focused information on that topic.
	</p>

	@requires Results

	@provides <code>${core_controller.exploreUrl}</code>
-->
<#macro Explore>
	<#assign exploreUrl = "?" + changeParam(QueryString, "query", "explore:" + .namespace.result.liveUrl)?html in .namespace>
	<#nested>
</#macro>

<#---
	Prints the url for explore links.

	@requires Explore
-->
<#macro ExploreUrl><#compress>
	<#if (.namespace.exploreUrl)!?has_content>
		<#noescape>
			${.namespace.exploreUrl!}
		</#noescape>
	</#if>
</#compress></#macro>

<#--- @end -->

<#--- @begin Quicklinks -->

<#---
	Conditional display - Runs the nested code only if quick links
	exists for a result.

	<p>
		The Quick Links feature displays a list of relevant links below
		the result summary for home page results. These links are displayed
		whether the result is a top level domain home page
		<code>(eg. http://www.domain.com/) </code> or a sub home page
		<code>(eg. http://www.domain.com/news/default.htm)<code>.
	</p>

	<p>
		It provides search users quicker access to specific links contained
		in home pages without having to visit the home page to find the link.
	</p>

	<p>
		If the result is a top level domain home page, it also allows you to provide an inline search box restricted to this domain.
	</p>

	<p>
		The content will be evaluated only if quicklinks is applicable to
		the current result.
	</p>

	@requires Results
-->
<#macro Quicklinks>
	<#if (.namespace.result.quickLinks)!?has_content>
		<#nested>
	</#if>
</#macro>

<#---
	Sets up the namespace variables for each quicklinks.

	<p>The content will be evaluated once per quick link.</p>

	@requires Quicklinks

	@provides <code>${core_controller.quickLink}</code> <br /> <code>${core_controller.quickLink_index}</code> <br /> <code>${core_controller.quickLink_has_next}</code>
-->
<#macro QuickLink>
	<#if (.namespace.result.quickLinks.quickLinks)!?has_content>
		<#list .namespace.result.quickLinks.quickLinks as quickLink>
			<#assign quickLink = quickLink in .namespace />
			<#assign quickLink_index = quickLink_index in .namespace />
			<#assign quickLink_has_next = quickLink_has_next in .namespace />
			<#nested>
		</#list>
	</#if>
</#macro>

<#---
	Prints the url for the current quick link.

	@requires Quicklinks
-->
<#macro QuickLinkUrl><#compress>
	<#if (.namespace.quickLink.url)!?has_content>
		<#noescape>
			${.namespace.quickLink.url!}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Prints the text for the current quick link.

	@requires Quicklinks
-->
<#macro QuickLinkText><#compress>
	<#if (.namespace.quickLink.text)!?has_content>
		${.namespace.quickLink.text!}
	</#if>
</#compress></#macro>

<#--- @end -->

<#--- @begin Optimise -->

<#---
	Sets up the namespace variables required to generate an
	&quot;optimise&quot; link to the SEO Auditor (From the admin side only).

	<p>
		The SEO Auditor is a tool to help improve the search ranking of a
		specific page for a specific query. Given a query and a page URL, it
		lists a series of simple steps that could be taken to improve the
		ranking of the selected document for that query.
	</p>

	<p>SEO Auditor was previously known as Content Auditor.</p>

	@requires Results

	@provides <code>${core_controller.optimiseUrl}</code>
-->
<#macro Optimise>
	<@AdminUIOnly>
		<#assign optimiseUrl = "seo-auditor.html?optimiser_url=${.namespace.result.indexUrl}&amp;query=${response.resultPacket.query}&amp;collection=${.namespace.result.collection}&amp;profile=${question.profile}">
		<#nested>
	</@AdminUIOnly>
</#macro>

<#---
	Prints the url for the optimise link.

	@requires Optimise
-->
<#macro OptimiseUrl>
	<#if (.namespace.optimiseUrl)!?has_content>
		<#noescape>
			${.namespace.optimiseUrl}
		</#noescape>
	</#if>
</#macro>

<#--- @end -->

<#--- @begin Result collapsing -->

<#---
	Sets up the namespace variables required to generate a link to show
	the results that were collapsed for the current result.

	<p>
		Result Collapsing is the ability to collapse similar results
		into one, when displayed on the search results page.

		Results are considered similar when:

		<ul>
			<li>
				Their content is identical, or nearly identical (as decided by the query processor)
			</li>
			<li>
				They share one or multiple identical metadata fields
			</li>
		</ul>
	<p>

	@requires Results

	@provides <code>${core_controller.collapsedUrl}</code> <br /> <code>${core_controller.collapsedCount}</code>
-->
<#macro Collapsed>
	<#if .namespace.result.collapsed??>
		<#assign collapsedUrl = "${question.collection.configuration.value('ui.modern.search_link')}?${removeParam(QueryString, ['start_rank'])?html}&amp;s=%3F:${.namespace.result.collapsed.signature}&amp;fmo=on&amp;collapsing=off" in .namespace>
		<#assign collapsedCount = .namespace.result.collapsed.count in .namespace>
		<#nested>
	</#if>
</#macro>

<#---
	Conditional display - Runs the nested code if exact count is avaialble.

	@requires Collapsed
-->
<#macro CollapsedLabel signature="">
	<#if (response.resultPacket.resultsSummary.estimatedCounts)!?has_content == false || response.resultPacket.resultsSummary.estimatedCounts == false>
		<#if signature!?has_content == false || ((.namespace.result.collapsed.column)!?has_content && .namespace.result.collapsed.column == signature)>
			<#nested>
		</#if>
	</#if>
</#macro>

<#---
	Conditional display - Runs the nested code if only an approximate
	count is avaialble.

	@requires Collapsed
-->
<#macro CollapsedApproximateLabel signature="">
	<#if (response.resultPacket.resultsSummary.estimatedCounts)!?has_content && response.resultPacket.resultsSummary.estimatedCounts>
		<#if signature!?has_content == false || ((.namespace.result.collapsed.column)!?has_content && .namespace.result.collapsed.column == signature)>
			<#nested>
		</#if>
	</#if>
</#macro>

<#---
	Prints the url for the collapsed result.

	@requires Collapsed
-->
<#macro CollapsedUrl><#compress>
	<#if (.namespace.collapsedUrl)!?has_content>
		<#noescape>
			${.namespace.collapsedUrl}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Prints the count for the collapsed result.

	@requires Collapsed
-->
<#macro CollapsedCount><#compress>
	<#if (.namespace.collapsedCount)!?has_content>
			${.namespace.collapsedCount}
	</#if>
</#compress></#macro>

<#--- @end -->

<#--- @begin Extra searches -->

<#---
	Perform an additional search and process results.

	<p>
		The data can then be accessed using the standard <code>question</code>,
		<code>response</code> and <code>error</code> objects from within the tag.
	</p>

	<p>
		Note that the search is run when the tag is actually evaluated. This
		could impact the overall response time. For this reason it's recommended
		to use <code>@fb.ExtraResults</code>.
	</p>

	@param question Initial SearchQuestion, used as a base for parameters.
	@param collection Name of the collection to search on.
	@param query Query terms to search for.
	@param params Map of additional parameters (ex: <code>{&quot;num_ranks&quot; : &quot;3&quot;}</code>).
-->
<#macro ExtraSearch question collection query params={}>
	<#local questionBackup = question!{} />
	<#local responseBackup = response!{} />
	<#local errorBackup = error!{} />
	<#local extra = search(question, collection, query, params)>
	<#global question = extra.question!{} />
	<#global response = extra.response!{} />
	<#global error = extra.error!{} />
	<#nested>
	<#global question = questionBackup />
	<#global response = responseBackup />
	<#global error = errorBackup />
</#macro>

<#---
	Process results coming from an extra search.

	<p>The extra search needs to be properly configured in
	<code>collection.cfg</code> for the results to be available.</p>

	<p>Extra searches are run in parallel of the main query and take advantage
	of multi-core machines. It's recommended to use it rather than <code>@fb.ExtraSearch</code></p>

	<p>An example configuration is:
			<ol>
					<li>
							<strong>Create extra search config file</strong> (<code>$SEARCH_HOME/conf/$COLLECTION_NAME/extra_search.<extra search name>.cfg</code>)<br />
							<code>collection=&lt;collection name to search&gt;</code><br />
							<code>query_processor_options=-num_ranks3</code>
					</li>
					<li><strong>Reference extra search config in collection.cfg</strong><br />
							<code>ui.modern.extra_searches=&lt;extra search name&gt;</code>
					</li>
					<li><strong>Add extra search form code to search template</strong><br />
							<pre>
							&lt;div id=&quot;extraSearch&quot;&gt;<br />
									&lt;@fb.ExtraResults name=&quot;&lt;extra search name&gt;&quot;&gt;<br />
											&lt;#if response.resultPacket.results?size &lt; 0&gt;<br />
													&lt;h3>Related news&gt;/h3&gt;<br />
															&lt;#list response.resultPacket.results as result&gt;<br />
																	&lt;p class=&quot;fb-extra-result&quot;&gt;<br />
																			${result.title}<br />
																	&lt;/p&gt;<br />
															&lt;/#list&gt;<br />
													&lt;/div&gt;<br />
											&lt;/#if&gt;<br />
									&lt;/@fb.ExtraResults&gt;<br />
							&lt;/div&gt;<br />
							</pre>
					</li>
			</ol>
	</p>

	@param name Name of the extra search results to process, as configured in <code>collection.cfg</code>.
-->
<#macro ExtraResults name>
	<#if extraSearches?? && extraSearches[name]??>
		<#local questionBackup = question!{} />
		<#local responseBackup = response!{} />
		<#if error??>
				<#local errorBackup = error />
		</#if>

		<#global question = extraSearches[name].question!{} />
		<#global response = extraSearches[name].response!{} />
		<#if extraSearches[name].error??>
				<#global error = extraSearches[name].error />
		</#if>

		<#nested>

		<#global question = questionBackup />
		<#global response = responseBackup />
		<#if errorBackup??>
				<#global error = errorBackup />
		</#if>
	<#else>
		<!-- No extra results for '${name}' found -->
	</#if>
</#macro>



<#--- @end -->

</#escape>
