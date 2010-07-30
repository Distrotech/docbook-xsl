<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://docbook.org/ns/website-layout"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:lo="http://docbook.org/website/ns/layout"
		xmlns:al="http://docbook.org/website/ns/autolayout"
		xmlns:f="http://docbook.org/website/xslt/ns/extension"
		xmlns:t="http://docbook.org/website/xslt/ns/template"
		xmlns:m="http://docbook.org/website/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:db="http://docbook.org/ns/docbook"
		exclude-result-prefixes="h lo al f t m fn ghost db"
		version="2.0">

  <!-- ********************************************************************
       DocBook Website XSL Stylesheets
       
       Utility functions and templates.
       
       Release $Id$
       ******************************************************************** -->

<xsl:output name="xml" method="xml" encoding="utf-8" indent="no"/>

<xsl:template name="t:insert-newline">
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:function name="f:to-string">
  <xsl:param name="node"/>

  <xsl:variable name="ns">
    <xsl:value-of select="fn:namespace-uri($node)"/>
  </xsl:variable>
  
  <xsl:text>Element: </xsl:text>
  <xsl:value-of select="fn:local-name($node)"/>
  <xsl:if test="$ns != ''">
    <xsl:text> (in namespace: </xsl:text>
    <xsl:value-of select="fn:namespace-uri($node)"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
  <xsl:text> </xsl:text>
</xsl:function>

<xsl:template name="t:error">
  <xsl:param name="args"/>
  <xsl:message terminate="yes">
    <xsl:for-each select="$args">
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:message>
</xsl:template>

<xsl:function name="f:error">
  <xsl:param name="args"/>
  <xsl:message terminate="yes">
    <xsl:for-each select="$args">
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:message>
</xsl:function>

<xsl:template name="t:assert">
  <xsl:param name="predicate" select="true()"/>
  <xsl:param name="empty-str" select="'NOT_EMPTY'"/>
  <xsl:param name="on-fail"/>
  <xsl:if test="not($predicate)">
    <xsl:call-template name="t:error">
      <xsl:with-param name="args" select="$on-fail"/>
    </xsl:call-template>    
  </xsl:if>
</xsl:template>

<xsl:template name="t:debug">
  <xsl:param name="args"/>
  <xsl:if test="$website.debug != 0">
    <xsl:message terminate="no">
      <xsl:for-each select="$args">
	<xsl:value-of select="."/>
      </xsl:for-each>
    </xsl:message>
  </xsl:if>
</xsl:template>

<xsl:function name="f:glean-basename">
  <xsl:param name="path"/>
  <xsl:value-of 
      select="f:glean-basename-helper(fn:lower-case(fn:normalize-space($path)))"/>
</xsl:function>

<xsl:function name="f:glean-basename-helper">
  <xsl:param name="path"/>
  <xsl:choose>
    <xsl:when test="fn:contains($path, '/')">
      <xsl:value-of select="f:glean-basename-helper(
			    fn:substring-after($path, '/'))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="fn:substring-before($path, '.')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>
