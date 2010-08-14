<?xml version="1.0"?>
<!--
   Copyright (c) 2002 Douglas Gregor <doug.gregor -at- gmail.com>
  
   Distributed under the Boost Software License, Version 1.0.
   (See accompanying file LICENSE_1_0.txt or copy at
   http://www.boost.org/LICENSE_1_0.txt)
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
xmlns:suwl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.UnwrapLinks"
                exclude-result-prefixes="suwl d"
                version="1.0">

<!-- Import the HTML chunking stylesheet -->
<xsl:import
    href="http://docbook.sourceforge.net/release/xsl/current/html/xref.xsl"/>


<xsl:template name="adjust-url">
    <xsl:param name="target"/>
    <xsl:param name="context" select="."/>

    <xsl:choose>
        <xsl:when test="contains($target, ':')">
          <xsl:value-of select="$target"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="href.target.relative">
            <xsl:with-param name="target" select="$target"/>
          </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>


<xsl:template match="d:link" name="ulink">
  <xsl:variable name="link">
    <a>
      <xsl:if test="@xml:id">
        <xsl:attribute name="name">
          <xsl:value-of select="@xml:id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="href">
        <xsl:call-template name="adjust-url">
          <xsl:with-param name="target" select="@url"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:if test="$link.target != ''">
        <xsl:attribute name="target">
          <xsl:value-of select="$link.target"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="count(child::node())=0">
          <xsl:value-of select="@url"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('suwl:unwrapLinks')">
      <xsl:copy-of select="suwl:unwrapLinks($link)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$link"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>
