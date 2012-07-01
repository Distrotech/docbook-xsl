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

	<xsl:param name="mobile.base.dir">application</xsl:param>
	
	<xsl:param name="base.dir" select="concat($mobile.base.dir,'/')"/>

</xsl:stylesheet>
