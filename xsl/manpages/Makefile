include ../../cvstools/Makefile.incl

ALLTARGETS=param.xsl html-synop.xsl
PROFILECONDITION=manpages
HTML2ROFF=../tools/xsl/build/html2roff.xsl

include ../Makefile.incl

html-synop.xsl: ../html/synop.xsl
	$(XSLT) $< $(HTML2ROFF) $@
