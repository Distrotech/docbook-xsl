<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exsl="http://exslt.org/common"
        xmlns:ng="http://docbook.org/docbook-ng" 
        xmlns:db="http://docbook.org/ns/docbook"
        version="1.0" xmlns="http://www.w3.org/1999/xhtml">

    <xsl:import href="../../xhtml/chunk.xsl"/>

    <xsl:output
            method="html"
            encoding="utf-8"
            cdata-section-elements=""/>
	<!--some configurations for mobile xsl sheets-->
	<xsl:param name="mobile.base.dir">application</xsl:param>
	
	<!--default configuration for build mobile out put-->
	<xsl:param name="chunker.output.indent">no</xsl:param>
	<xsl:param name="navig.showtitles">0</xsl:param>
	<xsl:param name="generate.manifest" select="0"></xsl:param>	
	<!--<xsl:param name="manifest">HTML.manifest</xsl:param>
	<xsl:param name="manifest.in.base.dir" select="1"></xsl:param>-->
	
	<xsl:param name="base.dir" select="concat($mobile.base.dir,'/')"/>
	<xsl:param name="suppress.navigation" select="1"></xsl:param>
	<!--<xsl:param name="suppress.header.navigation" select="0"></xsl:param>
	<xsl:param name="suppress.footer.navigation">0</xsl:param>-->
	
	<xsl:param name="generate.index" select="0"></xsl:param>
	<!--<xsl:param name="index.links.to.section" select="1"></xsl:param>-->	
	
	<xsl:param name="inherit.keywords" select="0"></xsl:param>
		<!--is non-zero, the keyword meta for each HTML head element will include all of the keywords from ancestor elements.-->
	
	<xsl:param name="para.propagates.style" select="1"></xsl:param>
		<!--if true, the role attribute of para elements will be passed through to the HTML as a class attribute on the p generated for the paragraph-->
	
	<xsl:param name="phrase.propagates.style" select="1"></xsl:param>
		<!--the role attribute of phrase elements will be passed through to the HTML as a class attribute on a span that surrounds the phrase-->
	
	<xsl:param name="chunk.first.sections" select="0"></xsl:param>
		<!--if non zero, a chunk will be created for the first top level sect1 or section elements in each component -->	
	
	<!--<xsl:param name="chunk.section.depth" select="1"></xsl:param>
	<xsl:param name="chunk.separate.lots" select="1"></xsl:param>-->
		<!--if non-zero, each of the ToC and LoTs (List of Examples, List of Figures, etc.) will be put in its own separate chunk.
			The title page includes generated links to each of the separate files.
			This feature depends on the chunk.tocs.and.lots parameter also being non-zero-->
	<xsl:param name="chunk.tocs.and.lots" select="1"></xsl:param>
		<!--if non-zero, ToC and LoT (List of Examples, List of Figures, etc.) will be put in a separate chunk-->
	<!-- <xsl:param name="generate.section.toc.level" select="0"></xsl:param> -->
	<!-- <xsl:param name="toc.max.depth">8</xsl:param> -->

	<xsl:param name="chapter.autolabel" select="1"/>
    <xsl:param name="section.autolabel" select="0"/>
    <!-- <xsl:param name="appendix.autolabel">A</xsl:param> -->
    <!-- <xsl:param name="preface.autolabel" select="0"></xsl:param> -->
    
    

</xsl:stylesheet>