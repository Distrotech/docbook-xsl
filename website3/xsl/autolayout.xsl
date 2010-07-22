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

<xsl:output name="xml" method="xml" encoding="utf-8" indent="no"/>

<xsl:template match="lo:layout">
  <al:autolayout>
    <xsl:apply-templates/>
  </al:autolayout>
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

</xsl:stylesheet>
