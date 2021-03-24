# Social Media Date Filter

The Social Media Date Filter is used to filter out social media posts that are too old. Old posts are usually not
relevant and count towards the license limit. This is especially useful for Tweets where there may be thousands of
old, non-useful Tweets sitting in the index.

**Note:** At the time of writing the filter supports Twitter, Facebook, and Instagram collections. Support for other platforms, such as Youtube can be added on an as-needed basis.

## Configuration

Add the filter to the filter classes:

```
filter.classes=...:com.funnelback.stencils.filter.social.SocialDateFilter
```

The date range to keep is configured in `collection.cfg`:

```
# Keep Tweets that are newer than 1 year
stencils.filter.social.drop.amount=1
stencils.filter.social.drop.unit=YEARS
```

The time unit needs to be a valid [ChronoUnit](https://docs.oracle.com/javase/8/docs/api/java/time/temporal/ChronoUnit.html).
Typical units will be MONTHS, YEAR, WEEKS and DAYS.

### Instagram Specific Configuration

Using this filter for Instagram requires an additional configuration parameter.
```
stencils.filter.social.drop.record_type=instagram
```

When adding this filter to `filter.classes`, add it after converting the record from JSON to XML, e.g.
```
filter.classes=ForceJSONMime:JSONToXML:com.funnelback.stencils.filter.social.SocialDateFilter
```
