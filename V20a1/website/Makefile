include ../cvstools/Makefile.incl
ZIPVER=

.PHONY : distrib clean

all: website.dtd
	make -C extensions all
	make -C extensions jars

website.dtd: website-custom.dtd forms.mod
	$(FLATTEN) $< > $@

distrib:
	$(CVS2LOG) -w
	$(MERGELOGS) > WhatsNew

newversion:
	$(NEXTVERSION)
	make distrib

clean:
	make -C example clean
