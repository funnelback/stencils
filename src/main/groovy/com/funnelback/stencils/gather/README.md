# Funnelback Custom Gather Scripts

## SFTP Server Gather

This script allows Funnelback to gather a file from an SFTP server using a custom gathering collection.

### Usage

1. Create a 'custom' type data gathering collection in Funnelback
2. Upload the `SFTPGather.groovy` file from this item to the collection as `custom_gather.groovy`
3. Configure the gather settings as described below.

### Configuration

| Configuration Key      | Required? | Description                                                   |
| ---------------------- | --------- | ------------------------------------------------------------- |
| sftp.gather.hostname   | Yes       | Hostname of the FTP server.                                   |
| sftp.gather.username   | Yes       | Username to authenticate with                                 |
| sftp.gather.password   | Yes       | Password to authenticate with                                 |
| sftp.gather.file       | Yes       | Full filepath of the document to gather                       |
| sftp.gather.use_store  | No        | 'false' to not use the Funnelback record store (see 1. below) |
| sftp.gather.stored_url | No        | URL to save the gathered document with (see 2. below)         |

1. By default, the Funnelback record store is used to store the gathered file, which allows filtering and some other features of Funnelback to be used on the data. If the file to gather is a plain XML file, the store can be skipped and the indexer will just index the raw XML file.
2. Funnelback requires all indexed documents to have a URL. If the document will be split later (for example, a JSON file converted to XML then split along an X-Path), each record would get its own URL later and thus this URL of the overall document doesn't matter. If not supplied, a dummy URL will be used.

### Limitations

The custom gather is not currently written to "crawl" or recursively walk an FTP server, it is meant to gather a specific file. This functionality could be added in the future, but note there would be concerns with making sure that the client limits the Funnelback user of the FTP server to only the areas that it should gather.

### Version Note

This custom gather script has been used on Funnelback versions 15.20+ but may be compatible with older versions.

