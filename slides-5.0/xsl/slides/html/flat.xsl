<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dbs="http://docbook.org/ns/docbook-slides"
                version="1.0">

<xsl:import href="slides-common.xsl"/>

<xsl:template match="/">
  <html>
    <head>
      <title><xsl:value-of select="/dbs:slides/info/title"/></title>
    </head>
    <body>
      <xsl:apply-templates/>
    </body>
  </html>
</xsl:template>

<xsl:template match="dbs:slides/info">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <div id="{$id}" class="titlepage">
    <div class="titlepage-body">
      <xsl:call-template name="titlepage-body"/>
    </div>
  </div>
</xsl:template>

<xsl:template match="dbs:slides" mode="toc">
  <!-- nop -->
</xsl:template>

<xsl:template match="dbs:foil">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <div class="{name(.)}" id="{$id}">
    <div class="foil-body">
      <xsl:call-template name="foil-body"/>
    </div>
    <xsl:call-template name="process.footnotes"/>
  </div>
</xsl:template>

<xsl:template match="dbs:foilgroup">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <div class="{name(.)}" id="{$id}">
    <div class="foilgroup-body">
      <xsl:call-template name="foilgroup-body"/>
    </div>
    <xsl:call-template name="process.footnotes"/>
  </div>

  <xsl:apply-templates select="foil"/>
</xsl:template>

<xsl:template match="author" mode="titlepage.mode">
  <div class="{name(.)}">
    <h2 class="{name(.)}"><xsl:call-template name="person.name"/></h2>
    <xsl:apply-templates mode="titlepage.mode" select="./contrib"/>
    <xsl:apply-templates mode="titlepage.mode" select="./affiliation"/>
  </div>
</xsl:template>

</xsl:stylesheet>
