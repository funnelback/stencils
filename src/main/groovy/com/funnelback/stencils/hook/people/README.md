# People Stencil Public UI Hooks

The People Stencil provides support for searching for staff results as well as browsing a directory by letter, department or position.

## Configuration

Set `stencils=people` in `collection.cfg`.

This will cause a `!padrenullquery` to be injected into the question if there is no query. This is used when browsing the directory without the user having to enter a query.