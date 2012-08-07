<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dbk='http://docbook.org/ns/docbook'
  xmlns:rnd='http://docbook.org/ns/docbook/roundtrip'
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
  xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
  xmlns:xlink='http://www.w3.org/1999/xlink'
  xmlns:exsl='http://exslt.org/common'
  exclude-result-prefixes='xsi a office text fo style'
  extension-element-prefixes='exsl'>

  <xsl:import href='normalise-common.xsl'/>

  <xsl:output method='xml' indent="yes"/>

  <!-- *****************************************************************************************
       ********** Buddhiprabha Erabadda and Steve Ball******** 07/08/2012 **********************
       *****************************************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://nwalsh.com/docbook/xsl/ for copyright
       and other information.

       ************************************************************************************* -->

  <xsl:strip-space elements='*'/>
  
  <xsl:template match="office:document-content">
    <dbk:article>
      <xsl:apply-templates select='office:body'/>
    </dbk:article>
  </xsl:template>
  
  <xsl:template match="text:p/text:note/text:note-body/text:p">
    <dbk:footnote>
      <dbk:para>
      <xsl:apply-templates/>
      </dbk:para>
    </dbk:footnote>
  </xsl:template>
  
  <xsl:template match="text:note/text:note-citation"/>
  
  <xsl:template match="text:p">
    
    <xsl:if test="text:note/@text:note-citation"/>
    <xsl:variable name='headingStyle'>
      <xsl:call-template name='rnd:map-paragraph-style'>
        <xsl:with-param name='headingStyle' select='@text:style-name'/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name='textStyle'>
      <xsl:call-template name='rnd:map-character-style'>
        <xsl:with-param name='textStyle' select='@text:style-name'/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="style-path" select="/office:document-content/office:automatic-styles
      /style:style[@style:name=current()/@text:style-name]/style:text-properties"></xsl:variable>
    
    <xsl:variable
      name='isItalic' select='$style-path/(@fo:font-style)'>
    </xsl:variable>
    
    <xsl:variable
      name='isBold' select='$style-path/(@fo:font-weight)'>
    </xsl:variable>
    
    <xsl:variable name="isUnderlined">
      <xsl:if test="$style-path[@style:text-underline-style='solid']">
        <xsl:text>underline</xsl:text>
      </xsl:if>
    </xsl:variable>
        
    <xsl:variable name="role" select="($isItalic[. != ('normal')], $isBold[. != ('normal')], $isUnderlined[. != ('')])"></xsl:variable>
    
    <xsl:choose>
      
      <xsl:when test = '$textStyle = "Table_20_Contents"'>
        <dbk:para>
          <xsl:attribute name='rnd:style'/>
          <xsl:apply-templates/>
        </dbk:para>
      </xsl:when>
      
      <xsl:when test='contains($role,"bold") or contains($role,"italic") or contains($role,"underline")'>
        <dbk:para>     
          <xsl:attribute name='rnd:style'>
            <xsl:value-of select='$textStyle'/>
          </xsl:attribute>
          
          <xsl:if test='@text:style-name and $textStyle ne @text:style-name'>
            <xsl:attribute name='rnd:original-style'>
              <xsl:value-of select='@text:style-name[1]'/>
            </xsl:attribute>
          </xsl:if>
          
          <dbk:emphasis>  
            <xsl:attribute name="role">
              <xsl:value-of separator="-" select="$role"/>
            </xsl:attribute>
            <xsl:apply-templates/>
          </dbk:emphasis>
          
        </dbk:para>
      </xsl:when>
      
      <xsl:otherwise>
        <dbk:para>
              <xsl:attribute name="rnd:style">
                <xsl:value-of select="$headingStyle"/>
              </xsl:attribute>
          <xsl:apply-templates/>
        </dbk:para>
        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="text:h">
    <xsl:variable name='headingStyle'>
      <xsl:call-template name='rnd:map-paragraph-style'>
        <xsl:with-param name='headingStyle' select='@text:style-name'/>
      </xsl:call-template>
    </xsl:variable>
    
    <dbk:para>
      <xsl:attribute name='rnd:style'>
        <xsl:value-of select='$headingStyle'/>
      </xsl:attribute>
      <xsl:if test='@text:style-name and $headingStyle ne @text:style-name'>
        <xsl:attribute name='rnd:original-style'>
          <xsl:value-of select='@text:style-name[1]'/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </dbk:para>
    
  </xsl:template>
  
  <xsl:template match="text:span[1]">
    <xsl:variable name="style-path" select="/office:document-content/office:automatic-styles
      /style:style[@style:name=current()/@text:style-name]/style:text-properties"></xsl:variable>
    
    <xsl:variable
      name='isItalic' select='$style-path/(@fo:font-style)'>
    </xsl:variable>
    
    <xsl:variable
      name='isBold' select='$style-path/(@fo:font-weight)'>
    </xsl:variable>
    
    <xsl:variable name="isUnderlined">
      <xsl:if test="$style-path[@style:text-underline-style='solid']">
        <xsl:text>underline</xsl:text>
      </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="role" select="($isItalic[. != ('normal')], $isBold[. != ('normal')], $isUnderlined[. != ('')])"></xsl:variable>
    
    <xsl:if test='contains($role,"bold") or contains($role,"italic") or contains($role,"underline")'>
    <dbk:emphasis>  
      <xsl:attribute name="role">
        <xsl:value-of separator="-" select="$role"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </dbk:emphasis>
    </xsl:if>
    
    <xsl:if test='contains(/office:document-content/office:automatic-styles
      /style:style[@style:name=current()/@text:style-name]/style:text-properties/(@style:text-position) , "super")'>
      <dbk:superscript>
        <xsl:apply-templates select='node()'>
          <xsl:with-param name='do-vert-align' select='false()'/>
        </xsl:apply-templates>
      </dbk:superscript>
    </xsl:if>
    
    <xsl:if test='contains(/office:document-content/office:automatic-styles
      /style:style[@style:name=current()/@text:style-name]/style:text-properties/(@style:text-position) , "sub")'>
      <dbk:subscript>
        <xsl:apply-templates select='node()'>
          <xsl:with-param name='do-vert-align' select='false()'/>
        </xsl:apply-templates>
      </dbk:subscript>
    </xsl:if>
    
  </xsl:template>
  
  <xsl:template match='table:table'>

    <dbk:informaltable>
      <!-- TODO: analyse row widths -->
      <dbk:tgroup>
          
        <!-- table coulumn width -->
        <xsl:if test="not(table:table-column/@table:number-columns-repeated)">
          <xsl:for-each select="table:table-column">
            <dbk:colspec colwidth='{/office:document-content/office:automatic-styles
              /style:style[@style:name=current()/@table:style-name]/style:table-column-properties/@style:rel-column-width}'
              colname='column-{count(preceding-sibling::table:table-column) + 1}'/>
          </xsl:for-each>
        </xsl:if>
        
        <xsl:variable name="equalWidth" select="/office:document-content/office:automatic-styles
          /style:style[@style:name=current()/table:table-column/@table:style-name]/style:table-column-properties/@style:rel-column-width">
        </xsl:variable>
        
        <xsl:if test="table:table-column/@table:number-columns-repeated">  
          <xsl:variable name="count">
            <xsl:value-of select="table:table-column/@table:number-columns-repeated"/>
          </xsl:variable>
          
          <xsl:for-each select="1 to $count">
            <xsl:variable name="columnNum">
              <xsl:value-of select="string(current())"></xsl:value-of>
            </xsl:variable>
            <dbk:colspec>
              <xsl:attribute name="colwidth" select="$equalWidth"></xsl:attribute>
              <xsl:attribute name="colname" select="concat('column-',$columnNum)"></xsl:attribute>
            </dbk:colspec>
          </xsl:for-each>
        </xsl:if>
        
            <dbk:tbody>
              <xsl:apply-templates select='table:table-row'/>
            </dbk:tbody>
      </dbk:tgroup>
    </dbk:informaltable>
    
  </xsl:template>
  
  <xsl:template match='table:table-row'>
    <dbk:row>
      <xsl:apply-templates/>
    </dbk:row>
  </xsl:template>
  
  <xsl:template match='table:table-cell'>
    <dbk:entry>
      
      <xsl:variable name='this.colnum'
        select='count(preceding-sibling::table:table-cell) + 1 +
        sum(preceding-sibling::table:table-cell/@table:number-columns-spanned) -
        count(preceding-sibling::table:table-cell[@table:number-columns-spanned])'/>
      
      <xsl:if test='@table:number-columns-spanned > 1'>
        <xsl:attribute name='namest'>
          <xsl:text>column-</xsl:text>
          <xsl:value-of select='$this.colnum[1]'/>
        </xsl:attribute>
        <xsl:attribute name='nameend'>
          <xsl:text>column-</xsl:text>
          <xsl:value-of select='$this.colnum + @table:number-columns-spanned[1] - 1'/>
        </xsl:attribute>
      </xsl:if>
      
      <xsl:if test='@table:number-rows-spanned > 1'>
        <xsl:attribute name='morerows'>
          <xsl:value-of select='@table:number-rows-spanned - 1'/>
        </xsl:attribute>
      </xsl:if>
      
      <xsl:apply-templates/>
    </dbk:entry>
  </xsl:template>
</xsl:stylesheet>
