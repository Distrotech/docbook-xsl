include ../cvstools/Makefile.incl

CVS2LOG=../cvstools/cvs2log
NEXTVER=
DIFFVER=
CVSCHECK = $(shell cvs -n update 2>&1 | grep -v ^cvs | cut -c3-)
RELVER := $(shell grep "<fm:Version" VERSION | sed "s/ *<\/\?fm:Version>//g")
TAGVER := $(shell echo "V$(RELVER)" | sed "s/\.//g")
DEBVER := 0+pre1
SFRELID=
FMGO=-N
TMP=/tmp
BROWSER=w3m
SUDO=sudo
LFTP=lftp
SCP=scp
SCP_OPTS=
SSH=ssh
SSH_OPTS=
SF_UPLOAD_HOST=upload.sf.net
SF_UPLOAD_DIR=incoming
PROJECT_HOST=docbook.sf.net
PROJECT_BASE=/home/groups/d/do/docbook
RELEASE_BASE:=$(PROJECT_BASE)/htdocs/release/xsl
PROJECT_USER:=`sed 's/^:.\+:\([^@]\+\)@.\+$$/\1/' CVS/Root`
DEBIAN_BASE:=$(PROJECT_BASE)/htdocs/debian

DIRS=common lib html fo manpages extensions htmlhelp javahelp

.PHONY: distrib clean doc xhtml

all:	checkclasspath base xhtml docsrc

checkclasspath:
ifeq ($(CLASSPATH),)
	cat <<- EOF\
	error: CLASSPATH not set. Stopping.\
	\
	You must set the Java CLASSPATH environment variable and it must\
	contain absolute pathnames for the following:\
	\
	  - Saxon or Xalan2 jar file or classes\
	  - Xerces jar file(s) or classes\
	  - Apache XML Commons Resolver jar file or classes\
	  - directory containing CatalogManager.properties file\
	EOF\
	exit 1
endif

base:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

RELEASE-NOTES.html: RELEASE-NOTES.xml
	$(XJPARSE) $<
	$(XSLT) $< docsrc/doc-link-docbook.xsl $@

RELEASE-NOTES.txt: RELEASE-NOTES.html
	$(BROWSER) -dump $< > $@

xhtml:
	$(MAKE) -C xhtml

docsrc:
	$(MAKE) -C docsrc

doc:
	$(MAKE) -C docsrc
	$(MAKE) -C doc

distrib: all doc RELEASE-NOTES.html RELEASE-NOTES.txt
	$(CVS2LOG) -w
ifeq ($(DIFFVER),)
	$(MERGELOGS) > WhatsNew
else
	$(MERGELOGS) -v $(DIFFVER) > WhatsNew
endif

newversion:
ifeq ($(CVSCHECK),)
ifeq ($(DIFFVER),)
	@echo "DIFFVER must be specified."
	exit 1
else
ifeq ($(NEXTVER),$(RELVER))
	cvs tag $(TAGVER)
	$(MAKE) DIFFVER=$(DIFFVER) distrib
else
	@echo "VERSION $(RELVER) doesn't match specified version $(NEXTVER)."
	exit 1
endif
endif
else
	@echo "CVS is not up-to-date! ($(CVSCHECK))"
	exit 1
endif

freshmeat:
ifeq ($(SFRELID),)
	@echo "You must specify the sourceforge release identifier in SFRELID"
	exit 1
else
	$(XSLT) VERSION VERSION $(TMP)/fm-docbook-xsl sf-relid=$(SFRELID)
	grep -v "<?xml" $(TMP)/fm-docbook-xsl | freshmeat-submit $(FMGO)
endif

zip:
ifeq ($(RELVER),)
	@echo You must specify RELVER for the zip target
	exit 1
