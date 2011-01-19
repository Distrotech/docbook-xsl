all: refpages list-elements.xml

refpages:
	$(MAKE) -C elements

list-elements.xml: Makefile $(wildcard elements/build/*.xml) ../tools/bin/makeelist
	@echo Extracting elements...
	../tools/bin/makeelist > $@

clean:
	$(MAKE) -C elements clean
