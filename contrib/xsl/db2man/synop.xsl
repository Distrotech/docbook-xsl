<?xml version='1.0'?>
<!-- vim:set sts=2 shiftwidth=2 syntax=sgml: -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:template match="synopfragment">
<xsl:text>&#10;.PP&#10;</xsl:text>
<xsl:apply-templates/>
</xsl:template>
<!--
  there's a bug were an <arg> that's not inside a <group> isn't made bold
-->

<xsl:template match="group|arg">
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
  <xsl:if test="position()>1"><xsl:value-of select="$sepchar"/></xsl:if>
  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <!-- do nothing -->
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
  <xsl:value-of select="normalize-space($arg)"/>
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
  <xsl:if test="position()>1">
    <xsl:value-of select="$arg.or.sep"/>
  </xsl:if>
  <!-- Don't use the 'bold' named template here since there may be -->
  <!-- child elements that require different markup (such as       -->
  <!-- <replaceable>).                                             -->
  <xsl:text>\fB</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>\fR</xsl:text>
</xsl:template>

<xsl:template match="command">
  <xsl:apply-templates mode="bold" select="."/>
</xsl:template>

<xsl:template match="function[not(ancestor::command)]">
  <xsl:apply-templates mode="bold" select="."/>
</xsl:template>

<xsl:template match="parameter[not(ancestor::command)]">
  <xsl:apply-templates mode="italic" select="."/>
</xsl:template>

<xsl:template match="sbr">
  <xsl:variable name="cmd" select="ancestor::cmdsynopsis/command"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:value-of select="translate($cmd,$cmd,'                        ')"/>
</xsl:template>

<xsl:template name="wrap-cmd">
  <xsl:param name="indent" select="''"/>
  <xsl:param name="text" select="''"/>
  <xsl:param name="allow" select="75"/>
  <xsl:param name="width" select="$allow - string-length($indent)"/>
  <xsl:variable name="total" select="string-length($text)"/>
  <xsl:variable name="split"
                select="substring($text,$width+1,$total - $width)"/>
  <xsl:variable name="fragment" select="substring-before($split,' ')"/>
  <xsl:variable name="line">
    <xsl:value-of select="substring($text,1,$width)"/>
    <xsl:choose>
      <xsl:when test="$fragment!=''">
        <xsl:value-of select="$fragment"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$split"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$split=''">
      <xsl:value-of select="$line"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$line"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="$indent"/>
      <xsl:variable name="done" select="string-length($line)"/>
      <xsl:variable name="remaining" select="$total - $done + 1"/>
      <xsl:call-template name="wrap-cmd">
        <xsl:with-param name="indent" select="$indent"/>
        <xsl:with-param name="text"
                        select="substring($text,1+$done,$remaining)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="cmdsynopsis">
  <xsl:text>&#10;.nf&#10;</xsl:text>
  <xsl:choose>
    <xsl:when test=".//sbr">
      <!-- The author has put explicit formatting hints in for us. -->
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <!-- Try to do some smart formatting. -->
      <xsl:variable name="cmdsynopsis">
        <xsl:apply-templates/>
      </xsl:variable>
      <xsl:variable name="cmd" select="command"/>
      <xsl:variable name="indent"
                    select="translate($cmd,$cmd,'                         ')"/>
      <xsl:text>\fB</xsl:text>
      <xsl:value-of select="$cmd"/><xsl:text>\fR </xsl:text>
      <xsl:call-template name="wrap-cmd">
        <xsl:with-param name="indent" select="$indent"/>
        <xsl:with-param name="text" select="substring-after($cmdsynopsis,' ')"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;.fi&#10;</xsl:text>
</xsl:template>

<xsl:template match="synopsis">
  <xsl:text>&#10;.nf&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;.fi&#10;</xsl:text>
</xsl:template>

<!-- TODO: Handle K&R-style parameter lists -->
<xsl:template match="paramdef">
  <xsl:choose>
    <xsl:when test="position() > 2">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> (</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="void">
  <xsl:text> (void</xsl:text>
</xsl:template>

<xsl:template match="varargs">
  <xsl:text> (...</xsl:text>
</xsl:template>

<xsl:template name="wrap-fn">
  <xsl:param name="indent" select="''"/>
  <xsl:param name="text" select="''"/>
  <xsl:variable name="total" select="string-length($text)"/>
  <xsl:variable name="param" select="substring-before($text,',')"/>
  <xsl:choose>
    <xsl:when test="$param=''">
      <xsl:value-of select="$text"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$param"/>
      <xsl:text>,&#10;</xsl:text>
      <xsl:value-of select="$indent"/>
      <xsl:variable name="done" select="string-length($param)"/>
      <xsl:variable name="remaining" select="$total - $done + 1"/>
      <xsl:call-template name="wrap-fn">
        <xsl:with-param name="indent" select="$indent"/>
        <xsl:with-param name="text"
                        select="substring($text,2+$done,$remaining)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="funcsynopsisinfo">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;.sp&#10;</xsl:text>
</xsl:template>

<xsl:template match="funcsynopsis">
  <xsl:text>.nf&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>.fi&#10;</xsl:text>
</xsl:template>

<xsl:template match="funcprototype">
  <xsl:variable name="fnprototype">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="funcprototype" select="normalize-space($fnprototype)"/>
  <xsl:variable name="fn"
       select="substring-before($funcprototype,'(')"/>
  <xsl:variable name="indent"
                select="translate($fn,$fn,'                               ')"/>
  <xsl:text>.sp&#10;</xsl:text>
  <xsl:value-of select="substring-before($funcprototype,'(')"/>
  <xsl:text>(</xsl:text>
  <xsl:call-template name="wrap-fn">
    <xsl:with-param name="indent"
    select="substring($indent,1,string-length($indent) - 6)"/>
    <xsl:with-param name="text"
                    select="substring-after($funcprototype,'(')"/>
  </xsl:call-template>
  <xsl:text>);&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
