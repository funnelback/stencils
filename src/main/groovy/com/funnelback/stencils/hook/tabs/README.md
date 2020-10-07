# Pre-select a tab by default

The tab hook can be used to pre-select a tab by default, either when there is no "All results" tab,
or when the default tab should not be "All results".

## Usage

Call the Stencils hook in your `hook_pre_process.groovy` script, and configure the tab to pre-select in
`collection.cfg`:

```
stencils.tabs.default=Courses
```
