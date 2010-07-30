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
       
       XSLT Parameters
       
       Release $Id$
       ******************************************************************** -->

  <xsl:param name="website.output.default.filename" select="'index.html'"/>
  <xsl:param name="website.debug" select="1"/>
  <!--
  <xsl:param name="website." select=""/>
  -->

</xsl:stylesheet>