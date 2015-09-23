Implementation - Getting Started
=================

The tab stencil uses the faceted navigation system to create tabs by visually styling a set of facets using tab / pill markup.

This page contains the steps required in order to implement the tabs stencil into a project. 

# Files Required / Affected / Key Files

* [collection.cfg] (collection.cfg)
* [faceted_navigation.cfg] (faceted_navigation.cfg)
* [hook_post_datafetch.groovy] (hook_post_datafetch.groovy)
* [tabs.view.ftl] (/_default_preview/tabs.view.ftl)
* ExtraSearch files

# Configurations

In order to implement the tab stencil, please refer to the following:

## Facets

The tab stencil leverages the faceted navigation system in order to create the tabs. What this means that metadata or gscope based facet defined in [faceted_navigation.cfg] (faceted_navigation.cfg) can used as tabs. 

### Meta collections

It is common requirement that tabs are added for each component collection. In order to achieve this, it is best to either inject meta data using external_metadata.cfg or gscope.cfg within each component collection. 

<insert example here>

## Hook Scripts

The content's of the [hook_post_datafetch.groovy] (hook_post_datafetch.groovy) needs to be included as part of the collection as it will enable the custom collection config described in the following section.

<insert explanation here around any edge cases>

## Collection Configurations

After including the contents of [hook_post_datafetch.groovy] (hook_post_datafetch.groovy), the following collection configuration settings are available:

```ini
	stencils.tabs.full_facet.gscope=x
	stencils.tabs.full_facet.metadata.<metadata class>.1=<value>
	stencils.tabs.full_facet.metadata.<metadata class>.2=<value>
```

Instructions on how to use the above settings can be found below:

### Gscope Based Facets
```ini
	stencils.tabs.full_facet.gscope=x
```

e.g. Facets based on gscope 1,2,3 and 4 will always appear even if they have 0 results
```ini
  stencils.tabs.full_facet.gscope=1,2,3,4
```

### Metadata Based Facets
```ini
	stencils.tabs.full_facet.metadata.<metadata class>.1=<value>
	stencils.tabs.full_facet.metadata.<metadata class>.2=<value>
```

e.g Facets under the category "tabs" with the value web or courses will always appear even if they have 0 results

```ini
  stencils.tabs.full_facet.metadata.tabs.1=web
  stencils.tabs.full_facet.metadata.tabs.2=courses      
```

# Freemarker Template

The [project.view.ftl](default_preview/project.view.ftl) contains various sample implementation of the markups required in order to implement tabs and tab previews. Snippets have been provided below for convenience: 

## Tabs

```html
<#-- Sample implementation of tabs which can be customised --> 
<#macro TabMenu>
  <!-- tabs.view.ftl :: TabMenu -->
	<@tabs_controller.TabSearch> 
		<div class="btn-group" data-input="pagetype">
		  <@tabs_controller.Tabs name="Tabs">
		  	<@tabs_controller.Tab>
          <button type="button" class="btn btn-default remove-outline <@tabs_controller.IsActive>active</@tabs_controller.IsActive> <@tabs_controller.IsDisabled>disabled</@tabs_controller.IsDisabled>">
  		      <a href="<@tabs_controller.Url />" alt="<@tabs_controller.Name />" title="<@tabs_controller.Name />">
              <@tabs_controller.Name /> <span class="text-muted"> (<@tabs_controller.Count />) </span>
  		      </a>
          </button>              
		    </@tabs_controller.Tab>
		  </@tabs_controller.Tabs>    
		</div>
	</@tabs_controller.TabSearch>
</#macro>
```

## Tab Preview

A sample snippet of the tab preview can be found below:

Taken from [project.view.ftl](default_preview/project.view.ftl) 
```html
<@tabs_view.TabPreview extraSearchName="current_docs" code="11" value="Current Docs" />
```

which calls the following in [tabs.view.ftl] (/_default_preview/tabs.view.ftl)

```html
<#-- Sample implementation of showing an extra search as a tab preview -->
<#macro TabPreview extraSearchName code value>
  <!-- tabs.view.ftl :: TabPreview -->
  <@tabs_controller.Preview extraSearchName=extraSearchName>
    <div class="well">         
      <h3>More results for '<strong>'<@s.QueryClean />'</strong> </h3>
      
      <#-- Display results for the extra search -->
      <@core_controller.Results />

      <#-- Provides a link which provides more results from the extra search -->
      <@tabs_controller.PreviewMoreLinkArea>
        <a href="<@tabs_controller.PreviewMoreLink code=code value=value />"> <span class="glyphicon glyphicon-plus"></span> More results from this collection</a>
      </@tabs_controller.PreviewMoreLinkArea>                   
    </div>
  </@tabs_controller.Preview>
</#macro>
```

*Please note that the above assumes that extra searches have been setup*