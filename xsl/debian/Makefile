PACKAGEREMAIL=docbook-developers@lists.sf.net
DEVSCRIPTS_CHECK_DIRNAME_LEVEL=0

DEBCHANGE=debchange
DEBCHANGE_OPTS=

SED=sed
SED_OPTS=-i

CHANGEDESC=Auto-built pre-packaging of new upstream release

.PHONY: changelog versionup

all: changelog versionup

changelog:
ifeq ($(RELVER),)
	$(error You must specify a value for RELVER)
endif
ifeq ($(DEBVER),)
	$(error You must specify a value for DEBVER)
endif
	DEBEMAIL=" <$(PACKAGEREMAIL)>" $(DEBCHANGE) $(DEBCHANGE_OPTS) -v $(RELVER)-$(DEBVER) $(CHANGEDESC)

versionup: catalog.xml docbook-xsl.install docbook-xsl.links
	$(SED) $(SED_OPTS) 's/[0-9]\.[0-9][0-9]\.[0-9]/$(RELVER)/' $?
