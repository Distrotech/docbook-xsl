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

<xsl:variable name="arg.or.sep"> |</xsl:variable>

<!-- * Note: If you're looking for the *Synopsis* element, you won't -->
<!-- * find any code here for handling it. It's a "verbatim" -->
<!-- * environment; see the block.xsl file instead. -->

<xsl:template match="synopfragmentref">
  <xsl:variable name="target" select="key('id',@linkend)"/>
  <xsl:variable name="snum">
    <xsl:apply-templates select="$target" mode="synopfragment.number"/>
  </xsl:variable>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="$snum"/>
  <xsl:text>)</xsl:text>
  <xsl:text>&#x2580;</xsl:text>
  <xsl:call-template name="italic">
    <xsl:with-param name="node" select="exsl:node-set(normalize-space(.))"/>
    <xsl:with-param name="context" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="synopfragment" mode="synopfragment.number">
  <xsl:number format="1"/>
</xsl:template>

<xsl:template match="synopfragment">
  <xsl:variable name="snum">
    <xsl:apply-templates select="." mode="synopfragment.number"/>
  </xsl:variable>
  <xsl:text>&#10;</xsl:text>
  <!-- * If we have a group of Synopfragments, we only want to output a -->
  <!-- * line of space before the first; so when we find a Synopfragment -->
  <!-- * whose first preceding sibling is another Synopfragment, we back -->
  <!-- * up one line vertically to negate the line of vertical space -->
  <!-- * that's added by the .HP macro -->
  <xsl:if test="preceding-sibling::*[1][self::synopfragment]">
    <xsl:text>.sp -1&#10;</xsl:text>
  </xsl:if>
  <xsl:text>.HP </xsl:text>
  <!-- * For each Synopfragment, make a hanging paragraph, with the -->
  <!-- * indent calculated from the length of the generated number -->
  <!-- * used as a reference + pluse 3 characters (for the open and -->
  <!-- * close parens around the number, plus a space). -->
  <xsl:value-of select="string-length (normalize-space ($snum)) + 3"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="$snum"/>
  <xsl:text>)</xsl:text>
  <xsl:text> </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="group|arg" name="group-or-arg">
  <xsl:variable name="choice" select="@choice"/>
  <xsl:variable name="rep" select="@rep"/>
  <xsl:variable name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*/@sepchar">
        <xsl:value-of select="ancestor-or-self::*/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="position()>1 and
                not(preceding-sibling::*[1][self::sbr])"
          ><xsl:value-of select="$sepchar"/></xsl:if>
  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <!-- * do nothing -->
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.open.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.open.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.open.str"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:variable name="arg">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="local-name(.) = 'arg' and not(ancestor::arg)">
      <!-- * Prevent arg contents from getting wrapped and broken up -->
      <xsl:variable name="arg.wrapper">
        <Arg><xsl:value-of select="normalize-space($arg)"/></Arg>
      </xsl:variable>
      <xsl:apply-templates mode="prevent.line.breaking"
                           select="exsl:node-set($arg.wrapper)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="$rep='repeat'">
      <xsl:value-of select="$arg.rep.repeat.str"/>
    </xsl:when>
    <xsl:when test="$rep='norepeat'">
      <xsl:value-of select="$arg.rep.norepeat.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.rep.def.str"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <xsl:if test='arg'>
      <xsl:value-of select="$arg.choice.plain.close.str"/>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.close.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.close.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.close.str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="group/arg">
  <xsl:variable name="choice" select="@choice"/>
  <xsl:variable name="rep" select="@rep"/>
  <xsl:if test="position()>1"><xsl:value-of select="$arg.or.sep"/></xsl:if>
  <xsl:call-template name="group-or-arg"/>
</xsl:template>

<xsl:template match="sbr">
  <xsl:text>&#x2592;</xsl:text>
  <xsl:text>.br&#x2592;</xsl:text>
</xsl:template>

<xsl:template match="cmdsynopsis">
  <!-- * if justification is enabled by default, turn it off temporarily -->
  <xsl:if test="$man.justify != 0">
    <xsl:text>.ad l&#10;</xsl:text>
  </xsl:if>
  <!-- * if hyphenation is enabled by default, turn it off temporarily -->
  <xsl:if test="$man.hyphenate != 0">
    <xsl:text>.hy 0&#10;</xsl:text>
  </xsl:if>
  <xsl:text>.HP </xsl:text>
  <xsl:value-of select="string-length (normalize-space (command)) + 1"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
  <!-- * if justification is enabled by default, turn it back on -->
  <xsl:if test="$man.justify != 0">
    <xsl:text>.ad&#10;</xsl:text>
  </xsl:if>
  <!-- * if hyphenation is enabled by default, turn it back on -->
  <xsl:if test="$man.hyphenate != 0">
    <xsl:text>.hy&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->
