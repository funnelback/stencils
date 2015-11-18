<#ftl encoding="utf-8" />
<#---
	Controllers for Collasped Result

	<h2>Table of Contents</h2>
	<ul>
		<li><strong>Collapsed:</strong> The logic to the collaspsed result.</li>
		<li><strong>Collapsed Results:</strong> The logic to the collaspsed result's results.</li>
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

<#--- @begin Collapsed -->

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
	<#if core_controller.result.collapsed??>
		<#assign collapsed = core_controller.result.collapsed in .namespace>
		<#assign collapsedUrl in .namespace><@CollapsedUrl /></#assign>
		<#assign collapsedCount in .namespace><@CollapsedCount /></#assign>
		<#assign collapsedResultsCount in .namespace><@CollapsedResultsCount /></#assign>
		<#assign collapsedHasExactCount in .namespace><@CollapsedHasExactCount /></#assign>

		<#nested>
	</#if>
</#macro>

<#---
	Prints the url for the collapsed result.

	@requires Collapsed
-->
<#macro CollapsedUrl><#compress>

	<#local searchLink = "${question.collection.configuration.value('ui.modern.search_link')}">
	<#local searchQuery = "${removeParam(QueryString, ['start_rank'])?html}&amp;s=%3F:${.namespace.collapsed.signature}&amp;fmo=on&amp;collapsing=off" >
	<#local url = "${searchLink}?${searchQuery}" >

	<#if (url)!?has_content>
		<#noescape>
			${url}
		</#noescape>
	</#if>
</#compress></#macro>

<#---
	Prints the count for the collapsed result.

	@requires Collapsed
-->
<#macro CollapsedCount><#compress>
	<#local count = .namespace.collapsed.count>
	<#if (count)!?has_content>
			${count}
	</#if>
</#compress></#macro>

<#---
	Gets the number of Collapsed Results that are available to print
	@requires Collapsed
-->
<#macro CollapsedResultsCount><#compress>
${.namespace.collapsed.results?size}
</#compress></#macro>

<#---
	Conditional display - Runs the nested code if exact count is avaialble.
	NOTE: This used to be CollapsedLabel
	@param negate Reverse conditon by setting to true. Will display if has approximate count
	@requires Collapsed
-->
<#macro CollapsedHasExactCount signature="" negate=false>
	<#if !negate>
		<#--  If we have exact count print -->
		<#if (response.resultPacket.resultsSummary.estimatedCounts)!?has_content == false || response.resultPacket.resultsSummary.estimatedCounts == false>
			<#if signature!?has_content == false || ((.namespace.collapsed.column)!?has_content && .namespace.collapsed.column == signature)>
				<#nested>
			</#if>
		</#if>
	<#else>
		<#-- If we do not have exact count print - Runs the nested code if only an approximate count -->
		<#if (response.resultPacket.resultsSummary.estimatedCounts)!?has_content && response.resultPacket.resultsSummary.estimatedCounts>
			<#if signature!?has_content == false || ((.namespace.result.collapsed.column)!?has_content && .namespace.result.collapsed.column == signature)>
				<#nested>
			</#if>
		</#if>
	</#if>
</#macro>
<#--- @end -->

<#-- @begin Collapsed Results -->
<#---
	Gets the Collapsed Results ready to print
	@requires core_controller.Collapsed
-->
<#macro Results>
	<#list .namespace.collapsed.results as r>
		<#assign result = r in .namespace >
		<#nested>
	</#list>
</#macro>

<#---
	Displays content if Collapsed Results has more results than set for display
	in -collapsing_num_ranks setting.
	@param negate set to true to reverse condition.
	@requires Results
-->
<#macro ResultsHasMoreResults negate=false>
	<#if !negate >
		<#-- Show #nested if there are more collasped results than area available to print in view  -->
		<#if .namespace.collapsedCount?number gt .namespace.collapsedResultsCount?number>
			<#nested>
		</#if>
	<#else>
		<#-- Show #nested if there all the collasped results are avaible to print in view -->
		<#if .namespace.collapsedCount?number lte .namespace.collapsedResultsCount?number>
			<#nested>
		</#if>
	</#if>
</#macro>
<#-- @end -->
<#-- / Category - Results  -->

</#escape>
