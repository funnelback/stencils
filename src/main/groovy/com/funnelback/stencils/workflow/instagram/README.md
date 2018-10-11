# Instagram Gather Helper

This package contains a helper class to gather Instagram posts.

Each account to crawl requires an API token, to be generated manually (See relevant Funnelback Community article about
social media API keys). The tokens are then put in `collection.cfg`, and the Instagram Gather class is called from
the Custom collection gather Groovy script.

The crawler produces JSON, so the JSON to XML filter must be used.

## Usage

Retrieve API tokens for all the accounts you want to crawl and put them in `collection.cfg`. Also add the JSON to
XML filter:

```
filter.classes=JSONToXML:ForceXMLMime
stencils.instagram.access-tokens=token1,token2,token3,...
```

Edit `custom_gather.groovy`, and call the Instagram Gather class:

```
if (args.length < 2) {
    println 'Usage: script $SEARCH_HOME collection-name'
    return 1
}

new com.funnelback.stencils.workflow.instagram.InstagramGather(new File(args[0]), args[1]).gather()
``` 

## Gathered data and metadata mapping

The resulting XML for a post looks like this:

```xml
<?xml version="1.0" encoding="utf-8"?>
<json>
  <created_time>1416272390</created_time>
  <images>
    <thumbnail>
      <width>150</width>
      <url>https://scontent.cdninstagram.com/vp/35ad5ead14e46accda4f8a5b3db44243/5C6218BB/t51.2885-15/e15/s150x150/10809513_977023198980895_1296884175_n.jpg</url>
      <height>150</height>
    </thumbnail>
    <low_resolution>
      <width>320</width>
      <url>https://scontent.cdninstagram.com/vp/4050fc8d20631e4aaaa58d6e9f674751/5C54683F/t51.2885-15/e15/s320x320/10809513_977023198980895_1296884175_n.jpg</url>
      <height>320</height>
    </low_resolution>
    <standard_resolution>
      <width>640</width>
      <url>https://scontent.cdninstagram.com/vp/b3a0b18504be869a3ce075584ce455af/5C3D2CF5/t51.2885-15/e15/10809513_977023198980895_1296884175_n.jpg</url>
      <height>640</height>
    </standard_resolution>
  </images>
  <comments>
    <count>0</count>
  </comments>
  <user_has_liked>false</user_has_liked>
  <link>https://www.instagram.com/p/vhZci_jKBz/</link>
  <caption>
    <created_time>1416272390</created_time>
    <from>
      <full_name>De Anza College</full_name>
      <profile_picture>https://scontent.cdninstagram.com/vp/42098952af98fc3222589c37d08acdbd/5C545FA3/t51.2885-19/1739549_307815329417115_1514940059_a.jpg</profile_picture>
      <id>1508400807</id>
      <username>deanzacollege</username>
    </from>
    <id>17850591766048808</id>
    <text>Signs of #fall at #deanzacollege</text>
  </caption>
  <type>image</type>
  <tags>fall</tags>
  <tags>deanzacollege</tags>
  <created_time_iso>2014-11-18T00:59:50Z</created_time_iso>
  <filter>Normal</filter>
  <attribution>null</attribution>
  <location>null</location>
  <id>856077317058633843_1508400807</id>
  <user>
    <full_name>De Anza College</full_name>
    <profile_picture>https://scontent.cdninstagram.com/vp/42098952af98fc3222589c37d08acdbd/5C545FA3/t51.2885-19/1739549_307815329417115_1514940059_a.jpg</profile_picture>
    <id>1508400807</id>
    <username>deanzacollege</username>
  </user>
  <likes>
    <count>10</count>
  </likes>
</json>
```

Suggested XML mapping:

```
PADRE XML Mapping Version: 2
docurl,/json/link
I,0,,//low_resolution/url
c,1,,//caption/text
d,0,,//created_time_iso
a,0,,//user/full_name
stencilsInstagramUserProfilePicture,0,,//user/profile_picture
stencilsInstagramUserName,0,,//user/username
-,,,//DUMMY
```