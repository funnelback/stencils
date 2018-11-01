# HTML document date drop filter

The Date Drop filter is used to filter out documents that are older than a configured date. It is especially useful
when the URLs of the documents don't contain the date itself, making it difficult to exclude these from being
crawled (For example https://example.org/2005/document.html is easy to exclude via the crawler exclude patterns).

This filter runs a configured Jsoup selector on the document, extracts a date, and checks it against the retention
period. If it's too old, the filter drops the document and it does not get stored nor indexed.

The Jsoup selector can be used to locate the date from any part of the document:

- META tag: `<meta name="created_date" content="2005-10-12">`: Use `meta[name=created_date]` and set the attribute to extract to `content`
- Tag content: `<span class="date">October 12th, 2015</span>`: Use `span.date`
- Tag attributes: `<span data-date="12/10/2005">...</span>`: Use `span[data-date]` and set the attribute to extract to `data-date`

## Configuration 

Add the filter to the filter classes:

```
filter.classes=...:com.funnelback.stencils.filter.date.HTMLDateDropFilter
```

Set the date range to keep in `collection.cfg`, as well as the Jsoup selector, attribute and expected date format to
parse:

```
stencils.filter.date.drop.jsoup_selector=meta[name=created_date]
# Attribute is optional if the date is the content of the selected tag
stencils.filter.date.drop.jsoup_selector.attribute=content
stencils.filter.date.drop.document_date_format=yyyy-MM-dd
# Keep documents that are newer than 1 year
stencils.filter.date.drop.unit=YEARS
stencils.filter.date.drop.amount=1
```

The date format needs to be a valid [DateTimeFormatter](https://docs.oracle.com/javase/8/docs/api/java/time/format/DateTimeFormatter.html) pattern string.

The time unit needs to be a valid [ChronoUnit](https://docs.oracle.com/javase/8/docs/api/java/time/temporal/ChronoUnit.html).
Typical units will be MONTHS, YEAR, WEEKS and DAYS.

