<#ftl encoding="utf-8" />
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>
<@s.AfterSearchOnly>
<@s.Results>
<#if s.result.class.simpleName == "TierBar">
    <#if s.result.matched != s.result.outOf></#if>
<#else>
    <#if s.result.metaData["S"]??>
        ${s.result.metaData["j"]!} ${s.result.metaData["g"]!},999,"<img src='https://admin-demo-au.funnelback.com/s/scale?url=<#if s.result.metaData["q"]??>${s.result.metaData["q"]}<#else>http://img3.wikia.nocookie.net/__cb20121227201208/jamesbond/images/6/61/Generic_Placeholder_-_Profile.jpg</#if>&width=80&height=80&format=jpg&type=keep_aspect'><div class='list-item'>${s.result.metaData["c"]!} ${s.result.metaData["g"]!} <@s.boldicize> ${s.result.metaData["j"]!}</@s.boldicize><br>${s.result.metaData["l"]!}</div>",H,"${s.result.metaData["S"]}",1,"${s.result.liveUrl}",U
    </#if>
</#if>
</@s.Results>
</@s.AfterSearchOnly>