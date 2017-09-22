# Title prefix / suffix cleaner

The title prefix / suffix cleaner is used to remove SEO-style prefixes and
suffixes from document titles.  For example with a page titled "Products |
Funnelback", it's usually desirable to remove the "| Funnelback" part as it's
used on every page.

This is often done at query time via hook scripts, but it's preferable to do it
in a filter:
* Prevent issues with prefixes and title sort, when the title is removed from
 display but the sort still happens on the prefixed title
* Avoid ranking bias by having words repeated on every page title
* Prevent easy typos / error in hook scripts that cause the whole script to fail

## Configuration

Add the filter to the JSoup filter classes:

```
filter.jsoup.classes=ContentGeneratorUrlDetection,...,com.funnelback.stencils.filter.title.TitlePrefixSuffixCleaner
```

The prefix / suffix to remove is configured via `collection.cfg`:

```
stencils.filter.title.strip-prefix=Funnelback \|
stencils.filter.title.strip-suffix= \| Funnelback
```

The filter supports stripping both prefixes and suffixes, or only one or the
other depending on the configuration. To not strip prefixes for example, do not
configure a pattern in `collection.cfg`. 

The prefix / suffix is a regular expression, so escaping is needed for special
characters like `|`.

An example of a more lenient pattern to deal with arbitrary spaces:

```
stencils.filter.title.strip-prefix=Funnelback\s*\|\s*
stencils.filter.title.strip-suffix=\s*\|\s*Funnelback
```

