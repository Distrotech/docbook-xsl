# $Id$

include ../buildtools/Makefile.incl
include ../releasetools/Variables.mk

# The -E0 switch on xjparse gets passed on to the XML Commons
# resolver and causes all error message from the resolver to be
# suppressed. The -w switch causes the resolver to just do a
# well-formedness check instead of a validity check.
XJPARSEFLAGS=-E 0 -w

DISTRO=xsl

# value of DISTRIB_CHANGELOG_INCLUDES is a space-separated list of
# any other top-level modules from which to log changes in the
# NEWS and RELEASE-NOTES.* files for this distro
DISTRIB_CHANGELOG_INCLUDES = gentext

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS = doc docsrc install.sh RELEASE-NOTES.txt RELEASE-NOTES.pdf

# value of RELEASE_DEPENDS is a space-separated list of any
# targets for this distro's "release" target to depend on
RELEASE_DEPENDS = ChangeHistory.xml.zip extensions

# value of ZIP_EXCLUDES is a space-separated list of any file or
# directory names (shell wildcards OK) that should be excluded
# from the zip file and tarball for the release
DISTRIB_EXCLUDES = \
  reference.txt.html$$ \
  doc/reference.txt$$ \
  doc/reference.fo$$ \
  doc/reference.pdf$$ \
  doc/HTML.manifest$$ \
  tools/xsl \
  xhtml/html2xhtml.xsl$$ \
  README.RELEASE-BUILD \
  .param.dbkns \
  .param.stripped \
  .param.xmlid \
  .lib.dbkns \
  .lib.stripped \
  .lib.xmlid

# value of DISTRIB_PACKAGES is a space-separated list of any
# directory names that should be packaged as separate zip/tar
# files for the release
DISTRIB_PACKAGES = doc

# list of pathname+URIs to test for catalog support
URILIST = \
.\ http://docbook.sourceforge.net/release/xsl/current/

DIRS=common lib html fo manpages htmlhelp javahelp eclipse roundtrip slides website

.PHONY: distrib clean doc docsrc xhtml

all: base xhtml
# If you're annoyed about getting the reminder that it's possible
# to use xsltproc to build, delete the following conditional from
# this makefile.
ifeq (,$(findstring xsltproc,$(XSLT)))
	@echo
	@echo "-----------------------------------------------------------------"
	@echo "   To build using xsltproc, run make as follows:"
	@echo "     make XSLT=\"\$$DOCBOOK_SVN/buildtools/xslt -xsltproc\""
	@echo "-----------------------------------------------------------------"
endif

base:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

xhtml:
	$(MAKE) -C xhtml

docsrc: base 
	$(MAKE) -C docsrc

doc: docsrc
	$(MAKE) -C doc RELVER=$(RELVER)

extensions:
	$(MAKE) -C ../xsl-java
	cp -pR ../xsl-java $@

clean:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) clean -C $$i"; $(MAKE) clean -C $$i; \
		fi \
	done
	$(RM) -r extensions
	$(MAKE) clean -C xhtml
	$(MAKE) clean -C doc
	$(MAKE) clean -C docsrc

include ../releasetools/Targets.mk
include ../releasetools/xslns.mk
