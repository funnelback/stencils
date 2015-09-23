<!--
Simple translation: padre XML -> RSS (2.0)

WARNING:
	- required a string parameter 'now' containing the current
	  date & time in RFC 822 format.

TODO:
- "publication" dates for individual <item>s
- handle browser's 'if-modified-since' param (query time?)
-->

<xsl:transform
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times"
        version="1.0"
>
<xsl:template match="text()|@*" />

<xsl:template match="results">
<rss version="2.0"><channel>
<title><xsl:value-of select="$title"/></title>
<link><xsl:value-of select="$site"/></link>
<pubDate><xsl:value-of select="$now"/></pubDate>
<generator>Funnelback</generator>
<xsl:apply-templates />
</channel></rss>
</xsl:template>

<xsl:template match="result">
<item>
<xsl:apply-templates />
</item>
</xsl:template>

<xsl:template match="title">
<title>
<xsl:value-of select="."/>
</title>
</xsl:template>

<xsl:template match="summary">
<description>
<xsl:value-of select="."/>
</description>
</xsl:template>

<xsl:template match="live_url">
<link><xsl:value-of select="."/></link>
</xsl:template>

</xsl:transform>

<!--
$Id: rss.xsl.dist 10218 2007-08-24 03:46:43Z gbills $
-->
