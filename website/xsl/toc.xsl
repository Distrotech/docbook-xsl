<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:output method="html"/>

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
                select="/autolayout/config[@param='homebanner'][1]"/>

  <xsl:variable name="banner"
                select="/autolayout/config[@param='banner'][1]"/>

  <xsl:variable name="homebannertext"
                select="/autolayout/config[@param='homebannertext'][1]"/>

  <xsl:variable name="bannertext"
                select="/autolayout/config[@param='bannertext'][1]"/>

  <xsl:choose>
    <xsl:when test="$pageid = @id">
      <xsl:choose>
        <xsl:when test="$homebanner">
          <img border="0">
            <xsl:attribute name="src">
              <xsl:value-of select="$relpath"/>
              <xsl:value-of select="$homebanner/@value"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:value-of select="$homebanner/@altval"/>
            </xsl:attribute>
          </img>
          <xsl:text>@</xsl:text>
        </xsl:when>
        <xsl:when test="$homebannertext">
          <xsl:value-of select="$homebannertext/@value"/>
          <xsl:text>@</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Home</xsl:text>
          <xsl:text>@</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <a href="{$relpath}{@dir}{$filename-prefix}{@filename}">
        <xsl:choose>
          <xsl:when test="$banner">
            <img border="0">
              <xsl:attribute name="src">
                <xsl:value-of select="$relpath"/>
                <xsl:value-of select="$banner/@value"/>
              </xsl:attribute>
              <xsl:attribute name="alt">
                <xsl:value-of select="$banner/@altval"/>
              </xsl:attribute>
            </img>
          </xsl:when>
          <xsl:when test="$bannertext">
            <xsl:value-of select="$bannertext/@value"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Home</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text> | </xsl:text>

  <xsl:call-template name="process-children">
    <xsl:with-param name="pageid" select="$pageid"/>
    <xsl:with-param name="relpath" select="$relpath"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="tocentry">
  <xsl:param name="pageid" select="@id"/>
  <xsl:param name="relpath" select="''"/>

  <xsl:if test="preceding-sibling::tocentry">
    <xsl:text> | </xsl:text>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$pageid = @id">
      <xsl:choose>
        <xsl:when test="titleabbrev">
          <xsl:apply-templates select="titleabbrev"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="title"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>@</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <a href="{$relpath}{@dir}{$filename-prefix}{@filename}">
        <xsl:choose>
          <xsl:when test="titleabbrev">
            <xsl:apply-templates select="titleabbrev"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="title"/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="toc|tocentry|notoc" mode="toc-rel-path">
  <xsl:call-template name="toc-rel-path"/>
</xsl:template>

<xsl:template name="toc-rel-path">
  <xsl:param name="pageid" select="@id"/>
  <xsl:variable name="entry" select="//*[@id=$pageid]"/>
  <xsl:variable name="filename" select="concat($entry/@dir,$entry/@filename)"/>

  <xsl:variable name="depth">
    <xsl:call-template name="toc-directory-depth">
      <xsl:with-param name="filename" select="$filename"/>
    </xsl:call-template>
  </xsl:variable>

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

<xsl:template name="process-children">
  <xsl:param name="pageid" select="@id"/>
  <xsl:param name="relpath" select="''"/>

  <xsl:apply-templates select="tocentry">
    <xsl:with-param name="pageid" select="$pageid"/>
    <xsl:with-param name="relpath" select="$relpath"/>
  </xsl:apply-templates>
  <br/>

  <!-- if the current page isn't in this list, keep digging... -->
  <xsl:if test="not(tocentry[$pageid=@id])">
    <xsl:for-each select="tocentry">
      <xsl:if test="descendant::*[@id=$pageid]">
        <xsl:call-template name="process-children">
          <xsl:with-param name="pageid" select="$pageid"/>
          <xsl:with-param name="relpath" select="$relpath"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