<!-- *  Funcsynopis hierarchy starts here -->
<!-- ==================================================================== -->

<!-- * Note: If you're looking for the *Funcsynopsisinfo* element, -->
<!-- * you won't find any code here for handling it. It's a "verbatim" -->
<!-- * environment; see the block.xsl file instead. -->

<!-- * Within funcsynopis output, disable hyphenation, and use -->
<!-- * left-aligned filling for the duration of the synopsis, so that -->
<!-- * line breaks only occur between separate paramdefs. -->
<xsl:template match="funcsynopsis">
  <!-- * if justification is enabled by default, turn it off temporarily -->
  <xsl:if test="$man.justify != 0">
    <xsl:text>.ad l&#10;</xsl:text>
  </xsl:if>
  <!-- * if hyphenation is enabled by default, turn it off temporarily -->
  <xsl:if test="$man.hyphenate != 0">
    <xsl:text>.hy 0&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <!-- * if justification is enabled by default, turn it back on -->
  <xsl:if test="$man.justify != 0">
    <xsl:text>.ad&#10;</xsl:text>
  </xsl:if>
  <!-- * if hyphenation is enabled by default, turn it back on -->
  <xsl:if test="$man.hyphenate != 0">
    <xsl:text>.hy&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- * In HTML output, placing a dbfunclist PI as a child of a particular -->
<!-- * element creates a hyperlinked list of all funcsynopsis instances -->
<!-- * that are descendants of that element. But we can’t really do this -->
<!-- * kind of hyperlinked list in manpages output, so we just need to -->
<!-- * suppress it instead. -->
<xsl:template match="processing-instruction('dbfunclist')"/>

<!-- * ***************************************************************** -->
<!-- *           Note about boldface in funcprototype output -->
<!-- * ***************************************************************** -->
<!-- * All funcprototype content is by default rendered in bold, -->
<!-- * because the man(7) man page says this: -->
<!-- * -->
<!-- *   For functions, the arguments are always specified using -->
<!-- *   italics, even in the SYNOPSIS section, where the rest of -->
<!-- *   the function is specified in bold -->
<!-- * -->
<!-- * Look through the contents of the man/man2 and man3 directories -->
<!-- * on your system, and you'll see that most existing pages do follow -->
<!-- * this "bold everything in function synopsis" rule. -->
<!-- * -->
<!-- * Users who don't want the bold output can choose to adjust the -->
<!-- * man.font.funcprototype parameter on their own. So even if you -->
<!-- * don't personally like the way it looks, please don't change the -->
<!-- * default to be non-bold - because it's a convention that's -->
<!-- * followed is the vast majority of existing man pages that document -->
<!-- * functions, and we need to follow it by default, like it or no. -->
<!-- * ***************************************************************** -->

<xsl:template match="funcprototype">
  <xsl:variable name="man-funcprototype-style">
    <xsl:call-template name="pi.dbman_funcsynopsis-style">
      <xsl:with-param name="node" select="ancestor::funcsynopsis/descendant-or-self::*"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="style">
    <xsl:choose>
      <xsl:when test="not($man-funcprototype-style = '')">
        <xsl:value-of select="$man-funcprototype-style"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$man.funcsynopsis.style"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="funcprototype.string.value">
    <xsl:value-of select="funcdef"/>
  </xsl:variable>
  <xsl:variable name="funcprototype">
    <xsl:apply-templates select="funcdef"/>
  </xsl:variable>
  <xsl:text>.HP </xsl:text>
  <!-- * Hang Paragraph by length of string value of <funcdef> + 1 -->
  <!-- * (because funcdef is always followed by one open paren char) -->
  <xsl:value-of select="string-length (normalize-space ($funcprototype.string.value)) + 1"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:call-template name="verbatim-block-start"/>
  <xsl:text>.</xsl:text>
  <xsl:value-of select="$man.font.funcprototype"/>
  <xsl:text> </xsl:text>
  <!-- * The following quotation mark (and the one further below) are -->
  <!-- * needed to properly delimit the parts of the Funcprototype that -->
  <!-- * should be rendered in the prevailing font (either Bold or Roman) -->
  <!-- * from Parameter output that needs to be alternately rendered in -->
  <!-- * italic. -->
  <xsl:text>"</xsl:text>
  <xsl:value-of select="normalize-space($funcprototype)"/>
  <xsl:text>(</xsl:text>
  <xsl:choose>
    <xsl:when test="not($style = 'ansi')">
      <xsl:apply-templates select="*[local-name() != 'funcdef']" mode="kr"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="*[local-name() != 'funcdef']" mode="ansi"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>"</xsl:text>
  <xsl:text>&#10;</xsl:text>
  <xsl:if test="paramdef and not($style = 'ansi')">
    <!-- * if we have any paramdef instances in this funcprototype and -->
    <!-- * the user has chosen K&R style output (by specifying some style -->
    <!-- * value other than the default 'ansi'), then we need to generate -->
    <!-- * the separate list of param definitions for this funcprototype -->
    <!-- * -->
    <!-- * we put a blank line after the prototype and before the list, -->
    <!-- * and we indent the list by whatever width $list-indent is set -->
    <!-- * to (4 spaces by default) -->
    <xsl:text>.sp&#10;</xsl:text>
    <xsl:text>.RS</xsl:text> 
    <xsl:if test="not($list-indent = '')">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$list-indent"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="paramdef" mode="kr-paramdef-list"/>
    <xsl:text>.RE&#10;</xsl:text>
  </xsl:if>
  <xsl:call-template name="verbatim-block-end"/>
</xsl:template>

<xsl:template match="funcdef">
  <xsl:apply-templates mode="prevent.line.breaking"/>
</xsl:template>

<xsl:template match="funcdef/function">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="void" mode="kr">
  <xsl:text>);</xsl:text>
