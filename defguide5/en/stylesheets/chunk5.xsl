<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		version="2.0"
                exclude-result-prefixes="doc">

<!-- Because I want to change the chunking rules, I need to copy the
     whole stylesheet. The import/apply-imports trick won't work because
     the imported chunking code would chunk at the places where I want
     to avoid chunking. -->

<xsl:import href="tdg5.xsl"/>

<xsl:param name="html.ext" select="'.html'"/>
<xsl:param name="root.filename" select="'docbook'"/>
<xsl:param name="base.dir" select="''"/>

</xsl:stylesheet>
