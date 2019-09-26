# Enable extra searches on a per tab basis

The extra search hook can be used to enable or disable extra searches 
based on the the selected tab.  

## Usage

Call the Stencils hook in your `hook_extra_searches.groovy` script, and configure which extra searches should run on each tab in the `collection.cfg`.

### Format
```
stencils.tabs.extra_searches.<tab display label>=<extra search name 1>,<extra search name 2>
```

_Note: By default, all extra searches are enabled for a tab if no configurations is specified._

### Examples
Given a search implementation has the following:

* 4 tabs; All results, Courses, Events, Social media
* 3 extra searches; twitter, events, courses

#### Enable extra searches on the "All results" tab but hide it for all other tabs 
```
stencils.tabs.extra_searches.Courses=
stencils.tabs.extra_searches.Events=
stencils.tabs.extra_searches.Social media=
```

#### Disable twitter extra search results on all tabs except the "All results"   
```
# stencils.tabs.extra_searches.Courses=twitter,events,courses // This is not explicitly required as by default, all extra searches will run
stencils.tabs.extra_searches.Courses=events,courses
stencils.tabs.extra_searches.Events=events,courses
stencils.tabs.extra_searches.Social media=events,courses
```

#### Only show twitter extra search results on the All results tab and events extra saerch on other tabs 
```
stencils.tabs.extra_searches.Courses=twitter
stencils.tabs.extra_searches.Courses=events
stencils.tabs.extra_searches.Events=events
stencils.tabs.extra_searches.Social media=events
```