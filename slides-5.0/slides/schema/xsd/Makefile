include ../../../buildtools/Makefile.incl

all: slides.xsd

slides.xsd: ../relaxng/slides.rnc
	$(FLATTEN) $< $@

clean:

maintainer-clean: clean
	rm -f slides.xsd
