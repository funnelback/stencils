# Social Media Date Filter

The Social Media Date Filter is used to filter out social media posts that are too old. Old posts are usually not
relevant and count towards the license limit. This is especially useful for Tweets were they may be thousands of
old, non-useful Tweets sitting in the index.

**Note:** At the time of writing the filter only support Twitter collections. It should be relatively easy to add
support for other platforms like Facebook or YouTube.

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

The time unit needs to be a valid [https://docs.oracle.com/javase/8/docs/api/java/time/temporal/ChronoUnit.html](ChronoUnit).
Typical units will be MONTHS, YEAR, WEEKS and DAYS.