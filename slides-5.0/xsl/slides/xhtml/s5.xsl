<?xml version="1.0" encoding="ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:dbs="http://docbook.org/ns/docbook-slides"
		exclude-result-prefixes="dbs db"
		version="1.0">

<xsl:import href="../../xhtml/chunk.xsl"/>
<xsl:import href="plain.xsl"/>

<xsl:param name="wrap.slidecontent">0</xsl:param>

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

<!-- paths for S5-related files -->
<xsl:param name="s5.path.prefix">http://meyerweb.com/eric/tools/s5/</xsl:param>
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

  <link rel="stylesheet" href="{concat($s5.path.prefix, $s5.path.slides.css)}" type="text/css" media="projection" id="slideProj" />
  <link rel="stylesheet" href="{concat($s5.path.prefix, $s5.path.outline.css)}" type="text/css" media="screen" id="outlineStyle" />
  <link rel="stylesheet" href="{concat($s5.path.prefix, $s5.path.print.css)}" type="text/css" media="print" id="slidePrint" />
  <link rel="stylesheet" href="{concat($s5.path.prefix, $s5.path.opera.css)}" type="text/css" media="projection" id="operaFix" />

  <script src="{concat($s5.path.prefix, $s5.path.slides.js)}" type="text/javascript"></script>
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

<xsl:template match="db:xref">
  <xsl:variable name="target" select="id(./@linkend)"/>

  <xsl:choose>
    <xsl:when test="($target[self::dbs:foil] or $target[self::dbs:foilgroup])">
      <xsl:variable name="target.no" select="count(preceding::dbs:foil|preceding::dbs:foilgroup) + 1"/>

      <xsl:apply-templates select="$target" mode="xref-to"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template select="." name="xref"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:biblioentry" mode="xref-to">
  <xsl:variable name="id" select="@xml:id"/>

  <xsl:choose>
    <xsl:when test="$bibliography.numbered != 0">
      <xsl:number from="db:bibliography" count="db:biblioentry|db:bibliomixed" level="any" format="1"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$id"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
