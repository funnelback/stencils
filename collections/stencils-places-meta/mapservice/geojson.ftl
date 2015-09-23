<#ftl encoding="utf-8" />
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>
<#escape x as x?html>
<#compress>
<#-- geojson.ftl
Outputs Funnelback response in GeoJSON format.
Version: 0.3
Date: Aug 2014
Author: Gordon Grace (Jun 2013), modifications by Peter Levan
See also:
http://www.geojson.org/geojson-spec.html
http://geojsonlint.com/
http://docs.funnelback.com/ui_modern_form_content_type_collection_cfg.html
Pre-requisites:
- Collection has geospatial component, encoded as lat/longs only - This file assumes that 'x' is the field containing the geo-coordinate
- collection.cfg has template response type correctly set to text/javascript (ui.modern.form.geojson.content_type=text/javascript) to return GeoJSON within a mapPoints javascript variable.

Optimisation: Because GeoJSON requests are likely to use large response sets you should optimise your queries as much as possible.
The general advice is to turn off as much stuff as possible (esp if turning the feature off causes a reduction in the size of the padre XML response/Modern UI data model).
The following should be considered:
- Set SM=meta (turn off result summaries) 
- Set SF to just the fields you need in the response (x + whatever you want to expose in the popups)
- Disable gscope counts (or use -countgbits=1 (or a field that contains few categories)
- Disable best bets (setting -bb=false)
- Disable metadata counts (-rmcf value should be removed in a pre datafetch hook script if metadata facets are used for the collection
- Set a short metadata buffer length (eg. -MBL=255).  This will most likely be determined by the length of a summary that you are presenting in result pins.

ToDo:
- Handle complex geometry output
-->
<@s.AfterSearchOnly>
  <#if question.inputParameterMap["callback"]?exists>
    ${question.inputParameterMap["callback"]?json_string} (
  </#if>
  {
<#if response.resultPacket.resultsSummary.totalMatching != 0>
<#-- RESULTS -->
        "type": "FeatureCollection",
        "features": [
    <@s.Results>
        <#if s.result.class.simpleName != "TierBar">
          <#if s.result.metaData["x"]??> <#-- has geo-coord - update to the meta class containing the geospatial coordinate -->
            <#-- EACH RESULT -->
            {
                "type": "Feature",
                "style": {
                  "radius": 8,
                  "fillColor": "#ff7800",
                  "color": "#000",
                  "weight": 1,
                  "opacity": 1,
                  "fillOpacity": 0.8
                },
                    "geometry": {
                        "type": "Point",
                        "coordinates": [${s.result.metaData["x"]?replace(".*\\;","","r")},${s.result.metaData["x"]?replace("\\;.*","","r")}] <#-- update to the meta class containing the geospatial coordinate -->
                    },
                    "properties": { <#-- Fill out with all the custom metadata you wish to expose (eg for use in the map display -->
                        "rank": "${s.result.rank?string?json_string}",
                        "title": "${s.result.title!"No title"?json_string}",
                              "summary": "${s.result.summary!?json_string}",
                        "fileSize": "${s.result.fileSize!?json_string}",
                        "fileType": "${s.result.fileType!?json_string}",
                        "exploreLink": "${s.result.exploreLink!?json_string}",
                        <#if s.result.date?exists> "date": "${s.result.date?datetime!"No date"?json_string}",</#if>
                        <#if s.result.kmFromOrigin?? && question.inputParameterMap["origin"]??>"kmFromOrigin": "${s.result.kmFromOrigin?string("0.###")?json_string}",</#if>
                        <#-- MORE METADATA FIELDS... -->
            "metaData": {
            <#list s.result.metaData?keys as md>
                "${md?json_string}": "${s.result.metaData[md]?json_string}"<#if md_has_next>,</#if>
            </#list>
                        },
                        "displayUrl": "${s.result.liveUrl!?json_string}",
                        "cacheUrl": "${s.result.cacheUrl!?json_string}",
                        "clickTrackingUrl": "${s.result.clickTrackingUrl!?json_string}"
                    }
                }<#if s.result.rank &lt; response.resultPacket.resultsSummary.currEnd>,</#if>
              </#if> <#-- has geo-coord -->
            </#if>
    </@s.Results>
    ]
</#if>
  } 
  <#if question.inputParameterMap["callback"]?exists>
)
  </#if>
</@s.AfterSearchOnly>
</#compress>
</#escape>
