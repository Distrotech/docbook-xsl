<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f fn m mp xs"
                version="2.0">

<xsl:key name="id" match="*" use="@xml:id"/>
<xsl:param name="save.normalized.xml" select="()"/>

<xsl:template name="cleanup-docbook" as="document-node()">
  <xsl:param name="root" select="/"/>

  <xsl:if test="$verbosity &gt; 2">
    <xsl:message>Processing: <xsl:value-of select="base-uri($root)"/></xsl:message>
  </xsl:if>

  <!-- Phase 1 makes three changes to the input document:

       1. It adds an xml:base attribute to the root element so that
          URI resolution in subsequent phases will know the correct base
          URI.

       2. It resolves entityref attributes into fileref attributes
          because subsequent phases won't have access to the entity
          declarations in the original document

       3. If the root element does not declare the DocBook namespace,
         it moves all elements in no namespace into the DocBook
         namespace
  -->

  <xsl:if test="$verbosity &gt; 3">
    <xsl:message>Phase 1...namespace fixup</xsl:message>
  </xsl:if>
  <xsl:variable name="phase1">
    <xsl:choose>
      <xsl:when test="$root/*[1]/namespace::* = $docbook-namespace">
	<xsl:apply-templates select="$root" mode="mp:justcopy"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="$root" mode="mp:fixnamespace"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Phase 2 applies profiling -->
  <xsl:if test="$verbosity &gt; 3">
    <xsl:message>Phase 2...profiling</xsl:message>
  </xsl:if>
  <xsl:variable name="phase2">
    <xsl:apply-templates select="$phase1" mode="m:profile"/>
  </xsl:variable>

  <!-- Phase 3 normalizes markup -->
  <xsl:if test="$verbosity &gt; 3">
    <xsl:message>Phase 3...normalize markup</xsl:message>
  </xsl:if>
  <xsl:variable name="phase3">
    <xsl:processing-instruction name="db-private-normalized"/>
    <xsl:apply-templates select="$phase2" mode="m:normalize"/>
  </xsl:variable>

  <xsl:if test="$rootid != '' and not(key('id', $rootid, $phase3))">
    <xsl:message terminate="yes">
      <xsl:text>ID '</xsl:text>
      <xsl:value-of select="$rootid"/>
      <xsl:text>' not found in document.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="root" as="element()">
    <xsl:choose>
      <xsl:when test="$rootid != ''">
	<xsl:sequence select="key('id', $rootid, $phase3)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:sequence select="$phase3/*[1]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="not($root.elements/*[fn:node-name(.) = fn:node-name($root)])">
    <xsl:call-template name="m:root-terminate"/>
  </xsl:if>

  <xsl:if test="not(empty($save.normalized.xml))">
    <xsl:if test="$verbosity &gt; 0">
      <xsl:message>Saving <xsl:value-of select="$save.normalized.xml"/></xsl:message>
    </xsl:if>
    <xsl:result-document href="{$save.normalized.xml}" method="xml">
      <xsl:sequence select="$phase3"/>
    </xsl:result-document>
  </xsl:if>

  <xsl:sequence select="$phase3"/>
</xsl:template>

<xsl:template name="format-docbook">
  <xsl:variable name="doc" as="document-node()">
    <xsl:call-template name="cleanup-docbook"/>
  </xsl:variable>
  <xsl:if test="$verbosity &gt; 3">
    <xsl:message>Styling...</xsl:message>
  </xsl:if>
  <xsl:apply-templates select="$doc"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="/*[1]" priority="2" mode="mp:justcopy">
  <xsl:copy>
    <xsl:attribute name="xml:base" select="base-uri(.)"/>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="mp:justcopy"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="*" mode="mp:justcopy">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="mp:justcopy"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="imagedata|db:imagedata
		     |textdata|db:textdata
		     |videodata|db:videodata
		     |audiodata|db:audiodata" mode="mp:justcopy">
  <xsl:copy>
    <xsl:copy-of select="@*[name(.) != 'entityref']"/>

    <xsl:if test="@entityref">
      <xsl:attribute name="fileref">
	<xsl:value-of select="unparsed-entity-uri(@entityref)"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:apply-templates mode="mp:justcopy"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="mp:justcopy">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="/*[1]" mode="mp:fixnamespace">
  <xsl:choose>
    <xsl:when test="namespace-uri(.) = ''">
      <xsl:element name="{local-name(.)}" namespace="{$docbook-namespace}">
	<xsl:attribute name="xml:base" select="base-uri(.)"/>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="mp:fixnamespace"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
	<xsl:attribute name="xml:base" select="base-uri(.)"/>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="mp:fixnamespace"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="mp:fixnamespace">
  <xsl:choose>
    <xsl:when test="namespace-uri(.) = ''">
      <xsl:element name="{local-name(.)}" namespace="{$docbook-namespace}">
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="mp:fixnamespace"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="mp:fixnamespace"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="imagedata|db:imagedata
		     |textdata|db:textdata
		     |videodata|db:videodata
		     |audiodata|db:audiodata" mode="mp:fixnamespace">
  <xsl:element name="{local-name(.)}" namespace="{$docbook-namespace}">
    <xsl:copy-of select="@*[name(.) != 'entityref']"/>

    <xsl:if test="@entityref">
      <xsl:attribute name="fileref">
	<xsl:value-of select="unparsed-entity-uri(@entityref)"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:apply-templates mode="mp:fixnamespace"/>
  </xsl:element>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="mp:fixnamespace">
  <xsl:copy/>
</xsl:template>
  
<!-- ============================================================ -->
<!-- profile content -->

<doc:mode name="m:profile" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for profiling DocBook documents</refpurpose>

<refdescription>
<para>This mode is used to profile an input document. Profiling discards
content that is not in the specified profile.</para>
</refdescription>
</doc:mode>

<xsl:template match="/" mode="m:profile">
  <xsl:apply-templates mode="m:profile"/>
</xsl:template>

<xsl:template match="*" mode="m:profile">
  <xsl:if test="f:profile-ok(@arch, $profile.arch)
                and f:profile-ok(@condition, $profile.condition)
                and f:profile-ok(@conformance, $profile.conformance)
                and f:profile-ok(@lang, $profile.lang)
                and f:profile-ok(@os, $profile.os)
                and f:profile-ok(@revision, $profile.revision)
                and f:profile-ok(@revisionflag, $profile.revisionflag)
                and f:profile-ok(@role, $profile.role)
                and f:profile-ok(@security, $profile.security)
                and f:profile-ok(@userlevel, $profile.userlevel)
                and f:profile-ok(@vendor, $profile.vendor)
		and f:profile-attribute-ok(.,
		                           $profile.attribute, $profile.value)">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="m:profile"/>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template match="text()|comment()|processing-instruction()"
	      mode="m:profile">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<doc:function name="f:profile-ok" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns true if the specified attribute is in the specified profile
</refpurpose>

<refdescription>
<para>This function compares the profile values actually specified on
an element with the set of values being used for profiling and returns
true if the current attribute is in the specified profile.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>attr</term>
<listitem>
<para>The profiling attribute.</para>
</listitem>
</varlistentry>
<varlistentry><term>prof</term>
<listitem>
<para>The desired profile.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>True or false.</para>
</refreturn>
</doc:function>

<xsl:function name="f:profile-ok" as="xs:boolean">
  <xsl:param name="attr" as="attribute()?"/>
  <xsl:param name="prof" as="xs:string?"/>

  <xsl:choose>
    <xsl:when test="not($attr) or not($prof)">
      <xsl:value-of select="true()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="node-values"
		    select="fn:tokenize($attr, $profile.separator)"/>
      <xsl:variable name="profile-values"
		    select="fn:tokenize($prof, $profile.separator)"/>

      <!-- take advantage of existential semantics of "=" -->
      <xsl:value-of select="$node-values = $profile-values"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:profile-attribute-ok"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns true if the context node has the specified attribute and that attribute is in the specified profile
</refpurpose>

<refdescription>
<para>This function compares the profile values actually specified in the
named attribute on the context element
with the set of values being used for profiling and returns
true if the current attribute is in the specified profile.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>context</term>
<listitem>
<para>The context element.</para>
</listitem>
</varlistentry>
<varlistentry><term>attr</term>
<listitem>
<para>The profiling attribute.</para>
</listitem>
</varlistentry>
<varlistentry><term>prof</term>
<listitem>
<para>The desired profile.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>True or false.</para>
</refreturn>
</doc:function>

<xsl:function name="f:profile-attribute-ok" as="xs:boolean">
  <xsl:param name="context" as="element()"/>
  <xsl:param name="attrname" as="xs:string?"/>
  <xsl:param name="prof" as="xs:string?"/>

  <xsl:choose>
    <xsl:when test="not($attrname) or not($prof)">
      <xsl:value-of select="true()"/>
    </xsl:when>
    <xsl:when test="not($context/@*[local-name(.) = $attrname
		                    and namespace-uri(.) = ''])">
      <xsl:value-of select="true()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="f:profile-ok($context/@*[local-name(.) = $attrname
                                                     and namespace-uri(.) = ''],
					 $prof)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:template name="m:root-terminate" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Aborts processing if the root element is inappropriate</refpurpose>

<refdescription>
<para>This template is called if the stylesheet detects that the root
element (or the element selected for processing with
<parameter>rootid</parameter>) is not an appropriate root element.
</para>
</refdescription>

<refreturn>
<para>Does not return.</para>
</refreturn>
</doc:template>

<xsl:template name="m:root-terminate">
  <xsl:message terminate="yes">
    <xsl:text>Error: document root element (</xsl:text>
    <xsl:value-of select="name(/*[1])"/>
    <xsl:if test="$rootid">
      <xsl:text>, $rootid=</xsl:text>
      <xsl:value-of select="$rootid"/>
    </xsl:if>
    <xsl:text>) </xsl:text>

    <xsl:text>must be one of the following elements: </xsl:text>
    <xsl:value-of select="for $elem in $root.elements/*[position() &lt; last()]
			  return local-name($elem)" separator=", "/>
    <xsl:text>, or </xsl:text>
    <xsl:value-of select="local-name($root.elements/*[last()])"/>
    <xsl:text>.</xsl:text>
  </xsl:message>
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
