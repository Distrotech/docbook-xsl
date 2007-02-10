include ../../cvstools/Makefile.incl

.PHONY: fo xhtml

ALLTARGETS=base param.xsl
PROFILECONDITION=slides
CLEANTARGETS=base-clean
DIRS = fo xhtml

include ../Makefile.incl

base:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

%.xsl: %.xml
	$(XSLT) $< $(TTLTEMPLATEXSL) $@

base-clean: 
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i clean"; $(MAKE) -C $$i clean; \
		fi \
	done
