<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
								xmlns:exsl="http://exslt.org/common"
								extension-result-prefixes="exsl"
								version="1.0">
	
<xsl:include href="../xhtml-1_1/chunker.xsl"/>
		
  <xsl:template match="book" mode="opf">
  
  <!-- generate OPF manifest -->
		<xsl:variable name="content">
			<package version="2.0" unique-identifier="bookid" 
								xmlns:dc="http://purl.org/dc/elements/1.1/"
								xmlns:dcterms="http://purl.org/dc/terms/" 
								xmlns:opf="http://www.idpf.org/2007/opf"
								xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
								xmlns="http://www.idpf.org/2007/opf">
				<metadata>
					<dc:identifier id="bookid" opf:scheme="ISBN">
						<xsl:text>isbn:</xsl:text>
						<xsl:value-of select="bookinfo/isbn[1]"/>
					</dc:identifier>
					<dc:title>
						<xsl:value-of select="title"/>
					</dc:title>
					<dc:creator>
						<xsl:apply-templates select="bookinfo/author" mode="authorlist"/>
					</dc:creator>
					<xsl:apply-templates select="bookinfo/author" mode="meta"/>
					<xsl:apply-templates select="bookinfo/editor" mode="meta"/>
					<xsl:apply-templates select="bookinfo/contributor" mode="meta"/>
					<dc:publisher>
						<xsl:value-of select="bookinfo/publisher/publishername"/>
					</dc:publisher>
					<dc:language>en</dc:language>
					<xsl:if test="bookinfo/copyright">
						<xsl:variable name="copyright.date">
							<xsl:call-template name="copyright.years">
							<xsl:with-param name="years" select="bookinfo/copyright/year"/>
							</xsl:call-template>
						</xsl:variable>
						<dc:date><xsl:value-of select="$copyright.date"/></dc:date>
						<!--
						<dc:date><xsl:value-of select="bookinfo/copyright/year[1]"/></dc:date>
						-->
						<dc:rights>
							<xsl:text>Copyright </xsl:text>
							<xsl:value-of select="bookinfo/copyright/year[1]"/><xsl:text>, </xsl:text>
							<xsl:value-of select="bookinfo/copyright/holder[1]"/>
						</dc:rights>
					</xsl:if>	
				</metadata>
				<manifest>
					<item id="toc" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
					<item id="style" href="style.css" media-type="text/css"/>
					<item id="template" href="template.xpgt" media-type="application/vnd.adobe-page-template+xml"/>
					<item id="coverpage" href="coverpage.xhtml" media-type="application/xhtml+xml"/>
					<item id="titlepage" href="titlepage.xhtml" media-type="application/xhtml+xml"/>
					<item id="titlepage-style" href="titlepage.css"	media-type="text/css"/>
					<xsl:if test="count(bookinfo/author/authorblurb)!=0">
						<item id="authors" href="authors.xhtml"	media-type="application/xhtml+xml"/>
					</xsl:if>
					<xsl:apply-templates mode="manifest" select="dedication
																											|chapter
																											|preface
																											|appendix
																											|part
																											|colophon"/>
					<xsl:apply-templates select="document('resitemstmp.xml')/manifest/item"	mode="manifest"/>
				</manifest>
				<spine toc="toc">
					<itemref idref="coverpage"/>
					<itemref idref="titlepage"/>
					<xsl:apply-templates mode="spine" select="dedication
																										|chapter
																										|preface
																										|appendix
																										|part"/>
					<xsl:if test="count(bookinfo/author/authorblurb)!=0">
						<itemref idref="authors"/>
					</xsl:if>
					<xsl:apply-templates select="colophon" mode="spine"/>
				</spine>
			</package>
		</xsl:variable>
		
		<xsl:call-template name="write.chunk">
			<xsl:with-param name="filename" select="'./epub/OEBPS/content.opf'"/>
			<xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="quiet" select="$chunk.quietly"/>
		</xsl:call-template>

	</xsl:template>
    
  <!-- OPF-related stuff -->
  
  <xsl:template match="item" mode="manifest" xmlns="http://www.idpf.org/2007/opf">
		<item id="{@id}" href="{@href}" media-type="{@media-type}"/>
  </xsl:template>
  
  <xsl:template match="author" mode="authorlist">
    <xsl:if test="count(preceding-sibling::author)!=0">
			<xsl:text>, </xsl:text>
		</xsl:if>
    <xsl:value-of select="firstname"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname"/>
  </xsl:template>
  
  <xsl:template match="author" mode="meta" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
    <xsl:variable name="fileas">
      <xsl:value-of select="surname"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="firstname"/>
    </xsl:variable>
    <dc:creator opf:file-as="{$fileas}" opf:role="aut">
      <xsl:value-of select="firstname"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="surname"/>
    </dc:creator>
  </xsl:template>
  
  <xsl:template match="editor" mode="meta" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
    <xsl:variable name="fileas">
      <xsl:value-of select="surname"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="firstname"/>
    </xsl:variable>
    <dc:contributor opf:file-as="{$fileas}" opf:role="edt">
      <xsl:value-of select="firstname"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="surname"/>
    </dc:contributor>
  </xsl:template>
  
  <xsl:template match="contributor" mode="meta" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
    <xsl:variable name="fileas">
      <xsl:value-of select="surname"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="firstname"/>
    </xsl:variable>
    <xsl:variable name="role">
      <xsl:choose>
        <xsl:when test="@role='illustrator'">
					<xsl:text>ill</xsl:text>
				</xsl:when>
        <xsl:otherwise>
					<xsl:text>oth</xsl:text>
				</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <dc:contributor opf:role="{$role}" opf:file-as="{$fileas}">
      <xsl:value-of select="firstname"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="surname"/>
    </dc:contributor>
  </xsl:template>
  
  <xsl:template match="part" mode="spine" xmlns="http://www.idpf.org/2007/opf">
     <itemref idref="{@id}"/>
     <xsl:apply-templates select="chapter
		 															|preface
																	|appendix
																	|colophon" mode="spine"/>
  </xsl:template>
  
  <xsl:template match="part" mode="manifest" xmlns="http://www.idpf.org/2007/opf">
     <item id="{@id}" href="{@id}.xhtml" media-type="application/xhtml+xml"/>
     <xsl:apply-templates select="chapter
		 															|preface
																	|appendix
																	|colophon" mode="manifest"/>
  </xsl:template>
  
  <xsl:template match="dedication" mode="spine" xmlns="http://www.idpf.org/2007/opf">
		<itemref idref="dedication"/>
  </xsl:template>
  
  <xsl:template match="dedication" mode="manifest" xmlns="http://www.idpf.org/2007/opf">
		<item id="dedication" href="dedication.xhtml" media-type="application/xhtml+xml"/>
  </xsl:template>
  
  <xsl:template match="preface
											|chapter
											|appendix
											|colophon" mode="spine" xmlns="http://www.idpf.org/2007/opf">
		<itemref idref="{@id}"/>
  </xsl:template>
  
  <xsl:template match="preface
											|chapter
											|appendix
											|colophon" mode="manifest" xmlns="http://www.idpf.org/2007/opf">
		<item id="{@id}" href="{@id}.xhtml" media-type="application/xhtml+xml"/>
  </xsl:template>
</xsl:stylesheet>
