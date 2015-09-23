Functional Specification Snippets
=================

This page contains shorts snippets which can be fed into the functional specification document.

# Tabs
Tabs allows content to be divided/segmented based on a wide varierty of rules such as by audience, content type or even geography. It aims is to allow users to easily switch between contexts within the results with minimal effort.

The following describes the tabs which will be setup for this project:

| Tab Name | Description |
| ----------- | ------ |
| All Results | Show all results relating to the current query|
| Current Docs | Show only results from the Funnelback documentation site of the current Funnelback version|
| Funnelback Site | Show only results from the Funnelback web site |

The following describes the behaviour of the tabs:

* Counts - A approaximate count will be displayed against each tab to indicate the number of results which corresponds to the constaints of that tab
* Disabled tabs - Tabs which have no matching results will be disabled, in order to prevent users from encountering a "no results page".
* Always visible - Tabs will always be visible and in the same order regardless of how many results are being returned
* Query constrains between tabs - When users navigate between tabs, only their query will be maintained. Query parameters such as pagination, scope and selected facets will not be retained.

# Tab Previews

Funnelback has the capability to previews content from tabs. This provides an intuitive means to explore content by guiding them though potentially related results and minimises the need to "guess" what is on another tab.

The following describes the tab previews which will be setup for this project:

| Tab Name | Target Tab | Description |
| -------- | ---------- | ----------- |
| All Results | Current Docs | Provides a preview of the "current docs" tabs on the "all results" tab|


The following describes the behaviour of the tabs:

* Result display - The results will inherit the styling and functionality of the target tab. i.e. The tab previews of the "Current Doc" will has the same styling and functionality as the results which appear on the "Current Doc" tab.
* See more link - A link will be provided which will navigate the user to the corresponding tab. This will have the same behaviour as clicking on the corresponding tab.


