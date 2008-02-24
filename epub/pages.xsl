<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns="http://www.w3.org/1999/xhtml" version="1.0">

  <xsl:param name="oebps.full.dir">
    <xsl:if test="$manifest.in.base.dir != 0">
      <xsl:value-of select="$base.dir" />
    </xsl:if>
    <xsl:value-of select="$epub.oebps.dir" />
  </xsl:param>

	<xsl:template match="book" mode="xhtml">
	<!-- generate content -->
	
    <xsl:apply-templates select="bookinfo|dedication|preface|chapter|appendix|colophon|part" mode="xhtml"/>
    <xsl:if test="count(bookinfo/author/authorblurb)!=0">
      <xsl:variable name="authorcount" select="count(bookinfo/author/authorblurb)"/>
	  <xsl:variable name="content">

        <html>
        <head>
          <xsl:choose>
            <xsl:when test="$authorcount=1">
              <title>About the Author</title>
            </xsl:when>
            <xsl:otherwise>
              <title>About the Authors</title>
            </xsl:otherwise>
          </xsl:choose>
          <link rel="stylesheet" type="text/css" href="style.css"/>
        </head>
        <body>
          <xsl:choose>
            <xsl:when test="$authorcount=1">
              <h1 class="about">About the Author</h1>
            </xsl:when>
            <xsl:otherwise>
              <h1 class="about">About the Authors</h1>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="bookinfo/author/authorblurb"/>
        </body>
        </html>
      </xsl:variable>
	  <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename"> 
        <xsl:value-of select="$eobps.full.dir" />
        <xsl:value-of select="'authors.xhtml'" />
      </xsl:with-param>  
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="quiet" select="$chunk.quietly"/>
	  </xsl:call-template>

    </xsl:if>
	</xsl:template>
	
  <!-- content-related stuff -->
  
  <xsl:template match="bookinfo" mode="xhtml">
	  <xsl:variable name="content">
        <html>
        <head>
          <title>Title Page</title>
          <link rel="stylesheet" type="text/css" href="titlepage.css"/>
        </head>
        <body>
          <div class="spacerblock"/>
          <div class="titleblock">
          <xsl:choose>
            <xsl:when test="number(edition)=2">
              <h1 class="bookedition">SECOND EDITION</h1>
            </xsl:when>
            <xsl:when test="number(edition)=3">
              <h1 class="bookedition">THIRD EDITION</h1>
            </xsl:when>
            <xsl:when test="number(edition)=4">
              <h1 class="bookedition">FOURTH EDITION</h1>
            </xsl:when>
            <xsl:when test="number(edition)=5">
              <h1 class="bookedition">FIVTH EDITION</h1>
            </xsl:when>
          </xsl:choose>
          <h1 class="booktitle"><xsl:value-of select="/book/title"/></h1>
          </div>
          <div class="authorblock">
            <p class="authors">
            <xsl:apply-templates select="author" mode="author"/>
            </p>
          </div>
          <div class="logoblock">
            <img class="booklogo" alt="O'Reilly Logo" src="images/OReillyLogo.svg"/>
          </div>
        </body>
        </html>
      </xsl:variable>
	  <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename">
        <xsl:value-of select="$eobps.full.dir" />
        <xsl:value-of select="'titlepage.xhtml'" />
      </xsl:with-param>  
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="quiet" select="$chunk.quietly"/>
	  </xsl:call-template>

  </xsl:template>
  
  <xsl:template match="author" mode="author">
    <xsl:if test="count(preceding-sibling::author)!=0"><xsl:text>, </xsl:text></xsl:if>
    <xsl:value-of select="firstname"/><xsl:text> </xsl:text><xsl:value-of select="surname"/>    
  </xsl:template>

  <xsl:template match="dedication" mode="xhtml">
	<xsl:variable name="content">
      <html>
      <head>
        <title>Dedication</title>
        <style type="text/css">html {height:100%;}</style>
        <link rel="stylesheet" type="text/css" href="style.css"/>
      </head>
      <body class="dedication">
        <div class="dedication-spacer"/>
        <xsl:apply-templates/>
      </body>
      </html>
	</xsl:variable>
	<xsl:call-template name="write.chunk">
		<xsl:with-param name="filename">
        <xsl:value-of select="$eobps.full.dir" />
        <xsl:value-of select="'dedication.xhtml'" />
      </xsl:with-param>  
		<xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="quiet" select="$chunk.quietly"/>
	</xsl:call-template>

  </xsl:template>
 
 <xsl:template name="write.xhtml">
	<xsl:param name="chapnum"/>
	<xsl:param name="title"/>
	<xsl:param name="stylesheet">style.css</xsl:param>
	<xsl:param name="stylesheet.type">text/css</xsl:param>
	<xsl:param name="filename"/>
	<xsl:param name="apply-selection"/>
	<xsl:variable name="content">
		<html>
			<head>
				<title><xsl:value-of select="$title"/></title>
				<xsl:element name="link">
					<xsl:attribute name="rel"><xsl:text>stylesheet</xsl:text></xsl:attribute>
					<xsl:attribute name="type"><xsl:value-of select="$stylesheet.type"/></xsl:attribute>
					<xsl:attribute name="href"><xsl:value-of select="$stylesheet"/></xsl:attribute>
				</xsl:element>
			</head>
			<body>
				<xsl:if test="$chapnum">
					<p class="chnum">
					<xsl:value-of select="$chapnum"/>
					</p>
				</xsl:if>
				<h1 class="title"><xsl:value-of select="$title"/></h1>
				<xsl:choose>
					<xsl:when test="$apply-selection">
						<xsl:apply-templates select="$apply-selection"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
			</body>
		</html>
	</xsl:variable>
	<xsl:call-template name="write.chunk">
		<xsl:with-param name="filename" select="$filename"/>
		<xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="quiet" select="$chunk.quietly"/>
	</xsl:call-template>
