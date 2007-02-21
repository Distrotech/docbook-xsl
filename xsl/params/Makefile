# $Id: Makefile 6578 2007-02-02 06:51:30Z xmldoc $

include ../../cvstools/Makefile.incl

XSLTPROC=xsltproc
XSLTPROC_OPTS=

RNV=rnv
RNVOPTS=-q

DB4UPGRADE=../../docbook/relaxng/tools/db4-upgrade.xsl
XMLPARAMSDIR=$(DOCBOOK_SVN)/xsl/params

PARAMS_REFENTRY_RNC=../../docbook/relaxng/params/refentry.rnc

all:

remove-old:
	for f in $(XMLPARAMSDIR)/*.xml; do if [ -f `basename $$f` ]; then $(RM) `basename $$f`; fi; done

add-new:
	for f in *.xml; do \
          echo $$f; \
          touch -t 197001010000 `basename $$f`; done
	$(DOCBOOK_SVN)/cvstools/saxon ../website/param.xweb ../tools/xsl/build/burst.xsl
	$(DOCBOOK_SVN)/cvstools/saxon ../slides/param.xweb ../tools/xsl/build/burst.xsl

xml-files: remove-old add-new
	for f in *.xml; \
	  do \
	  $(XSLTPROC) $(XSLTPROC_OPTS) $(DB4UPGRADE) $$f \
	  | sed "s/<link xmlns:xlink=\"http:\/\/www.w3.org\/1999\/xlink\"/<link/g" \
	  | sed "s/<uri xmlns:xlink=\"http:\/\/www.w3.org\/1999\/xlink\"/<uri/g" \
	  | sed "s/<src:fragment xmlns:src=\"http:\/\/nwalsh.com\/xmlns\/litprog\/fragment\" */<src:fragment /" \
	  | sed "s/<xsl:attribute-set xmlns:xsl=\"http:\/\/www.w3.org\/1999\/XSL\/Transform\" */<xsl:attribute-set /" \
	  | sed "s/<xsl:param xmlns:xsl=\"http:\/\/www.w3.org\/1999\/XSL\/Transform\" */<xsl:param /" \
	  | sed "s/<refentry xmlns=\"http:\/\/docbook.org\/ns\/docbook\"/<refentry xmlns=\"http:\/\/docbook.org\/ns\/docbook\"\n          xmlns:xlink=\"http:\/\/www.w3.org\/1999\/xlink\"\n          xmlns:src=\"http:\/\/nwalsh.com\/xmlns\/litprog\/fragment\"\n          xmlns:xsl=\"http:\/\/www.w3.org\/1999\/XSL\/Transform\"\n         /" \
	  > $$f; done

test:
	$(RNV) $(RNVOPTS) $(PARAMS_REFENTRY_RNC) *.xml

clean: remove-old
