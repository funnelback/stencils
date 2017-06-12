# No Results Stencil Public UI Hooks

The no results Stencil relies on an extra search to display results even if there are no documents returned by the main search.

These results are usually displayed under an "Have you tried?" heading.

## Configuration

Configure an extra search named `no_results`, which results should be displayed when there are no organic results.

`stencil.no_results.query=...` can be set to specify which query to use for the no-results extra search. If not set, default to a null query `!padrenullquery`.