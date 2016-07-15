<#ftl encoding="utf-8" />

<#--
   Funnelback App: Core
   By: <Name>
   Description: <Description>
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#assign librariesPrefix = "/share/stencils/libraries/" >
<#assign peopleResourcesPrefix = "/stencils/resources/people/" >
<#assign thirdPartyResourcesPrefix = "/stencils/resources/thirdparty/" >

<#import "${librariesPrefix}stencils.utilities.ftl" as stencils_utilities />
<#import "/share/stencils/libraries/people/controllers/people.controller.ftl" as people_controller/>

<#assign stencils=["core","base"] />

<@stencils_utilities.ImportStencils stencils=stencils>
	<@stencils_utilities.imports?interpret />
</@stencils_utilities.ImportStencils>

<#macro CSS>
    <link rel="stylesheet" href="${peopleResourcesPrefix}css/people.css">
</#macro>

<#macro JS>
    <script src="${thirdPartyResourcesPrefix}jquery/jquery.collapser/jquery.collapser.min.js"></script>
</#macro>

<!---
    Render an A-Z listing to browse the people list. Uses faceted navigation data under the hood
    in order to prevent reaching zero results page by clicking on a letter that doesn't have results
-->
<#macro AZList>
    <#local alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] />
    
    <ul class="pagination pagination-sm funnelback--people--az">
        <li class="<#if people_controller.noLetterSelected()>active</#if>">
            <a id="funnelback--people--az--browse--all"
                title="Browse all results"
                href="?collection=${question.collection.id}&amp;profile=${question.profile}&amp;query=${question.query!}">
                all
            </a>
        </li>

        <#list alphabet as letter>
            <#if people_controller.getLetterCount(letter) gt 0>
                <li class="<#if people_controller.isLetterSelected(letter)>active</#if>">
                    <a id="funnelback--people--az--browse--${letter}" 
                        title="Browse by letter: '${letter})" 
                        href="?collection=${question.collection.id}&amp;profile=${question.profile}&amp;query=${question.query!}&amp;f.Initial${"|"?url}stencilsPeopleInitial=${letter}">
                            ${letter}
                    </a>
                </li>
            <#else>
                <li class="disabled"><a href="#" title="No results for '${letter}'">${letter}</a></li>
            </#if>

        </#list>
    </ul>
</#macro>

<!---
    Render the sorting drop down
-->
<#macro SortDropdown>
    <#-- SORT MODES -->
    <div class="dropdown pull-right">
        <a class="dropdown-toggle text-muted" data-toggle="dropdown" href="#" id="dropdown-sortmode" title="Sort">
            <small><span class="glyphicon glyphicon-sort"></span>&nbsp;Sort</small>
        </a>
        
        <ul class="dropdown-menu" role="menu" aria-labelledby="dropdown-sortmode">
            <#if people_controller.noLetterSelected()>
                <li role="menuitem" <#if !question.inputParameterMap["sort"]??>class="active"</#if>><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])}"><span class="glyphicon glyphicon-sort-by-attributes-alt"></span> Relevance</a></li>
            </#if>
            
            <#local sortModes = {
                "Last name (a-z)": "metastencilsPeopleLastName",
                "Last name (z-a)": "dmetastencilsPeopleLastName",
                "Department (a-z)": "metastencilsPeopleDepartment",
                "Department (z-a)": "dmetastencilsPeopleDepartment",
                "Location (a-z)": "metastencilsPeopleLocation",
                "Location (z-a)": "dmetastencilsPeopleLocation",
                "Position (a-z)": "metastencilsPeoplePosition",
                "Position (z-a)": "dmetastencilsPeoplePosition"
            } />
            
            <#list sortModes?keys as sortMode>
                <li role="menuitem" <#if question.inputParameterMap["sort"]! == sortModes[sortMode]>class="active"</#if>><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])}&sort=${sortModes[sortMode]}">${sortMode}</a></li>
            </#list>
        </ul>
    </div>

</#macro>

<#---
    Render the browser that's displayed on the initial form. Display the A-Z listing
    and a choice of facets
    
    @param facets Facets to displayed
    @param maxCategories Number of categories to display for each facet
-->
<#macro PeopleBrowser facets=["Department", "Location", "Position"] maxCategories=30>
    <@core_controller.AfterSearchOnly>
        <h1>Browse ${response.resultPacket.resultsSummary.totalMatching} people by:</h1>
                
        <div class="row">
            <div class="col-md-12 text-center">
                <h2>Surname</h2>
                <@AZList />
            </div>
        </div>
                
        <div class="row">                
            <@core_controller.Facets names=facets>
                <@core_controller.Facet>
                    <#-- Twitter Bootstrap page width is 12 columns -->
                    <div class="col-md-${12 / facets?size}">
                        <h2 class="text-center"><@core_controller.FacetLabel /></h2>
                        
                        <ul class="list list-unstyled">
                            <@core_controller.FacetCategories max=maxCategories>
                            
                                <@core_controller.FacetCategory>
                                    <li class="category"><a href="<@core_controller.FacetCategoryUrl />"><@core_controller.FacetCategoryLabel /></a> <span class="badge pull-right"><@core_controller.FacetCategoryCount /></span></li>
                                </@core_controller.FacetCategory>
                            </@core_controller.FacetCategories>
                        </ul>
                    </div>
                </@core_controller.Facet>
            </@core_controller.Facets>
        </div>
    </@core_controller.AfterSearchOnly>
