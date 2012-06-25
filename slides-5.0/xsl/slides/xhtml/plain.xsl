<?xml version="1.0" encoding="ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:dbs="http://docbook.org/ns/docbook-slides"
		xmlns:exsl="http://exslt.org/common"
		exclude-result-prefixes="dbs db"
		extension-element-prefixes="exsl"
		version="1.0">

<xsl:import href="../../xhtml/chunk.xsl"/>

<xsl:param name="local.l10n.xml" select="document('')"/>
<i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="en">
    <l:gentext key="Foilgroup" text="Foil Group"/>
    <l:gentext key="Foil" text="Foil"/>
    <l:gentext key="Speakernotes" text="Speaker Notes"/>
    <l:gentext key="Handout" text="Handout Notes"/>
    <l:gentext key="SVGImage" text="SVG image"/>
    <l:gentext key="MathMLFormula" text="MathML formula"/>

    <l:context name="title">
      <l:gentext key="foil" text="Foil %n %t"/>
      <l:gentext key="foilgroup" text="Foil %n %t"/>
    </l:context>
  </l:l10n>
</i18n>

<!-- whether titlepage is generated -->
<xsl:param name="generate.titlepage">1</xsl:param>

<!-- whether toc is generated for foilgroup -->
<xsl:param name="generate.foilgroup.toc">1</xsl:param>

<!-- whether foilgroup toc is numbered (or bulleted): 0 or 1 -->
<xsl:param name="generate.foilgroup.numbered.toc">1</xsl:param>

<!-- whether to generate handout notes -->
<xsl:param name="generate.handoutnotes">1</xsl:param>

<!-- whether speakernotes are generated as handout notes: 0 or 1 -->
<xsl:param name="speakernotes.as.handoutnotes">1</xsl:param>

<!-- whether to wrap slide content in a div class="slidecontent" -->
<xsl:param name="wrap.slidecontent">1</xsl:param>

<!-- whether lists are incremental: all, default (incremental attrib), no -->
<xsl:param name="incremental.lists">default</xsl:param>

<!-- whether lists are collapsable: all, default (collapsable attrib), no -->
<xsl:param name="collapsable.lists">default</xsl:param>

<!-- inline, object, embed, iframe, image, link -->
<xsl:param name="svg.embedding.mode">object</xsl:param>

<!-- inline, object, embed, iframe, image, link -->
<xsl:param name="mml.embedding.mode">object</xsl:param>

<!-- Overrides from DocBook XSL -->
<xsl:template name="process.qanda.toc"/>

<!-- Main content starts here -->

<xsl:template name="xhtml.head">
  <meta name="generator" content="DocBook Slides Stylesheets V{$VERSION}"/>
</xsl:template>

<xsl:template name="slideshow.head"/>

<xsl:template name="slideshow.content">
  <div class="presentation">
    <xsl:if test="$generate.titlepage != 0">
      <div class="slide">
	<xsl:apply-templates select="/" mode="slide.titlepage.mode"/>
      </div>
    </xsl:if>

    <xsl:apply-templates select="/dbs:slides/dbs:foil|dbs:slides/dbs:foilgroup"/>
  </div>
</xsl:template>

<xsl:template name="slide.handout">
  <xsl:if test="($generate.handoutnotes != 0) or ($speakernotes.as.handoutnotes != 0)">
    <div class="handout">
      <xsl:if test="($generate.handoutnotes != 0)">
	<xsl:apply-templates select="dbs:handoutnotes/*"/>
      </xsl:if>

      <xsl:if test="($speakernotes.as.handoutnotes != 0)">
	<xsl:apply-templates select="dbs:speakernotes/*"/>
      </xsl:if>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="/">
  <html xml:lang="{/dbs:slides/@xml:lang}">
    <head>
      <title><xsl:value-of select="/dbs:slides/db:info/db:title"/></title>

      <xsl:call-template name="xhtml.head"/>
    </head>

    <body>
      <xsl:call-template name="slideshow.head"/>

      <xsl:call-template name="slideshow.content"/>
    </body>
  </html>
</xsl:template>

<xsl:template name="foilgroup.content">
      <xsl:apply-templates select="*[not(self::dbs:foil)][not(self::dbs:speakernotes)]"/>

      <xsl:if test="($generate.foilgroup.toc != 0)">
        <xsl:choose>
          <xsl:when test="($generate.foilgroup.numbered.toc != 0)">
            <ol>
              <xsl:for-each select="dbs:foil">
                <li><xsl:value-of select="db:info/db:title"/></li>
              </xsl:for-each>
            </ol>
          </xsl:when>

          <xsl:otherwise>
            <ul>
              <xsl:for-each select="dbs:foil">
                <li><xsl:value-of select="db:info/db:title"/></li>
              </xsl:for-each>
            </ul>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
