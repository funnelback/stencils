<#ftl encoding="utf-8" />
<#---
	This contains basic utilities functions which can be used across all stencils and general implementations.

	<h2>Table of Contents</h2>
	<ul>
		<li><strong>General:</strong> General search helpers.</li>
		<li><strong>Search forms:</strong> Advanced search form, simple search form ....</li>
		<li><strong>Sessions:</strong> Favorites/Cart, search history.</li>
		<li><strong>Facets:</strong> Faceted navigation, search breadcrumbs.</li>
		<li><strong>Result features:</strong> Search view selectors/formaters, best bets, contextual navigation.</li>
		<li><strong>Result:</strong> Result helpers e.g. panels ...</li>
		<li><strong>Share Tools:</strong> Email and social sharing buttons.</li>
	</ul>
-->
<#escape x as x?html>

<#-- Import Utilities -->
<#import "/share/stencils/libraries/stencils.utilities.ftl" as stencils_utilities />

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils = ["core"] />

<#--
	The following code imports and assigns stencil namespaces automatically eg. core_controller.
	The code expects that the controller files are located under $SEARCH_HOME/share/stencils/libraries/

 	Note: View files should not be imported to to the controller
-->
<@stencils_utilities.ImportStencilsControllers stencils=stencils>
	<@stencils_utilities.importsControllers?interpret />
</@stencils_utilities.ImportStencilsControllers>

<#-- ###################  Controllers ####################### -->
<#-- @begin  General -->
<#---
	Builds a URL which can be used to navigate the user to another search page
	while maintaining the specified CGI parameters and their associated values.

	@param parameters The CGI parameters which are to be maintained
	@param urlStem The base urls in which the paramters are to be attached to

	@return String The generated URL as a String
-->
<#function buildQueryString(parameters, urlStem ="")>
	<#local url = urlStem>
	<#--
		Search for each parameter and append the values to the url
		if a value can be found
	-->
	<#local flag = false>
	<#list parameters as param>
		<#if (question.rawInputParameters)!?has_content && question.rawInputParameters[param]??>
			<#--
				Append values for each occurence of the parameter
				i.e. meta_a=peter&meta_a=john
			-->
			<#list question.rawInputParameters[param] as value>
				<#if value?has_content>
					<#--
						Appends a "&"" only if this is not the first time a value
						is being added to the url
					-->
					<#if url?matches("&$") == false && flag>
						<#local url = url + "&">
					</#if>

					<#local url = url + param + "=" + value>

					<#local flag = true>
				</#if>
			</#list>
		</#if>
	</#list>
	<#return url>
</#function>

<#---
	Remove from query string parameter of given name and value.

	@param queryString The query string in which the @name and @value pair are to be removed
	@param parameter The name of the matching CGI paramter
	@param value The value of the matching CGI paramter

	@return String The query string with the matching CGI parameter and value removed
-->
<#function removeParamWithValue queryString parameter value>
	<#local queries = queryString?split("&",'r')>
	<#list queries as query>
		<#local params = query?split("=", "r")>
		<#if urlDecode(params[0]) == urlDecode(parameter) && urlDecode(params[1]) == urlDecode(value)>
			<#if query_index == 0>
				<#local queries = queries[query_index+1..] />
			<#elseif !query_has_next>
				<#local queries = queries[0..query_index-1] />
			<#else>
				<#local queries = queries[0..query_index-1] + queries[query_index+1..] >
			</#if>
		</#if>
	</#list>
	<#return queries?join('&')>
</#function>

<#---
	Generate URls for changing display format query.
	<p><strong>Example</strong</p>
	<code>&lt;@CreateSearchUrl CGI=[&quot;name=value&quot;, &quot;query=test&quot;] /&gt; or &lt;@base_controller.CreateSearchUrl CGIs=[&quot;display=list&quot;,&quot;num_ranks=10&quot;] /&gt;</code>
	@param cgi Array of cgi parameters as ["name=value", "query=test"].
	@param append	Append CGI to existing CGI Query. Default to true. (optional)
	@param URL URL to append CGI parameters to. Defaults to '/s/search.html'. (optional)
	@return string
