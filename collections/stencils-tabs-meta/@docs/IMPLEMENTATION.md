Implementation
=================

The Tab Stencil re-uses the faceted navigation system to create tabs. This is done by visually styling a set of facets as tabs or pills.

This page contains the steps required in order to implement the tabs stencil into a project.

# Dependencies

The following Stencils are required by this implementation and must be included in order for the Tab Stencils to function correctly:

* Core (which includes Base)

# Key Files

* [faceted_navigation.cfg] (faceted_navigation.cfg)
* [hook_post_datafetch.groovy] (hook_post_datafetch.groovy)
* [collection.cfg] (collection.cfg)
* [tabs.view.ftl] (/_default_preview/tabs.view.ftl)
* Extra search configuration files

# Configurations

In order to implement the tab stencil, please refer to the following:

## Facets

The Tab Stencil leverages the [faceted navigation system] (http://docs.funnelback.com/faceted_navigation.html) in order to create tabs. This allows tabs to be based of metadata or gscope provided that they are defined in [faceted_navigation.cfg] (faceted_navigation.cfg).

### Faceting by Collections

It is a common requirement that tabs are created for each component collection that makes up the wider [meta collection] (http://docs.funnelback.com/meta_collection.html). In order to achieve this, it is possible to:

* Inject metadata using [external metadata] (http://docs.funnelback.com/external_metadata.html) allowing each component collection to be tagged with its own unique name
* Inject [gscopes] (http://docs.funnelback.com/gscopes.html) allowing each each component collection to be tagged with its own unique gscope value

## Hook Scripts

The contents of the [hook_post_datafetch.groovy] (hook_post_datafetch.groovy) needs to be included as part of the project implementation which enables the Tab Stencil's specific configurations. These are described in the [Collection Configuration] (#collection-configurations) section.

## Collection Configurations

The next step is to enable the tab specific collection configurations which provides the ability to change the behaviour of the tabs. This is done by including the contents of [hook_post_datafetch.groovy] (hook_post_datafetch.groovy) which enables the following:

```ini
	stencils.tabs.full_facet.gscope=x
	stencils.tabs.full_facet.metadata.<metadata_class>.1=<value>
	stencils.tabs.full_facet.metadata.<metadata_class>.2=<value>
```

The above settings can be used to control the behaviour without the need to write any complicated [hook scripts] (http://docs.funnelback.com/user_interface_hook_scripts.html). Instructions on how to use the above settings can be found below:

### Gscope Facets

The following configuration can be used to force gscope facets to always appear even if they have no results for the current query.

```ini
	stencils.tabs.full_facet.gscope=<gscope number>
```

where

* ```gscope number``` - Comma (,) separated list of gscope values

e.g. To make facets based on gscope ```1```,```2```,```3``` and ```4``` always appear even if they have zero results, use the following:

```ini
	stencils.tabs.full_facet.gscope=1,2,3,4
```

### Metadata Facets

The following configuration can be used to force metadata facets to always appear even if they have no results for the current query.

```ini
	stencils.tabs.full_facet.metadata.<metadata class>.1=<value>
	stencils.tabs.full_facet.metadata.<metadata class>.2=<value>
```

where

* ```metadata class``` - The class used to generate the facet
* ```value``` - The value of the facet category

e.g To make facets derived from the metadata class "tabs" and with the category value *web* or *courses* always appear even if they have 0 results

```ini
	stencils.tabs.full_facet.metadata.tabs.1=web
	stencils.tabs.full_facet.metadata.tabs.2=courses
```

# Freemarker Template

After the facets for the tabs have been setup and configured, they tabs can by styled. The [project.view.ftl](default_preview/project.view.ftl) contains various sample implementation of the markups required in order to implement tabs and tab previews.

Snippets have been provided below for convenience:

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

Tab preview provides the user the ability to view a small subset of results from another tab. This is completed through the use of [extra searches] (http://docs.funnelback.com/ui_modern_extra_searches_collection_cfg.html).

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