</xsl:template>

<xsl:template name="foil.classes">
  <xsl:choose>
    <xsl:when test="@style">
      <xsl:attribute name="class">
	<xsl:value-of select="concat('slide ', @style)"/>
      </xsl:attribute>
    </xsl:when>

    <xsl:otherwise>
      <xsl:attribute name="class">slide</xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dbs:foilgroup">
  <xsl:call-template name="generate.anchor" select="."/>
  <div>
    <xsl:call-template name="foil.classes"/>

    <xsl:choose>
      <xsl:when test="($wrap.slidecontent != 0)">
	<div class="slidecontent">
	  <xsl:call-template name="foilgroup.content"/>
	</div>
      </xsl:when>

      <xsl:otherwise>
	<xsl:call-template name="foilgroup.content"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="slide.handout"/>
  </div>

  <xsl:apply-templates select="dbs:foil"/>
</xsl:template>

<xsl:template match="dbs:foil">
  <xsl:call-template name="generate.anchor" select="."/>
  <div>
    <xsl:call-template name="foil.classes"/>

    <xsl:choose>
      <xsl:when test="($wrap.slidecontent != 0)">
	<div class="slidecontent">
	  <xsl:apply-templates select="*"/>
	</div>
      </xsl:when>

      <xsl:otherwise>
	<xsl:apply-templates select="*"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="process.footnotes"/>

    <xsl:call-template name="slide.handout"/>
  </div>
</xsl:template>

<xsl:template match="db:info">
  <h1 class="title"><xsl:value-of select="db:title"/></h1>
  <xsl:if test="db:subtitle">
    <h2 class="subtitle"><xsl:value-of select="db:subtitle"/></h2>
  </xsl:if>
  <xsl:apply-templates select="db:author|db:authorgroup/db:author"/>
</xsl:template>

<xsl:template match="db:author">
  <h3 class="author"><xsl:apply-templates select="db:personname|db:orgname"/></h3>
  <h4 class="email"><xsl:apply-templates select="db:email"/></h4>
  <xsl:if test="db:affiliation">
    <h4 class="affiliation"><xsl:value-of select="db:affiliation"/></h4>
  </xsl:if>
</xsl:template>

<xsl:template match="db:email">
  <a>
    <xsl:attribute name="href">
      <xsl:text>mailto:</xsl:text><xsl:value-of select="."/>
    </xsl:attribute>

    &lt;<xsl:value-of select="."/>&gt;
  </a>
</xsl:template>

<xsl:template name="list.content">
    <xsl:if test="($incremental.lists = 'all') or (($incremental.lists = 'default') and (ancestor-or-self::*/@incremental[1] = '1'))">
      <xsl:attribute name="class">incremental</xsl:attribute>
    </xsl:if>

    <xsl:if test="not(ancestor::db:itemizedlist|ancestor::db:orderedlist)">
      <xsl:if test="($collapsable.lists = 'all') or (($collapsable.lists = 'default') and (ancestor-or-self::*/@collapsable[1] = '1'))">
	<xsl:attribute name="class">outline</xsl:attribute>
      </xsl:if>
      <xsl:if test="($collapsable.lists = 'all') or (($collapsable.lists = 'default') and (ancestor-or-self::*/@collapsable[1] = 'expanded'))">
	<xsl:attribute name="class">expand</xsl:attribute>
      </xsl:if>
    </xsl:if>

    <xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="db:itemizedlist">
  <ul>
    <xsl:call-template name="list.content"/>
  </ul>
</xsl:template>

<xsl:template match="db:orderedlist">
  <ol>
    <xsl:call-template name="list.content"/>
  </ol>
</xsl:template>

<xsl:template name="bibliography.titlepage"/>

<xsl:template match="db:bibliosource" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:choose>
      <xsl:when test="@xlink:href">
	<a href="{@xlink:href}">
    	  <xsl:apply-templates mode="bibliography.mode"/>
	</a>
      </xsl:when>

      <xsl:otherwise>
	<xsl:apply-templates mode="bibliomixed.mode"/>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="dbs:foil|dbs:foilgroup" mode="xref-to">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Foil'"/>
  </xsl:call-template>
  <xsl:call-template name="gentext.space"/>
  <xsl:value-of select="count(preceding::dbs:foil|preceding::dbs:foilgroup) + 1"/>
  <xsl:text>: </xsl:text>
  <xsl:value-of select="./db:info/db:title"/>
