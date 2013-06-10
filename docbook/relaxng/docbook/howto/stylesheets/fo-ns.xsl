<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:d="http://docbook.org/ns/docbook"
                exclude-result-prefixes="d"
                version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/fo/profile-docbook.xsl"/>

<xsl:param name="profile.status">final</xsl:param>

<xsl:param name="body.start.indent" select="'0pt'"/>
<xsl:param name="title.margin.left" select="'0pt'"/>

<xsl:attribute-set name="urilist">
  <xsl:attribute name="margin-left">0.5in</xsl:attribute>
</xsl:attribute-set>

<xsl:template name="article.titlepage">
  <fo:block text-align="left">
    <xsl:apply-templates select="d:info" mode="howto-titlepage"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:info" mode="howto-titlepage">
  <xsl:apply-templates select="d:title" mode="howto-titlepage"/>
  <xsl:apply-templates select="d:subtitle" mode="howto-titlepage"/>
  <xsl:apply-templates select="d:pubdate[1]" mode="howto-titlepage"/>
  <xsl:apply-templates select="d:pubdate[1]" mode="version-list"/>
  <xsl:apply-templates select="d:authorgroup" mode="howto-titlepage"/>
</xsl:template>

<xsl:template match="d:title" mode="howto-titlepage">
  <fo:block font-size="24pt" font-weight="bold" font-family="sans-serif"
	    margin-bottom="5pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="howto-titlepage">
  <fo:block font-size="18pt" font-weight="bold" font-family="sans-serif"
	    margin-bottom="5pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:pubdate" mode="howto-titlepage">
  <fo:block font-size="16pt" font-weight="bold" margin-bottom="15pt"
	    font-family="sans-serif">
    <xsl:call-template name="datetime.format">
      <xsl:with-param name="date" select="."/>
      <xsl:with-param name="format" select="'d B Y'"/>
    </xsl:call-template>
  </fo:block>
</xsl:template>

<xsl:template match="d:pubdate[1]" priority="10"
	      mode="version-list">
  <fo:block font-size="12pt" font-family="sans-serif">This version:</fo:block>

  <fo:block xsl:use-attribute-sets="urilist">
    <xsl:apply-templates select="." mode="datedURI"/>
  </fo:block>

  <fo:block font-size="12pt" font-family="sans-serif">Latest version:</fo:block>
  <fo:block xsl:use-attribute-sets="urilist">
    <fo:inline>http://docbook.org/docs/howto/</fo:inline>
  </fo:block>

  <xsl:if test="following-sibling::d:pubdate">
    <fo:block font-size="12pt" font-family="sans-serif">
      <xsl:text>Previous version</xsl:text>
      <xsl:if test="count(following-sibling::d:pubdate) &gt; 1">
	<xsl:text>s</xsl:text>
      </xsl:if>
      <xsl:text>:</xsl:text>
    </fo:block>
    <xsl:apply-templates
	select="following-sibling::d:pubdate"
	mode="version-list"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:pubdate" mode="version-list">
  <xsl:if test="count(preceding-sibling::d:pubdate) &lt; 4">
    <fo:block xsl:use-attribute-sets="urilist">
      <xsl:apply-templates select="." mode="datedURI"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:pubdate" mode="datedURI">
  <xsl:variable name="uri">
    <xsl:text>http://docbook.org/docs/howto/</xsl:text>
    <xsl:value-of select="substring(.,1,4)"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="substring(.,6,2)"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="substring(.,9,2)"/>
    <xsl:text>/</xsl:text>
  </xsl:variable>

  <fo:inline>
    <xsl:value-of select="$uri"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:authorgroup" mode="howto-titlepage">
  <fo:block font-size="12pt" font-family="sans-serif">
    <xsl:text>Author</xsl:text>
    <xsl:if test="count(d:author) &gt; 1">s</xsl:if>
    <xsl:if test="d:othercredit">
      <xsl:text> and other credited contributors</xsl:text>
    </xsl:if>
   <xsl:text>:</xsl:text>
  </fo:block>
  <xsl:apply-templates select="d:author|d:othercredit" mode="howto-titlepage"/>
</xsl:template>

<xsl:template match="d:author|d:othercredit" mode="howto-titlepage">
  <fo:block xsl:use-attribute-sets="urilist">
    <xsl:apply-templates select="d:personname"/>
    <xsl:if test="d:email">
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="d:email"/>
    </xsl:if>
    <xsl:if test="@otherclass">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="normalize-space(@otherclass)"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
 </fo:block>
</xsl:template>

<xsl:attribute-set name="monospace.properties">
  <xsl:attribute name="font-stretch">narrower</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="draft.watermark.image" select="''"/>

<xsl:param name="ulink.footnotes" select="1"/>

<xsl:template match="d:programlisting[@language]">
  <fo:block clear="left"/>
  <fo:float float="start">
    <fo:block width="0.4cm" text-align="end" font-family="Helvetica" font-size="7pt" font-weight="bold" 
              margin-left="-0.4cm">
      <xsl:if test="not(preceding-sibling::*[1]/self::d:programlisting)">
        <xsl:attribute name="margin-top">1.5em</xsl:attribute>
      </xsl:if>
      <fo:block-container reference-orientation="90" width="0.8cm">
        <fo:block color="white" background-color="#808080" text-align="center">
          <xsl:value-of select="translate(@language,'rngc','RNGC')"/>
        </fo:block>
      </fo:block-container>
    </fo:block>
  </fo:float>
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
