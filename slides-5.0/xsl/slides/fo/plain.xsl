<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:dbs="http://docbook.org/ns/docbook-slides"
		xmlns:exsl="http://exslt.org/common"
		exclude-result-prefixes="dbs db"
		extension-element-prefixes="exsl"
                version="1.0">

<xsl:import href="../../fo/docbook.xsl"/>
<xsl:output indent="yes"/>

<xsl:param name="page.margin.top" select="'0.25in'"/>
<xsl:param name="region.before.extent" select="'0.75in'"/>
<xsl:param name="body.margin.top" select="'1in'"/>

<xsl:param name="region.after.extent" select="'0.5in'"/>
<xsl:param name="body.margin.bottom" select="'0.5in'"/>
<xsl:param name="page.margin.bottom" select="'0.25in'"/>

<xsl:param name="page.margin.inner" select="'0.25in'"/>
<xsl:param name="page.margin.outer" select="'0.25in'"/>
<xsl:param name="column.count.body" select="1"/>

<xsl:param name="slide.font.family">Helvetica</xsl:param>
<xsl:param name="slide.title.font.family">Helvetica</xsl:param>
<xsl:param name="foil.title.master">36</xsl:param>
<xsl:param name="body.font.size">20</xsl:param>

<xsl:param name="callout.icon.size" select="'40pt'"/>

<xsl:param name="alignment" select="'start'"/>

<xsl:param name="local.l10n.xml" select="document('')"/>
<i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="en">
    <l:gentext key="Continued" text="(Continued)"/>
    <l:context name="title">
      <l:template name="slides" text="%t"/>
      <l:template name="foilgroup" text="%t"/>
      <l:template name="foil" text="%t"/>
    </l:context>
  </l:l10n>
</i18n>

<xsl:variable name="root.elements" select="' slides '"/>

<xsl:param name="preferred.mediaobject.role" select="'print'"/>

<xsl:param name="page.orientation" select="'landscape'"/>

<xsl:attribute-set name="formal.title.properties"
                   use-attribute-sets="normal.para.spacing">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.master * 1.2"/>
    <xsl:text>pt</xsl:text>
  </xsl:attribute>
  <xsl:attribute name="hyphenate">false</xsl:attribute>
  <xsl:attribute name="space-after.minimum">8pt</xsl:attribute>
  <xsl:attribute name="space-after.optimum">6pt</xsl:attribute>
  <xsl:attribute name="space-after.maximum">10pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="list.block.spacing">
  <xsl:attribute name="space-before.optimum">12pt</xsl:attribute>
  <xsl:attribute name="space-before.minimum">8pt</xsl:attribute>
  <xsl:attribute name="space-before.maximum">14pt</xsl:attribute>
  <xsl:attribute name="space-after.optimum">0pt</xsl:attribute>
  <xsl:attribute name="space-after.minimum">0pt</xsl:attribute>
  <xsl:attribute name="space-after.maximum">0pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="list.item.spacing">
  <xsl:attribute name="space-before.optimum">6pt</xsl:attribute>
  <xsl:attribute name="space-before.minimum">4pt</xsl:attribute>
  <xsl:attribute name="space-before.maximum">8pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="normal.para.spacing">
  <xsl:attribute name="space-before.optimum">8pt</xsl:attribute>
  <xsl:attribute name="space-before.minimum">6pt</xsl:attribute>
  <xsl:attribute name="space-before.maximum">10pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="footnote.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.size * 0.8"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="slides.titlepage.recto.style">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$slide.font.family"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="slides.titlepage.verso.style">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$slide.font.family"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:template name="user.pagemasters">
  <fo:simple-page-master master-name="slides-titlepage-master"
			 xsl:use-attribute-sets="titlepage.master.properties">
    <fo:region-body xsl:use-attribute-sets="titlepage.region-body.properties"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="slides-foil-master"
			 xsl:use-attribute-sets="foil.master.properties">
    <fo:region-body xsl:use-attribute-sets="foil.region-body.properties"/>
    <fo:region-before region-name="xsl-region-before-foil" xsl:use-attribute-sets="foil.region-before.properties"/>
    <fo:region-after region-name="xsl-region-after-foil" xsl:use-attribute-sets="foil.region-after.properties"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="slides-foil-continued-master"
			 xsl:use-attribute-sets="foil.master.properties">
    <fo:region-body xsl:use-attribute-sets="foil.region-body.properties"/>
    <fo:region-before region-name="xsl-region-before-foil-continued" xsl:use-attribute-sets="foil.region-before.properties"/>
    <fo:region-after region-name="xsl-region-after-foil-continued" xsl:use-attribute-sets="foil.region-after.properties"/>
  </fo:simple-page-master>

  <fo:page-sequence-master master-name="slides-titlepage">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="slides-titlepage-master"/>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>

  <fo:page-sequence-master master-name="slides-foil">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="slides-foil-master"
                                            page-position="first"/>
      <fo:conditional-page-master-reference master-reference="slides-foil-continued-master"/>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>
