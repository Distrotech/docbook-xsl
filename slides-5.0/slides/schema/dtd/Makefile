include ../../../buildtools/Makefile.incl

all: slides.dtd

slides.dtd: ../relaxng/slides.rnc
	$(FLATTEN) $< $@

clean:

maintainer-clean: clean
	rm -f slides.dtd
