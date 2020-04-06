# Custom Gather Scripts

## Instagram Custom Gather

This custom gather script uses the Instagram Basic Display API to gather posts from a user's own account. 

### Usage

In a `custom` collection, copy the `InstagramCustomGather.groovy` script into the collection directory as a `custom_gather.groovy` file, and configure the collection as described below.

Additionally, the Instagram API endpoint produced a JSON response, which must be converted into XML to index in Funnelback.

See [JSON to XML filter](https://docs.funnelback.com/develop/programming-options/document-filtering/builtin-filters-JSONToXML.html).

### Configuration

The following collection configuration options must/can be configured.

| Configuration Key                    | Mandatory? |
| ------------------------------------ | ---------- |
| stencils.instagram.user-access-token | yes        |
| stencils.instagram.media-fields      | no         |

The default value of the `stencils.instagram.media-fields` configuration option is `media_type,media_url,timestamp,caption,permalink,thumbnail_url`

### User Access Token

The Instagram [User Token Generator](https://developers.facebook.com/docs/instagram-basic-display-api/overview#user-token-generator) can be used to generate a User Access Token. By using this method, the app within the Facebook developer portal does not need elevated permissions or require going through App Review to use the Basic Display API to read its own data.

NOTE: This script currently can only process one User Access Token. The script could be extended in the future to take a comma-separated list of User Access Token.

### Sample Output

A sample record produced by the API using the default media fields is:

```json
{
    "media_type": "IMAGE|VIDEO|CAROUSEL_ALBUM",
    "caption": "...",
    "id": 12345,
    "permalink": "https:// ...",
    "media_url": "https:// ...",
    "thumbnail_url": "https:// ...", // VIDEO only
    "timestamp": "2020-03-02T17:27:30" // ISO 8601
}
```

After conversion to XML with the JSONToXML filter, the record appears as:

```xml
<?xml version="1.0" encoding="utf-8"?>
<json>
   <media_type>IMAGE|VIDEO|CAROUSEL_ALBUM</media_type>
   <caption>...</caption>
   <id>...number...</id>
   <permalink>...URL...</permalink>
   <media_url>...URL...</media_url>
   <thumbnail_url>...URL (VIDEO only)...</thumbnail_url>
   <timestamp>...ISO 8601...</timestamp>
</json>
```