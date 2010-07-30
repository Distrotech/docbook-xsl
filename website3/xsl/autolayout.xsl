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
		exclude-result-prefixes="h lo al f t m fn ghost"
		version="2.0">

  <!-- ********************************************************************
       DocBook Website XSL Stylesheets
       
       Process Website Layout to generate Website Autolayout.
       
       Release $Id$
       ******************************************************************** -->

<xsl:include href="utils.xsl"/>
<xsl:include href="param.xsl"/>

<xsl:output name="xml" method="xml" encoding="utf-8" indent="no"/>

<xsl:template match="lo:layout">
  <xsl:call-template name="t:layout-begin-outer"/>
  <al:autolayout>
    <xsl:call-template name="t:layout-begin-inner"/>
    <xsl:apply-templates/>
    <xsl:call-template name="t:layout-end-inner"/>
  </al:autolayout>
  <xsl:call-template name="t:layout-end-outer"/>
</xsl:template>

<xsl:template match="db:head|db:config">
  <xsl:apply-templates select="." mode="m:clone-layout"/>
</xsl:template>

<xsl:template match="*" mode="m:clone-layout">
  <xsl:element name="{name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="m:clone-layout"/>
  </xsl:element>
</xsl:template>

<xsl:template match="lo:toc">
  <xsl:call-template name="t:layout-toc-begin-outer"/>
  <toc>
    <xsl:call-template name="t:process-layout-tocentry"/>
  </toc>
  <xsl:call-template name="t:layout-toc-end-outer"/>
</xsl:template>

<xsl:template match="lo:notoc">
  <xsl:call-template name="t:layout-notoc-begin-outer"/>
  <notoc>
    <xsl:call-template name="t:process-layout-tocentry"/>
  </notoc>
  <xsl:call-template name="t:layout-notoc-end-outer"/>
</xsl:template>

<xsl:template match="lo:tocentry">
  <xsl:call-template name="t:layout-tocentry-begin-outer"/>
  <tocentry>
    <xsl:call-template name="t:process-layout-tocentry"/>
  </tocentry>
  <xsl:call-template name="t:layout-tocentry-end-outer"/>
</xsl:template>

<xsl:template name="t:process-layout-tocentry">
  <xsl:if test="not(@page)">
    <xsl:call-template name="t:error">
      <xsl:with-param 
	  name="args" 
	  select="f:error((f:to-string(.), 
		  'must have a page attribute'))"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:variable name="page" select="document(@page, .)"/>

  <xsl:call-template name="t:assert">
    <xsl:with-param name="predicate" select="$page"/>
    <xsl:with-param name="on-fail" select="(@page, ' not found')"/>
  </xsl:call-template>
  
  <xsl:variable name="id" select="$page/db:webpage/@xml:id"/>
    
  <xsl:call-template name="t:assert">
    <xsl:with-param name="predicate" select="$id"/>
    <xsl:with-param name="on-fail" select="('ID is missing in ' , @page)"/>
  </xsl:call-template>
  
  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="@filename">
	<xsl:value-of select="@filename"/>
      </xsl:when>
      <xsl:when test="$website.output.default.filename != ''">
	<xsl:value-of select="$website.output.default.filename"/>
      </xsl:when>
      <xsl:otherwise>index.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="outdir">
    <xsl:apply-templates select="." mode="m:calculate-outdir"/>
  </xsl:variable>

  <xsl:call-template name="t:debug">
    <xsl:with-param name="args" 
		    select="(@page, ': ', fn:concat($outdir, $filename))"/>
  </xsl:call-template>

  <xsl:attribute name="page">
    <xsl:value-of select="@page"/>
  </xsl:attribute>

  <xsl:attribute name="xml:id">
    <xsl:value-of select="$id"/>
  </xsl:attribute>

  <xsl:if test="$outdir != ''">
    <xsl:attribute name="outdir">
      <xsl:value-of select="$outdir"/>
    </xsl:attribute>
  </xsl:if>

  <xsl:attribute name="filename">
    <xsl:value-of select="$filename"/>
  </xsl:attribute>

  <xsl:call-template name="t:call-layout-begin-inner-hooks"/>

  <xsl:call-template name="t:layout-tocentry-required-element">
    <xsl:with-param name="tag" select="'db:title'"/>
    <xsl:with-param name="in-layout" select="db:title"/>
    <xsl:with-param name="in-webpage" select="$page/*[1]/db:head/db:title"/>
  </xsl:call-template>

  <xsl:call-template name="t:layout-tocentry-optional-element">
    <xsl:with-param name="tag" select="'db:titleabbrev'"/>
    <xsl:with-param name="in-layout" select="db:titleabbrev"/>
    <xsl:with-param name="in-webpage" select="$page/*[1]/db:head/db:titleabbrev"/>
  </xsl:call-template>

  <xsl:call-template name="t:layout-tocentry-optional-element">
    <xsl:with-param name="tag" select="'db:summary'"/>
    <xsl:with-param name="in-layout" select="db:summary"/>
    <xsl:with-param name="in-webpage" select="$page/*[1]/db:head/db:summary"/>
  </xsl:call-template>

  <xsl:apply-templates select="lo:tocentry"/>

  <xsl:call-template name="t:call-layout-end-inner-hooks"/>

