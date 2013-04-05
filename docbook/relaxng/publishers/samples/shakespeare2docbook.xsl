<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://docbook.org/ns/docbook" version="1.0" ><!--
				This stylesheet was autogenerated from the 'createstylesheet.xsl' 
				XSLT stylesheet. It contains template matches for all of the known 
				element declarations found in the W3C or RelaxNG schema passed through 
				this transform.  The template matches are in alphabetical order.
				
				* Notes and Limitations
					- Default namespaces (via the root @targetNamespace or @ns attributes) are
					  automatically picked up and included in the xsl:stylesheet element
						- you can use the 'default' namespace prefix (defaultns) or specify
						  your own, via the 'prefix.name' parameter
					- Does not recurse through imported/included schema files (yet)
					
				
				* createstylesheet.xsl Author: Jim Earley (jim.earley@flatironssolutions.com)
				* modified by Scott Hudson (scott.hudson@flatironssolutions.com)
				
				* Revision History:
					06.06.2006 [Jim E.] - Initial release
					05.29.2008 [Scott Hudson] - created shakespeare2docbook.
					04.04.2013 [Scott Hudson] - updated for DocBook Publishers v1.1
-->
    <xsl:template match="/"><xsl:processing-instruction name="oxygen">RNGSchema="../publishers/publishers.rnc" type="compact"</xsl:processing-instruction>
        <xsl:apply-templates/></xsl:template>
    <xsl:template match="ACT"><chapter remap="ACT"><xsl:apply-templates /></chapter></xsl:template>
   <xsl:template match="EPILOGUE">
     <xsl:choose>
         <xsl:when test="parent::ACT"><section remap="EPILOGUE"><xsl:apply-templates /></section></xsl:when>
         <xsl:otherwise><chapter remap="EPILOGUE"><xsl:apply-templates/></chapter></xsl:otherwise>
     </xsl:choose>
   </xsl:template>
    <xsl:template match="FM">
        <info remap="FM">
        <dc:title xmlns:dc="http://purl.org/dc/elements/1.1/"><xsl:value-of select="//TITLE"/></dc:title>
        <dc:creator xmlns:dc="http://purl.org/dc/elements/1.1/">William Shakespeare</dc:creator>
        <dc:contributor xmlns:dc="http://purl.org/dc/elements/1.1/">ASCII text placed in the public domain by Moby Lexical Tools, 1992.</dc:contributor>
        <dc:contributor xmlns:dc="http://purl.org/dc/elements/1.1/">SGML markup by Jon Bosak, 1992-1994.</dc:contributor>
        <dc:contributor xmlns:dc="http://purl.org/dc/elements/1.1/">XML version by Jon Bosak, 1996-1999.</dc:contributor>
        <dc:contributor xmlns:dc="http://purl.org/dc/elements/1.1/">DocBook version by Scott Hudson, 2008.</dc:contributor>
        <dcterms:license xmlns:dcterms="http://purl.org/dc/terms/">Bosak and Hudson license this work for worldwide use under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License. 
            (http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode).</dcterms:license>
        <dc:source xmlns:dc="http://purl.org/dc/elements/1.1/">http://metalab.unc.edu/bosak/xml/eg/shaks200.zip</dc:source>
        </info>
    </xsl:template>
   <xsl:template match="GRPDESCR"><xsl:apply-templates /></xsl:template>
    <xsl:template match="INDUCT"><chapter remap="INDUCT"><xsl:apply-templates /></chapter></xsl:template>
    <xsl:template match="LINE"><line remap="LINE"><xsl:apply-templates /></line></xsl:template>
    <xsl:template match="P"><para remap="P"><xsl:apply-templates /></para></xsl:template>
    <xsl:template match="PERSONA">
      <xsl:choose>
          <xsl:when test="parent::PGROUP"><personname remap="PERSONA"><xsl:apply-templates /></personname></xsl:when>
          <xsl:otherwise><para><personname remap="PERSONA"><xsl:apply-templates /></personname></para></xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    <xsl:template match="PERSONAE"><preface remap="PERSONAE"><xsl:apply-templates /></preface></xsl:template>
    <xsl:template match="PGROUP"><simplelist columns="2" remap="PGROUP"><member><xsl:apply-templates select="PERSONA"/></member><member><xsl:apply-templates select="GRPDESCR"/></member></simplelist></xsl:template>
    <xsl:template match="PLAY"><book xmlns="http://docbook.org/ns/docbook" version="5.0" remap="PLAY"><xsl:apply-templates /></book></xsl:template>
   <xsl:template match="PLAYSUBT"/>
   <xsl:template match="PROLOGUE">
       <xsl:choose>
           <xsl:when test="parent::ACT"><section remap="PROLOGUE"><xsl:apply-templates /></section></xsl:when>
           <xsl:otherwise><preface remap="PROLOGUE"><xsl:apply-templates /></preface></xsl:otherwise>
       </xsl:choose>
   </xsl:template>
    <xsl:template match="SCENE"><section remap="SCENE"><xsl:apply-templates /></section></xsl:template>
    <xsl:template match="SCNDESCR"><para remap="SCNDESCR"><xsl:apply-templates /></para></xsl:template>
    <xsl:template match="SPEAKER"><speaker remap="SPEAKER"><xsl:apply-templates /></speaker></xsl:template>
    <xsl:template match="SPEECH"><dialogue remap="SPEECH"><linegroup><xsl:apply-templates /></linegroup></dialogue></xsl:template>
   <xsl:template match="STAGEDIR"><xsl:choose>
       <xsl:when test="parent::LINE"><inlinestagedir remap="STAGEDIR"><xsl:apply-templates/></inlinestagedir></xsl:when>
       <xsl:otherwise><stagedir remap="STAGEDIR"><xsl:apply-templates/></stagedir></xsl:otherwise>
   </xsl:choose></xsl:template>
    <xsl:template match="SUBHEAD"><bridgehead remap="SUBHEAD"><xsl:apply-templates /></bridgehead></xsl:template>
    <xsl:template match="SUBTITLE"><subtitle remap="SUBTITLE"><xsl:apply-templates /></subtitle></xsl:template>
    <xsl:template match="TITLE"><title remap="TITLE"><xsl:apply-templates /></title></xsl:template>
</xsl:stylesheet>
