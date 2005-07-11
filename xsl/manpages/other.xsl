<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:param name="man.string.subst.map.enabled">0</xsl:param>

<!-- * This file contains named templates that are related to things -->
<!-- * other than just assembling the actual text of the main text flow -->
<!-- * of each man page. This "other" stuff currently amounts to: -->
<!-- * -->
<!-- *  - adding a comment to top part of roff source of each page -->
<!-- *  - making a .TH title line (for controlling page header/footer) -->
<!-- *  - setting hyphenation, alignment, & line-breaking defaults -->
<!-- *  - "preparing" the complete man page contents for final output -->
<!-- *  - writing the actual man file to the filesystem -->
<!-- *  - writing any "stub" pages to the filesystem -->
<!-- * -->
<!-- * The templates in this file are actually called only once per -->
<!-- * each Refentry; they are just in a separate file for the purpose -->
<!-- * of keeping things modular. -->

<!-- ==================================================================== -->
<!-- * Get character map contents -->
<!-- ==================================================================== -->

  <xsl:variable name="man.charmap.contents">
    <xsl:if test="$man.charmap.enabled != 0">
      <xsl:call-template name="read-character-map">
        <xsl:with-param name="use.subset" select="$man.charmap.use.subset"/>
        <xsl:with-param name="subset.profile" select="$man.charmap.subset.profile"/>
        <xsl:with-param name="uri">
          <xsl:choose>
            <xsl:when test="$man.charmap.uri != ''">
              <xsl:value-of select="$man.charmap.uri"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'../manpages/charmap.groff.xsl'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

<!-- ==================================================================== -->

  <xsl:template name="top.comment">
    <xsl:text>.\" ** You probably do not want to</xsl:text>
    <xsl:text> edit this file directly **&#10;</xsl:text>
    <xsl:text>.\" It was generated using the DocBook</xsl:text>
    <xsl:text> XSL Stylesheets (version </xsl:text>
    <xsl:value-of select="$VERSION"/>
    <xsl:text>).&#10;</xsl:text>
    <xsl:text>.\" Instead of manually editing it, you</xsl:text>
    <xsl:text> probably should edit the DocBook XML&#10;</xsl:text>
    <xsl:text>.\" source for it and then use the DocBook</xsl:text>
    <xsl:text> XSL Stylesheets to regenerate it.&#10;</xsl:text>
  </xsl:template>

