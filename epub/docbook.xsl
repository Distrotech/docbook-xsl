<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ng="http://docbook.org/docbook-ng"
  xmlns:dc="http://purl.org/dc/elements/1.1/"  
  xmlns:db="http://docbook.org/ns/docbook"
  xmlns:exsl="http://exslt.org/common" version="1.0"
  exclude-result-prefixes="exsl db ng dc">

  <xsl:import href="../xhtml-1_1/chunk.xsl" />
  <xsl:param name="ade.extensions" select="0"/>
  <xsl:param name="epub.autolabel" select="'1'"/> <!-- TODO: Document this in params -->
  <xsl:param name="manifest.in.base.dir" select="'1'"/> <!-- TODO: Document this in params; is '1' correct? -->

  <xsl:param name="epub.oebps.dir" select="'OEBPS/'"/> 
  <xsl:param name="base.dir" select="$epub.oebps.dir"/>

  <xsl:param name="epub.ncx.filename" select="'toc.ncx'"/> 
  <xsl:param name="epub.container.filename" select="'container.xml'"/> 
  <xsl:param name="epub.opf.filename" select="concat($epub.oebps.dir, 'content.opf')"/> 

  <xsl:param name="epub.toc.id">toc</xsl:param>
  <xsl:param name="epub.metainf.dir" select="'META-INF/'"/> 


  <!-- Per Bob Stayton:
       """Process your documents with the css.decoration parameter set to zero. 
          That will avoid the use of style attributes in XHTML elements where they are not permitted."""
       http://www.sagehill.net/docbookxsl/OtherOutputForms.html#StrictXhtmlValid -->
  <xsl:param name="css.decoration" select="0"/>

  <!-- no navigation in .epub -->
  <xsl:param name="suppress.navigation" select="'1'"/> 

  <xsl:variable name="article.no.chunks">
    <xsl:choose>
      <xsl:when test="/article[not(sect1) or not(section)]">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:key name="image-filerefs" match="graphic|inlinegraphic|imagedata" use="@fileref"/>

  <xsl:template match="/">
    <!-- * Get a title for current doc so that we let the user -->
    <!-- * know what document we are processing at this point. -->
    <xsl:variable name="doc.title">
      <xsl:call-template name="get.doc.title" />
    </xsl:variable>
    <xsl:choose>
      <!-- Hack! If someone hands us a DocBook V5.x or DocBook NG document,
        toss the namespace and continue.  Use the docbook5 namespaced
        stylesheets for DocBook5 if you don't want to use this feature.-->
      <!-- include extra test for Xalan quirk -->
      <xsl:when
        test="(function-available('exsl:node-set') or
                     contains(system-property('xsl:vendor'),
                       'Apache Software Foundation'))
                    and (*/self::ng:* or */self::db:*)">
        <xsl:call-template name="log.message">
          <xsl:with-param name="level">Note</xsl:with-param>
          <xsl:with-param name="source" select="$doc.title" />
          <xsl:with-param name="context-desc">
            <xsl:text>namesp. cut</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="message">
            <xsl:text>stripped namespace before processing</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:variable name="nons">
          <xsl:apply-templates mode="stripNS" />
        </xsl:variable>
        <xsl:call-template name="log.message">
          <xsl:with-param name="level">Note</xsl:with-param>
          <xsl:with-param name="source" select="$doc.title" />
          <xsl:with-param name="context-desc">
            <xsl:text>namesp. cut</xsl:text>
          </xsl:with-param>
          <xsl:with-param name="message">
            <xsl:text>processing stripped document</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="exsl:node-set($nons)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$rootid != ''">
            <xsl:choose>
              <xsl:when
                test="count(key('id',$rootid)) = 0">
                <xsl:message terminate="yes">
                  <xsl:text>ID '</xsl:text>
                  <xsl:value-of select="$rootid" />
                  <xsl:text>' not found in document.</xsl:text>
                </xsl:message>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if
                  test="$collect.xref.targets = 'yes' or
                                $collect.xref.targets = 'only'">
                  <xsl:apply-templates
                    select="key('id', $rootid)" mode="collect.targets" />
                </xsl:if>
                <xsl:if
                  test="$collect.xref.targets != 'only'">
                  <xsl:message>
                    Formatting from
                    <xsl:value-of select="$rootid" />
                  </xsl:message>
                  <xsl:apply-templates
                    select="key('id',$rootid)" mode="process.root" />
                  <xsl:call-template name="ncx" />
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if
              test="$collect.xref.targets = 'yes' or
                    $collect.xref.targets = 'only'">
              <xsl:apply-templates select="/"
                mode="collect.targets" />
            </xsl:if>
            <xsl:if
              test="$collect.xref.targets != 'only'">
              <xsl:apply-templates select="/"
                mode="process.root" />
              <xsl:call-template name="ncx" />
              <xsl:call-template name="opf" />
              <xsl:call-template name="container" />
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="opf">
    <xsl:variable name="package-id"><xsl:value-of select="concat(name(/*), 'id')"/></xsl:variable>
    <xsl:variable name="unique-id">
      <xsl:choose>
        <xsl:when test="/*/*[contains(name(.), 'info')]/biblioid"> <xsl:value-of select="/*/*[contains(name(.), 'info')]/biblioid"/> </xsl:when>
        <xsl:when test="/*/*[contains(name(.), 'info')]/invpartnumber"> <xsl:value-of select="/*/*[contains(name(.), 'info')]/invpartnumber"/> </xsl:when>
        <xsl:when test="/*/*[contains(name(.), 'info')]/issn"> <xsl:value-of select="/*/*[contains(name(.), 'info')]/issn"/> </xsl:when>
        <xsl:when test="/*/*[contains(name(.), 'info')]/issuenum"> <xsl:value-of select="/*/*[contains(name(.), 'info')]/issuenum"/> </xsl:when>
        <xsl:when test="/*/*[contains(name(.), 'info')]/productnumber"> <xsl:value-of select="/*/*[contains(name(.), 'info')]/productnumber"/> </xsl:when>
        <xsl:when test="/*/*[contains(name(.), 'info')]/pubsnumber"> <xsl:value-of select="/*/*[contains(name(.), 'info')]/pubsnumber"/> </xsl:when>
        <xsl:when test="/*/*[contains(name(.), 'info')]/seriesvolnums"> <xsl:value-of select="/*/*[contains(name(.), 'info')]/seriesvolnums"/> </xsl:when>
        <xsl:when test="/*/*[contains(name(.), 'info')]/volumenum"> <xsl:value-of select="/*/*[contains(name(.), 'info')]/volumenum"/> </xsl:when>
        <xsl:when test="/*/*[contains(name(.), 'info')]/isbn"> <xsl:value-of select="/*/*[contains(name(.), 'info')]/isbn"/> </xsl:when>
      </xsl:choose>  
      <xsl:text>_</xsl:text>
      <xsl:value-of select="/*/@id"/>
    </xsl:variable>
    <xsl:variable name="doc.title">
      <xsl:call-template name="get.doc.title" />
    </xsl:variable>
    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename">
        <xsl:value-of select="$epub.opf.filename" />
      </xsl:with-param>
      <xsl:with-param name="method" select="'xml'" />
      <xsl:with-param name="encoding" select="'utf-8'" />
      <xsl:with-param name="indent" select="'yes'" />
      <xsl:with-param name="quiet" select="$chunk.quietly" />
      <xsl:with-param name="content">
        <package xmlns="http://www.idpf.org/2007/opf" 
                 xmlns:dc="http://purl.org/dc/elements/1.1/"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 version="2.0">
          <xsl:attribute name="unique-identifier"> <xsl:value-of select="$package-id"/> </xsl:attribute>
          <metadata xmlns:dc="http://purl.org/dc/elements/1.1/"  xmlns:opf="http://www.idpf.org/2007/opf">
            <xsl:element name="dc:identifier">
              <xsl:attribute name="id"> <xsl:value-of select="$package-id"/> </xsl:attribute>
              <xsl:value-of select="$unique-id"/>
            </xsl:element>

            <xsl:element name="dc:title">
              <xsl:value-of select="normalize-space($doc.title)"/>
            </xsl:element>

            <xsl:apply-templates select="/*/*[contains(name(.), 'info')]/author|
                                         /*/*[contains(name(.), 'info')]/corpauthor|
                                         /*/*[contains(name(.), 'info')]/authorgroup/author" 
                                 mode="opf.metadata"/>        
            <xsl:apply-templates select="/*/*[contains(name(.), 'info')]/publisher/publishername" mode="opf.metadata"/>
            <xsl:element name="dc:language">
              <xsl:call-template name="l10n.language"/>
            </xsl:element>

          </metadata>
          <xsl:call-template name="opf.manifest"/>
          <xsl:call-template name="opf.spine"/>

        </package>  
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="container">
    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename">
        <xsl:value-of select="$epub.metainf.dir" />
        <xsl:value-of select="$epub.container.filename" />
      </xsl:with-param>
      <xsl:with-param name="method" select="'xml'" />
      <xsl:with-param name="encoding" select="'utf-8'" />
      <xsl:with-param name="indent" select="'yes'" />
      <xsl:with-param name="quiet" select="$chunk.quietly" />
      <xsl:with-param name="content">
        <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
          <rootfiles>
            <rootfile>
              <xsl:attribute name="full-path">
                <!-- TODO: Figure out how to get this to work right with generation but also not be hardcoded -->
                <xsl:value-of select="'OEBPS/content.opf'"/>
              </xsl:attribute>
              <xsl:attribute name="media-type">
                <xsl:text>application/oebps-package+xml</xsl:text>
              </xsl:attribute>
            </rootfile>  
          </rootfiles>  
        </container>  
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="ncx">
    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename">
        <xsl:if test="$manifest.in.base.dir != 0">
          <xsl:value-of select="$base.dir" />
        </xsl:if>
        <xsl:value-of select="$epub.ncx.filename" />
      </xsl:with-param>
      <xsl:with-param name="method" select="'xml'" />
      <xsl:with-param name="encoding" select="'utf-8'" />
      <xsl:with-param name="indent" select="'yes'" />
      <xsl:with-param name="quiet" select="$chunk.quietly" />
      <xsl:with-param name="content">
        <ncx version="2005-1" xmlns="http://www.daisy.org/z3986/2005/ncx/">
          <head>
            <xsl:if test="/*/*[contains(name(.), 'info')]/isbn"> 
              <meta name="dtb:uid">
                <xsl:attribute name="content">
                  <xsl:text>isbn:</xsl:text>
                  <xsl:value-of select="/*/*[contains(name(.), 'info')]/isbn"/> 
                </xsl:attribute>
              </meta>  
            </xsl:if>
            <!-- TODO What are these hardcoded values? -->
            <meta name="dtb:depth" content="-1" />
            <meta name="dtb:totalPageCount" content="0" />
            <meta name="dtb:maxPageNumber" content="0" />
          </head>
          <xsl:choose>
            <xsl:when test="$rootid != ''">
              <xsl:variable name="title">
                <xsl:if test="$epub.autolabel != 0">
                  <xsl:variable name="label.markup">
                    <xsl:apply-templates select="key('id',$rootid)" mode="label.markup" />
                  </xsl:variable>
                  <xsl:if test="normalize-space($label.markup)">
                    <xsl:value-of select="concat($label.markup,$autotoc.label.separator)" />
                  </xsl:if>
                </xsl:if>
                <xsl:apply-templates select="key('id',$rootid)" mode="title.markup" />
              </xsl:variable>
              <xsl:variable name="href">
                <xsl:call-template name="href.target.with.base.dir">
                  <xsl:with-param name="object" select="key('id',$rootid)" />
                </xsl:call-template>
              </xsl:variable>
              <docTitle>
                <text><xsl:value-of select="normalize-space($title)" /></text>  
              </docTitle>
              <navMap>
                <xsl:apply-templates select="key('id',$rootid)/*" mode="ncx" />
              </navMap>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="title">
                <xsl:if test="$epub.autolabel=1">
                  <xsl:variable name="label.markup">
                    <xsl:apply-templates select="/*" mode="label.markup" />
                  </xsl:variable>
                  <xsl:if test="normalize-space($label.markup)">
                    <xsl:value-of select="concat($label.markup,$autotoc.label.separator)" />
                  </xsl:if>
                </xsl:if>
                <xsl:apply-templates select="/*" mode="title.markup" />
              </xsl:variable>
              <xsl:variable name="href">
                <xsl:call-template name="href.target.with.base.dir">
                  <xsl:with-param name="object" select="/" />
                </xsl:call-template>
              </xsl:variable>
              <docTitle>
                <text><xsl:value-of select="normalize-space($title)" /></text>
              </docTitle>
              <navMap>
                <xsl:choose>
                  <xsl:when test="$article.no.chunks != '0'">
                    <xsl:apply-templates select="/*" mode="ncx" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="/*/*" mode="ncx" />
                  </xsl:otherwise>
                </xsl:choose>
              </navMap>
            </xsl:otherwise>

          </xsl:choose>
        </ncx>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- TODO: Are we certain of this match list? -->
  <xsl:template match="book|
                       article|
                       part|
                       reference|
                       preface|
                       chapter|
                       bibliography|
                       appendix|
                       article|
                       glossary|
                       section|
                       sect1|
                       sect2|
                       sect3|
                       sect4|
                       sect5|
                       refentry|
                       colophon|
                       bibliodiv|
                       index"
                mode="ncx">
    <xsl:variable name="depth" select="count(ancestor::*)"/>
    <xsl:variable name="title">
      <xsl:if test="$epub.autolabel=1">
        <xsl:variable name="label.markup">
          <xsl:apply-templates select="." mode="label.markup" />
        </xsl:variable>
        <xsl:if test="normalize-space($label.markup)">
          <xsl:value-of
            select="concat($label.markup,$autotoc.label.separator)" />
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select="." mode="title.markup" />
    </xsl:variable>

    <xsl:variable name="href">
      <xsl:call-template name="href.target.with.base.dir">
        <xsl:with-param name="context" select="/" />
        <!-- Generate links relative to the location of root file/toc.xml file -->
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="id">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:variable>
    <xsl:variable name="order">
      <xsl:value-of select="$depth +
                                  count(preceding::part|
                                  preceding::reference|
                                  preceding::preface|
                                  preceding::chapter|
                                  preceding::bibliography|
                                  preceding::appendix|
                                  preceding::article|
                                  preceding::glossary|
                                  preceding::section[not(parent::partintro)]|
                                  preceding::sect1[not(parent::partintro)]|
                                  preceding::sect2|
                                  preceding::sect3|
                                  preceding::sect4|
                                  preceding::sect5|
                                  preceding::refentry|
                                  preceding::colophon|
                                  preceding::bibliodiv|
                                  preceding::index)"/>
    </xsl:variable>

    <navPoint id="{$id}" xmlns="http://www.daisy.org/z3986/2005/ncx/">

      <xsl:attribute name="playOrder">
        <xsl:choose>
          <xsl:when test="$article.no.chunks != '0'">
            <xsl:value-of select="$order + 1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$order - 0"/>
            <!-- TODO hrm
            <xsl:value-of select="$order - 1"/>
            -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <navLabel>
        <text><xsl:value-of select="normalize-space($title)"/></text>
      </navLabel>
      <content src="{$href}"/>
      <xsl:apply-templates select="part|reference|preface|chapter|bibliography|appendix|article|glossary|section|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv|index" mode="ncx"/>
    </navPoint>

  </xsl:template>

  <xsl:template match="author|corpauthor" mode="opf.metadata">
    <xsl:variable name="n">
      <xsl:call-template name="person.name">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:element name="dc:creator">
      <xsl:value-of select="normalize-space(string($n))"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="publishername" mode="opf.metadata">
    <xsl:element name="dc:publisher">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="copyright" mode="opf.metadata">
    <xsl:variable name="copyright.date">
      <xsl:call-template name="copyright.years">
        <xsl:with-param name="years" select="year"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:element name="dc:date">
      <xsl:value-of select="$copyright.date"/>
    </xsl:element>
    <xsl:element name="dc:rights">
      <xsl:text>Copyright </xsl:text>
      <xsl:value-of select="year[1]"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="holder[1]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="opf.spine">

    <spine xmlns="http://www.idpf.org/2007/opf" toc="{$epub.toc.id}">
      <!-- TODO: be nice to have a idref="coverpage" here -->
      <!-- TODO: be nice to have a idref="titlepage" here -->
      <xsl:if test="$article.no.chunks != '0'">
        <xsl:apply-templates select="/*" mode="opf.spine"/>
      </xsl:if>
      <xsl:apply-templates select="/*/*|
                                   /*/part/*" mode="opf.spine"/>
                                   
    </spine>          
  </xsl:template>

  <xsl:template match="*" mode="opf.spine">
    <xsl:variable name="is.chunk">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$is.chunk = 1">
      <itemref xmlns="http://www.idpf.org/2007/opf" >
        <xsl:attribute name="idref">
          <xsl:value-of select="generate-id(.)"/>
        </xsl:attribute>
      </itemref>  
    </xsl:if>
  </xsl:template>

  <xsl:template name="opf.manifest">
    <manifest xmlns="http://www.idpf.org/2007/opf" 
              xmlns:dc="http://purl.org/dc/elements/1.1/"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <!-- TODO: Figure out how to get this to work right with generation but also not be hardcoded -->
      <item id="{$epub.toc.id}" media-type="application/x-dtbncx+xml">
        <xsl:attribute name="href"><xsl:value-of select="$epub.ncx.filename"/> </xsl:attribute>
      </item>  
      <!-- TODO: be nice to have a id="coverpage" here -->
      <!-- TODO: be nice to have a id="titlepage" here -->
      <xsl:apply-templates select="//part|
                                   //reference|
                                   //preface|
                                   //chapter|
                                   //bibliography|
                                   //appendix|
                                   //article|
                                   //glossary|
                                   //section|
                                   //sect1|
                                   //sect2|
                                   //sect3|
                                   //sect4|
                                   //sect5|
                                   //refentry|
                                   //colophon|
                                   //bibliodiv|
                                   //index|
                                   //graphic|
                                   //inlinegraphic|
                                   //mediaobject|
                                   //inlinemediaobject" 
                           mode="opf.manifest"/>
    </manifest>
  </xsl:template>

  <xsl:template match="mediaobject|
                       inlinemediaobject" 
                mode="opf.manifest">
    <xsl:apply-templates select="imageobject/imagedata" 
                         mode="opf.manifest"/>              
  </xsl:template>

  <!-- TODO: Barf (xsl:message terminate=yes) if you find a graphic with no reasonable format or a mediaobject w/o same? [option to not die?] -->

  <!-- TODO: Remove hardcoding -->
  <!-- wish I had XSLT2 ...-->
  <!-- TODO: priority a hack -->
  <xsl:template match="graphic[not(@format)]|
                       inlinegraphic[not(@format)]|
                       imagedata[not(@format)]"
                mode="opf.manifest">        
    <xsl:variable name="filename">
      <xsl:choose>
        <xsl:when test="contains(name(.), 'graphic')">
          <xsl:choose>
            <xsl:when test="@entityref">
              <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="@fileref"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="mediaobject.filename">
            <xsl:with-param name="object" select=".."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>  
    <xsl:variable name="format"> 
      <xsl:choose>
        <xsl:when test="contains(@fileref, '.gif')">
          <xsl:text>image/gif</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@fileref, '.GIF')">
          <xsl:text>image/gif</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@fileref, '.png')">
          <xsl:text>image/png</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@fileref, '.PNG')">
          <xsl:text>image/png</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@fileref, '.jpeg')">
          <xsl:text>image/jpeg</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@fileref, '.JPEG')">
          <xsl:text>image/jpeg</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@fileref, '.jpg')">
          <xsl:text>image/jpeg</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@fileref, '.JPG')">
          <xsl:text>image/jpeg</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@fileref, '.svg')">
          <xsl:text>image/svg+xml</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@fileref, '.SVG')">
          <xsl:text>image/svg+xml</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- we failed -->
          <xsl:text></xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="fr" select="@fileref"/>
    <xsl:if test="$format != ''">
      <!-- only do this if we're the first file to match -->
      <!-- TODO: Why can't this be simple equality?? (I couldn't get it to work) -->
      <xsl:if test="generate-id(.) = generate-id(key('image-filerefs', $fr)[1])">
        <item xmlns="http://www.idpf.org/2007/opf"> 
          <xsl:attribute name="id"> <xsl:value-of select="generate-id(.)"/> </xsl:attribute>
          <xsl:attribute name="href"> <xsl:value-of select="$filename"/> </xsl:attribute>
          <xsl:attribute name="media-type">
            <xsl:value-of select="$format"/>
          </xsl:attribute>
        </item>  
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- TODO: Remove hardcoding -->
  <xsl:template match="graphic[@format][@format = 'GIF' or @format = 'GIF87a' or @format = 'GIF89a' or @format = 'JPEG' or @format = 'JPG' or @format = 'PNG' or @format = 'SVG']|
                       inlinegraphic[@format][@format = 'GIF' or @format = 'GIF87a' or @format = 'GIF89a' or @format = 'JPEG' or @format = 'JPG' or @format = 'PNG' or @format = 'SVG']|
                       imagedata[@format][@format = 'GIF' or @format = 'GIF87a' or @format = 'GIF89a' or @format = 'JPEG' or @format = 'JPG' or @format = 'PNG' or @format = 'SVG']"
                mode="opf.manifest">
    <xsl:variable name="filename">
      <xsl:choose>
        <xsl:when test="contains(name(.), 'graphic')">
          <xsl:choose>
            <xsl:when test="@entityref">
              <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="@fileref"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="mediaobject.filename">
            <xsl:with-param name="object" select=".."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>  
    <xsl:variable name="fr" select="@fileref"/>
    <!-- only do this if we're the first file to match -->
    <!-- TODO: Why can't this be simple equality?? (I couldn't get it to work) -->
    <xsl:if test="generate-id(.) = generate-id(key('image-filerefs', $fr)[1])">
      <item xmlns="http://www.idpf.org/2007/opf"> 
        <xsl:attribute name="id"> <xsl:value-of select="generate-id(.)"/> </xsl:attribute>
        <xsl:attribute name="href"> <xsl:value-of select="$filename"/> </xsl:attribute>
        <xsl:attribute name="media-type">

          <xsl:choose>
            <!-- TODO: What is GIF87a? -->
            <xsl:when test="@format = 'GIF' or @format = 'GIF87a' or @format = 'GIF89a'">
              <xsl:text>image/gif</xsl:text>
            </xsl:when>
            <xsl:when test="@format = 'JPEG' or @format = 'JPG'">
              <xsl:text>image/jpeg</xsl:text>
            </xsl:when>
            <xsl:when test="@format = 'PNG'">
              <xsl:text>image/png</xsl:text>
            </xsl:when>
            <xsl:when test="@format = 'SVG'">
              <xsl:text>image/svg+xml</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:attribute>
      </item>  
    </xsl:if>
  </xsl:template>

  <!-- TODO: Are we certain of this match list? -->
  <xsl:template
    match="book|article|part|reference|preface|chapter|bibliography|appendix|article|glossary|section|sect1|sect2|sect3|sect4|sect5|refentry|colophon|bibliodiv|index"
    mode="opf.manifest">
    <xsl:variable name="href">
      <xsl:call-template name="href.target.with.base.dir">
        <xsl:with-param name="context" select="/" />
        <!-- Generate links relative to the location of root file/toc.xml file -->
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="id">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:variable>

    <xsl:variable name="is.chunk">
      <xsl:call-template name="chunk">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$is.chunk = 1">
      <item id="{$id}" href="{$href}" media-type="application/xhtml+xml" xmlns="http://www.idpf.org/2007/opf"/> 
    </xsl:if>  
  </xsl:template>  

  <xsl:template match="text()" mode="ncx" />

  <xsl:template name="html.head">
    <xsl:param name="prev" select="/foo"/>
    <xsl:param name="next" select="/foo"/>
    <xsl:variable name="this" select="."/>
    <xsl:variable name="home" select="/*[1]"/>
    <xsl:variable name="up" select="parent::*"/>

    <head xmlns="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="system.head.content"/>
      <xsl:call-template name="head.content"/>

      <xsl:call-template name="user.head.content"/>
    </head>
  </xsl:template>

  <!-- we can't deal with no img/@alt, because it's required. Try grabbing a title before it instead (hopefully meaningful) -->
  <xsl:template name="process.image.attributes">
    <xsl:param name="alt"/>
    <xsl:param name="html.width"/>
    <xsl:param name="html.depth"/>
    <xsl:param name="longdesc"/>
    <xsl:param name="scale"/>
    <xsl:param name="scalefit"/>
    <xsl:param name="scaled.contentdepth"/>
    <xsl:param name="scaled.contentwidth"/>
    <xsl:param name="viewport"/>

    <xsl:choose>
      <xsl:when test="@contentwidth or @contentdepth">
        <!-- ignore @width/@depth, @scale, and @scalefit if specified -->
        <xsl:if test="@contentwidth and $scaled.contentwidth != ''">
          <xsl:attribute name="width">
            <xsl:value-of select="$scaled.contentwidth"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@contentdepth and $scaled.contentdepth != ''">
          <xsl:attribute name="height">
            <xsl:value-of select="$scaled.contentdepth"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>

      <xsl:when test="number($scale) != 1.0">
        <!-- scaling is always uniform, so we only have to specify one dimension -->
        <!-- ignore @scalefit if specified -->
        <xsl:attribute name="width">
          <xsl:value-of select="$scaled.contentwidth"/>
        </xsl:attribute>
      </xsl:when>

      <xsl:when test="$scalefit != 0">
        <xsl:choose>
          <xsl:when test="contains($html.width, '%')">
            <xsl:choose>
              <xsl:when test="$viewport != 0">
                <!-- The *viewport* will be scaled, so use 100% here! -->
                <xsl:attribute name="width">
                  <xsl:value-of select="'100%'"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="width">
                  <xsl:value-of select="$html.width"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <xsl:when test="contains($html.depth, '%')">
            <!-- HTML doesn't deal with this case very well...do nothing -->
          </xsl:when>

          <xsl:when test="$scaled.contentwidth != '' and $html.width != ''                         and $scaled.contentdepth != '' and $html.depth != ''">
            <!-- scalefit should not be anamorphic; figure out which direction -->
            <!-- has the limiting scale factor and scale in that direction -->
            <xsl:choose>
              <xsl:when test="$html.width div $scaled.contentwidth &gt;                             $html.depth div $scaled.contentdepth">
                <xsl:attribute name="height">
                  <xsl:value-of select="$html.depth"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="width">
                  <xsl:value-of select="$html.width"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <xsl:when test="$scaled.contentwidth != '' and $html.width != ''">
            <xsl:attribute name="width">
              <xsl:value-of select="$html.width"/>
            </xsl:attribute>
          </xsl:when>

          <xsl:when test="$scaled.contentdepth != '' and $html.depth != ''">
            <xsl:attribute name="height">
              <xsl:value-of select="$html.depth"/>
            </xsl:attribute>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>

    <xsl:attribute name="alt">
      <xsl:choose>
        <xsl:when test="$alt != ''">
          <xsl:value-of select="normalize-space($alt)"/>
        </xsl:when>
        <xsl:when test="preceding::title[1]">
          <xsl:value-of select="normalize-space(preceding::title[1])"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>(missing alt)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:if test="$longdesc != ''">
      <xsl:attribute name="longdesc">
        <xsl:value-of select="$longdesc"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="@align and $viewport = 0">
      <xsl:attribute name="align">
        <xsl:choose>
          <xsl:when test="@align = 'center'">middle</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@align"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
