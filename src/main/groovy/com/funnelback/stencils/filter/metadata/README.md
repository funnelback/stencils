# Metadata Filters

## Extract Content Length

The Funnelback indexer converts the Content-Length HTTP header to an internal field for filesize, however that field is only 24-bit which means that any crawled documents larger than 16.7 MB have an incorrect file size.

This filter extracts the Content-Length into a custom metadata field to store as a String which prevents integer overflow. A formatted version of the filesize is also stored which represents the document size in a human-readable format.

### Configuration

Add the filter to the filter classes:

```
filter.classes=...:com.funnelback.stencils.filter.metadata.ExtractContentLength
```

This filter injects metadata **sources** of `custom-content-length` and `custom-content-length-formatted`. The former is the number of bytes in the document and the latter is a human readable version (i.e. '42 MB').

In the Metadata Mappings, map these two sources to new metadata classes so that the metadata is pulled into the data model.