else
	find . -type f | xargs chmod 0644
	find . -type d | xargs chmod 0755
	chmod 0755 fo/pdf2index docsrc/make-xsl-params.pl INSTALL
	rm -rf $(TMP)/docbook-xsl-$(RELVER)
	rm -f $(TMP)/tar.exclude
	rm -f $(TMP)/docbook-xsl-$(RELVER).tar.gz
	rm -f $(TMP)/docbook-xsl-$(RELVER).tar.bz2
	rm -f $(TMP)/docbook-xsl-$(RELVER).zip
	umask 022; mkdir $(TMP)/docbook-xsl-$(RELVER)
	touch $(TMP)/tar.exclude
	-find debian -print >> $(TMP)/tar.exclude
	-find extensions/xsltproc -print >> $(TMP)/tar.exclude
	-find extensions/saxon8 -print >> $(TMP)/tar.exclude
	-find extensions/saxon8.jar -print >> $(TMP)/tar.exclude
	-find tools -print >> $(TMP)/tar.exclude
	-find wordml -print >> $(TMP)/tar.exclude
	find . -print  | grep /CVS$$ | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep /CVS/ | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep /debian/ | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep .classes | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep '^.\+\(/all\)\|\(/jar\)$$' | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "*~"  | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name ".*~"  | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name ".*.pyc"  | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "#*"  | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name ".#*"  | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "prj.el"  | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name ".cvsignore"  | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "Makefile*"   | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "README.CVS"   | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "catalog.xml"   | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "MANIFEST.build"   | cut -c3- >> $(TMP)/tar.exclude
	tar cf - * --exclude-from $(TMP)/tar.exclude | (cd $(TMP)/docbook-xsl-$(RELVER); tar xf -)
	umask 022; cd $(TMP) && tar cf - docbook-xsl-$(RELVER) | gzip > docbook-xsl-$(RELVER).tar.gz
	umask 022; cd $(TMP) && tar cf - docbook-xsl-$(RELVER) | bzip2 > docbook-xsl-$(RELVER).tar.bz2
	umask 022; cd $(TMP) && zip -q -rpD docbook-xsl-$(RELVER).zip docbook-xsl-$(RELVER)
	rm -f $(TMP)/tar.exclude
endif

install: zip
	-$(LFTP) -e "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook-xsl-$(RELVER).*; quit" $(SF_UPLOAD_HOST)
	$(SCP) $(SCP_OPTS) $(TMP)/docbook-xsl-$(RELVER).tar.bz2 $(PROJECT_USER)@$(PROJECT_HOST):$(RELEASE_BASE)/
	$(SSH) $(SSH_OPTS)-l $(PROJECT_USER) $(PROJECT_HOST) \
	  "(\
	   umask 002; \
	   cd $(RELEASE_BASE); \
	   rm -rf $(RELVER); \
	   tar xfj docbook-xsl-$(RELVER).tar.bz2; \
	   mv docbook-xsl-$(RELVER) $(RELVER); \
	   rm -rf docbook-xsl-$(RELVER).tar.bz2; \
	   chmod -R g+w $(RELVER); \
	   rm -f current; \
	   ln -s $(RELVER) current; \
	   cd $(RELVER)/doc; \
	   ln -s ../images; \
	   )"

debdepends: zip
	$(SUDO) rm -f $(TMP)/docbook-xsl_$(RELVER)-$(DEBVER)_all.deb; \
	$(SUDO) cp -pR debian $(TMP)/docbook-xsl-$(RELVER); \
	cd $(TMP)/docbook-xsl-$(RELVER); \
	$(MAKE) -C debian RELVER=$(RELVER) DEBVER=$(DEBVER)

deb: debdepends
	cd $(TMP)/docbook-xsl-$(RELVER); \
	$(SUDO) $(MAKE) -f debian/rules binary RELVER=$(RELVER)

debupload: deb
	$(SSH) $(SSH_OPTS)-l $(PROJECT_USER) $(PROJECT_HOST) \
	  "(\
	   cd $(DEBIAN_BASE)/unstable; \
	   rm -rf docbook-xsl_*; \
	   )"
	$(SCP) $(SCP_OPTS) $(TMP)/docbook-xsl_$(RELVER)-$(DEBVER)_all.deb $(PROJECT_USER)@$(PROJECT_HOST):$(DEBIAN_BASE)/unstable/
	$(SSH) $(SSH_OPTS)-l $(PROJECT_USER) $(PROJECT_HOST) \
	  "(\
	   umask 002; \
	   export PATH=$(PROJECT_BASE)/bin:$$PATH; \
	   cd $(DEBIAN_BASE); \
	   dpkg-scanpackages unstable /dev/null | gzip -9c > unstable/Packages.gz; \
	   )"

debclean:
	$(SUDO) rm -rf $(TMP)/docbook-xsl-$(RELVER)/debian

clean: debclean
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) clean -C $$i"; $(MAKE) clean -C $$i; \
		fi \
	done
	$(MAKE) clean -C xhtml
	$(MAKE) clean -C doc
	$(MAKE) clean -C docsrc

realclean: clean
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) realclean -C $$i"; $(MAKE) realclean -C $$i; \
		fi \
	done
	$(MAKE) realclean -C xhtml
	$(MAKE) realclean -C doc
	$(MAKE) realclean -C docsrc