</xsl:template>

<xsl:template match="db:biblioentry" mode="xref-to">
  <xsl:variable name="id" select="@xml:id"/>
  <xsl:variable name="entry" select="//db:bibliography/*[@xml:id=$id][1]"/>

  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="concat('#', $id)"/>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="$bibliography.numbered != 0">
        <xsl:number from="db:bibliography" count="db:biblioentry|db:bibliomixed" level="any" format="1"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$id"/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<xsl:template match="*[namespace-uri() = 'http://www.w3.org/2000/svg']">
  <xsl:call-template name="handle.embedded">
    <xsl:with-param name="modeParam" select="$svg.embedding.mode"/>
    <xsl:with-param name="fileExt" select="'.svg'"/>
    <xsl:with-param name="mimeType" select="'image/svg+xml'"/>
    <xsl:with-param name="gentextKey" select="'SVGImage'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*[namespace-uri() = 'http://www.w3.org/1998/Math/MathML']">
  <xsl:call-template name="handle.embedded">
    <xsl:with-param name="modeParam" select="$mml.embedding.mode"/>
    <xsl:with-param name="fileExt" select="'.mml'"/>
    <xsl:with-param name="mimeType" select="'application/mathml-presentation+xml'"/>
    <xsl:with-param name="gentextKey" select="'MathMLFormula'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="handle.embedded">
  <xsl:param name="modeParam">inline</xsl:param>
  <xsl:param name="fileExt"/>
  <xsl:param name="mimeType"/>
  <xsl:param name="gentextKey"/>

  <xsl:choose>
    <xsl:when test="$modeParam = 'inline'">
      <xsl:copy-of select="."/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:variable name="id">
	<xsl:call-template select="." name="generate.id"/>
      </xsl:variable>
      <xsl:variable name="fname">
	<xsl:value-of select="concat($id, $fileExt)"/>
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
        <xsl:when test="$modeParam = 'object'">
	  <object data="{$fname}" type="{$mimeType}"/>
        </xsl:when>

        <xsl:when test="$modeParam = 'image'">
	  <img src="{$fname}"/>
        </xsl:when>

        <xsl:when test="$modeParam = 'link'">
	  <a href="{$fname}">
	    <xsl:call-template name="gentext">
	      <xsl:with-param name="key" select="$gentextKey"/>
	    </xsl:call-template>
	  </a> 
        </xsl:when>

        <xsl:when test="$modeParam = 'iframe'">
	  <iframe src="{$fname}"/>
        </xsl:when>

        <xsl:when test="$modeParam = 'embed'">
	  <embed src="{$fname}" type="{$mimeType}" /> 
        </xsl:when>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="generate.anchor">
  <a>
    <xsl:attribute name="name">
      <xsl:call-template name="generate.id"/>
    </xsl:attribute>
  </a>
</xsl:template>

<xsl:template name="generate.id">
  <xsl:choose>
    <xsl:when test="./@xml:id">
      <xsl:value-of select="./@xml:id"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="generate-id(.)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="slide.copyright">
  <div class="copyright">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:text>&#xa9;</xsl:text>
    <xsl:call-template name="gentext.space"/>
    <xsl:value-of select="/dbs:slides/db:info/db:copyright/db:year"/>
    <xsl:call-template name="gentext.space"/>
    <xsl:value-of select="/dbs:slides/db:info/db:copyright/db:holder"/>
  </div>
</xsl:template>

<xsl:template name="slide.pubdate">
  <div class="pubdate">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Published'"/>
    </xsl:call-template>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="/dbs:slides/db:info/db:pubdate"/>
  </div>
</xsl:template>

<xsl:template match="/" mode="slide.header.mode"/>

<xsl:template match="/" mode="slide.footer.mode">
  <xsl:if test="/dbs:slides/db:info/db:copyright">
    <xsl:call-template name="slide.copyright"/>
  </xsl:if>
  <xsl:if test="($s5.generate.pubdate != 0) and /dbs:slides/db:info/db:pubdate">
    <xsl:call-template name="slide.pubdate"/>
  </xsl:if>
</xsl:template>

<xsl:template match="/" mode="slide.titlepage.mode">
  <xsl:apply-templates select="/dbs:slides/db:info"/>
</xsl:template>

</xsl:stylesheet>