<!-- ==================================================================== -->

  <xsl:template name="TH.title.line">

    <!-- * The exact way that .TH contents are displayed is system- -->
    <!-- * dependent; it varies somewhat between OSes and roff -->
    <!-- * versions. Below is a description of how Linux systems with -->
    <!-- * a modern groff seem to render .TH contents. -->
    <!-- * -->
    <!-- *   title(section)  extra3  title(section)  <- page header -->
    <!-- *   extra2          extra1  title(section)  <- page footer-->
    <!-- * -->
    <!-- * Or, using the names with which the man(7) man page refers -->
    <!-- * to the various fields: -->
    <!-- * -->
    <!-- *   title(section)  manual  title(section)  <- page header -->
    <!-- *   source          date    title(section)  <- page footer-->
    <!-- * -->
    <!-- * Note that while extra1, extra2, and extra3 are all (nominally) -->
    <!-- * optional, in practice almost all pages include an "extra1" -->
    <!-- * field, which is, universally, a date (in some form), and it is -->
    <!-- * always rendered in the same place (the middle footer position) -->
    <!-- * -->
    <!-- * Here are a couple of examples of real-world man pages that -->
    <!-- * have somewhat useful page headers/footers: -->
    <!-- * -->
    <!-- *   gtk-options(7)    GTK+ User's Manual   gtk-options(7) -->
    <!-- *   GTK+ 1.2              2003-10-20       gtk-options(7) -->
    <!-- * -->
    <!-- *   svgalib(7)       Svgalib User Manual       svgalib(7) -->
    <!-- *   Svgalib 1.4.1      16 December 1999        svgalib(7) -->
    <!-- * -->
    <xsl:param name="title"/>
    <xsl:param name="section"/>
    <xsl:param name="extra1"/>
    <xsl:param name="extra2"/>
    <xsl:param name="extra3"/>

    <xsl:call-template name="mark.subheading"/>
    <!-- * Note that we generate quotes around _every_ field in the -->
    <!-- * .TH title line, including the "title" and "section" -->
    <!-- * fields. That is because we use the contents of those "as -->
    <!-- * is", unchanged from the DocBook source; and DTD-based -->
    <!-- * validation does not provide a way to constrain them to be -->
    <!-- * "space free" -->
    <xsl:text>.TH "</xsl:text>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:choose>
          <xsl:when test="$man.th.title.max.length != ''">
            <xsl:value-of
                select="normalize-space(substring($title, 1, $man.th.title.max.length))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space($title)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="normalize-space($section)"/>
    <xsl:text>" "</xsl:text>
    <xsl:if test="$man.th.extra1.suppress = 0">
      <!-- * there is no max.length for the extra1 field; the reason -->
      <!-- * is, it is almost always a date, and it is not possible -->
      <!-- * to truncate dates without changing their meaning -->
      <xsl:value-of select="normalize-space($extra1)"/>
    </xsl:if>
    <xsl:text>" "</xsl:text>
    <xsl:if test="$man.th.extra2.suppress = 0">
      <xsl:choose>
        <!-- * if max.length is non-empty, use value to truncate field -->
        <xsl:when test="$man.th.extra2.max.length != ''">
          <xsl:value-of
              select="normalize-space(substring($extra2, 1, $man.th.extra2.max.length))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($extra2)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:text>" "</xsl:text>
    <xsl:if test="$man.th.extra3.suppress = 0">
      <xsl:choose>
        <!-- * if max.length is non-empty, use value to truncate field -->
        <xsl:when test="$man.th.extra3.max.length != ''">
          <xsl:value-of
              select="normalize-space(substring($extra3, 1, $man.th.extra3.max.length))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($extra3)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:text>"&#10;</xsl:text>
    <xsl:call-template name="mark.subheading"/>
  </xsl:template>

  <!-- ============================================================== -->

  <xsl:template name="set.default.formatting">
    <!-- * Set default hyphenation, justification, and line-breaking -->
    <!-- * -->
    <!-- * If the value of man.hypenate is zero (the default), then -->
    <!-- * disable hyphenation (".nh" = "no hyphenation") -->
    <xsl:if test="$man.hyphenate = 0">
      <xsl:text>.\" disable hyphenation&#10;</xsl:text>
      <xsl:text>.nh&#10;</xsl:text>
    </xsl:if>
    <!-- * If the value of man.justify is zero (the default), then -->
    <!-- * disable justification (".ad l" means "adjust to left only") -->
    <xsl:if test="$man.justify = 0">
      <xsl:text>.\" disable justification</xsl:text>
      <xsl:text> (adjust text to left margin only)&#10;</xsl:text>
      <xsl:text>.ad l&#10;</xsl:text>
    </xsl:if>
    <!-- * Unless the value of man.break.after.slash is zero (the -->
    <!-- * default), tell groff that it is OK to break a line -->
    <!-- * after a slash when needed. -->
    <xsl:if test="$man.break.after.slash != 0">
      <xsl:text>.\" enable line breaks after slashes&#10;</xsl:text>
      <xsl:text>.cflags 4 /&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->

  <!-- * The prepare.manpage.contents template is called after -->
  <!-- * everything else has been done, just before writing the actual -->
  <!-- * man-page files to the filesystem. It works on the entire roff -->
  <!-- * source for each man page (not just the visible contents). -->
  <xsl:template name="prepare.manpage.contents">
    <xsl:param name="content" select="''"/>

    <!-- * First do "essential" string/character substitutions; for -->
    <!-- * example, the backslash character _must_ be substituted with -->
    <!-- * a double backslash, to prevent it from being interpreted as -->
    <!-- * a roff escape -->
    <xsl:variable name="adjusted.content">
      <xsl:choose>
        <xsl:when test="$man.string.subst.map.enabled != 0">
      <xsl:call-template name="apply-string-subst-map">
        <xsl:with-param name="content" select="$content"/>
        <xsl:with-param name="map.contents"
                        select="exsl:node-set($man.string.subst.map)/*"/>
      </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="replace-entities">
            <xsl:with-param name="content" select="$content"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- * Optionally, apply a character map to replace Unicode -->
    <!-- * symbols and special characters. -->
    <xsl:choose>
      <xsl:when test="$man.charmap.enabled != 0">
        <xsl:call-template name="apply-character-map">
          <xsl:with-param name="content" select="$adjusted.content"/>
          <xsl:with-param name="map.contents"
                          select="exsl:node-set($man.charmap.contents)/*"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- * if we reach here, value of $man.charmap.enabled is zero, -->
        <!-- * so we just pass the adjusted contents through "as is" -->
        <xsl:value-of select="$adjusted.content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================== -->
  
  <xsl:template name="write.man.file">
    <xsl:param name="name"/>
    <xsl:param name="section"/>
    <xsl:param name="content"/>
    <xsl:param name="filename">
      <xsl:call-template name="string.subst">
        <!-- replace spaces in source filename with underscores in output filename -->
        <xsl:with-param name="string"
                        select="concat(normalize-space($name), '.', normalize-space($section))"/>
        <xsl:with-param name="target" select="' '"/>
        <xsl:with-param name="replacement" select="'_'"/>
      </xsl:call-template>
    </xsl:param>
    <xsl:call-template name="write.text.chunk">
      <xsl:with-param name="filename" select="$filename"/>
      <xsl:with-param name="quiet" select="$man.output.quietly"/>
      <xsl:with-param name="encoding" select="$man.output.encoding"/>
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ============================================================== -->

  <!-- * A "stub" is sort of alias for another file, intended to be read -->
  <!-- * and expanded by soelim(1); it's simply a file whose complete -->
  <!-- * contents are just a single line of the following form: -->
  <!-- * -->
  <!-- *  .so manX/realname.X -->
  <!-- * -->
  <!-- * "realname" is a name of another man-page file. That .so line is -->
  <!-- * basically a roff "include" statement.  When the man command finds -->
  <!-- * it, it calls soelim(1) and includes and displays the contents of -->
  <!-- * the manX/realqname.X file. -->
  <!-- * -->
  <!-- * If a refentry has multiple refnames, we generate a "stub" page for -->
  <!-- * each refname found, except for the first one. -->
  <xsl:template name="write.stubs">
    <xsl:param name="first.refname"/>
    <xsl:param name="section"/>
    <xsl:for-each select="refnamediv/refname">
      <xsl:if test=". != $first.refname">
        <xsl:call-template name="write.text.chunk">
          <xsl:with-param name="filename"
                          select="concat(normalize-space(.), '.',
                                  $section)"/>
          <xsl:with-param name="quiet" select="$man.output.quietly"/>
          <xsl:with-param
              name="content"
              select="concat('.so man', $section, '/',
                      $first.refname, '.', $section, '&#10;')"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

