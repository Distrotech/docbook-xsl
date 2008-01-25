<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
		version="1.0"
                exclude-result-prefixes="exsl">


<!-- ==================================================================== -->

<!-- This is a customization layer on top of the XHTML 1.1 stylesheets.
		It's based on chunk.xsl becasue we need to generate multiple files.
		(the chunking templates will chunk the xhtml, and below we'll emit
		the .opf and .ncx files. Everything else should be handled by the 
		ant script or makefile.) -->


<!-- First import the non-chunking templates that format elements
     within each chunk file. In a customization, you should
     create a separate non-chunking customization layer such
     as mydocbook.xsl that imports the original docbook.xsl and
     customizes any presentation templates. Then your chunking
     customization should import mydocbook.xsl instead of
     docbook.xsl.  -->
<xsl:import href="../xhtml-1_1/docbook.xsl"/>

<!-- chunk-common.xsl contains all the named templates for chunking.
     In a customization file, you import chunk-common.xsl, then
     add any customized chunking templates of the same name. 
     They will have import precedence over the original 
     chunking templates in chunk-common.xsl. -->
<xsl:import href="../xhtml-1_1/chunk-common.xsl"/>


<!-- chunk-code.xsl contains all the chunking templates that use
     a match attribute.  In a customization it should be referenced
     using <xsl:include> instead of <xsl:import>, and then add
     any customized chunking templates with match attributes. But be sure
     to add a priority="1" to such customized templates to resolve
     its conflict with the original, since they have the
     same import precedence.
     
     Using xsl:include prevents adding another layer
     of import precedence, which would cause any
     customizations that use xsl:apply-imports to wrongly
     apply the chunking version instead of the original
     non-chunking version to format an element.  -->
<xsl:include href="../xhtml-1_1/chunk-code.xsl"/>
<!-- These templates are specific to epub. -->
<xsl:include href="opf.xsl"/>
<xsl:include href="ncx.xsl"/>
<xsl:include href="pages.xsl"/>

<xsl:param name="ade.extensions" select="0"/>

<xsl:template match="*" mode="process.root">
  <xsl:call-template name="user.preroot"/>
  <xsl:call-template name="root.messages"/>
  <xsl:apply-templates select="." mode="opf"/>
  <xsl:apply-templates select="." mode="ncx"/>
	<xsl:apply-templates select="."/>
  <!--xsl:apply-templates select="." mode="xhtml"/ -->

</xsl:template>




</xsl:stylesheet>
