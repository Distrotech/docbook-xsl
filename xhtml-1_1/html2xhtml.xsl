<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="exsl"
                version="1.0">

<xsl:include href="../lib/lib.xsl"/>
<xsl:output method="xml"
  encoding="ASCII"
  saxon:character-representation="decimal"
  />
<xsl:preserve-space elements="*"/>

<xsl:template match="/">
  <xsl:comment>This file was created automatically by html2xhtml</xsl:comment>
  <xsl:comment>from the HTML stylesheets.</xsl:comment>
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="xsl:stylesheet" >
  <xsl:variable name="a">
      <xsl:element name="dummy" namespace="http://www.w3.org/1999/xhtml"/>
  </xsl:variable>
    <xsl:copy>
      <xsl:copy-of select="exsl:node-set($a)//namespace::*"/>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
   </xsl:copy>

</xsl:template>

<!-- Make sure we override some templates and parameters appropriately for XHTML -->
<xsl:template match="xsl:output">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="method">xml</xsl:attribute>
    <xsl:attribute name="encoding">UTF-8</xsl:attribute>
    <xsl:attribute name="doctype-public">-//W3C//DTD XHTML 1.1//EN</xsl:attribute>

    <xsl:attribute name="doctype-system">http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:import">
  <xsl:copy>
    <xsl:attribute name="href">
      <xsl:call-template name="string.subst">
        <xsl:with-param name="string" select="@href"/>
        <xsl:with-param name="target">/html/</xsl:with-param>

        <xsl:with-param name="replacement">/xhtml-1_1/</xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:call-template[@name='language.attribute']">
	<xsl:copy>
		<xsl:attribute name="name">xml.language.attribute</xsl:attribute>
	</xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='stylesheet.result.type']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'xhtml'</xsl:attribute>

  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='make.valid.html']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">1</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='output.method']">

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'xml'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.method']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'xml'</xsl:attribute>

  </xsl:copy>
</xsl:template>

<xsl:template match="td/xsl:attribute[@name='width']"/>

<xsl:template match="hr">
	<xsl:element name="hr" namespace="http://www.w3.org/1999/xhtml"/>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.encoding']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'UTF-8'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.doctype-public']">

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'-//W3C//DTD XHTML 1.1//EN'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='chunker.output.doctype-system']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="select">'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'</xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='ulink.target']">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:element name="xsl:text"><xsl:text></xsl:text></xsl:element>
	</xsl:copy>
</xsl:template>


<xsl:template match="xsl:param[@name='html.longdesc']">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:attribute name="select">0</xsl:attribute>
	</xsl:copy>
</xsl:template>

<xsl:template match="xsl:param[@name='css.decoration']">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:attribute name="select">0</xsl:attribute>
	</xsl:copy>
</xsl:template>

<xsl:template match="xsl:variable[@name='use.viewport']">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:attribute name="select">0</xsl:attribute>
	</xsl:copy>
</xsl:template>

<xsl:template match="xsl:attribute[@name='bgcolor']">
  <xsl:element name="xsl:attribute">
    <xsl:attribute name="name">style</xsl:attribute>
    <xsl:element name="xsl:text">background-color: </xsl:element>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="xsl:attribute[@name='align']">
  <xsl:element name="xsl:attribute">
    <xsl:attribute name="name">style</xsl:attribute>
    <xsl:element name="xsl:text">text-align: </xsl:element>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="xsl:attribute[@name='type']">
	<xsl:choose>
		<xsl:when test="ancestor::ol"/>
		<xsl:when test="ancestor::ul"/>
		<xsl:otherwise>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:apply-templates/>
			</xsl:copy>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="xsl:attribute[@name='name']">
  <xsl:choose>
    <xsl:when test="ancestor::a">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="name">id</xsl:attribute>
        <xsl:apply-templates/>

      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template match="xsl:element">
  <!-- make sure literal xsl:element declarations propagate the right namespace -->
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="namespace">http://www.w3.org/1999/xhtml</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:template[@name='body.attributes']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> no apply-templates; make it empty </xsl:comment>
    <xsl:text>&#10;</xsl:text>
  </xsl:copy>
</xsl:template>

<!-- this only occurs in docbook.xsl to identify errors -->
<xsl:template match="font">
  <span class="ERROR" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="a[@name]">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>

    <xsl:for-each select="@*">
      <xsl:if test="local-name(.) != 'name'">
        <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="img[@border]">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:for-each select="@*">
      <xsl:if test="local-name(.) != 'border'">
        <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="td[@width]">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:for-each select="@*">
      <xsl:if test="local-name(.) != 'width'">
        <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="*">
  <xsl:choose>
    <xsl:when test="namespace-uri(.) = ''">
      <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
