<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:output method="xml" indent="yes"
            doctype-public="-//Norman Walsh//DTD Website Auto Layout V1.0//EN"
            doctype-system="autolayout.dtd"
/>

<xsl:strip-space elements="toc tocentry layout copyright"/>

<xsl:template match="layout">
  <autolayout>
    <xsl:apply-templates/>
  </autolayout>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="style|script|copyright|config">
  <xsl:apply-templates select="." mode="copy"/>
</xsl:template>

<xsl:template match="*" mode="copy">
  <xsl:element name="{name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="copy"/>
  </xsl:element>
</xsl:template>

<xsl:template match="toc">
  <xsl:if test="not(@page)">
    <xsl:message terminate="yes">
      <xsl:text>All toc entries must have a page attribute.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="page" select="document(@page)"/>

  <toc>
    <xsl:call-template name="tocentry"/>
  </toc>
</xsl:template>

<xsl:template match="tocentry">
  <tocentry>
    <xsl:call-template name="tocentry"/>
  </tocentry>
</xsl:template>

<xsl:template match="notoc">
  <notoc>
    <xsl:call-template name="tocentry"/>
  </notoc>
</xsl:template>

<xsl:template name="tocentry">
  <xsl:if test="not(@page)">
    <xsl:message terminate="yes">
      <xsl:text>All toc entries must have a page attribute.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="page" select="document(@page,.)"/>

  <xsl:if test="not($page/*[1]/@id)">
    <xsl:message terminate="yes">
      <xsl:value-of select="@page"/>
      <xsl:text>: missing ID.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="id" select="$page/*[1]/@id"/>

  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="@filename">
        <xsl:value-of select="@filename"/>
      </xsl:when>
      <xsl:when test="/layout/config[@param='default-filename']">
        <xsl:value-of select="(/layout/config[@param='default-filename'])[1]/@value"/>
      </xsl:when>
      <xsl:otherwise>index.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="dir">
    <xsl:apply-templates select="." mode="calculate-dir"/>
  </xsl:variable>

  <xsl:if test="$filename = ''">
    <xsl:message terminate="yes">
      <xsl:value-of select="@page"/>
      <xsl:text>: missing filename.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:message>
    <xsl:value-of select="@page"/>
    <xsl:text>: </xsl:text>
    <xsl:if test="$dir != ''">
      <xsl:value-of select="$dir"/>
    </xsl:if>
    <xsl:value-of select="$filename"/>
  </xsl:message>

  <xsl:attribute name="page">
    <xsl:value-of select="@page"/>
  </xsl:attribute>
  <xsl:attribute name="id">
    <xsl:value-of select="$id"/>
  </xsl:attribute>
  <xsl:if test="$dir != ''">
    <xsl:attribute name="dir">
      <xsl:value-of select="$dir"/>
    </xsl:attribute>
  </xsl:if>
  <xsl:attribute name="filename">
    <xsl:value-of select="$filename"/>
  </xsl:attribute>
  <xsl:if test="@tocskip != '0'">
    <xsl:attribute name="tocskip">
      <xsl:value-of select="@tocskip"/>
    </xsl:attribute>
  </xsl:if>

  <title>
    <xsl:choose>
      <xsl:when test="$page/*[1]/head/titleabbrev">
        <xsl:apply-templates select="$page/*[1]/head/titleabbrev"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$page/*[1]/head/title"/>
      </xsl:otherwise>
    </xsl:choose>
  </title>

  <xsl:if test="$page/*[1]/head/titleabbrev">
    <titleabbrev>
      <xsl:apply-templates select="$page/*[1]/head/titleabbrev"/>
    </titleabbrev>
  </xsl:if>

  <xsl:if test="$page/*[1]/head/summary">
    <summary>
      <xsl:apply-templates select="$page/*[1]/head/summary"/>
    </summary>
  </xsl:if>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="*" mode="calculate-dir">
  <xsl:choose>
    <xsl:when test="starts-with(@dir, '/')">
      <!-- if the directory on this begins with a "/", we're done... -->
<!--
      <xsl:value-of select="substring-after(@dir, '/')"/>
-->
      <xsl:value-of select="@dir"/>
      <xsl:if test="@dir != '/'">
        <xsl:text>/</xsl:text>
      </xsl:if>
    </xsl:when>

    <xsl:when test="parent::*">
      <!-- if there's a parent, try it -->
      <xsl:apply-templates select="parent::*" mode="calculate-dir"/>
      <xsl:if test="@dir">
        <xsl:value-of select="@dir"/>
        <xsl:text>/</xsl:text>
      </xsl:if>
    </xsl:when>

    <xsl:otherwise>
      <xsl:if test="@dir">
        <xsl:value-of select="@dir"/>
        <xsl:text>/</xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