</#macro>

<#---
    Render a single person result
-->
<#macro Result>

    <#local metaData = core_controller.result.metaData />

    <#local email = core_controller.result.metaData["stencilsPeopleEmail"]!>
    <#local phone = core_controller.result.metaData["stencilsPeoplePhone1"]!>
    <#local mobile = core_controller.result.metaData["stencilsPeoplePhone2"]!>

    <#local thumbnail = "resources/${question.collection.id}/no-thumbnail.png">
    <#if core_controller.result.metaData["stencilsPeopleThumbnail"]?? && core_controller.result.metaData["stencilsPeopleThumbnail"] != "empty">
        <#local thumbnail = core_controller.result.metaData["stencilsPeopleThumbnail"]>
    </#if>
  
    <li data-fb-result=${core_controller.result.indexUrl}">
        <div class="row">
            <div class="media">
                <div class="media-left">
                    <a href="${core_controller.result.clickTrackingUrl}">
                        <img class="media-object img-thumbnail" src="${thumbnail!}">
                    </a>
                </div>
                
                <div class="media-body">
                    <h4 class="media-heading">
                        <a href="${core_controller.result.clickTrackingUrl}" title="${core_controller.result.liveUrl}">
                            <@core_controller.boldicize><@PersonName
                                name=metaData["stencilsPeopleName"]!
                                title=metaData["stencilsPeopleTitle"]!
                                firstName=metaData["stencilsPeopleFirstName"]!
                                middleName=metaData["stencilsPeopleMiddleName"]!
                                lastName=metaData["stencilsPeopleLastName"]! /></@core_controller.boldicize>
                        </a>
                    </h4>
                    
                    <cite class="text-success">
                        <@core_controller.boldicize>${core_controller.result.metaData["stencilsPeoplePosition"]!}</@core_controller.boldicize>
                    </cite>
                    <#if metaData["stencilsPeopleDepartment"]!?has_content>
                        &mdash; <span class="text-muted"><a href="?collection=${question.collection.id}&amp;profile=${question.profile}&amp;f.Department${"|"?url}stencilsPeopleDepartment=${metaData["stencilsPeopleDepartment"]?url}">${metaData["stencilsPeopleDepartment"]}</a></span>
                    </#if>
                
                    <dl class="dl-horizontal text-muted">
                        <#if email?has_content><dt><span class="glyphicon glyphicon-envelope" title="Email"></span></dt><dd><a href="mailto:${email!}">${email!}</a></dd></#if>
                        <#if phone?has_content && phone != "N/A"><dt><span class="glyphicon glyphicon-phone-alt" title="Phone"></span></dt><dd>${phone!}</dd></#if>
                        <#if mobile?has_content && mobile != "N/A"><dt><span class="glyphicon glyphicon-phone" title="Mobile"></span></dt><dd>${mobile!}</dd></#if>
                        
                        <dt><span class="glyphicon glyphicon-map-marker" title="Address"></span></dt>
                        <dd>
                            ${core_controller.result.metaData["stencilsPeopleLocation1"]!}, 
                            ${core_controller.result.metaData["stencilsPeopleLocation2"]!} ${core_controller.result.metaData["stencilsPeopleLocation3"]!}
                        </dd>
                    </dl>
                
                    <div class="funnelback--people--more"><#noescape><@core_controller.boldicize>${core_controller.result.metaData["stencilsPeopleSummary"]!}</@core_controller.boldicize></#noescape></div>
                    <div class="text-muted funnelback--people--more"><#noescape><@core_controller.boldicize>${core_controller.result.metaData["stencilsPeopleSkills"]!}</@core_controller.boldicize></#noescape></div>
                </div>

            </div>
        </div>
    </li>

</#macro>

<#---
    Format a person name from all the fields constituting it
    
    @param name Full person name, will be returned as is if present
    @param title Person's title
    @param firstName Person's first name
    @param middleName Person's middle name
    @param lastName Person's last name
    
    @return formatted person name
-->
<#macro PersonName name="" title="" firstName="" middleName="" lastName=""><#compress>
    <#if name?has_content>
        ${name}
    <#else>
        ${[title, firstName, middleName, lastName]?join(" ")}
    </#if>
</#compress></#macro>

</#escape>
