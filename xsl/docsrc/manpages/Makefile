include ../../../cvstools/Makefile.incl

JSTYLE=../../docsrc/xsl2jref.xsl
VPATH=../../manpages

XMLFILES = docparam.xml

all: $(XMLFILES)

clean:
	rm -f $(XMLFILES)

%.xml : %.xsl $(JSTYLE)
	$(XSLT) $< $(JSTYLE) /dev/null output-file=$@
	$(XJPARSE) $@

docparam.xml: ../../manpages/param.xsl
	$(MAKE) -C ../../manpages param.xml
	cp ../../manpages/param.xml docparam.xml
