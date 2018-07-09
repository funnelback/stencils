<#ftl encoding="utf-8"><#compress>
<#--
  Template to generate CSV completions for the Concierge based
  on the indexed document metadata
-->
<#assign stopWordsList><#include "/share/lang/${question.collection.configuration.value('stencils.auto-completion.stop-words', 'en')}_stopwords"></#assign>
<#assign stopWords = stopWordsList?split("[\r\n]", "r")>
<#assign actionType = question.collection.configuration.value("stencils.auto-completion.action-type")!"U">

<#list (response.resultPacket.results)![] as result>
    <#if result.class.simpleName != "TierBar">
        <#-- Read the list of triggers to generate from collection.cfg. Can be just the result title, or any metadata field -->
        <#list question.collection.configuration.value("stencils.auto-completion.triggers")!?split(",") as metaDataOrTitle>
            <#if (metaDataOrTitle == "title" && result.title?has_content) || result.metaData[metaDataOrTitle]!?has_content>
                <#assign field = result.title>
                <#if metaDataOrTitle != "title">
                  <#assign field = result.metaData[metaDataOrTitle]>
                </#if>
                <#-- The field may have multiple values. Process them one by one -->
                <#list field?split("|") as singleValue>
                    <#assign data>
                    {
                        "title": "${result.title?json_string}",
                        <#if result.date?has_content>
                          "date": "${result.date?date?string.short?json_string}",
                        </#if>
                        "metaData": {
                          <#list result.metaData!{} as key, value>
                            "${key?json_string}": "${value?replace("|", ", ")?replace("\"", "\\\"")?json_string}"<#if key_has_next>,</#if>
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
            </#if>
        </#list>
    </#if>
</#list>
</#compress>

<#-- Generates a single CSV line, for a trigger, data to display and URL to navigate to -->
<#macro csvLine trigger data action actionType>
"${trigger}",100,${data},J,"${escapeCsv(question.collection.configuration.value("stencils.auto-completion.category")!)}",,"${escapeCsv(action)}",${actionType}
</#macro>

<#-- Escapes a String suitably for CSV -->
<#function escapeCsv str>
    <#return str!?chop_linebreak?trim?replace("\"", "\\\"")?replace(",", "\\,") />
</#function>
