include ../cvstools/Makefile.incl

CVS2LOG=../cvstools/cvs2log
NEXTVER=
DIFFVER=
ZIPVER=
CVSCHECK = $(shell cvs -n update 2>&1 | grep -v ^cvs | cut -c3-)
RELVER := $(shell grep "<fm:Version" VERSION | sed "s/ *<\/\?fm:Version>//g")
TAGVER := $(shell echo "V$(RELVER)" | sed "s/\.//g")
SFRELID=
FMGO=-N
TMP=/tmp
BROWSER=w3m
LFTP=lftp
SCP=scp
SCP_OPTS=
SSH=ssh
SSH_OPTS=
SF_UPLOAD_HOST=upload.sf.net
SF_UPLOAD_DIR=incoming
PROJECT_HOST=docbook.sf.net
PROJECT_BASE=/home/groups/d/do/docbook/htdocs/release/xsl
PROJECT_USER:=`sed 's/^:.\+:\([^@]\+\)@.\+$$/\1/' CVS/Root`

DIRS=common lib html fo extensions htmlhelp javahelp

.PHONY : distrib clean doc xhtml

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
ifeq ($(ZIPVER),)
	@echo You must specify ZIPVER for the zip target
	exit 1
else
	find . -type f | xargs chmod 0644
	find . -type d | xargs chmod 0755
	chmod 0755 fo/pdf2index docsrc/make-xsl-params.pl INSTALL
	rm -rf $(TMP)/docbook-xsl-$(ZIPVER)
	rm -f $(TMP)/tar.exclude
	rm -f $(TMP)/docbook-xsl-$(ZIPVER).tar.gz
	rm -f $(TMP)/docbook-xsl-$(ZIPVER).tar.bz2
	rm -f $(TMP)/docbook-xsl-$(ZIPVER).zip
	umask 022; mkdir $(TMP)/docbook-xsl-$(ZIPVER)
	touch $(TMP)/tar.exclude
	-find extensions/xsltproc -print >> $(TMP)/tar.exclude
	-find tools -print >> $(TMP)/tar.exclude
	-find wordml -print >> $(TMP)/tar.exclude
	-find extensions/saxon8 -print >> $(TMP)/tar.exclude
	-find extensions/saxon8.jar -print >> $(TMP)/tar.exclude
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
	tar cf - * --exclude-from $(TMP)/tar.exclude | (cd $(TMP)/docbook-xsl-$(ZIPVER); tar xf -)
	umask 022; cd $(TMP) && tar cf - docbook-xsl-$(ZIPVER) | gzip > docbook-xsl-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && tar cf - docbook-xsl-$(ZIPVER) | bzip2 > docbook-xsl-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && zip -q -rpD docbook-xsl-$(ZIPVER).zip docbook-xsl-$(ZIPVER)
	rm -f $(TMP)/tar.exclude
endif

install: zip
	-$(LFTP) -e "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook-xsl-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST)
	$(SCP) $(SCP_OPTS) $(TMP)/docbook-xsl-$(ZIPVER).tar.bz2 $(PROJECT_USER)@$(PROJECT_HOST):$(PROJECT_BASE)/
	$(SSH) $(SSH_OPTS)-l $(PROJECT_USER) $(PROJECT_HOST) \
	  "(\
	   umask 002; \
	   cd $(PROJECT_BASE); \
	   rm -rf $(ZIPVER); \
	   tar xfj docbook-xsl-$(ZIPVER).tar.bz2; \
	   mv docbook-xsl-$(ZIPVER) $(ZIPVER); \
	   rm -rf docbook-xsl-$(ZIPVER).tar.bz2; \
	   chmod -R g+w $(ZIPVER); \
	   rm -f current; \
	   ln -s $(ZIPVER) current; \
	   cd $(ZIPVER)/doc; \
	   ln -s ../images; \
	   )"

clean:
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
