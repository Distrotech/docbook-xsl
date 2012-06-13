<?xml version="1.0" encoding="ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:dbs="http://docbook.org/ns/docbook-slides"
		exclude-result-prefixes="dbs db"
		version="1.0">

<xsl:import href="s5.xsl"/>

<xsl:template name="xhtml.head">
<!--  <meta name="generator" content="S5" />
  <meta name="version" content="S5 1.1" />
  <meta name="presdate" content="20050728" />
  <meta name="author" content="Eric A. Meyer" />
  <meta name="company" content="Complex Spiral Consulting" />
-->

  <link rel="stylesheet" href="http://www.w3.org/Talks/Tools/Slidy2/styles/slidy.css" type="text/css"/>
  <link rel="stylesheet" href="http://www.w3.org/Talks/Tools/Slidy2/styles/w3c-blue.css" type="text/css"/>
  <script src="http://www.w3.org/Talks/Tools/Slidy2/scripts/slidy.js" charset="utf-8" type="text/javascript"/>
</xsl:template>

<xsl:template name="slideshow.head">
  <div class="background"> 
    <img id="head-icon" alt="graphic with four colored squares"
      src="http://www.w3.org/Talks/Tools/Slidy2/graphics/icon-blue.png" /> 
    <object id="head-logo" title="W3C logo" type="image/svg+xml"
      data="http://www.w3.org/Talks/Tools/Slidy2/graphics/w3c-logo-white.svg">
	<img src="http://www.w3.org/Talks/Tools/Slidy2/graphics/w3c-logo-white.gif" 
	  alt="W3C logo" id="head-logo-fallback"/>
    </object>
  </div>

  <div class="copyright">
    <xsl:apply-templates select="/" mode="slide.footer.mode"/>
  </div>

  <div class="slide cover title">
    <xsl:apply-templates select="/dbs:slides/db:info"/>
  </div>
</xsl:template>

<xsl:template name="slideshow.content">
  <div class="slide">
    <xsl:apply-templates select="/dbs:slides/db:info"/>
  </div>

  <xsl:apply-templates select="/dbs:slides/dbs:foil|dbs:slides/dbs:foilgroup"/>
</xsl:template>

</xsl:stylesheet>
