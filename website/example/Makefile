PROC=saxon
PROCOPT=
TABSTYLE=../xsl/tabular.xsl
WEBSTYLE=../xsl/website.xsl
TABCHUNK=../xsl/chunk-tabular.xsl
WEBCHUNK=../xsl/chunk-website.xsl
DESTPATH=.
TEXTONLY=0

ifeq ($(TEXTONLY),0)
STYLESHEET=$(TABSTYLE)
include depends.tabular
else
STYLESHEET=$(WEBSTYLE)
include depends.textonly
endif

.PHONY : clean

all: website

autolayout.xml: layout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(PROC) $(PROCOPT) $< ../xsl/autolayout.xsl $@

chunk-tabular: autolayout.xml
	$(PROC) $(PROCOPT) layout.xml $(TABCHUNK) - output-root=$(DESTPATH)

chunk-website: autolayout.xml
	$(PROC) $(PROCOPT) layout.xml $(WEBCHUNK) - output-root=$(DESTPATH)

%.html: autolayout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(PROC) $(PROCOPT) $(filter-out autolayout.xml,$^) $(STYLESHEET) $@

depends: autolayout.xml
	xjparse $<
	$(PROC) $(PROCOPT) $< ../xsl/makefile-dep.xsl depends.tabular
	$(PROC) $(PROCOPT) $< ../xsl/makefile-dep.xsl depends.textonly prefix=txt
