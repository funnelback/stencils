# Custom Gather Scripts

## Instagram Custom Gather

This custom gather script uses the Instagram Basic Display API to gather posts from a user's own account. 

### Usage

In a `custom` collection, create the `custom_gather.groovy` script as below.

```groovy
import com.funnelback.stencils.gather.InstagramCustomGather

File searchHome = new File(args[0])
String collection = args[1]
new InstagramCustomGather()
    .init(searchHome, collection)
    .refreshToken(searchHome, collection)
    .gather()
```

Additionally, the Instagram API endpoint produces a JSON response, which must be converted into XML to index in Funnelback.

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

User Access Tokens must be long-lived (valid for 60 days). This gather script programmatically refreshes the token before each use, which produces a new token valid for another 60 days.

NOTE: This script currently can only process one User Access Token. The script could be extended in the future to take a comma-separated list of User Access Tokens.

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

## SFTP Server Gather

This script allows Funnelback to gather a file from an SFTP server using a custom gathering collection.

### Usage

In a `custom` collection, create the `custom_gather.groovy` script as below.


```groovy
import com.funnelback.stencils.gather.SFTPCustomGather

File searchHome = new File(args[0])
String collection = args[1]
new SFTPCustomGather()
    .init(searchHome, collection)
    .gather()
```

Alternatively, the `SFTPCustomGather.groovy` can be uploaded directly as the collection's `custom_gather.groovy`.

### Configuration

| Configuration Key               | Required? | Description                                                   |
| ------------------------------- | --------- | ------------------------------------------------------------- |
| stencils.gather.sftp.hostname   | Yes       | Hostname of the FTP server.                                   |
| stencils.gather.sftp.username   | Yes       | Username to authenticate with                                 |
| stencils.gather.sftp.password   | Yes       | Password to authenticate with                                 |
| stencils.gather.sftp.file       | Yes       | Full filepath of the document to gather                       |
| stencils.gather.sftp.mime_type  | Yes       | Mime type for the gathered data (see 1. below)                |
| stencils.gather.sftp.stored_url | No        | URL to save the gathered document with (see 2. below)         |

1. Common MIME types are `text/xml` for XML, `application/json` for JSON, and `text/csv` for CSV
2. Funnelback requires all indexed documents to have a URL. If the document will be split later (for example, a JSON file converted to XML then split along an X-Path), each record would get its own URL later and thus this URL of the overall document doesn't matter. If not supplied, a dummy URL will be used.


### Limitations

The custom gather is not currently written to "crawl" or recursively walk an SFTP server, it is meant to gather a specific file. This functionality could be added in the future, but note there would be concerns with making sure that the client limits the Funnelback user of the SFTP server to only the areas that it should gather.

### Version Note

This custom gather script has been used on Funnelback versions 15.20+ but may be compatible with older versions.
