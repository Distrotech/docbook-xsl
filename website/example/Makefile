PROC=saxon
PROCOPT=-q
TABSTYLE=../xsl/tabular.xsl
WEBSTYLE=../xsl/website.xsl
TABCHUNK=../xsl/chunk-tabular.xsl
WEBCHUNK=../xsl/chunk-website.xsl
DESTPATH=.
TEXTONLY=0
USETIDY=1

.PHONY : clean

all:
	make website
	make TEXTONLY=1 website

ifeq ($(TEXTONLY),0)
STYLESHEET=$(TABSTYLE)
STYLEOPT=
include depends.tabular
else
STYLESHEET=$(WEBSTYLE)
STYLEOPT=filename-prefix=txt
include depends.textonly
endif

autolayout.xml: layout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(PROC) $(PROCOPT) $< ../xsl/autolayout.xsl $@
	make depends

chunk-tabular: autolayout.xml
	$(PROC) $(PROCOPT) layout.xml $(TABCHUNK) - output-root=$(DESTPATH)

chunk-website: autolayout.xml
	$(PROC) $(PROCOPT) layout.xml $(WEBCHUNK) - output-root=$(DESTPATH)

%.html: autolayout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(PROC) $(PROCOPT) $(filter-out autolayout.xml,$^) $(STYLESHEET) $@ $(STYLEOPT)
ifeq ($(USETIDY),1)
	-tidy -iq -latin1 -mn $@
endif

depends: autolayout.xml
	xjparse $<
	$(PROC) $(PROCOPT) $< ../xsl/makefile-dep.xsl depends.tabular
	$(PROC) $(PROCOPT) $< ../xsl/makefile-dep.xsl depends.textonly prefix=txt
