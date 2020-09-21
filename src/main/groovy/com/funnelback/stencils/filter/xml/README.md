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

Instead, the description field should be mapped as an [inner HTML document](https://docs.funnelback.com/15.24/customise/standard-options/xml-documents.html#inner-html-or-xml-documents), which can be configured within the collection's XML processing settings.

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

# XML Filter Notes

These filters will only apply to XML documents, but can be used with JSON too
by converting the JSON to XML with the built-in filters:

```
filter.classes=ForceJSONMime:JSONToXML:ForceXMLMime:com.funnelback.stencils.filter.xml.XmlElementHtmlWrapperFilter
```
