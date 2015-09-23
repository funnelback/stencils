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
	</ul>
-->
<#escape x as x?html>

<#-- Import Utilities -->
<#import "/web/templates/modernui/stencils-libraries/stencils.utilities.ftl" as stencils_utilities />

<#-- Import libraries -->
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import Stencils -->
<#assign stencils = ["core"] />

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
	Conditional Display - Runs the nested code if there is at least one selected facet.

	<p>
		Aims to provide a means for the user to unselect facet categories
	</p>
-->
<#macro BreadCrumbSearch>
	<#if (question.selectedFacets)!?has_content
		&& question.selectedFacets?size &gt; 0>
		<#nested>
	</#if>
</#macro>

<#---
	Displays the facet breadcrumb as list which can be unselected
-->
<#macro BreadCrumbs name="" names=[]>
	<#if response?exists && response.facets?exists>
		<#if name == "" && names?size == 0>
			<#-- Iterate over all facets -->
			<#list response.facets as f>
				<#if f.hasValues() || question.selectedFacets?seq_contains(f.name)>
					<#assign facet = f in s>
					<#assign facet_index = f_index in s>
					<#assign facet_has_next = f_has_next in s>
					<#nested>
				</#if>
			</#list>
		<#else>
			<#list response.facets as f>
				<#if (f.name == name || names?seq_contains(f.name) ) && (f.hasValues() || question.selectedFacets?seq_contains(f.name))>
					<#assign facet = f in s>
					<#assign facet_index = f_index in s>
					<#assign facet_has_next = f_has_next in s>

					<#nested>
				</#if>
			</#list>
		</#if>
	</#if>
</#macro>

<#---
	Sets up the namespace variables for each individual breadcrumb.

	@requires BreadCrumbs

	@provides <code>${base_controller.facetDef}</code> <br /> <code>${base_controller.facetDef_index}</code> <br /> <code>${base_controller.facetDef_has_next}</code>
-->
<#macro BreadCrumb>
	<#local fn = facetedNavigationConfig(question.collection, question.profile) >
	<#if fn?exists>
		<#--
			Find facet definition in the configuration corresponding
			to the facet we're currently displaying
		-->
		<#list fn.facetDefinitions as fdef>
			<#if fdef.name == s.facet.name>
				<#assign facetDef = fdef in s />
				<#assign facetDef_index = fdef_index in s />
				<#assign facetDef_has_next = fdef_has_next in s />
				<@BreadCrumbSummary>
					<#nested>
				</@BreadCrumbSummary>
			</#if>
		</#list>
	</#if>
</#macro>

<#---
	Sets up the namespace variables in order to display the breadcrumb summary.

	<p>
		This is an internal macro that should not be used directly in any views.
	</p>

	@requires BreadCrumb

	@provides <code>${base_controller.breadCrumbUrl}</code> <br /> <code>${base_controller.facetDef_index}</code> <br /> <code>${base_controller.facetDef_has_next}</code>
