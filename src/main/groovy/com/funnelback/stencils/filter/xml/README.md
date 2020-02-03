# XML element HTML wrapper

The XML element HTML wrapper is used to wrap specific XML elements in `<html>...</html>`
tags, so that they can be indexed by PADRE as inner HTML documents. This is useful
when an XML or JSON feed provided by a client contains nested HTML.

For example:

```xml
<root>
  <title>Biology</title>
  <description>This course is about &lt;strong&gt;biology&lt;/strong&gt; and other things</description>
</root>
```

If `description` is mapped as a regular metadata, the HTML content `...<strong>biology</strong>...`
will not be parsed and the `strong` word will appear in results summary.

Instead, it should be mapped as an inner document:

```
+,,,//description
```

However PADRE will still not parse the content as HTML unless the document is
considered to be HTML, meaning it needs to be insider `<html>...</html>` tags.

This filter is used to wrap such an XML element in HTML tags.

## Configuration

Add the filter to the filter classes:

```
filter.classes=...:com.funnelback.stencils.filter.xml.XmlElementHtmlWrapperFilter
```

The specific XML element to wrap in HTML is configured via `collection.cfg`:

```
stencils.filter.xml.html_wrapper.xpath=//description
```

# XML Document Splitter

The XML Document Splitter filter will split an XML document into separate records along a configured [X-Path](https://en.wikipedia.org/wiki/XPath).

The Funnelback indexer has the ability to split XML documents by X-Path, this filter is necessary if the documents are to be used later in XSLT processing, where HTML can be generated from each XML record. If the indexer splitter is used, the XML will be saved as a single document in the cache and therefore cannot be processed as individual records for XSLT.

This filter may also be desirable to use in combination with another filter that can drop records based on some value. For example, an RSS feed for a calendar may contain events that occurred in the past. If these events should not be shown in the search results, the file can be split using this filter and then another filter can be used to drop events which have occurred in the past.

## Configuration

Add the filter to the filter classes:

```
filter.classes=...:com.funnelback.stencils.filter.xml.XmlDocumentSplitter
```

The element to split on is configured in `collection.cfg`:
```
stencils.filter.xml.split_by_xpath=/xpath
```

Optionally, an element in the split XML can be assigned as the URL of the document. This is optional because the URL of the split document can also be configured in the 'XML Processing' section of the Funnelback Administration interface.

```
stencils.filter.xml.url_node=/xpath
```

## Example

The following XML document can be split by this filter into three records, which are then saved as three separate XML documents in the Funnelback cache that can be processed using XSLT.

```xml
<products>
  <product>
    <name>Braided 4K HDMI to HDMI Cable 3-Foot</name>
    <price>5.94</price>
    <image_url>https://www.example.com/products/images/hdmi-3foot</image_url>
    <url>https://www.example.com/products/hdmi-3foot</url>
    <description>Meets the latest HDMI standards (4K video at 60 Hz, 2160p, 48 bit/px color depth); supports bandwidth up to 18 Gbps; backwards compatible with earlier versions</description>
  </product>
  <product>
    <name>USB 2.0 Printer Type Cable 16-Feet</name>
    <price>6.44</price>
    <image_url>https://www.example.com/products/images/usb-a-b-16foot</image_url>
    <url>https://www.example.com/products/usb-a-b-16foot</url>
    <description>One 16-foot-long high-speed multi-shielded USB 2.0 A-Male to B-Male cable. Connects mice, keyboards, and speed-critical devices, such as external hard drives, printers, and cameras to your computer</description>
  </product>
  <product>
    <name>USB 3.0 Cable, Type A to Type A, 16-Feet</name>
    <price>5.99</price>
    <image_url>https://www.example.com/products/images/usb-a-a-16foot</image_url>
    <url>https://www.example.com/products/usb-a-a-16foot</url>
    <description>USB 3.0 A Extension. High performance USB 3.0 Male to Male cable connects USB host computers with USB 3.0 type A port to USB peripherals</description>
  </product>
</products>
```

The configuration for this example would be:

```
stencils.filter.xml.split_by_xpath=/products/product
stencils.filter.xml.url_node=/product/url
```

Note that the root of the url_node configuration is the root of the split document, not the original full document.

Relative X-Paths can also be used if field names are not duplicated. Relative paths for this example would be:
```
stencils.filter.xml.split_by_xpath=//product
stencils.filter.xml.url_node=//url
```

# XML Filter Notes

These filters will only apply to XML documents, but can be used with JSON too
by converting the JSON to XML with the built-in filters:

```
filter.classes=ForceJSONMime:JSONToXML:ForceXMLMime:com.funnelback.stencils.filter.xml.XmlElementHtmlWrapperFilter
```