<!-- ==================================================================== -->

<xsl:template name="replace-entities">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="replace-trademark">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-servicemark">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-registered">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-copyright">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-rsquo">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-lsquo">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-rdquo">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-ldquo">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-nbsp">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-apostrophe">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-an-break-flag">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-an-no-space-flag">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-an-trap">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-dash">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-comment-start">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-roman-start">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-ital-start">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-bold-start">
  <xsl:with-param name="content">
  <xsl:call-template name="replace-backslash">
  <xsl:with-param name="content" select="$content"/>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
  </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="replace-backslash">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'\'"/>
    <xsl:with-param name="replacement" select="'\\'"/>
  </xsl:call-template>
</xsl:template>

<!-- * after replacing backslashes, we need to restore -->
<!-- * single-backslashes in all roff requests (because the -->
<!-- * backslash substitution above doubled them) -->

<xsl:template name="replace-bold-start">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'\\fB'"/>
    <xsl:with-param name="replacement" select="'\fB'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-ital-start">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'\\fI'"/>
    <xsl:with-param name="replacement" select="'\fI'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-roman-start">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'\\fR'"/>
    <xsl:with-param name="replacement" select="'\fR'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-comment-start">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'.\\'"/>
    <xsl:with-param name="replacement">.\"</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<!-- * although the groff docs do not make it clear, it appears that -->