-->
<#macro BreadCrumbSummary>
		<#-- We must test various combinations here as different browsers will encode
				 some characters differently (i.e. '/' will sometimes be preserved, sometimes
				 encoded as '%2F' -->
		<#if QueryString?contains("f." + s.facetDef.name?url)
				|| urlDecode(QueryString)?contains("f." + s.facetDef.name)
				|| urlDecode(QueryString)?contains("f." + s.facetDef.name?url)>
				<#assign breadCrumbUrl = question.collection.configuration.value("ui.modern.search_link") + "?" +	removeParam(facetScopeRemove(QueryString, s.facetDef.allQueryStringParamNames), ["start_rank"] + s.facetDef.allQueryStringParamNames) in s>
				<@NestedBreadCrumbName categoryDefinitions=s.facetDef.categoryDefinitions selectedCategoryValues=question.selectedCategoryValues>
					<#nested>
				</@NestedBreadCrumbName>
		</#if>
</#macro>

<#---
	Recursively generates the breadcrumbs using the facet.

	<p>
		This is an internal macro that should not be used directly in any views.
	</p>

	@param categoryDefinitions List of sub categories (hierarchical).
	@param selectedCategoryValues List of selected values.
	@param separator Separator to use in the breadcrumb.
-->
<#macro NestedBreadCrumbName categoryDefinitions selectedCategoryValues>
	<#list categoryDefinitions as def>
		<#if def.class.simpleName == "URLFill" && selectedCategoryValues?keys?seq_contains(def.queryStringParamName)>
			<#-- Special case for URLFill facets: Split on slashes -->
			<#assign path = selectedCategoryValues[def.queryStringParamName][0]>
			<#assign pathBuilding = "">
			<#list path?split("/", "r") as part>
				<#assign pathBuilding = pathBuilding + "/" + part>
				<#-- Don't display bread crumb for parts that are part
						 of the root URL -->
				<#if ! def.data?lower_case?matches(".*[/\\\\]"+part?lower_case+"[/\\\\].*")>
					<#if part_has_next>
						<a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(facetScopeRemove(QueryString, def.allQueryStringParamNames), ["start_rank"] + def.allQueryStringParamNames)?html}&amp;${def.queryStringParamName}=${pathBuilding?url}">${part}</a>
					<#else>
						${part}
					</#if>
				</#if>
			</#list>
		<#else>
			<#if selectedCategoryValues?keys?seq_contains(def.queryStringParamName)>
				<#-- Find the label for this category. For nearly all categories the label is equal
						 to the value returned by the query processor, but not for date counts for example.
						 With date counts the label is the actual year "2003" or a "past 3 weeks" but the
						 value is the constraint to apply like "d=2003" or "d>12Jun2012" -->
				<#-- Use value by default if we can't find a label -->
				<#local valueLabel = selectedCategoryValues[def.queryStringParamName][0] />

				<#-- Iterate over generated facets -->
				<#list response.facets as facet>
					<#if def.facetName == facet.name>
						<#-- Facet located, find current working category -->
						<#assign fCat = facet.findDeepestCategory([def.queryStringParamName])!"" />
						<#if fCat != "">
							<#list fCat.values as catValue>
								<#-- Find the category value for which the query string param
										 matches the currently selected value -->
								<#local kv = catValue.queryStringParam?split("=") />
								<#if valueLabel == urlDecode(kv[1])>
										<#local valueLabel = catValue.label />
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

				<#if last == true>
					<#assign breadCrumbName = valueLabel in s>
					<#nested>
				<#else>
					<#assign breadCrumbName = valueLabel in s>
					<#nested>
					<#assign breadCrumbUrl = question.collection.configuration.value("ui.modern.search_link") + "?" + removeParam(facetScopeRemove(QueryString, def.allQueryStringParamNames), ["start_rank"] + def.allQueryStringParamNames) + "&" + def.queryStringParamName + "=" + selectedCategoryValues[def.queryStringParamName][0] in s>

					<@NestedBreadCrumbName categoryDefinitions=def.subCategories selectedCategoryValues=selectedCategoryValues>
						<#nested>
					</@NestedBreadCrumbName>
				</#if>
				<#-- We've displayed one step in the breadcrumb, no need to inspect
						 other category definitions -->
				<#break />
			</#if>
		</#if>
	</#list>
</#macro>

<#---
 Displays the breadcrumb name
-->
<#macro BreadCrumbName><#compress>
		<#if (s.breadCrumbName)!?has_content>
			${s.breadCrumbName}
		</#if>
</#compress></#macro>

<#---
	Displays the breadcrumb url
-->
<#macro BreadCrumbUrl><#compress>
		<#if (s.breadCrumbUrl)!?has_content>
			${s.breadCrumbUrl}
		</#if>
 </#compress></#macro>
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
-->
<#macro HasResults>
	<#if (response.resultPacket.resultsSummary.totalMatching)!?has_content
	 && response.resultPacket.resultsSummary.totalMatching &gt; 0>
	 <#nested>
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

</#escape>
