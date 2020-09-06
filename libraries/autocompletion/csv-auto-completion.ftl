<#ftl output_format="JSON" encoding="utf-8"><#compress>
<#--
  Template to generate CSV completions for the Concierge based
  on the indexed document metadata
-->
<#assign stopWordsList><#include "/share/lang/${question.getCurrentProfileConfig().get('stencils.auto-completion.stop-words')!'en'}_stopwords.ftl"></#assign>
<#assign stopWords = stopWordsList?split("[\r\n]", "r")>
<#assign actionType = question.getCurrentProfileConfig().get("stencils.auto-completion.action-type")!"U">
<#assign triggers = question.getCurrentProfileConfig().get("stencils.auto-completion.triggers")!?split(",")>

<#list (response.resultPacket.results)![] as result>
    <#if result.class.simpleName != "TierBar">
        <#list triggers as metaDataOrTitle>
            <#list getTriggerValues(result, metaDataOrTitle) as singleValue>
                <#assign data>
                {
                    "title": "${result.title}",
                    <#if result.date?has_content>
                      "date": "${result.date?date?string.short}",
                    </#if>
                    "metaData": {
                      <#list result.listMetadata!{} as key, value>
                        "${key}": "${value?join(", ")?replace("\"", "\\\"")}"<#sep>,
                      </#list>
                    }
                }
                </#assign>

                <#assign action = result.clickTrackingUrl!>
                <#-- If the action is "Q", use the title as the query to run -->
                <#if actionType == "Q">
                  <#assign action = result.title>
                </#if>

                <#-- Add a line with the trigger as-is so that it will match if it's typed in as-is -->
                <@csvLine trigger=singleValue data=escapeCsv(data?replace("[\r\n]","", "r")) action=action actionType=actionType />

                <#-- Split value on space -->
                <#list singleValue?split(" ") as value>
                    <#-- Strip any character that doesn't matter for the trigger -->
                    <#assign trigger = value?lower_case?replace("[^A-Za-z0-9\\s]","","r")>
                    <#-- Ignore the trigger if it's a stop word -->
                    <#if !stopWords?seq_contains(trigger)>
                      <#-- Generate a JSON block for the completion, containing all the metadata fields of the document -->
                      <@csvLine trigger=trigger data=escapeCsv(data?replace("[\r\n]", "", "r")) action=action actionType=actionType />
                    </#if>
                </#list>
            </#list>
        </#list>
    </#if>
</#list>
</#compress>

<#-- Generates a single CSV line, for a trigger, data to display and URL to navigate to -->
<#macro csvLine trigger data action actionType>
"${trigger}",100,${data},J,"${escapeCsv(question.getCurrentProfileConfig().get("stencils.auto-completion.category")!)}",,"${escapeCsv(action)}",${actionType}
</#macro>

<#function getTriggerValues result trigger>
    <#if trigger == "title" && result.title!?has_content>
        <#return result.title?split("|") />
    <#elseif result.listMetadata?keys?seq_contains(trigger)>
        <#return result.listMetadata[trigger] />
    </#if>
    <#return []>
</#function>

<#-- Escapes a String suitably for CSV -->
<#function escapeCsv str>
    <#return str!?chop_linebreak?trim?replace("\\", "\\\\")?replace("\"", "\\\"")?replace(",", "\\,") />
</#function>