</xsl:template>

<xsl:template match="varargs" mode="kr">
  <xsl:text>...);</xsl:text>
</xsl:template>

<xsl:template match="void" mode="ansi">
  <xsl:text>void);</xsl:text>
</xsl:template>

<xsl:template match="varargs" mode="ansi">
  <xsl:text>...);</xsl:text>
</xsl:template>

<xsl:template match="paramdef" mode="kr">
  <!-- * in K&R-style output, the prototype just contains the parameter -->
  <!-- * names - because the parameter definitions for each parameter -->
  <!-- * (including the type information) are displayed in a separate -->
  <!-- * list following the prototype; so in this mode (which is for the -->
  <!-- * prototype, not the separate list), we first just want to grab -->
  <!-- * the parameter for each paramdef -->
  <xsl:variable name="contents">
    <xsl:apply-templates select="parameter"/>
  </xsl:variable>
  <xsl:apply-templates mode="prevent.line.breaking" select="exsl:node-set($contents)"/>
  <xsl:choose>
    <xsl:when test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>);</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="paramdef" mode="ansi">
  <!-- * in ANSI-style output, the prototype contains the complete -->
  <!-- * parameter definitions for each parameter (there is no separate -->
  <!-- * list of parameter definitions like the one for K&R style -->
  <xsl:apply-templates mode="prevent.line.breaking" select="."/>
  <xsl:choose>
    <xsl:when test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>);</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="paramdef" mode="kr-paramdef-list">
  <!-- * this mode is for generating the separate list of parameter -->
  <!-- * definitions in K&R-style output -->
  <xsl:text>.br&#10;</xsl:text>
  <xsl:text>.</xsl:text>
  <xsl:value-of select="$man.font.funcprototype"/>
  <xsl:text> </xsl:text>
  <!-- * The following quotation mark (and the one further below) are -->
  <!-- * needed to properly delimit the parts of the Funcprototype that -->
  <!-- * should be rendered in the prevailing font (either Bold or Roman) -->
  <!-- * from Parameter output that needs to be alternately rendered in -->
  <!-- * italic. -->
  <xsl:text>"</xsl:text>
  <xsl:variable name="contents">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($contents)"/>
  <xsl:text>;</xsl:text>
  <xsl:text>"</xsl:text>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="paramdef/parameter">
  <!-- * We use U+2591 here in place of a normal space, because if we -->
  <!-- * were to just use a normal space, it would get replaced with a -->
  <!-- * non-breaking space when we run the whole Paramdef through the -->
  <!-- * prevent.line.breaking template. And as far as why we're -->
  <!-- * inserting the space and quotation marks around each Parameter -->
  <!-- * to begin with, the reason is that we need to because we are -->
  <!-- * outputting Funcsynopsis in either the "BI" or "RI" font, and -->
  <!-- * the space and quotation marks delimit the text as the -->
  <!-- * "alternate" or "I" text that needs to be rendered in italic. -->
  <xsl:text>"&#x2591;"</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>"&#x2591;"</xsl:text>
</xsl:template>

<xsl:template match="funcparams">
  <xsl:text>(</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>)</xsl:text>
</xsl:template>

</xsl:stylesheet>
