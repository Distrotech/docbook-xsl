.PHONY : distrib clean

all: website.dtd

website.dtd: website-custom.dtd forms.mod
	perl ../cvstools/flatten $< > $@

distrib:
	cvs2log -w
	mergechangelogs > WhatsNew

newversion:
	nextversion
	make distrib

clean:
	make -C example clean
