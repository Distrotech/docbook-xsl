include ../../../buildtools/Makefile.incl
SLIDES=../../doc/slides.xml

index.html: ../../xsl/slides/xhtml/plain.xsl
	$(XSLT) $(SLIDES) $<

clean:
	rm -f *.html
