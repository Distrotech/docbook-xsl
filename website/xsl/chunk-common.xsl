<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xweb="xalan://com.nwalsh.xalan.Website"
                xmlns:sweb="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Website"
                exclude-result-prefixes="sweb xweb"
                version="1.0">

<xsl:output method="html"/>

<xsl:param name="autolayout-file" select="'autolayout.xml'"/>
<xsl:param name="output-root" select="'.'"/>
<xsl:param name="dry-run" select="'0'"/>
<xsl:param name="rebuild-all" select="'0'"/>

<xsl:template match="autolayout">
  <xsl:apply-templates select="toc|notoc" mode="make"/>
</xsl:template>

<xsl:template match="toc" mode="make">
  <xsl:call-template name="make.tocentry"/>
  <xsl:apply-templates select="tocentry" mode="make"/>
</xsl:template>

<xsl:template match="tocentry|notoc" mode="make">
  <xsl:call-template name="make.tocentry"/>
  <xsl:apply-templates select="tocentry" mode="make"/>
</xsl:template>

<xsl:template name="make.tocentry">
  <xsl:variable name="srcFile" select="@page"/>
  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="@filename">
        <xsl:value-of select="@filename"/>
      </xsl:when>
      <xsl:otherwise>index.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="dir">
    <xsl:apply-templates select="." mode="calculate-dir"/>
  </xsl:variable>

<!--
  <xsl:message>
    <xsl:text>!!</xsl:text>
    <xsl:value-of select="$dir"/>
    <xsl:text>!!</xsl:text>
    <xsl:value-of select="$filename-prefix"/>
    <xsl:text>!!</xsl:text>
    <xsl:value-of select="$filename"/>
  </xsl:message>
-->

  <xsl:variable name="targetFile">
    <xsl:value-of select="$dir"/>
    <xsl:value-of select="$filename-prefix"/>
    <xsl:value-of select="$filename"/>
  </xsl:variable>

  <xsl:if test="not(sweb:exists($srcFile))">
    <xsl:message terminate="yes">
      <xsl:value-of select="$srcFile"/>
      <xsl:text> does not exist.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="output-file">
    <xsl:value-of select="$output-root"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$targetFile"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$rebuild-all != 0
                    or sweb:needsUpdate($autolayout-file, $output-file)
                    or sweb:needsUpdate($srcFile, $output-file)">
      <xsl:message>
        <xsl:text>Update: </xsl:text>
        <xsl:value-of select="$output-file"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="$srcFile"/>
      </xsl:message>

      <xsl:variable name="webpage" select="document($srcFile)"/>
      <xsl:variable name="content">
        <xsl:apply-templates select="$webpage/webpage"/>
      </xsl:variable>

      <xsl:if test="$dry-run = 0">
        <xsl:call-template name="write.chunk">
          <xsl:with-param name="filename" select="$output-file"/>
          <xsl:with-param name="content" select="$content"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Up-to-date: </xsl:text>
        <xsl:value-of select="$output-file"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="calculate-dir">
  <xsl:choose>
    <xsl:when test="@dir">
      <!-- if there's a directory, use it -->
      <xsl:choose>
        <xsl:when test="starts-with(@dir, '/')">
          <!-- if the directory on this begins with a "/", we're done... -->
          <xsl:value-of select="substring-after(@dir, '/')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@dir"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="parent::*">
      <!-- if there's a parent, try it -->
      <xsl:apply-templates select="parent::*" mode="calculate-dir"/>
    </xsl:when>

    <xsl:otherwise>
      <!-- nop -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
