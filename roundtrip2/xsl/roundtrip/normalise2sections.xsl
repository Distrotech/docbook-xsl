<axsl:stylesheet version="2.0"
    xmlns:axsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:f="http://function.com/f"
    xmlns:dbk="http://docbook.org/ns/docbook"
    xmlns:rnd="http://docbook.org/ns/docbook/roundtrip"
    exclude-result-prefixes="xs f ">
    
    <axsl:param name="section" as="xs:string" select="'sect'"/>
    <axsl:param name="sectionNum" as="xs:string" select="'-title'"/>
    
    <axsl:output indent="yes"/>
    
    <!-- ********************************************************************
       ******* Buddhiprabha Erabadda and Steve Ball ****** 07.08.2012 *****
       ********************************************************************
       
       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://nwalsh.com/docbook/xsl/ for copyright
       and other information.
       
       ******************************************************************** -->
    
    <axsl:function name="f:group" as="node()*">
        <axsl:param name="this.node" as="node()*"/>
        <axsl:param name="level" as="xs:integer"/>
        <axsl:for-each-group select="$this.node" group-starting-with="dbk:para[@rnd:style = (concat($section, $level, $sectionNum), concat($section, $level))]">
            <axsl:choose>
                <axsl:when test="not(self::dbk:para[@rnd:style = (concat($section, $level, $sectionNum), concat($section, $level))])">
                    <axsl:apply-templates select="current-group()" mode="sections"/>
                </axsl:when>
                <axsl:otherwise>
                    <axsl:element name="sect{$level}"  xmlns="http://docbook.org/ns/docbook">
                        <axsl:apply-templates select="." mode="sections"/>
                        <axsl:sequence select="f:group(current-group() except ., $level + 1)"/>
                    </axsl:element>
                </axsl:otherwise>
            </axsl:choose>
        </axsl:for-each-group>
    </axsl:function>
    
    <axsl:template match="@* | node()" mode="sections">
        <axsl:copy>
            <axsl:apply-templates select="@* , node()" mode="sections"/>
        </axsl:copy>
    </axsl:template>
    
    <axsl:template match="dbk:article">
        <axsl:choose>
            <axsl:when test="dbk:para[@rnd:style='book' or @rnd:style='book-title']">
                <axsl:call-template name="make-book"/>
            </axsl:when>
            <axsl:when test="dbk:para[@rnd:style='article' or @rnd:style='article-title']">
                <axsl:call-template name="make-article"/>
            </axsl:when>
            <axsl:otherwise>
                <axsl:copy>
                    <axsl:apply-templates mode="sections"/>
                </axsl:copy>
            </axsl:otherwise>
        </axsl:choose>
    </axsl:template>
    
    <axsl:template name="make-book">
        <axsl:copy>
            <axsl:element name="book" namespace="http://docbook.org/ns/docbook">
                <axsl:for-each-group select="*" group-starting-with="dbk:para[@rnd:style = ('chapter', 'chapter-title', 'preface', 'preface-title',
                    'article', 'article-title', 'appendix', 'appendix-title', 'part', 'part-title')]">
                    <axsl:choose>
                        <axsl:when test="not(self::dbk:para[@rnd:style = ('chapter', 'chapter-title', 'preface', 'preface-title',
                            'article', 'article-title', 'appendix', 'appendix-title', 'part','part-title')])">
                            <axsl:apply-templates select="current-group()" mode="sections"/>
                        </axsl:when>
                        <axsl:otherwise>
                            <book-component xmlns="http://docbook.org/ns/docbook">
                                <axsl:sequence select="f:group(current-group(), 1)"/>
                            </book-component>
                        </axsl:otherwise>
                    </axsl:choose>
                </axsl:for-each-group>
            </axsl:element>
        </axsl:copy>
    </axsl:template>
    
    <axsl:template name="make-article">
        <axsl:copy>
            <axsl:for-each-group select="*" group-starting-with="dbk:para[@rnd:style = ('preface', 'preface-title',
                'article', 'article-title', 'appendix', 'appendix-title', 'part', 'part-title')]">
                    <axsl:choose>
                        <axsl:when test="not(self::dbk:para[@rnd:style = ('preface', 'preface-title',
                            'article', 'article-title', 'appendix', 'appendix-title', 'part', 'part-title')])">
                            <axsl:apply-templates select="current-group()" mode="sections"/>
                        </axsl:when>
                        <axsl:otherwise>
                                <axsl:sequence select="f:group(current-group(), 1)"/>
                        </axsl:otherwise>
                    </axsl:choose>
                </axsl:for-each-group>
        </axsl:copy>
    </axsl:template>
    
</axsl:stylesheet>
