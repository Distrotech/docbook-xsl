include ../../cvstools/Makefile.incl

ALLTARGETS=param.xsl profile-docbook.xsl titlepage.templates.xsl \
  profile-chunk-code.xsl
PROFILECONDITION=html

include ../Makefile.incl

profile-chunk-code.xsl: chunk-code.xsl $(DOCBOOK_SVN)/xsl/profiling/xsl2profile.xsl
	$(XSLT) $< $(DOCBOOK_SVN)/xsl/profiling/xsl2profile.xsl $@