<!-- * the only way to get a non-breaking hyphen in roff is to put a -->
<!-- * backslash in front of it; and, unfortunately, groff is not smart -->
<!-- * about where it breaks things (for example, it'll break an -->
<!-- * argument for a command across a line, if that argument contains -->
<!-- * a dash/hyphen); so, we must globally change all hyphens to "\-" -->

<xsl:template name="replace-dash">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'-'"/>
    <xsl:with-param name="replacement" select="'\-'"/>
  </xsl:call-template>
</xsl:template>

<!-- * now we need to restore single-hypens in all roff requests -->
<!-- * (because dash substitution added backslashes before them) -->

<xsl:template name="replace-an-trap">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'.it 1 an\-trap'"/>
    <xsl:with-param name="replacement" select="'.it 1 an-trap'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-an-no-space-flag">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'.nr an\-no\-space\-flag 1'"/>
    <xsl:with-param name="replacement" select="'.nr an-no-space-flag 1'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-an-break-flag">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'.nr an\-break\-flag 1'"/>
    <xsl:with-param name="replacement" select="'.nr an-break-flag 1'"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<!-- * an apostrophe at the beginning of a line gets interpreted as a -->
<!-- * roff request (groff(7) says it is "the non-breaking control -->
<!-- * character"); so we must add backslash before any apostrophe -->
<!-- * found at the start of a line -->
<xsl:template name="replace-apostrophe">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target">&#10;'</xsl:with-param>
    <xsl:with-param name="replacement">&#10;\'</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<!-- * The remaining substitutions are all for characters that -->
<!-- * the DocBook XSL stylesheets themselves generate under -->
<!-- * certain circumstances; so we deal with them here so -->
<!-- * that we can ensure they will always be replaced, even -->
<!-- * if man.charmap.enabled is zero. -->

<!-- * A no-break space can be written two ways in roff; the difference, -->
<!-- * according to the "Page Motions" node in the groff info page, ixsl: -->
<!-- * -->
<!-- *   "\ " = -->
<!-- *   An unbreakable and unpaddable (i.e. not expanded during filling) -->
<!-- *   space. -->
<!-- * -->
<!-- *   "\~" = -->
<!-- *   An unbreakable space that stretches like a normal -->
<!-- *   inter-word space when a line is adjusted."  -->
<!-- * -->
<!-- * Unfortunately, roff seems to do some weird things with long -->
<!-- * lines that only have words separated by "\~" spaces, so it's -->
<!-- * safer just to stick with the "\ " space -->
<xsl:template name="replace-nbsp">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'&#x00a0;'"/>
    <xsl:with-param name="replacement" select="'\ '"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-ldquo">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'&#x201c;'"/>
    <xsl:with-param name="replacement" select="'\(lq'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-rdquo">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'&#x201d;'"/>
    <xsl:with-param name="replacement" select="'\(rq'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-lsquo">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'&#x2018;'"/>
    <xsl:with-param name="replacement" select="'\(oq'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-rsquo">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'&#x2019;'"/>
    <xsl:with-param name="replacement" select="'\(cq'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-copyright">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'&#x00a9;'"/>
    <xsl:with-param name="replacement" select="'\(co'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-registered">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'&#x00ae;'"/>
    <xsl:with-param name="replacement" select="'\(rg'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="replace-servicemark">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'&#x2120;'"/>
    <xsl:with-param name="replacement" select="'(SM)'"/>
  </xsl:call-template>
</xsl:template>

<!-- * trademark -->
<!-- * we don't do "\(tm" because for console output -->
<!-- * because groff just renders that as "tm"; that is: -->
<!-- * -->
<!-- *   Product&#x2122; -> Producttm -->
<!-- * -->
<!-- * So we just make it to "(TM)" instead; thus: -->
<!-- * -->
<!-- *   Product&#x2122; -> Product(TM) -->
<xsl:template name="replace-trademark">
  <xsl:param name="content" select="''"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target" select="'&#x2122;'"/>
    <xsl:with-param name="replacement" select="'(TM)'"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
