<?xml version="1.0"?>
<axsl:stylesheet
  xmlns:axsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dbk="http://docbook.org/ns/docbook"
  xmlns:rnd="http://docbook.org/ns/docbook/roundtrip"
  version="2.0">
  
  <!-- ********************************************************************
       **** sections2blocks.xsl 2012-08-11 Steve Ball ********************
       ********************************************************************
       
       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://nwalsh.com/docbook/xsl/ for copyright
       and other information.
       
       ******************************************************************** -->
  
  <axsl:output indent="yes"/>
  <axsl:strip-space elements="*"/>
  <axsl:preserve-space elements="dbk:para dbk:emphasis"/>

  <axsl:template
    match="dbk:appendix | dbk:article |  dbk:book | dbk:chapter | dbk:part | dbk:preface | dbk:section |
                        dbk:sect1 | dbk:sect2 | dbk:sect3 | dbk:sect4 | dbk:sect5">

    <axsl:variable name="subsections"
      select="dbk:para[@rnd:style = ('bibliography', 'bibliography-title', 'glossary', 'glossary-title', 'qandaset', 'qandaset-title')]"/>
    <axsl:copy>
      <axsl:apply-templates select="@*"/>
      <axsl:choose>
        <axsl:when test="$subsections">
          <axsl:apply-templates select="$subsections[1]/preceding-sibling::node()"/>
          <axsl:apply-templates select="$subsections[1]" mode="subsections">
            <axsl:with-param name="subsections" select="$subsections[position() != 1]"/>
          </axsl:apply-templates>
        </axsl:when>
        <axsl:when
          test="dbk:appendix | dbk:article | dbk:book | dbk:chapter | dbk:part | dbk:preface | dbk:section | dbk:sect1 | dbk:sect2 | dbk:sect3 | dbk:sect4 | dbk:sect5">
          <axsl:apply-templates
            select="*[self::dbk:appendix | self::dbk:article | self::dbk:book | self::dbk:chapter | self::dbk:part | self::dbk:preface | self::dbk:section | self::dbk:sect1 | self::dbk:sect2 | self::dbk:sect3 | self::dbk:sect4 | self::dbk:sect5][1]/preceding-sibling::node()"/>
          <axsl:apply-templates
            select="dbk:appendix | dbk:article | dbk:book | dbk:chapter | dbk:part | dbk:preface | dbk:section | dbk:sect1 | dbk:sect2 | dbk:sect3 | dbk:sect4 | dbk:sect5"
          />
        </axsl:when>
        <axsl:otherwise>
          <axsl:apply-templates/>
        </axsl:otherwise>
      </axsl:choose>
    </axsl:copy>
    <axsl:choose>
      <axsl:when
        test="following-sibling::*[self::dbk:appendix | self::dbk:article | self::dbk:book | self::dbk:chapter | self::dbk:part | self::dbk:preface | self::dbk:section | self::dbk:sect1 | self::dbk:sect2 | self::dbk:sect3 | self::dbk:sect4 | self::dbk:sect5]
        | following-sibling::dbk:para[@rnd:style = ('bibliography', 'bibliography-title', 'glossary', 'glossary-title', 'qandaset', 'qandaset-title')]">
        <axsl:variable name="nextComponent"
          select="following-sibling::*[self::dbk:appendix | self::dbk:article | self::dbk:book | self::dbk:chapter | self::dbk:part | self::dbk:preface | self::dbk:section | self::dbk:sect1 | self::dbk:sect2 | self::dbk:sect3 | self::dbk:sect4 | self::dbk:sect5|self::dbk:para[@rnd:style = ('bibliography', 'bibliography-title', 'glossary', 'glossary-title', 'qandaset', 'qandaset-title')]][1]"/>
        <axsl:apply-templates
          select="following-sibling::*[generate-id(following-sibling::*[self::dbk:appendix | self::dbk:article | self::dbk:book | self::dbk:chapter | self::dbk:part | self::dbk:preface | self::dbk:section | self::dbk:sect1 | self::dbk:sect2 | self::dbk:sect3 | self::dbk:sect4 | self::dbk:sect5|self::dbk:para[@rnd:style = ('bibliography', 'bibliography-title', 'glossary', 'glossary-title','qandaset', 'qandaset-title')]][1]) = generate-id($nextComponent)]"
        />
      </axsl:when>
      <axsl:otherwise>
        <axsl:apply-templates select="following-sibling::*"/>
      </axsl:otherwise>
    </axsl:choose>
  </axsl:template>

  <axsl:template match="dbk:para" mode="subsections">
    <axsl:param name="subsections" select="/.."/>
    <axsl:choose>
      <axsl:when test="@rnd:style = ('bibliography', 'bibliography-title')">
        <bibliography xmlns="http://docbook.org/ns/docbook">
          <axsl:call-template name="copy"/>
          <axsl:variable name="bibliodivs"
            select="following-sibling::dbk:para[@rnd:style = ('bibliodiv', 'bibliodiv-title')]"/>
          <axsl:choose>
            <axsl:when test="$bibliodivs">
              <axsl:apply-templates select="following-sibling::*[1]" mode="bibliodivs">
                <axsl:with-param name="nextSubsection" select="$subsections[1]"/>
                <axsl:with-param name="bibliodivs" select="$bibliodivs[position() != 1]"/>
              </axsl:apply-templates>
            </axsl:when>
            <axsl:otherwise>
              <axsl:apply-templates select="following-sibling::*[1]" mode="terminal">
                <axsl:with-param name="nextSubsection" select="$subsections[1]"/>
              </axsl:apply-templates>
            </axsl:otherwise>
          </axsl:choose>
        </bibliography>
      </axsl:when>
      <axsl:when test="@rnd:style = ('glossary', 'glossary-title')">
        <glossary xmlns="http://docbook.org/ns/docbook">
          <axsl:call-template name="copy"/>
          <axsl:variable name="glossdivs"
            select="following-sibling::dbk:para[@rnd:style = ('glossdiv', 'glossdiv-title')]"/>
          <axsl:choose>
            <axsl:when test="$glossdivs">
              <axsl:apply-templates select="following-sibling::*[1]" mode="glossdivs">
                <axsl:with-param name="nextSubsection" select="$subsections[1]"/>
                <axsl:with-param name="glossdivs" select="$glossdivs[position() != 1]"/>
              </axsl:apply-templates>
            </axsl:when>
            <axsl:otherwise>
              <axsl:apply-templates select="following-sibling::*[1]" mode="terminal">
                <axsl:with-param name="nextSubsection" select="$subsections[1]"/>
              </axsl:apply-templates>
            </axsl:otherwise>
          </axsl:choose>
        </glossary>
      </axsl:when>
      <axsl:when test="@rnd:style = ('qandaset', 'qandaset-title')">
        <qandaset xmlns="http://docbook.org/ns/docbook">
          <axsl:call-template name="copy"/>
          <axsl:variable name="qandadivs"
            select="following-sibling::dbk:para[@rnd:style =( 'qandadiv', 'qandadiv-title')]"/>
          <axsl:choose>
            <axsl:when test="$qandadivs">
              <axsl:apply-templates select="following-sibling::*[1]" mode="qandadivs">
                <axsl:with-param name="nextSubsection" select="$subsections[1]"/>
                <axsl:with-param name="qandadivs" select="$qandadivs[position() != 1]"/>
              </axsl:apply-templates>
            </axsl:when>
            <axsl:otherwise>
              <axsl:apply-templates select="following-sibling::*[1]" mode="terminal">
                <axsl:with-param name="nextSubsection" select="$subsections[1]"/>
              </axsl:apply-templates>
            </axsl:otherwise>
          </axsl:choose>
        </qandaset>
      </axsl:when>
    </axsl:choose>
  </axsl:template>

  <axsl:template match="*" mode="subsections">
    <axsl:param name="subsections" select="/.."/>
    <axsl:copy>
      <axsl:apply-templates select="@*"/>
      <axsl:apply-templates mode="subsections"/>
    </axsl:copy>
  </axsl:template>

  <axsl:template match="dbk:para" mode="bibliodivs">
    <axsl:param name="nextSubsection" select="/.."/>
    <axsl:param name="bibliodivs" select="/.."/>
    <axsl:choose>
      <axsl:when test="generate-id() = generate-id($nextSubsection)"/>
      <axsl:when test="@rnd:style = ('bibliodiv', 'bibliodiv-title')">
        <bibliodiv xmlns="http://docbook.org/ns/docbook">
          <axsl:call-template name="copy"/>
          <axsl:apply-templates select="following-sibling::*[1]" mode="terminal">
            <axsl:with-param name="nextSubsection" select="$nextSubsection"/>
            <axsl:with-param name="nextbibliodiv" select="$bibliodivs[1]"/>
          </axsl:apply-templates>
        </bibliodiv>
        <axsl:choose>
          <axsl:when
            test="$nextSubsection and $bibliodivs and count($nextSubsection/preceding-sibling::* | $bibliodivs[1]) = count($nextSubsection/preceding-sibling::*)">
            <axsl:apply-templates select="$bibliodivs[1]" mode="bibliodivs">
              <axsl:with-param name="nextSubsection" select="$nextSubsection"/>
              <axsl:with-param name="bibliodivs" select="$bibliodivs[position() != 1]"/>
            </axsl:apply-templates>
          </axsl:when>
          <axsl:when test="$bibliodivs">
            <axsl:apply-templates select="$bibliodivs[1]" mode="bibliodivs">
              <axsl:with-param name="bibliodivs" select="$bibliodivs[position() != 1]"/>
            </axsl:apply-templates>
          </axsl:when>
        </axsl:choose>
      </axsl:when>
      <axsl:otherwise>
        <axsl:call-template name="copy"/>
        <axsl:apply-templates select="following-sibling::*[1]" mode="bibliodivs">
          <axsl:with-param name="nextSubsection" select="$nextSubsection"/>
        </axsl:apply-templates>
      </axsl:otherwise>
    </axsl:choose>
  </axsl:template>

  <axsl:template match="dbk:para" mode="glossdivs">
    <axsl:param name="nextSubsection" select="/.."/>
    <axsl:param name="glossdivs" select="/.."/>
    <axsl:choose>
      <axsl:when test="generate-id() = generate-id($nextSubsection)"/>
      <axsl:when test="@rnd:style =( 'glossdiv', 'glossdiv-title')">
        <glossdiv xmlns="http://docbook.org/ns/docbook">
          <axsl:call-template name="copy"/>
          <axsl:apply-templates select="following-sibling::*[1]" mode="terminal">
            <axsl:with-param name="nextSubsection" select="$nextSubsection"/>
            <axsl:with-param name="nextglossdiv" select="$glossdivs[1]"/>
          </axsl:apply-templates>
        </glossdiv>
        <axsl:choose>
          <axsl:when
            test="$nextSubsection and $glossdivs and count($nextSubsection/preceding-sibling::* | $glossdivs[1]) = count($nextSubsection/preceding-sibling::*)">
            <axsl:apply-templates select="$glossdivs[1]" mode="glossdivs">
              <axsl:with-param name="nextSubsection" select="$nextSubsection"/>
              <axsl:with-param name="glossdivs" select="$glossdivs[position() != 1]"/>
            </axsl:apply-templates>
          </axsl:when>
          <axsl:when test="$glossdivs">
            <axsl:apply-templates select="$glossdivs[1]" mode="glossdivs">
              <axsl:with-param name="glossdivs" select="$glossdivs[position() != 1]"/>
            </axsl:apply-templates>
          </axsl:when>
        </axsl:choose>
      </axsl:when>
      <axsl:otherwise>
        <axsl:call-template name="copy"/>
        <axsl:apply-templates select="following-sibling::*[1]" mode="glossdivs">
          <axsl:with-param name="nextSubsection" select="$nextSubsection"/>
        </axsl:apply-templates>
      </axsl:otherwise>
    </axsl:choose>
  </axsl:template>

  <axsl:template match="dbk:para" mode="qandadivs">
    <axsl:param name="nextSubsection" select="/.."/>
    <axsl:param name="qandadivs" select="/.."/>
    <axsl:choose>
      <axsl:when test="generate-id() = generate-id($nextSubsection)"/>
      <axsl:when test="@rnd:style = ('qandadiv', 'qandadiv-title')">
        <qandadiv xmlns="http://docbook.org/ns/docbook">
          <axsl:call-template name="copy"/>
          <axsl:apply-templates select="following-sibling::*[1]" mode="terminal">
            <axsl:with-param name="nextSubsection" select="$nextSubsection"/>
            <axsl:with-param name="nextqandadiv" select="$qandadivs[1]"/>
          </axsl:apply-templates>
        </qandadiv>
        <axsl:choose>
          <axsl:when
            test="$nextSubsection and $qandadivs and count($nextSubsection/preceding-sibling::* | $qandadivs[1]) = count($nextSubsection/preceding-sibling::*)">
            <axsl:apply-templates select="$qandadivs[1]" mode="qandadivs">
              <axsl:with-param name="nextSubsection" select="$nextSubsection"/>
              <axsl:with-param name="qandadivs" select="$qandadivs[position() != 1]"/>
            </axsl:apply-templates>
          </axsl:when>
          <axsl:when test="$qandadivs">
            <axsl:apply-templates select="$qandadivs[1]" mode="qandadivs">
              <axsl:with-param name="qandadivs" select="$qandadivs[position() != 1]"/>
            </axsl:apply-templates>
          </axsl:when>
        </axsl:choose>
      </axsl:when>
      <axsl:otherwise>
        <axsl:call-template name="copy"/>
        <axsl:apply-templates select="following-sibling::*[1]" mode="qandadivs">
          <axsl:with-param name="nextSubsection" select="$nextSubsection"/>
        </axsl:apply-templates>
      </axsl:otherwise>
    </axsl:choose>
  </axsl:template>

  <axsl:template match="*" mode="terminal">
    <axsl:param name="nextSubsection" select="/.."/>
    <axsl:param name="nextbibliodiv" select="/.."/>
    <axsl:param name="nextglossdiv" select="/.."/>
    <axsl:param name="nextqandadiv" select="/.."/>
    <axsl:choose>
      <axsl:when test="generate-id() = generate-id($nextSubsection)"/>
      <axsl:when test="generate-id() = generate-id($nextbibliodiv)"/>
      <axsl:when test="generate-id() = generate-id($nextglossdiv)"/>
      <axsl:when test="generate-id() = generate-id($nextqandadiv)"/>
      <axsl:otherwise>
        <axsl:call-template name="copy"/>
        <axsl:apply-templates select="following-sibling::*[1]" mode="terminal">
          <axsl:with-param name="nextSubsection" select="$nextSubsection"/>
          <axsl:with-param name="nextbibliodiv" select="$nextbibliodiv"/>
          <axsl:with-param name="nextglossdiv" select="$nextglossdiv"/>
          <axsl:with-param name="nextqandadiv" select="$nextqandadiv"/>
        </axsl:apply-templates>
      </axsl:otherwise>
    </axsl:choose>
  </axsl:template>

  <axsl:template match="*">
    <axsl:copy>
      <axsl:apply-templates select="@*"/>
      <axsl:apply-templates/>
    </axsl:copy>
  </axsl:template>

  <axsl:template name="copy">
    <axsl:copy>
      <axsl:apply-templates select="@*"/>
      <axsl:apply-templates/>
    </axsl:copy>
  </axsl:template>

  <axsl:template match="@*">
    <axsl:copy/>
  </axsl:template>
</axsl:stylesheet>