-->
<#macro CreateSearchUrl cgis=[] append=true url="/s/search.html">
	<#compress>

		<#local query = QueryString key ="">

		<#if append>
		<#-- Create	query string from existing-->
			<#list cgis as cgi>
				<#-- Split out key value "name=value" into "name" & "value"	-->
				<#list cgi?split("=") as value>
					<#if value_index = 0>
						<#local key = value>
					<#else>
						<#local query = changeParam(query, key, value ) />
					</#if>
				</#list>
			</#list>
		<#else>
		<#-- Create new query string -->
			<#list cgis as cgi>
				<#if cgi_index = 0>
					<#local query=cgi>
				<#else>
					<#local query= query + "&" + cgi>
					<#break>
				</#if>
			</#list>
		</#if>

		${url + "?" + query}

	</#compress>
</#macro>

<#---
	Conditional display - Runs the nested code only if the matching  CGI parameter and value pair
	is found.

	<h3>Example Usuage</h3>
	<code>
		&lt;@IfDefCGIEquals name=&quot;display&quot; value=&quot;list&quot;&gt;&lt;p&gt;Return this&lt;/p&gt;&lt;/@IfDefCGIEquals&gt; or &lt;@base_controller.IfDefCGIEquals name=&quot;display&quot; &gt;active&lt;/@base_controller.IfDefCGIEquals&gt;
	</code>

	@param value value to test for a match to CGI parameter's value.
	@param name name of CGI paramater.
	@param trueIfEmpty return true if query param is null or not set

 -->
<#macro IfDefCGIEquals name="" value="" trueIfEmpty=false>
	<#if question?exists && question.inputParameterMap?exists && question.inputParameterMap?keys?seq_contains(name)>
		<#local result = question.inputParameterMap[name] >
		<#if result="">
			<#if trueIfEmpty>
				<#nested>
			</#if>
		<#else>
			<#if result?matches(value)>
				<#nested>
			</#if>
		</#if>
	<#else>
		<#if trueIfEmpty>
			<#nested>
		</#if>
	</#if>
</#macro>

<#---
	Get a CGI parameter's value. If empty the 'default' parameter is returned.

	@param name	Name of CGI parameter to retrieve value.
	@param default A value to return if CGI parameter is empty or null. Is set to "".
	@returns string
 -->
<#macro GetCGIValue name="" default=""><#compress>
	<#if question?exists && question.inputParameterMap?exists && question.inputParameterMap?keys?seq_contains(name)>
		<#local result = question.inputParameterMap[name] >
		<#if result="">
			${default}
		<#else>
			${result}
		</#if>
	<#else>
			${default}
	</#if>
 </#compress></#macro>


<#---
	Converts URLs within text to html links.

	<p>Warning: Please use this marco with care because this uses noescape. Please do not use on user input fields.</p>
 -->
<#macro Linkify><#compress>
	<#local content><#nested></#local>
	<#if content??>
			<#noescape>
				<#list content?matches("(https?://[^\\s]+)") as match>
					<#local content>
					${content?replace(match, " <a href='" + match + "' >" + match + "</a>", "f")}
					</#local>
				</#list>
				${content}
			</#noescape>
	<#else>
		${content}
	</#if>
</#compress></#macro>
<#-- @end --><#-- / Category - General -->

<#-- @begin  Search Forms -->
<#---
	Sets up the namespace variables required for creating hidden input form elements.

 	@param metadata The metadata name

 	@provides <code>${base_controller.hiddenInputList}</code> <br /> <code>${base_controller.hiddenInputName}</code>
-->
<#macro HiddenInputs metadata>
	<#if (question.rawInputParameters)!?has_content && question.rawInputParameters[metadata]??>
		<#assign hiddenInputList = question.rawInputParameters[metadata] in .namespace>
		<#assign hiddenInputName = metadata in .namespace>
		<#nested>
	</#if>
</#macro>

<#---
 	Sets up the namespace variables required for each input value.

 	@provides <code>${base_controller.hiddenInputValue}</code>