</xsl:template>

<xsl:template name="t:layout-tocentry-optional-element">
  <xsl:param name="tag"/>
  <xsl:param name="in-layout"/>
  <xsl:param name="in-webpage"/>
  <xsl:if test="$in-layout or $in-webpage">
    <xsl:choose>
      <xsl:when test="$in-layout">
	<xsl:apply-templates select="$in-layout" mode="m:clone-layout"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="{$tag}">
	  <xsl:apply-templates select="$in-webpage"/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template name="t:layout-tocentry-required-element">
  <xsl:param name="tag"/>
  <xsl:param name="in-layout"/>
  <xsl:param name="in-webpage"/>
  <xsl:choose>
    <xsl:when test="$in-layout">
      <xsl:apply-templates select="$in-layout" mode="m:clone-layout"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="{$tag}">
	<xsl:apply-templates select="$in-webpage"/>
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="m:calculate-outdir">
  <xsl:choose>
    <xsl:when test="starts-with(@outdir, '/')">
      <!-- if the directory on this begins with a "/", we're done... -->
      <xsl:value-of select="substring-after(@outdir, '/')"/>
      <xsl:text>/</xsl:text>
    </xsl:when>

    <xsl:when test="parent::*">
      <!-- if there's a parent, try it -->
      <xsl:apply-templates select="parent::*" mode="m:calculate-outdir"/>
      <xsl:if test="@outdir">
        <xsl:value-of select="@outdir"/>
        <xsl:text>/</xsl:text>
      </xsl:if>
    </xsl:when>

    <xsl:otherwise>
      <xsl:if test="@outdir">
        <xsl:value-of select="@outdir"/>
        <xsl:text>/</xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:call-layout-begin-inner-hooks">
  <xsl:param name="context" select="local-name(.)"/>
  <xsl:choose>
    <xsl:when test="$context = 'toc'">
      <xsl:call-template name="t:layout-toc-begin-inner"/>
    </xsl:when>
    <xsl:when test="$context = 'notoc'">
      <xsl:call-template name="t:layout-notoc-begin-inner"/>
    </xsl:when>
    <xsl:when test="$context = 'tocentry'">
      <xsl:call-template name="t:layout-tocentry-begin-inner"/>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:call-layout-end-inner-hooks">
  <xsl:param name="context" select="local-name(.)"/>
  <xsl:choose>
    <xsl:when test="$context = 'toc'">
      <xsl:call-template name="t:layout-toc-end-inner"/>
    </xsl:when>
    <xsl:when test="$context = 'notoc'">
      <xsl:call-template name="t:layout-notoc-end-inner"/>
    </xsl:when>
    <xsl:when test="$context = 'tocentry'">
      <xsl:call-template name="t:layout-tocentry-end-inner"/>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Hooks -->

<xsl:template name="t:layout-begin-inner">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-end-inner">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-begin-outer">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-end-outer">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>

<xsl:template name="t:layout-toc-begin-inner">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-toc-end-inner">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-toc-begin-outer">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-toc-end-outer">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>

<xsl:template name="t:layout-notoc-begin-inner">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-notoc-end-inner">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-notoc-begin-outer">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-notoc-end-outer">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>

<xsl:template name="t:layout-tocentry-begin-inner">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-tocentry-end-inner">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-tocentry-begin-outer">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>
<xsl:template name="t:layout-tocentry-end-outer">
  <xsl:call-template name="t:insert-newline"/>
</xsl:template>

<!-- /Hooks -->

</xsl:stylesheet>