</xsl:template>

<xsl:template name="generate.id">
  <xsl:param name="ctx" select="."/>

  <xsl:choose>
    <xsl:when test="$ctx/@xml:id">
      <xsl:value-of select="$ctx/@xml:id"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="generate-id($ctx)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get.title">
  <xsl:param name="ctx" select="."/>

  <xsl:value-of select="($ctx/db:info/db:titleabbrev|$ctx/db:titleabbrev|$ctx/db:info/db:title|$ctx/db:title)[1]"/>
</xsl:template>

<xsl:template name="get.subtitle">
  <xsl:param name="ctx" select="."/>

  <xsl:value-of select="($ctx/db:info/db:subtitle|$ctx/db:subtitle)[1]"/>
</xsl:template>

<xsl:template match="/">
  <fo:root xsl:use-attribute-sets="slides.global.properties">
    <fo:layout-master-set>
      <xsl:call-template name="user.pagemasters"/>
    </fo:layout-master-set>
    <!-- XXX: titlepage -->

    <xsl:apply-templates select="/dbs:slides/dbs:foil|/dbs:slides/dbs:foilgroup"/>
  </fo:root>
</xsl:template>

<xsl:template match="dbs:foil|dbs:foilgroup">
  <fo:page-sequence master-reference="slides-foil" xsl:use-attribute-sets="foil.page-sequence.properties">
    <xsl:attribute name="language">
      <xsl:call-template name="l10n.language"/>
    </xsl:attribute>

    <xsl:attribute name="id">
      <xsl:call-template name="generate.id"/>
    </xsl:attribute>

    <fo:static-content flow-name="xsl-region-before-foil">
      <fo:block xsl:use-attribute-sets="foil.header.properties">
        <fo:block xsl:use-attribute-sets="foil.title.properties">
	  <xsl:call-template name="get.title"/>
        </fo:block>

        <fo:block xsl:use-attribute-sets="foil.subtitle.properties">
          <xsl:call-template name="get.subtitle"/>
        </fo:block>
      </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="xsl-region-before-foil-continued">
      <fo:block xsl:use-attribute-sets="foil.header.properties">
        <fo:block xsl:use-attribute-sets="foil.title.properties">
          <xsl:call-template name="get.title"/>
        </fo:block>
        <xsl:text> </xsl:text>
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Continued'"/>
        </xsl:call-template>
      </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="xsl-region-after-foil">
      <xsl:call-template name="generate.footer"/>
    </fo:static-content>

    <fo:static-content flow-name="xsl-region-after-foil-continued">
      <xsl:call-template name="generate.footer"/>
    </fo:static-content>

    <fo:flow flow-name="xsl-region-body">
      <fo:block xsl:use-attribute-sets="foil.properties">
	<xsl:apply-templates select="*[not(self::dbs:foil)][not(self::db:info)][not(self::db:title)][not(self::db:titleabbrev)][not(self::db:subtitle)]"/>
      </fo:block>

      <xsl:if test="self::dbs:foilgroup">
	<xsl:call-template name="foilgroup.generate.toc"/>
      </xsl:if>
    </fo:flow>
  </fo:page-sequence>

  <xsl:if test="self::dbs:foilgroup">
    <xsl:apply-templates select="dbs:foil"/>
  </xsl:if>
</xsl:template>

<xsl:template match="dbs:block">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name="generate.footer">
  <fo:table xsl:use-attribute-sets="foil.footer.properties">
    <fo:table-column column-number="1" column-width="33%"/>
    <fo:table-column column-number="2" column-width="34%"/>
    <fo:table-column column-number="3" column-width="33%"/>

    <fo:table-body>
      <fo:table-row height="14pt">
	<fo:table-cell text-align="left">
	  <xsl:call-template name="footer.left"/>
	</fo:table-cell>

	<fo:table-cell text-align="center">
	  <xsl:call-template name="footer.center"/>
	</fo:table-cell>

	<fo:table-cell text-align="right">
	  <xsl:call-template name="footer.right"/>
	</fo:table-cell>
      </fo:table-row>
    </fo:table-body>
  </fo:table>
