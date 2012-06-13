<?xml version="1.0" encoding="ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:dbs="http://docbook.org/ns/docbook-slides"
		exclude-result-prefixes="dbs db"
		version="1.0">

<xsl:import href="../../xhtml/chunk.xsl"/>
<xsl:import href="plain.xsl"/>

<!-- XXX: recommended by S5 but DocBook XSL produces XHTML Transitional

<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
-->

<!-- presentation mode: slideshow or outline -->
<xsl:param name="s5.defaultview">slideshow</xsl:param>

<!-- nav controls: hidden or visible -->
<xsl:param name="s5.controls">hidden</xsl:param>

<!-- whether to generate pubdate in the footer -->
<xsl:param name="s5.generate.pubdate">1</xsl:param>

<!-- whether lists are incremental: all, default (dbs:incremental), no -->
<xsl:param name="s5.incremental.lists">default</xsl:param>

<!-- paths for S5-related files -->
<xsl:param name="s5.path.slides.css">ui/default/slides.css</xsl:param>
<xsl:param name="s5.path.outline.css">ui/default/outline.css</xsl:param>
<xsl:param name="s5.path.print.css">ui/default/print.css</xsl:param>
<xsl:param name="s5.path.opera.css">ui/default/opera.css</xsl:param>
<xsl:param name="s5.path.slides.js">ui/default/slides.js</xsl:param>

<!-- Main content starts here -->

<xsl:template name="xhtml.head">
  <meta name="generator" content="DocBook Slides Stylesheets V{$VERSION}"/>
  <meta name="version" content="S5 1.1"/>
  <meta name="defaultView" content="{$s5.defaultview}"/>
  <meta name="controlVis" content="{$s5.controls}"/>

  <link rel="stylesheet" href="{$s5.path.slides.css}" type="text/css" media="projection" id="slideProj" />
  <link rel="stylesheet" href="{$s5.path.outline.css}" type="text/css" media="screen" id="outlineStyle" />
  <link rel="stylesheet" href="{$s5.path.print.css}" type="text/css" media="print" id="slidePrint" />
  <link rel="stylesheet" href="{$s5.path.opera.css}" type="text/css" media="projection" id="operaFix" />

  <script src="{$s5.path.slides.js}" type="text/javascript"></script>
</xsl:template>

<xsl:template name="slideshow.head">
  <div class="layout">
    <div id="controls"/>
    <div id="currentSlide"/>
    <div id="header">
      <xsl:apply-templates select="/" mode="slide.header.mode"/>
    </div>
    <div id="footer">
      <xsl:apply-templates select="/" mode="slide.footer.mode"/>
    </div>
  </div>
</xsl:template>

<xsl:template name="slide.copyright">
  <div class="copyright">
    <xsl:text>Copyright &#xa9; </xsl:text>
    <xsl:value-of select="/dbs:slides/db:info/db:copyright/db:year"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="/dbs:slides/db:info/db:copyright/db:holder"/>
  </div>
</xsl:template>

<xsl:template name="slide.pubdate">
  <div class="pubdate">
    <xsl:text>Published on </xsl:text>
    <xsl:value-of select="/dbs:slides/db:info/db:pubdate"/>
  </div>
</xsl:template>

<xsl:template match="db:itemizedlist">
  <ul>
    <xsl:if test="($s5.incremental.lists = 'all') or (($s5.incremental.lists = 'default') and (ancestor-or-self::*/@incremental[1] = '1'))">
      <xsl:attribute name="class">incremental</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="*"/>
  </ul>
</xsl:template>

<xsl:template match="db:orderedlist">
  <ul>
    <xsl:if test="($s5.incremental.lists = 'all') or (($s5.incremental.lists = 'default') and (ancestor-or-self::*/@incremental[1] = '1'))">
      <xsl:attribute name="class">incremental</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="*"/>
  </ul>
</xsl:template>

<xsl:template match="/" mode="slide.footer.mode">
  <xsl:if test="/dbs:slides/db:info/db:copyright">
    <xsl:call-template name="slide.copyright"/>
  </xsl:if>
  <xsl:if test="$s5.generate.pubdate and /dbs:slides/db:info/db:pubdate">
    <xsl:call-template name="slide.pubdate"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
