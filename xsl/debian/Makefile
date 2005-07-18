EMAIL=docbook-developers@lists.sf.net
DEVSCRIPTS_CHECK_DIRNAME_LEVEL=0

DEBCHANGE=debchange
DEBCHANGE_OPTS=

SED=sed
SED_OPTS=-i

PRINTF=printf
PRINTF_OPTS=

MYDATE:=$(shell LANG=C date -R)
CHANGEDESC=Auto-built pre-packaging of new upstream release. This is NOT the official Debian package for the $(RELVER) release.

COPYRIGHT_HEADER:=This package was debianized by $(EMAIL)\non $(MYDATE).\n\nIt was built by the DocBook Project at the same time as the\nstandard DocBook XSL stylesheet release. Non-Debian builds of the\npackage can be downloaded from the DocBook Project site.\n\n  http://sourceforge.net/projects/docbook/\n\nUpstream Authors: Norman Walsh <ndw@nwalsh.com> and members of\nthe DocBook Project <$(EMAIL)>\n\n\n

README_HEADER=\n----------------------------------------------------------------------\nThis file was copied from the official Debian package. Bug reports\nabout this [version $(RELVER)-$(DEBVER)] unoffical package should NOT be\nreported to the Debian bug tracking system or the official\nmaintainer. Instead, report them here:\n\n  http://sourceforge.net/tracker/?func=add&group_id=21935&atid=373747\n\nSet the Group field to \"Packaging problem\".\n----------------------------------------------------------------------\n\n

LICENSE=../LICENSE

.PHONY: changelog copyright control README.Debian

all: changelog copyright control README.Debian versionup

changelog:
ifeq ($(RELVER),)
	$(error You must specify a value for RELVER)
endif
ifeq ($(DEBVER),)
	$(error You must specify a value for DEBVER)
endif
	DEBEMAIL=" <$(EMAIL)>" $(DEBCHANGE) $(DEBCHANGE_OPTS) -v $(RELVER)-$(DEBVER) $(CHANGEDESC)

copyright:
	rm -f copyright
	$(PRINTF) $(PRINTF_OPTS) "$(COPYRIGHT_HEADER)" | cat - $(LICENSE) > copyright

control:
	$(SED) $(SED_OPTS) 's/^Maintainer:.*$$/Maintainer: The DocBook Project <$(EMAIL)>/' control

README.Debian:
	mv README.Debian README.Debian.orig
	printf "$(README_HEADER)" | cat - README.Debian.orig > README.Debian

versionup: catalog.xml docbook-xsl.install docbook-xsl.links
	$(SED) $(SED_OPTS) 's/[0-9]\.[0-9][0-9]\.[0-9]/$(RELVER)/' $?
