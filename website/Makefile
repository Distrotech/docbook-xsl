.PHONY : distrib clean

all: website.dtd test

test:
	cd example; make test

website.dtd: website-custom.dtd
	perl ../cvstools/flatten $< > $@

distrib:
	cvs2log -w
	mergechangelogs > WhatsNew

newversion:
	nextversion
	make distrib

clean:
	cd example; make clean