-->
<#macro HiddenInput>
	<#list .namespace.HiddenInputList as value>
		<#if value!?has_content>
			<#assign hiddenInputValue = value in .namespace>
			<#nested>
		</#if>
	</#list>
</#macro>

<#---
	Prints the hidden input name
-->
<#macro HiddenInputName><#compress>
	<#if (.namespace.hiddenInputName)!?has_content>
		${.namespace.hiddenInputName}
	</#if>
</#compress></#macro>

<#---
	Prints the hidden input value
-->
<#macro HiddenInputValue><#compress>
	<#if (.namespace.hiddenInputValue)!?has_content>
		${.namespace.hiddenInputValue}
	</#if>
</#compress></#macro>
<#-- @end --><#-- / Search Forms -->

<#-- @begin  Sessions -->
<#-- @end --><#-- / Category - Sessions -->

<#-- @begin  Facets -->

<#---
 	Conditional Display - Runs the nested code if at least one facet has a facet category

	@param negate Set this to true to reverse the logic of this macro. i.e. Run the nested
	code if there are no facet with facet catergories.
-->
<#macro HasFacets negate=false>
	<@core_controller.AfterSearchOnly>
		<#assign facetFound = false>
		<#if response.facets??>
			<#list response.facets as facet>
				<#if facet.categories??>
					<#list facet.categories as category>
						<#if (category.values?? && category.values?size > 0)>
							<#assign facetFound = true>
						<#elseif (category.categories?? && category.categories?size > 0)>
							<#assign facetFound = true>
						</#if>
					</#list>
				</#if>
			</#list>
		</#if>

		<#if facetFound == true && negate == false>
			<#nested>
		<#elseif facetFound == false && negate == true>
			<#nested>
		</#if>
	</@core_controller.AfterSearchOnly>
</#macro>

<#---
	Displays a link that will clear all the facets.
-->
<#macro ClearFacetsLink>
  <#compress>
    <#-- generate the link that can be used to reset all of the facets -->
    <#if question.selectedCategoryValues?has_content>
      <#assign clearAllFacetsLink = question.collection.configuration.value("ui.modern.search_link")+"?"+removeParam(QueryString, question.  selectedCategoryValues?keys+["start_rank","facetScope"])/>
      ${clearAllFacetsLink}
    </#if>
  </#compress>
</#macro>

<#-- @end --><#-- / Category - Facets -->
<#-- @begin  Results Features -->

<#---
	Conditional Display - Runs the nested code only when there at least one contextual navigation entry that is not in "Site"
-->
<#macro HasContextNavigationEntries>
	<#assign contextFound = false>
	<@core_controller.AfterSearchOnly>
		<#if (response.resultPacket.contextualNavigation.categories)!?has_content>
			<#list response.resultPacket.contextualNavigation.categories as category>
				<#if category.name != "site">
					<#assign contextFound = true>
				</#if>
			</#list>
		</#if>
	</@core_controller.AfterSearchOnly>

	<#if contextFound == true && negate == false>
		<#nested>
	<#elseif contextFound == false && negate == true>
		<#nested>
	</#if>
</#macro>

<#---
	Conditional Display - Runs the nested code only if at least one result is found
	@param negate {boolean} Reverse condition, to HasNoResults. Set to true / false. Default is false.
-->
<#macro HasResults negate=false>
	<#if negate>
		<#-- Has No Results -->
		<#if !( (response.resultPacket.resultsSummary.totalMatching)!?has_content )
		 || !(response.resultPacket.resultsSummary.totalMatching &gt; 0) >
		 <#nested>
		</#if>
	<#else>
		<#-- Has Results-->
		<#if (response.resultPacket.resultsSummary.totalMatching)!?has_content
		 && response.resultPacket.resultsSummary.totalMatching &gt; 0>
		 <#nested>
		</#if>
	</#if>
</#macro>

<#---
	If a result grid is used change the result limits to match a number divible by the number of columns set. The main use case for this helper is for the limit selector.
	@param  limit {number} Number of rows show.
	@param  columns {number} Number of columns for setting grid limit for. Defaults to currently set number of columns.
