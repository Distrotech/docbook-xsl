.PHONY : distrib clean

all: test

test:
	cd example; make test

distrib:
	cvs2log -w
	mergechangelogs > WhatsNew

newversion:
	nextversion
	make distrib

clean:
	cd example; make clean
