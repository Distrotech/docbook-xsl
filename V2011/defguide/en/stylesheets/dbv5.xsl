<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:set="http://exslt.org/sets"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
		xmlns:s="http://www.ascc.net/xml/schematron"
                xmlns:doc="http://nwalsh.com/xmlns/schema-doc/"
                exclude-result-prefixes="rng set s doc"
                version="1.0">

  <xsl:strip-space elements="rng:*"/>

  <xsl:variable name="db5doc" select="document('build/lib/docbook-rng.xml',.)/rng:grammar"/>

  <xsl:key name="defs" match="rng:define" use="@name"/>
  <xsl:key name="elemdefs" match="rng:define[rng:element]" use="rng:element/@name"/>

  <xsl:template name="rng-element">
    <xsl:param name="element" select="'nop'"/>
    <xsl:choose>
      <xsl:when test="$element = '*'">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:for-each select="$db5doc//rng:define[rng:element[@name=$element]]">
	  <xsl:apply-templates select=".">
	    <xsl:with-param name="elemNum" select="position()"/>
	  </xsl:apply-templates>
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:start">
    <div class="start">
      <h1>
        <a name="start"/>
	<xsl:text>Start</xsl:text>
      </h1>

      <ul>
	<xsl:apply-templates/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="rng:define[rng:element]" priority="2">
    <xsl:param name="elemNum" select="1"/>

    <div>
      <xsl:attribute name="class">
	<xsl:choose>
	  <xsl:when test="$elemNum = 1">define-first</xsl:when>
	  <xsl:otherwise>define-next</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>

      <xsl:apply-templates>
	<xsl:with-param name="elemNum" select="$elemNum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="rng:define">
    <div class="define">
      <xsl:value-of select="@name"/>

      <ul>
	<xsl:apply-templates/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="rng:text">
    <li><em>text</em></li>
  </xsl:template>

  <xsl:template match="rng:notAllowed">
    <!-- nop -->
  </xsl:template>

  <xsl:template match="rng:empty">
    <li><em>EMPTY</em></li>
  </xsl:template>

  <xsl:template match="rng:element">
    <xsl:param name="elemNum" select="1"/>
    <xsl:variable name="xdefs" select="key('elemdefs', @name)"/>

    <div class="element">
      <xsl:value-of select="@name"/>
      <xsl:if test="count($xdefs) &gt; 1">
	<xsl:text> (</xsl:text>
	<xsl:value-of select="../@name"/>
	<xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:text> ::=</xsl:text>

      <ul>
	<xsl:choose>
	  <xsl:when test="doc:content-model">
	    <xsl:apply-templates select="doc:content-model/*"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates/>
	  </xsl:otherwise>
	</xsl:choose>
      </ul>

      <xsl:apply-templates select="doc:attributes"/>
      <xsl:apply-templates select="doc:rules"/>
    </div>
  </xsl:template>

  <xsl:template match="doc:attributes">
    <xsl:variable name="attributes" select=".//rng:attribute"/>

    <xsl:variable name="cmnAttr"
		  select="$attributes[@name='id' and parent::rng:optional]
		          |$attributes[@name='xml:lang']
			  |$attributes[@name='xml:base']
			  |$attributes[@name='remap']
			  |$attributes[@name='xreflabel']
			  |$attributes[@name='revisionflag']
			  |$attributes[@name='arch']
			  |$attributes[@name='condition']
			  |$attributes[@name='conformance']
			  |$attributes[@name='os']
			  |$attributes[@name='revision']
			  |$attributes[@name='security']
			  |$attributes[@name='userlevel']
			  |$attributes[@name='vendor']
			  |$attributes[@name='role']
			  |$attributes[@name='version']"/>

    <xsl:variable name="cmnAttrIdReq"
		  select="$attributes[@name='id' and not(parent::rng:optional)]
		          |$attributes[@name='xml:lang']
			  |$attributes[@name='xml:base']
			  |$attributes[@name='remap']
			  |$attributes[@name='xreflabel']
			  |$attributes[@name='revisionflag']
			  |$attributes[@name='arch']
			  |$attributes[@name='condition']
			  |$attributes[@name='conformance']
			  |$attributes[@name='os']
			  |$attributes[@name='revision']
			  |$attributes[@name='security']
			  |$attributes[@name='userlevel']
			  |$attributes[@name='vendor']
			  |$attributes[@name='role']
			  |$attributes[@name='version']"/>

    <xsl:variable name="cmnAttrEither" select="$cmnAttr|$cmnAttrIdReq"/>

    <xsl:variable name="cmnLinkAttr"
		  select="$attributes[@name='href' and $attributes[@name='linkend']]
		          |$attributes[@name='linkend' and $attributes[@name='href']]"/>

    <xsl:variable name="otherAttr"
		  select="set:difference($attributes,
		                         $cmnAttr|$cmnAttrIdReq|$cmnLinkAttr)"/>

    <h4>DocBook NG “<xsl:value-of select="$ng-release"/>” Attributes</h4>

    <xsl:choose>
      <xsl:when test="count($cmnAttr) = 16 and $cmnLinkAttr">
	<p>Common attributes and common linking attributes.</p>
      </xsl:when>
      <xsl:when test="count($cmnAttrIdReq) = 16 and $cmnLinkAttr">
	<p>Common attributes (ID required) and common linking atttributes.</p>
      </xsl:when>
      <xsl:when test="count($cmnAttr) = 16">
	<p>Common attributes.</p>
      </xsl:when>
      <xsl:when test="count($cmnAttrIdReq) = 16">
	<p>Common attributes (ID required).</p>
      </xsl:when>
      <xsl:when test="$cmnLinkAttr">
	<p>Common linking attributes.</p>
      </xsl:when>
    </xsl:choose>

    <xsl:if test="count($cmnAttrEither) != 16 or count($otherAttr) &gt; 0">
      <p>
	<xsl:choose>
	  <xsl:when test="count($cmnAttr) = 16 
		          or count($cmnAttrIdReq) = 15
		  	  or $cmnLinkAttr">
	    <xsl:text>Additional attributes:</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>Attributes:</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:text> (Required attributes, if any, are </xsl:text>
	<b>bold</b>
	<xsl:text>)</xsl:text>
      </p>

      <ul>
	<xsl:for-each select="rng:interleave/*|*[not(self::rng:interleave)]">
	  <xsl:sort select="descendant-or-self::rng:attribute/@name"/>
	  <!-- don't bother with common attributes -->
	  <xsl:variable name="name" select="descendant-or-self::rng:attribute/@name"/>
	  <xsl:choose>
	    <xsl:when test="$cmnAttrEither[@name=$name]|$cmnLinkAttr[@name=$name]"/>
	    <xsl:otherwise>
	      <xsl:apply-templates select="." mode="attributes"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:optional" mode="attributes">
    <xsl:apply-templates mode="attributes"/>
  </xsl:template>

  <xsl:template match="rng:choice" mode="attributes">
    <li>
      <xsl:choose>
	<xsl:when test="ancestor::rng:optional">
	  <em>At most one of:</em>
	</xsl:when>
	<xsl:otherwise>
	  <em>Exactly one of:</em>
	</xsl:otherwise>
      </xsl:choose>
      <ul>
	<xsl:apply-templates mode="attributes"/>
      </ul>
    </li>
  </xsl:template>

  <xsl:template match="rng:interleave" mode="attributes">
    <li>
      <xsl:choose>
	<xsl:when test="ancestor::rng:optional">
	  <em>All or none of:</em>
	</xsl:when>
	<xsl:otherwise>
	  <em>All of:</em>
	</xsl:otherwise>
      </xsl:choose>
      <ul>
	<xsl:apply-templates mode="attributes"/>
      </ul>
    </li>
  </xsl:template>

  <xsl:template match="rng:group" mode="attributes">
    <li>
      <em>Each of:</em>
      <ul>
	<xsl:apply-templates mode="attributes"/>
      </ul>
    </li>
  </xsl:template>

  <xsl:template match="rng:ref" mode="attributes">
    <xsl:variable name="attrs" select="key('defs', @name)/rng:attribute"/>

    <xsl:choose>
      <xsl:when test="count($attrs) &gt; 1">
	<li>
	  <xsl:choose>
	    <xsl:when test="ancestor::rng:optional">
	      <em>At most one of:</em>
	    </xsl:when>
	    <xsl:otherwise>
	      <em><b>Each of:</b></em>
	    </xsl:otherwise>
	  </xsl:choose>
	  <ul>
	    <xsl:apply-templates select="$attrs" mode="attributes">
	      <xsl:with-param name="optional" select="ancestor::rng:optional"/>
	      <xsl:with-param name="choice" select="ancestor::rng:choice"/>
	    </xsl:apply-templates>
	  </ul>
	</li>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="$attrs" mode="attributes">
	  <xsl:with-param name="optional" select="ancestor::rng:optional"/>
	  <xsl:with-param name="choice" select="ancestor::rng:choice"/>
	</xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rng:attribute" mode="attributes">
    <xsl:param name="optional" select="ancestor::rng:optional"/>
    <xsl:param name="choice" select="ancestor::rng:choice"/>

    <li>
      <xsl:choose>
	<xsl:when test="$optional">
	  <xsl:value-of select="@name"/>
	</xsl:when>
	<xsl:otherwise>
	  <b>
	    <xsl:value-of select="@name"/>
	  </b>
	</xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
	<xsl:when test="rng:choice|rng:value">
	  <xsl:text> (enumeration)</xsl:text>
	  <ul>
	    <xsl:for-each select="rng:choice/rng:value|rng:value">
	      <li>
		<xsl:text>“</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>”</xsl:text>
	      </li>
	    </xsl:for-each>
	  </ul>
	</xsl:when>
	<xsl:when test="rng:data">
	  <xsl:text> (</xsl:text>
	  <xsl:value-of select="rng:data/@type"/>
	  <xsl:text>)</xsl:text>
	</xsl:when>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="doc:rules">
    <h4>DocBook NG “<xsl:value-of select="$ng-release"/>” Additional Constraints</h4>

    <ul>
      <xsl:for-each select=".//s:assert">
	<li>
	  <xsl:value-of select="."/>
	</li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="rng:value">
    <xsl:if test="position() &gt; 1"> | </xsl:if>
    <span class="{local-name()}">
      <xsl:text>“</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>”</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="rng:ref">
    <xsl:variable name="elemName" select="(key('defs', @name)/rng:element)[1]/@name"/>
    <xsl:variable name="xdefs" select="key('elemdefs', $elemName)"/>

    <li>
      <xsl:choose>
	<xsl:when test="$elemName">
	  <tt>
	    <a href="{$elemName}.html">
	      <xsl:value-of select="key('defs', @name)/rng:element/@name"/>
	    </a>
	  </tt>
	  <xsl:if test="parent::rng:optional">?</xsl:if>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@name"/>
	  <xsl:if test="parent::rng:optional">?</xsl:if>
	</xsl:otherwise>
      </xsl:choose>

      <xsl:if test="count($xdefs) &gt; 1">
	<xsl:text> (</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>)</xsl:text>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="rng:optional">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="rng:zeroOrMore">
    <li><xsl:text>Zero or more of:</xsl:text></li>
    <ul class="{local-name()}">
      <xsl:apply-templates>
	<xsl:sort select="key('defs',@name)/rng:element/@name"/>
	<xsl:sort select="@name"/>
      </xsl:apply-templates>
    </ul>
  </xsl:template>

  <xsl:template match="rng:oneOrMore">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optional one or more of:</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>One or more of:</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates>
	<xsl:sort select="key('defs',@name)/rng:element/@name"/>
	<xsl:sort select="@name"/>
      </xsl:apply-templates>
    </ul>
  </xsl:template>

  <xsl:template match="rng:group">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optional sequence of:</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>Sequence of:</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="rng:interleave">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optional interleave of:</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>Interleave of:</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="rng:choice">
      <li>
	<xsl:choose>
	  <xsl:when test="parent::rng:optional">
	    <xsl:text>Optionally one of: </xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>One of: </xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </li>
    <ul class="{local-name()}">
      <xsl:apply-templates>
	<xsl:sort select="key('defs',@name)/rng:element/@name"/>
	<xsl:sort select="@name"/>
      </xsl:apply-templates>
    </ul>
  </xsl:template>

</xsl:stylesheet>