</xsl:template>

<xsl:template name="footer.left">
  <fo:block/>
</xsl:template>

<xsl:template name="footer.center">
  <xsl:if test="/dbs:slides/db:info/db:copyright">
    <fo:block>
      <xsl:call-template name="gentext">
	<xsl:with-param name="key" select="'Copyright'"/>
      </xsl:call-template>
      <xsl:call-template name="gentext.space"/>
      <xsl:text>&#xa9;</xsl:text>
      <xsl:call-template name="gentext.space"/>
      <xsl:value-of select="/dbs:slides/db:info/db:copyright/db:year"/>
      <xsl:call-template name="gentext.space"/>
      <xsl:value-of select="/dbs:slides/db:info/db:copyright/db:holder"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="footer.right">
  <fo:block>
    <fo:page-number/>
    <xsl:text>&#160;/&#160;</xsl:text>
    <fo:page-number-citation>
      <xsl:attribute name="ref-id">
	<xsl:call-template name="generate.id">
	  <xsl:with-param name="ctx" select="(//dbs:foilgroup|//dbs:foil)[last()]"/>
	</xsl:call-template>
      </xsl:attribute>
    </fo:page-number-citation>
  </fo:block>
</xsl:template>


<xsl:template name="foilgroup.generate.toc">
  <fo:list-block xsl:use-attribute-sets="list.block.spacing orderedlist.properties">
    <xsl:for-each select="./dbs:foil">
      <fo:list-item xsl:use-attribute-sets="list.item.spacing">
	<fo:list-item-label end-indent="label-end()" xsl:use-attribute-sets="orderedlist.label.properties">
	  <fo:block>
	    <xsl:value-of select="position()"/>
	  </fo:block>
	</fo:list-item-label>

	<fo:list-item-body start-indent="body-start()">
	  <fo:block>
	    <xsl:call-template name="get.title"/>
	  </fo:block>
	</fo:list-item-body>
      </fo:list-item>
    </xsl:for-each>
  </fo:list-block>
</xsl:template>

<xsl:template match="*[namespace-uri() = 'http://www.w3.org/2000/svg']">
  <xsl:call-template name="handle.embedded">
    <xsl:with-param name="modeParam" select="$svg.embedding.mode"/>
    <xsl:with-param name="fileExt" select="'.svg'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*[namespace-uri() = 'http://www.w3.org/1998/Math/MathML']">
  <xsl:call-template name="handle.embedded">
    <xsl:with-param name="modeParam" select="$mml.embedding.mode"/>
    <xsl:with-param name="fileExt" select="'.mml'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="handle.embedded">
  <xsl:param name="modeParam">inline</xsl:param>
  <xsl:param name="fileExt"/>

  <xsl:choose>
    <xsl:when test="$modeParam = 'inline'">
      <xsl:copy-of select="."/>
    </xsl:when>

    <xsl:when test="$modeParam = 'instream-foreign-object'">
      <fo:instream-foreign-object>
	<xsl:copy-of select="."/>
      </fo:instream-foreign-object>
    </xsl:when>

    <xsl:otherwise>
      <xsl:variable name="id">
        <xsl:call-template name="generate.id"/>
      </xsl:variable>
      <xsl:variable name="fname">
        <xsl:value-of select="concat($id, $fileExt)"/>
      </xsl:variable>
      <xsl:variable name="prefix">url('</xsl:variable>
      <xsl:variable name="suffix">')</xsl:variable>
      <xsl:variable name="file.uri">
	<xsl:value-of select="concat($prefix, $fname, $suffix)"/>
      </xsl:variable>

      <exsl:document href="{$fname}">
        <xsl:copy-of select="."/>

        <xsl:fallback>
          <xsl:message terminate="yes">
            Your XSLT processor does not support exsl:document.
            You can only use inline SVG images.
          </xsl:message>
        </xsl:fallback>
      </exsl:document>

      <xsl:choose>
        <xsl:when test="$modeParam = 'external-graphic'">
	  <fo:external-graphic src="{$file.uri}"/>
        </xsl:when>

	<xsl:otherwise>
	  <xsl:message terminate="yes">
	    Unknown processing mode <xsl:value-of select="$modeParam"/>.
	  </xsl:message>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dbs:foil|dbs:foilgroup" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>
