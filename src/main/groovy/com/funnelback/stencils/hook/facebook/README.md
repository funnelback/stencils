# Facebook Stencil Public UI Hooks

The Facebook Stencil augments the data model with Facebook specific data, depending on the result type (post, event, page).

Augmented data is placed inside the `customData` map for each result. See the code for details, or the JSON endpoint of the Facebook Stencil demo collection.

 It relies on specific metadata mappings (See the code, or the demo Facebook Stencil collection configuration).

## Configuration

Set `stencils=facebook` in `collection.cfg`.

### Metadata mapping

The Facebook Stencil relies on specific metadata mappings:

* `stencilsFacebookType`: Facebook content type (post, page, event)
* `stencilsFacebookPostUserID`: Facebook ID of the post author
* `stencilsFacebookPageID`: Facebook ID of the page
* `stencilsFacebookEventUserID`: Facebook ID of the event organizer
* `stencilsFacebookEventStartDateTime`: Event start date+time
* `stencilsFacebookEventEndDateTime`: Event end date+time

### Accessing the augmented data

Augmented data is access like any other data model node in FreeMarker:

```
<img src="${result.customData["stencilsFacebookPageImageUrl"]!}">
```