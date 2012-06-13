<?xml version="1.0" encoding="ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:dbs="http://docbook.org/ns/docbook-slides"
		exclude-result-prefixes="dbs db"
		version="1.0">

<xsl:import href="../../xhtml/chunk.xsl"/>

<!-- whether toc is generated for foilgroup -->
<xsl:param name="generate.foilgroup.toc">0</xsl:param>

<!-- whether foilgroup toc is numbered (or bulleted): 0 or 1 -->
<xsl:param name="generate.foilgroup.numbered.toc">1</xsl:param>

<!-- whether to generate handout notes -->
<xsl:param name="generate.handoutnotes">1</xsl:param>

<!-- whether speakernotes are generated as handout notes: 0 or 1 -->
<xsl:param name="speakernotes.as.handoutnotes">1</xsl:param>

<!-- Overrides from DocBook XSL -->
<xsl:template name="process.qanda.toc"/>

<!-- Main content starts here -->

<xsl:template name="xhtml.head">
  <meta name="generator" content="DocBook Slides Stylesheets V{$VERSION}"/>
</xsl:template>

<xsl:template name="slideshow.head"/>

<xsl:template name="slideshow.content">
  <div class="presentation">
    <div class="slide">
      <xsl:apply-templates select="/" mode="slide.titlepage.mode"/>
    </div>

    <xsl:apply-templates select="/dbs:slides/dbs:foil|dbs:slides/dbs:foilgroup"/>
  </div>
</xsl:template>

<xsl:template name="slide.handout">
  <xsl:if test="$generate.handoutnotes or $speakernotes.as.handoutnotes">
    <div class="handout">
      <xsl:if test="$generate.handoutnotes">
	<xsl:apply-templates select="dbs:handoutnotes/*"/>
      </xsl:if>

      <xsl:if test="$speakernotes.as.handoutnotes">
	<xsl:apply-templates select="dbs:speakernotes/*"/>
      </xsl:if>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="/">
  <html>
    <head>
      <title><xsl:value-of select="/dbs:slides/db:info/db:title"/></title>

      <xsl:call-template name="xhtml.head"/>
    </head>

    <body>
      <xsl:call-template name="slideshow.head"/>

      <xsl:call-template name="slideshow.content"/>
    </body>
  </html>
</xsl:template>

<xsl:template match="dbs:foilgroup">
  <div class="slide">
    <div class="slidecontent">
      <xsl:apply-templates select="*[local-name() != 'foil'][local-name() != 'speakernotes']"/>

      <xsl:if test="$generate.foilgroup.toc">
	<xsl:choose>
	  <xsl:when test="$generate.foilgroup.numbered.toc">
	    <ol>
	      <xsl:for-each select="dbs:foil">
		<li><xsl:value-of select="db:info/db:title"/></li>
	      </xsl:for-each>
	    </ol>
	  </xsl:when>

	  <xsl:otherwise>
	    <ul>
	      <xsl:for-each select="dbs:foil">
		<li><xsl:value-of select="db:info/db:title"/></li>
	      </xsl:for-each>
	    </ul>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:if>
    </div>

    <xsl:call-template name="slide.handout"/>
  </div>

  <xsl:apply-templates select="dbs:foil"/>
</xsl:template>

<xsl:template match="dbs:foil">
  <div class="slide">
    <div class="slidecontent">
      <xsl:apply-templates select="*"/>
    </div>

    <xsl:call-template name="process.footnotes"/>

    <xsl:call-template name="slide.handout"/>
  </div>
</xsl:template>

<xsl:template match="db:info">
  <h1><xsl:value-of select="db:title"/></h1>
  <xsl:if test="db:subtitle">
    <h2><xsl:value-of select="db:subtitle"/></h2>
  </xsl:if>
  <xsl:apply-templates select="db:author|db:authorgroup/db:author"/>
</xsl:template>

<xsl:template match="db:author">
  <h3><xsl:apply-templates select="db:personname|db:orgname"/></h3>
  <h4><xsl:apply-templates select="db:email"/></h4>
  <xsl:if test="db:affiliation">
    <h4><xsl:value-of select="db:affiliation"/></h4>
  </xsl:if>
</xsl:template>

<xsl:template match="db:email">
  <a>
    <xsl:attribute name="href">
      <xsl:text>mailto:</xsl:text><xsl:value-of select="."/>
    </xsl:attribute>
    &lt;<xsl:value-of select="."/>&gt;
  </a>
</xsl:template>

<xsl:template match="/" mode="slide.header.mode"/>

<xsl:template match="/" mode="slide.footer.mode"/>

<xsl:template match="/" mode="slide.titlepage.mode">
  <xsl:apply-templates select="/dbs:slides/db:info"/>
</xsl:template>

</xsl:stylesheet>
