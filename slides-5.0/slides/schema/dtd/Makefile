include ../../../buildtools/Makefile.incl

all: slides.dtd

slides.dtd: ../relaxng/slides.rnc
	trang $< $@

clean:

maintainer-clean: clean
	rm -f slides.dtd
