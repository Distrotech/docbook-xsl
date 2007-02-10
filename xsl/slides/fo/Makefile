include ../../../cvstools/Makefile.incl

ALLTARGETS=plain-titlepage.xsl
TTLTEMPLATEXSL=$(DOCBOOK_SVN)/xsl/template/titlepage.xsl

include ../../Makefile.incl

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@
