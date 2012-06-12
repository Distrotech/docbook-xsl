DOCBOOK_SVN := /home/visitha/docbook/branches/webhelp
include $(DOCBOOK_SVN)/buildtools/Makefile.incl

INPUT_XML = docsrc/readme.xml
USER_IMAGES_PARENT_DIR=docsrc
DOCBOOK_EXTENSIONS_DIR = /home/visitha/Desktop/docbook-xsl-ns-snapshot/extensions
#DOCBOOK_EXTENSIONS_DIR = ../extensions
OUTPUT_DIR = docs

INDEXER_JAR   := $(DOCBOOK_EXTENSIONS_DIR)/webhelpindexer.jar
TAGSOUP_JAR   := $(DOCBOOK_EXTENSIONS_DIR)/tagsoup-1.2.1.jar
LUCENE_ANALYZER_JAR   := $(DOCBOOK_EXTENSIONS_DIR)/lucene-analyzers-3.0.0.jar
LUCENE_CORE_JAR   := $(DOCBOOK_EXTENSIONS_DIR)/lucene-core-3.0.0.jar

classpath := $(INDEXER_JAR):$(TAGSOUP_JAR):$(LUCENE_ANALYZER_JAR):$(LUCENE_CORE_JAR)

DOCBOOK_SVN := /home/visitha/docbook/branches/webhelp
	
all: webhelp

webhelp: docsrc/readme.xml copyfiles chunk index
#	$(MAKE) -C ../xhtml

#The script for xsl transformation goes here... Read Stefan's Makefile

#ifeq ($(XSLTENGINE),xsltproc)
#	$(XSLT) --xinclude $< ../profiling/profile.xsl webhelp-temp.xml 
#else
#	$(XSLT) $< ../profiling/profile.xsl webhelp-temp.xml 
#endif
#	$(XSLT) webhelp-temp.xml xsl/webhelp.xsl
#	rm webhelp-temp.xml

copyfiles:
	-rm -rf $(OUTPUT_DIR)
	mkdir -p $(OUTPUT_DIR)
	cp -r template/common ${OUTPUT_DIR}
	mkdir -p $(OUTPUT_DIR)/content/images
	test ! -d $(USER_IMAGES_PARENT_DIR)/images/ || cp -r $(USER_IMAGES_PARENT_DIR)/images ${OUTPUT_DIR}/content/images
	cp template/favicon.ico ${OUTPUT_DIR}/

chunk:
	xsltproc /home/visitha/Desktop/docbook-xsl-ns-snapshot/webhelp/xsl/webhelp.xsl ${INPUT_XML}	
index:
	java \
		-DhtmlDir=$(OUTPUT_DIR)/content \
		-DindexerLanguage=en \
		-DhtmlExtension=html \
		-DdoStem=true \
		-Dorg.xml.sax.driver=org.ccil.cowan.tagsoup.Parser \
		-Djavax.xml.parsers.SAXParserFactory=org.ccil.cowan.tagsoup.jaxp.SAXFactoryImpl \
		-classpath $(classpath) \
		com.nexwave.nquindexer.IndexerMain

	cp -r template/content/search/* ${OUTPUT_DIR}/content/search

clean:
	$(RM) -r docs/*

