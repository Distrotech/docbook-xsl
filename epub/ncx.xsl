<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
								xmlns:exsl="http://exslt.org/common"
								extension-result-prefixes="exsl"
								version="1.0">
	
	<!--xsl:include href="chunker.xsl"/ -->
		
	<xsl:template match="book" mode="ncx">
		<xsl:variable name="content">
			<ncx version="2005-1" xmlns="http://www.daisy.org/z3986/2005/ncx/">
				<head>
					<meta name="dtb:uid" content="isbn:{bookinfo/isbn[1]}"/>
					<meta name="dtb:depth" content="-1"/>
					<meta name="dtb:totalPageCount" content="0"/>
					<meta name="dtb:maxPageNumber" content="0"/>
				</head>
				<docTitle><text><xsl:value-of select="title"/></text></docTitle> 
				<navMap>
					<navPoint id="cover" playOrder="0">
						<navLabel><text>Cover page</text></navLabel>
						<content src="coverpage.xhtml"/>
					</navPoint>
					<xsl:apply-templates select="chapter|dedication|preface|appendix|colophon|part" mode="ncx"/>
				</navMap>
			</ncx>
		</xsl:variable>
		<xsl:call-template name="write.chunk">
			<xsl:with-param name="filename">
        <xsl:if test="$manifest.in.base.dir != 0">
          <xsl:value-of select="$base.dir" />
        </xsl:if>
        <xsl:value-of select="$epub.oebps.dir" />
        <xsl:value-of select="$epub.ncx.filename"/>
      </xsl:with-param>
			<xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="quiet" select="$chunk.quietly"/>
		</xsl:call-template>
	</xsl:template>
	
	
  <xsl:template match="part" mode="ncx" xmlns="http://www.daisy.org/z3986/2005/ncx/">
     <navPoint id="{@id}" playOrder="0">
       <navLabel><text>Part <xsl:value-of select="count(preceding::part)+1"/>. <xsl:value-of select="title"/></text></navLabel>
       <content src="{@id}.xhtml"/>
       <xsl:apply-templates select="sect1|section" mode="ncx">
         <xsl:with-param name="file" select="@id"/>
       </xsl:apply-templates>
       <xsl:apply-templates select="chapter|preface|appendix|colophon" mode="ncx"/>
     </navPoint>
  </xsl:template>
  
  <xsl:template match="preface|colophon" mode="ncx" xmlns="http://www.daisy.org/z3986/2005/ncx/">
     <navPoint id="{@id}" playOrder="0">
       <navLabel><text><xsl:value-of select="title"/></text></navLabel>
       <content src="{@id}.xhtml"/>
       <xsl:apply-templates select="sect1|section" mode="ncx">
         <xsl:with-param name="file" select="@id"/>
       </xsl:apply-templates>
     </navPoint>
  </xsl:template>
  
  <xsl:template match="chapter" mode="ncx" xmlns="http://www.daisy.org/z3986/2005/ncx/">
     <navPoint id="{@id}" playOrder="0">
       <navLabel><text>Chapter <xsl:value-of select="count(preceding::chapter)+1"/>. <xsl:value-of select="title"/></text></navLabel>
       <content src="{@id}.xhtml"/>
       <xsl:apply-templates select="sect1|section" mode="ncx">
         <xsl:with-param name="file" select="@id"/>
       </xsl:apply-templates>
     </navPoint>
  </xsl:template>
  
  <xsl:template match="dedication" mode="ncx" xmlns="http://www.daisy.org/z3986/2005/ncx/">
     <navPoint id="dedication" playOrder="0">
       <navLabel><text>Dedication</text></navLabel>
       <content src="dedication.xhtml"/>
     </navPoint>
  </xsl:template>
  
  <xsl:template match="appendix" mode="ncx" xmlns="http://www.daisy.org/z3986/2005/ncx/">
     <navPoint id="{@id}" playOrder="0">
       <navLabel><text>Appendix <xsl:value-of select="substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ',count(preceding::appendix)+1,1)"/>. <xsl:value-of select="title"/></text></navLabel>
       <content src="{@id}.xhtml"/>
       <xsl:apply-templates select="sect1|section" mode="ncx">
         <xsl:with-param name="file" select="@id"/>
       </xsl:apply-templates>
     </navPoint>
  </xsl:template>
  
  <xsl:template match="section|sect1|sect2|sect3" mode="ncx" xmlns="http://www.daisy.org/z3986/2005/ncx/">
     <xsl:param name="file"/>
     <xsl:if test="@id">
       <navPoint id="{@id}" playOrder="0">
         <navLabel><text><xsl:value-of select="title"/></text></navLabel>
         <content src="{$file}.xhtml#{@id}"/>
         <xsl:apply-templates select="sect2|sect3" mode="ncx">
           <xsl:with-param name="file" select="$file"/>
         </xsl:apply-templates>
       </navPoint>
     </xsl:if>
  </xsl:template>  
</xsl:stylesheet>	