-->
<#function setResultsLimitGrid limit=1 columns=getResultsColumnsNumber()>
	<#return (limit*columns)?string >
</#function>

<#---
	Constructor for ResultsColumns, defines how to format the grouping of result into columns.
	@provides <code>$&#123;base_controller.resultsColumnsNumber&#125;</code> <code>$&#123;base_controller.resultsColumnsIsLast&#125;</code> <code>$&#123;base_controller.resultsColumnsRank&#125;</code> <code>$&#123;base_controller.resultsColumnsIndex&#125;</code>
-->
<#macro ResultsColumns>
	<#-- Define attributes -->
	<#assign resultsColumnsNumber = getResultsColumnsNumber() in .namespace>
	<#assign resultsColumnsIsLast = getResultsColumnsIsLast() in .namespace>
	<#assign resultsColumnsRank = getResultsColumnsRank() in .namespace>
	<#assign resultsColumnsIndex = getResultsColumnsIndex() in .namespace>

	<#nested>
</#macro>

<#---
	Returns if the current result is the last item to be displayed. This can be accessed as <code>$&#123;base_controller.resultsColumnsIsLast&#125;</code>
	@requires ResultsColumns
	@return boolean
-->
<#function getResultsColumnsIsLast>
	<#return core_controller.result.rank == response.resultPacket.resultsSummary.currEnd>
</#function>

<#---
	Returns current position of the result which takes into account the current start rank. This can be accessed as <code>$&#123;base_controller.resultsColumnsRank&#125;</code>
	@requires ResultsColumns
	@return number
-->
<#function getResultsColumnsRank>
	<#return core_controller.result.rank - response.resultPacket.resultsSummary.currStart>
</#function>

<#---
	Returns the number of columns set. This can be accessed as <code>$&#123;base_controller.resultsColumnsNumber&#125;</code>
	@requires ResultsColumns
	@return number
-->
<#function getResultsColumnsNumber>
	<#local x><@GetCGIValue name="resultsColumns" default="2" /></#local>
	<#return x?number>
</#function>

<#---
	Returns the column set index. This can be accessed as <code>$&#123;base_controller.resultsColumnsIndex&#125;</code>
	@requires ResultsColumns
	@return number
-->
<#function getResultsColumnsIndex>
	<#return (.namespace.resultsColumnsRank / .namespace.resultsColumnsNumber)?floor + 1>
	<#-- <#return 0> -->
</#function>

<#---
	Show the nested content if it is the start of a column.
	@requires ResultsColumns
	@return nested
-->
<#macro ResultsColumnsIsOpen>
	<#if .namespace.resultsColumnsRank % .namespace.resultsColumnsNumber == 0>
		<#nested>
	</#if>
</#macro>

<#--
	Shows the nested content if it is the end of a column
	@requires ResultsColumns
	@return nested
-->
<#macro ResultsColumnsIsClosed>
	<#if (.namespace.resultsColumnsRank + 1) % .namespace.resultsColumnsNumber == 0 || .namespace.resultsColumnsIsLast>
		<#nested>
	</#if>
</#macro>
<#-- @end --><#-- / Category - Result Features -->

<#-- @begin  Result -->
<#--
	Checks the collection source of a results for meta collection.
	@return nested
	@parm name The name of the collection.
	@param nested String to display on condition test.
 -->
<#macro ResultIsCollection name="">
	<#if core_controller.result.collection = name >
		<#nested>
	</#if>
</#macro>
<#-- @end --><#-- / Category - Result -->


<#-- @begin Share Tools  -->
<#---
	Constructor for share tools
-->
<#macro ShareTools>
<#if (question.collection.configuration.value("stencils.base.share_tools"))?has_content && question.collection.configuration.value("stencils.base.share_tools") = "enabled" >
	<#assign shareToolsID in .namespace><@ShareToolsID /></#assign>
	<#nested>
</#if>
</#macro>

<#--
	Get the ID for the share tools plugin
 -->
<#macro ShareToolsID><#compress>
${question.collection.configuration.value("stencils.base.share_tools.id")}
</#compress></#macro>
<#-- @end --><#-- / Category - Share tools -->

</#escape>
