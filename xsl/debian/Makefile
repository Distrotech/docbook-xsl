PACKAGEREMAIL=docbook-developers@lists.sf.net
DEVSCRIPTS_CHECK_DIRNAME_LEVEL=0

DEBCHANGE=debchange
DEBCHANGE_OPTS=--check-dirname-level=0

SED=sed
SED_OPTS=-i

CHANGEDESC=New upstream release

.PHONY: changelog versionup

all: changelog versionup

changelog:
ifeq ($(RELVER),)
	$(error You must specify a value for RELVER)
else
	DEBEMAIL=" <$(PACKAGEREMAIL)>" $(DEBCHANGE) $(DEBCHANGE_OPTS) -v $(RELVER)-1 $(CHANGEDESC)
endif

versionup: catalog.xml docbook-xsl.install docbook-xsl.links
	$(SED) $(SED_OPTS) 's/[0-9]\.[0-9][0-9]\.[0-9]/$(RELVER)/' $?

revert:
	cvs update -C
