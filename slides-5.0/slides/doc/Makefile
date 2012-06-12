include ../../buildtools/Makefile.incl
VPATH = ../xsl/slides/xhtml
all: index.html

index.html: slides.xml
	$(XSLT) $< ../../xsl/slides/xhtml/s5.xsl $@

clean:
	rm -f *.html
