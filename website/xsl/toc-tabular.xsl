<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:output method="html"/>

<xsl:param name="toc.spacer.graphic" select="1"/>
<xsl:param name="toc.spacer.text">&#160;&#160;&#160;</xsl:param>
<xsl:param name="toc.spacer.image">graphics/blank.gif</xsl:param>
<xsl:param name="toc.pointer.graphic" select="1"/>
<xsl:param name="toc.pointer.text">&#160;&gt;&#160;</xsl:param>
<xsl:param name="toc.pointer.image">graphics/arrow.gif</xsl:param>
<xsl:param name="toc.blank.graphic" select="1"/>
<xsl:param name="toc.blank.text">&#160;&#160;&#160;</xsl:param>
<xsl:param name="toc.blank.image">graphics/blank.gif</xsl:param>

<xsl:template match="toc/title|tocentry/title|titleabbrev">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="toc">
  <xsl:param name="pageid" select="@id"/>

  <xsl:variable name="relpath">
    <xsl:call-template name="toc-rel-path">
      <xsl:with-param name="pageid" select="$pageid"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="homebanner"
                select="/autolayout/config[@param='homebanner-tabular'][1]"/>

  <xsl:variable name="banner"
                select="/autolayout/config[@param='banner-tabular'][1]"/>

  <xsl:choose>
    <xsl:when test="$pageid = @id">
      <img align="left" border="0">
        <xsl:attribute name="src">
          <xsl:value-of select="$relpath"/>
          <xsl:value-of select="$homebanner/@value"/>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:value-of select="$homebanner/@altval"/>
        </xsl:attribute>
      </img>
      <br clear="all"/>
      <br/>
    </xsl:when>
    <xsl:otherwise>
      <a href="{$relpath}{@dir}{$filename-prefix}{@filename}">
        <img align="left" border="0">
          <xsl:attribute name="src">
            <xsl:value-of select="$relpath"/>
            <xsl:value-of select="$banner/@value"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:value-of select="$banner/@altval"/>
          </xsl:attribute>
        </img>
      </a>
      <br clear="all"/>
      <br/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates select="tocentry">
    <xsl:with-param name="pageid" select="$pageid"/>
    <xsl:with-param name="relpath" select="$relpath"/>
  </xsl:apply-templates>
  <br/>
</xsl:template>

<xsl:template match="tocentry">
  <xsl:param name="pageid" select="@id"/>
  <xsl:param name="toclevel" select="count(ancestor::*)"/>
  <xsl:param name="relpath" select="''"/>

  <xsl:variable name="dir">
    <xsl:choose>
      <xsl:when test="starts-with(@dir, '/')">
        <xsl:value-of select="substring(@dir, 2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@dir"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="isdescendant">
    <xsl:choose>
      <xsl:when test="ancestor::*[@id=$pageid]">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="isancestor">
    <xsl:choose>
      <xsl:when test="descendant::*[@id=$pageid]">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="insert.spacers">
    <xsl:with-param name="count" select="$toclevel - 1"/>
    <xsl:with-param name="relpath" select="$relpath"/>
  </xsl:call-template>

  <span>
    <xsl:if test="$toclevel>1">
      <xsl:attribute name="class">
        <xsl:text>shrink</xsl:text>
        <xsl:value-of select="$toclevel - 1"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$pageid = @id">
        <span class="xnavtoc">
          <xsl:choose>
            <xsl:when test="$toc.pointer.graphic != 0">
              <img src="{$relpath}{$toc.pointer.image}"
                   alt="{$toc.pointer.text}"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$toc.pointer.text"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="titleabbrev">
              <xsl:apply-templates select="titleabbrev"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="title"/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <span>
	  <xsl:choose>
	    <xsl:when test="$isdescendant='0'">
              <xsl:attribute name="class">navtoc</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">ynavtoc</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:choose>
            <xsl:when test="$toc.blank.graphic != 0">
              <img src="{$relpath}{$toc.blank.image}"
                   alt="{$toc.blank.text}"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$toc.blank.text"/>
            </xsl:otherwise>
          </xsl:choose>

<!--
          <xsl:message>
            <xsl:text>1: </xsl:text>
            <xsl:value-of select="$relpath"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$dir"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$filename-prefix"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="@filename"/>
          </xsl:message>
-->

          <a href="{$relpath}{$dir}{$filename-prefix}{@filename}">
            <xsl:if test="summary">
              <xsl:attribute name="title">
                <xsl:value-of select="summary"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="titleabbrev">
                <xsl:apply-templates select="titleabbrev"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="title"/>
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </span>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </span>

  <xsl:if test="$pageid = @id or $isancestor='1'">
    <xsl:apply-templates select="tocentry">
      <xsl:with-param name="pageid" select="$pageid"/>
      <xsl:with-param name="relpath" select="$relpath"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template name="insert.spacers">
  <xsl:param name="count" select="0"/>
  <xsl:param name="relpath"/>
  <xsl:if test="$count>0">
    <xsl:choose>
      <xsl:when test="$toc.spacer.graphic">
        <img src="{$relpath}{$toc.spacer.image}" alt="{$toc.spacer.text}"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$toc.spacer.text"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="insert.spacers">
      <xsl:with-param name="count" select="$count - 1"/>
      <xsl:with-param name="relpath" select="$relpath"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="toc|tocentry|notoc" mode="toc-rel-path">
  <xsl:call-template name="toc-rel-path"/>
</xsl:template>

<xsl:template name="toc-rel-path">
  <xsl:param name="pageid" select="@id"/>
  <xsl:variable name="entry" select="//*[@id=$pageid]"/>
  <xsl:variable name="filename" select="concat($entry/@dir,$entry/@filename)"/>

  <xsl:variable name="slash-count">
    <xsl:call-template name="toc-directory-depth">
      <xsl:with-param name="filename" select="$filename"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="depth">
    <xsl:choose>
      <xsl:when test="starts-with($filename, '/')">
        <xsl:value-of select="$slash-count - 1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$slash-count"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!--
  <xsl:message>
    <xsl:value-of select="$filename"/>
    <xsl:text> depth=</xsl:text>
    <xsl:value-of select="$depth"/>
  </xsl:message>
-->

  <xsl:if test="$depth > 0">
    <xsl:call-template name="copy-string">
      <xsl:with-param name="string">../</xsl:with-param>
      <xsl:with-param name="count" select="$depth"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="toc-directory-depth">
  <xsl:param name="filename"></xsl:param>
  <xsl:param name="count" select="0"/>

  <xsl:choose>
    <xsl:when test='contains($filename,"/")'>
      <xsl:call-template name="toc-directory-depth">
        <xsl:with-param name="filename"
                        select="substring-after($filename,'/')"/>
        <xsl:with-param name="count" select="$count + 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$count"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
