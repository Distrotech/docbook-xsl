<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:xalanredirect="org.apache.xalan.xslt.extensions.Redirect"
                xmlns:exsl="http://exslt.org/common"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		version="1.1"
                exclude-result-prefixes="doc"
                extension-element-prefixes="saxon xalanredirect lxslt exsl">

<!-- This stylesheet works with Saxon and Xalan; for XT use xtchunker.xsl -->
<!-- Note: Only Saxon 6.4.2 or later is supported. -->

<!-- Note: I don't think the exsl namespace name is right! -->

<!-- ==================================================================== -->

<xsl:param name="default.encoding" select="'ISO-8859-1'" doc:type='string'/>

<doc:param name="default.encoding" xmlns="">
<refpurpose>Encoding used in generated HTML pages</refpurpose>
<refdescription>
<para>This encoding is used in files generated by chunking stylesheet. Currently
only Saxon is able to change output encoding.
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:param name="saxon.character.representation" select="'entity;decimal'" doc:type='string'/>

<doc:param name="saxon.character.representation" xmlns="">
<refpurpose>Saxon character representation used in generated HTML pages</refpurpose>
<refdescription>
<para>This character representation is used in files generated by chunking stylesheet. If
you want to suppress entity references for characters with direct representation 
in default.encoding, set this parameter to value <literal>native</literal>. 
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->

<xsl:template name="make-relative-filename">
  <xsl:param name="base.dir" select="'./'"/>
  <xsl:param name="base.name" select="''"/>

  <xsl:choose>
    <xsl:when test="element-available('exsl:document')">
      <!-- EXSL document does make the chunks relative, I think -->
      <xsl:choose>
        <xsl:when test="count(parent::*) = 0">
          <xsl:value-of select="concat($base.dir,$base.name)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$base.name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="element-available('saxon:output')">
      <!-- Saxon doesn't make the chunks relative -->
      <xsl:value-of select="concat($base.dir,$base.name)"/>
    </xsl:when>
    <xsl:when test="element-available('xalanredirect:write')">
      <!-- Xalan doesn't make the chunks relative -->
      <xsl:value-of select="concat($base.dir,$base.name)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="yes">
        <xsl:text>Don't know how to chunk with </xsl:text>
        <xsl:value-of select="system-property('xsl:vendor')"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="write.chunk">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="method" select="'html'"/>
  <xsl:param name="encoding" select="$default.encoding"/>
  <xsl:param name="indent" select="'no'"/>
  <xsl:param name="content" select="''"/>

  <xsl:message>
    <xsl:text>Writing </xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:if test="name(.) != ''">
      <xsl:text> for </xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:if test="@id">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:message>

  <xsl:choose>
    <xsl:when test="element-available('exsl:document')">
      <exsl:document href="{$filename}"
                     method="{$method}"
                     encoding="{$encoding}"
                     indent="{$indent}">
        <xsl:copy-of select="$content"/>
      </exsl:document>
    </xsl:when>
    <xsl:when test="element-available('saxon:output')">
      <saxon:output href="{$filename}"
                    method="{$method}"
                    encoding="{$encoding}"
                    indent="{$indent}"
                    saxon:character-representation="{$saxon.character.representation}">
        <xsl:copy-of select="$content"/>
      </saxon:output>
    </xsl:when>
    <xsl:when test="element-available('xalanredirect:write')">
      <!-- Xalan uses xalanredirect -->
      <xalanredirect:write file="{$filename}">
        <xsl:copy-of select="$content"/>
      </xalanredirect:write>
    </xsl:when>
    <xsl:otherwise>
      <!-- it doesn't matter since we won't be making chunks... -->
      <xsl:message terminate="yes">
        <xsl:text>Can't make chunks with </xsl:text>
        <xsl:value-of select="system-property('xsl:vendor')"/>
        <xsl:text>'s processor.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="write.chunk.with.doctype">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="method" select="'html'"/>
  <xsl:param name="encoding" select="$default.encoding"/>
  <xsl:param name="indent" select="'no'"/>
  <xsl:param name="doctype-public" select="''"/>
  <xsl:param name="doctype-system" select="''"/>
  <xsl:param name="content" select="''"/>

  <xsl:message>
    <xsl:text>Writing </xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:if test="name(.) != ''">
      <xsl:text> for </xsl:text>
      <xsl:value-of select="name(.)"/>
    </xsl:if>
  </xsl:message>


  <xsl:choose>
    <xsl:when test="element-available('exsl:document')">
      <exsl:document href="{$filename}"
                     method="{$method}"
                     encoding="{$encoding}"
                     indent="{$indent}"
                     doctype-public="{$doctype-public}"
                     doctype-system="{$doctype-system}">
        <xsl:copy-of select="$content"/>
      </exsl:document>
    </xsl:when>
    <xsl:when test="element-available('saxon:output')">
      <!-- Saxon uses saxon:output -->
      <saxon:output href="{$filename}"
                    method="{$method}"
                    encoding="{$encoding}"
                    indent="{$indent}"
                    doctype-public="{$doctype-public}"
                    doctype-system="{$doctype-system}"
                    saxon:character-representation="{$saxon.character.representation}">
        <xsl:copy-of select="$content"/>
      </saxon:output>
    </xsl:when>
    <xsl:when test="element-available('xalanredirect:write')">
      <!-- Xalan uses xalanredirect -->
      <xalanredirect:write file="{$filename}">
        <xsl:copy-of select="$content"/>
      </xalanredirect:write>
    </xsl:when>
    <xsl:otherwise>
      <!-- it doesn't matter since we won't be making chunks... -->
      <xsl:message terminate="yes">
        <xsl:text>Can't make chunks with </xsl:text>
        <xsl:value-of select="system-property('xsl:vendor')"/>
        <xsl:text>'s processor.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