</xsl:template>
	
  <xsl:template match="preface|colophon" mode="xhtml">
	<xsl:call-template name="write.xhtml">
		<xsl:with-param name="title" select="title[1]"/>
		<xsl:with-param name="filename" select="concat($oebps.full.dir, @id, '.xhtml')"/>
	</xsl:call-template>
  </xsl:template>
  
  <xsl:template match="part" mode="xhtml">
	<xsl:call-template name="write.xhtml">
		<xsl:with-param name="chapnum" select="concat('PART ',count(preceding-sibling::part)+1)"/>
		<xsl:with-param name="title" select="title[1]"/>
		<xsl:with-param name="filename" select="concat($oebps.full.dir, @id, '.xhtml')"/>
		<xsl:with-param name="apply-selection" select="partintro/*"/>
	</xsl:call-template>
    <xsl:apply-templates select="preface|chapter|appendix|colophon"/>
  </xsl:template>
 
  <xsl:template match="chapter" mode="xhtml">
	<xsl:call-template name="write.xhtml">
		<xsl:with-param name="chapnum" select="concat('CHAPTER ',count(preceding::chapter)+1)"/>
		<xsl:with-param name="title" select="title[1]"/>
		<xsl:with-param name="filename" select="concat($oebps.full.dir, @id, '.xhtml')"/>
	</xsl:call-template>
  </xsl:template>
  
  <xsl:template match="appendix" mode="xhtml">
	<xsl:call-template name="write.xhtml">
		<xsl:with-param name="chapnum" select="concat('APPENDIX ', @label)"/>
		<xsl:with-param name="title" select="title[1]"/>
		<xsl:with-param name="filename" select="concat($oebps.full.dir, @id, '.xhtml')"/>
	</xsl:call-template>
	</xsl:template>
  
  <xsl:template match="title">
  </xsl:template>
  
  <!--xsl:template match="remark">
  </xsl:template-->
  
  <!-- xsl:template match="para">
    <xsl:choose-->
      <!-- use div tag with class para instead of p tag if paragraph contains non-inline content -->
      <!--xsl:when test="table|tip|note|para|warning|itemizedlist|orderedlist|programlisting|variablelist|caution|figure|informalfigure|graphic">
        <div class="para">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template -->
  
  <!--xsl:template match="programlisting">
    <p class="programlisting">
      <xsl:apply-templates/>
    </p>
  </xsl:template -->
  
  <!--xsl:template match="blockquote">
    <blockquote>
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template -->
  
  <!--xsl:template match="emphasis">
    <em><xsl:apply-templates/></em>
  </xsl:template>
  
  <xsl:template match="phrase[@role='bold']">
    <b><xsl:apply-templates/></b>
  </xsl:template>
  
  <xsl:template match="literal">
    <span class="literal"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="userinput">
    <span class="userinput"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="replaceable">
    <span class="replaceable"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="tip">
    <table class="tip">
      <tr>
        <td class="tip-img-cell"><img class="tip-img" src="images/tip.jpg" alt="Tip"/></td>
        <td class="tip-text-cell"><xsl:apply-templates/></td>
	  </tr>
    </table>
  </xsl:template-->
  
  <!-- xsl:template match="warning|caution">
    <table class="warning">
      <tr>
        <td class="warning-img-cell"><img class="warning-img" src="images/warning.jpg" alt="Warning"/></td>
        <td class="warning-text-cell"><xsl:apply-templates/></td>
	  </tr>
    </table>
  </xsl:template -->
  
  <!--xsl:template match="sect1|section">
    <div>
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <h2><xsl:value-of select="title[1]"/></h2>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="sect2">
    <div>
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <h3><xsl:value-of select="title[1]"/></h3>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="sect3">
    <div>
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <h4><xsl:value-of select="title[1]"/></h4>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="epigraph">
    <div class="epigraph">
      <xsl:apply-templates/>
      <xsl:if test="attribution">
        <p class="attribution">
        <xsl:text>&#x2014; </xsl:text><xsl:value-of select="attribution"/>
        </p>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template match="attribution">
  </xsl:template>
  
  <xsl:template match="indexterm">
  </xsl:template>
  
  <xsl:template match="variablelist">
    <div class="variablelist">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="varlistentry">
    <div class="varlistentry">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="term">
    <div class="term">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="listitem">
    <xsl:choose>
      <xsl:when test="parent::varlistentry">
		<div class="listitem">
		  <xsl:apply-templates/>
		</div>
      </xsl:when>
      <xsl:otherwise>
		<li class="listitem">
		  <xsl:apply-templates/>
		</li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="ulink|systemitem[@role='url']">
    <xsl:choose>
      <xsl:when test="contains(@url,'://')">
        <a href="{@url}" class="ulink"><xsl:apply-templates/></a>
      </xsl:when>
      <xsl:otherwise>
        <a href="http://{@url}" class="ulink"><xsl:apply-templates/></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="simplelist">
    <div class="simplelist">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="member">
    <p class="member">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="email">
    <a class="email">
      <xsl:attribute name="href">mailto:<xsl:value-of select="."/></xsl:attribute>
      <xsl:value-of select="."/>    
    </a>
  </xsl:template>
  
  <xsl:template match="itemizedlist">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  
  <xsl:template match="orderedlist">
    <ol>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>
    
  <xsl:template match="footnote">
    <span class="footnote">
      <span class="footnote-trigger">&#x2020;</span>
      [<xsl:apply-templates select="para" mode="footnote"/>]
    </span>
  </xsl:template>
  
  <xsl:template match="para" mode="footnote">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="note">
    <xsl:choose>
      <xsl:when test="@role='safarienabled'">
        <div class="note-safari">
          <img src="images/safari.svg" alt="Safari logo" class="safari-logo"/>
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <table class="tip">
          <tr>
            <td class="tip-img-cell"><img class="tip-img" src="images/tip.jpg" alt="Tip"/></td>
            <td class="tip-text-cell"><xsl:apply-templates/></td>
	      </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="sidebar">
    <div class="sidebar">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      <h3 class="sidebar-title"><xsl:value-of select="title[1]"/></h3>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="table">
	<xsl:variable name="chapnum">
	   <xsl:value-of select="count(ancestor::chapter[1]/preceding::chapter)+1"/>
	</xsl:variable>
	<xsl:variable name="tablenum">
	   <xsl:value-of select="count(preceding::table) - count(ancestor::chapter[1]/preceding::table)+1"/>
	</xsl:variable>
    <table class="table">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      <caption>Table <xsl:value-of select="$chapnum"/>-<xsl:value-of select="$tablenum"/>. <xsl:value-of select="title[1]"/></caption>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  
  <xsl:template match="tgroup">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="thead">
    <xsl:apply-templates select="row" mode="head"/>
  </xsl:template>
  
  <xsl:template match="tbody">
    <xsl:apply-templates select="row"/>
  </xsl:template>
  
  <xsl:template match="row">
    <tr>
      <xsl:apply-templates select="entry"/>
    </tr>
  </xsl:template>
  
  <xsl:template match="row" mode="head">
    <tr>
      <xsl:apply-templates select="entry" mode="head"/>
    </tr>
  </xsl:template>
  
  <xsl:template match="entry">
    <td>
      <xsl:if test="@align">
        <xsl:attribute name="style">text-align:<xsl:value-of select="@align"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  
  <xsl:template match="entry" mode="head">
    <th>
      <xsl:if test="@align">
        <xsl:attribute name="style">text-align:<xsl:value-of select="@align"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </th>
  </xsl:template>
  
  <xsl:template match="graphic">
    <xsl:variable name="fileref" select="@fileref"/>
    <xsl:variable name="imgname" select="substring-after($fileref,'figs/')"/>
    <img class="graphic" alt=" ">
       <xsl:attribute name="src">images/<xsl:value-of select="$imgname"/></xsl:attribute>
       <xsl:if test="@width">
	     <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
       </xsl:if>
    </img>
  </xsl:template-->
  
  <!--xsl:template match="figure" -->
    <!-- this does not seem to have very uniform syntax... -->
    <!-- xsl:choose>
      <xsl:when test="mediaobject">
		<xsl:variable name="fileref" select="mediaobject/imageobject[@role='print']/imagedata/@fileref"/>
		<xsl:variable name="pdfname" select="substring-after($fileref,'print/')"/>
		<xsl:variable name="rawname" select="substring-before($pdfname,'.pdf')"/>
		<div class="figure">
		<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
		<div class="mediaobject">
			<img class="imageobject" alt="{title[1]}">
			<xsl:attribute name="src">images/<xsl:value-of select="$rawname"/>.svg</xsl:attribute>
			</img>
		</div>
		<p class="caption"><xsl:value-of select="title[1]"/></p>
		</div>
      </xsl:when>
      <xsl:when test="graphic">
		<xsl:variable name="fileref" select="graphic/@fileref"/>
		<xsl:variable name="imgname" select="substring-after($fileref,'figs/')"/>
		<div class="figure">
		<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
		<div class="mediaobject">
			<img class="imageobject" alt="{title[1]}">
			<xsl:attribute name="src">images/<xsl:value-of select="$imgname"/></xsl:attribute>
			</img>
		</div>
		<p class="caption"><xsl:value-of select="title[1]"/></p>
		</div>
      </xsl:when>
    </xsl:choose>
  </xsl:template -->
  
  <!-- xsl:template match="informalfigure" -->
    <!-- this does not seem to have very uniform syntax... -->
    <!-- xsl:choose>
      <xsl:when test="mediaobject">
		<xsl:variable name="fileref" select="mediaobject/imageobject[@role='print']/imagedata/@fileref"/>
		<xsl:variable name="pdfname" select="substring-after($fileref,'print/')"/>
		<xsl:variable name="rawname" select="substring-before($pdfname,'.pdf')"/>
		<div class="mediaobject">
		<img class="imageobject" alt="informal figure">
			<xsl:attribute name="src">images/<xsl:value-of select="$rawname"/>.svg</xsl:attribute>
		</img>
		</div>
      </xsl:when>
      <xsl:when test="graphics">
		<xsl:variable name="fileref" select="graphic/@fileref"/>
		<xsl:variable name="imgname" select="substring-after($fileref,'figs/')"/>
		<div class="mediaobject">
		<img class="imageobject" alt="informal figure">
			<xsl:attribute name="src">images/<xsl:value-of select="$imgname"/></xsl:attribute>
		</img>
		</div>
      </xsl:when>
    </xsl:choose>
  </xsl:template -->
  
  <!--xsl:template match="refentry">
    <div class="refentry">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="refmeta">
  </xsl:template>
  
  <xsl:template match="refnamediv">
    <table class="refnamediv">
      <tr>
        <xsl:apply-templates/>
      </tr>
    </table>
  </xsl:template>
  
  <xsl:template match="refname">
    <td class="refname">
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  
  <xsl:template match="refpurpose">
    <td class="refpurpose">
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  
  <xsl:template match="refsynopsisdiv">
    <div class="refsynopsisdiv">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="refsect1">
    <div class="refsect1">
      <h4><xsl:value-of select="title[1]"/></h4>
      <xsl:apply-templates/>
    </div>
  </xsl:template-->
  
  <!--xsl:template match="xref|link">
    <xsl:variable name="location">
	  <xsl:value-of select="@linkend"/>
    </xsl:variable>
    <xsl:choose>
	  <xsl:when test="@xrefstyle='chap-num-title'">
	    <a href="{$location}.xhtml" class="xref">
		Chapter <xsl:value-of select="count(//chapter[@id=$location]/preceding::chapter)+1"/>,
		<xsl:value-of select="//*[@id=$location]/title[1]"/>
		</a>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="type">
	      <a href="{$location}.xhtml" class="xref">
		    <xsl:value-of select="local-name(//*[@id=$location])"/>
		  </a>
	    </xsl:variable>
	    <xsl:choose>
	      <xsl:when test="$type='appendix'">
	        <a href="{$location}.xhtml" class="xref">
	          Appendix <xsl:value-of select="substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ',count(//appendix[@id=$location]/preceding::appendix)+1,1)"/>
	        </a>
	      </xsl:when>
	      <xsl:when test="$type='chapter'">
	        <a href="{$location}.xhtml" class="xref">
	          Chapter <xsl:value-of select="count(//chapter[@id=$location]/preceding::chapter)+1"/>
	        </a>
	      </xsl:when>
	      <xsl:when test="$type='part'">
	        <a href="{$location}.xhtml" class="xref">
	          Part <xsl:value-of select="count(//part[@id=$location]/preceding::part)+1"/>
	        </a>
	      </xsl:when>
	      <xsl:when test="$type='table'">
	        <xsl:variable name="chapter">
	          <xsl:value-of select="//table[@id=$location]/ancestor::chapter[1]/@id"/>
	        </xsl:variable>
	        <xsl:variable name="chapnum">
	          <xsl:value-of select="count(//table[@id=$location]/ancestor::chapter[1]/preceding::chapter)+1"/>
	        </xsl:variable>
	        <xsl:variable name="tablenum">
	          <xsl:value-of select="count(//table[@id=$location]/preceding::table) - count(//table[@id=$location]/ancestor::chapter[1]/preceding::table)+1"/>
	        </xsl:variable>
	        <a href="{$chapter}.xhtml#{$location}" class="xref">
	        Table <xsl:value-of select="$chapnum"/>-<xsl:value-of select="$tablenum"/>
	        </a>
	      </xsl:when>
	      <xsl:when test="$type='refentry'">
	        <xsl:variable name="chapter">
	          <xsl:value-of select="//refentry[@id=$location]/ancestor::appendix[1]/@id"/>
	        </xsl:variable>
	        <a href="{$chapter}.xhtml#{$location}" class="xref"><span class="xref-refentry"><xsl:value-of select="//refentry[@id=$location]/refnamediv/refname"/></span></a>
	      </xsl:when>
	      <xsl:when test="//*[@id=$location]/title[1]">
	        <xsl:variable name="chapter">
	          <xsl:value-of select="//*[@id=$location]/ancestor::chapter[1]/@id|//*[@id=$location]/ancestor::appendix[1]/@id|//*[@id=$location]/ancestor::preface[1]/@id"/>
	        </xsl:variable-->
	        <!--
	        <a href="{$chapter}.xhtml#{$location}" class="xref">&#x201C;<xsl:value-of select="//*[@id=$location]/title[1]"/>&#x201D;</a>
	        -->
	        <!--a href="{$chapter}.xhtml#{$location}" class="xref"><xsl:value-of select="//*[@id=$location]/title[1]"/></a>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:variable name="chapter">
	          <xsl:value-of select="//*[@id=$location]/ancestor::chapter[1]/@id"/>
	        </xsl:variable>
	        <a href="{$chapter}.xhtml#{$location}" class="xref">	        
	        THIS
	        </a>
	      </xsl:otherwise>
	    </xsl:choose>	    
	  </xsl:otherwise>
    </xsl:choose>
  </xsl:template-->
	
	<xsl:template match="authorblurb">
		<xsl:apply-templates/>
	</xsl:template>
	
</xsl:stylesheet>
