.PHONY: doc saxon8 saxon643 saxon644 saxon65 saxon651 xalan2

all: jars

jars: saxon643.jar xalan25.jar

saxon643.jar:
	$(MAKE) -C saxon643/.classes
	jar cf saxon643.jar `find saxon643/.classes/com -name "*.class" -print`
	cp saxon643.jar saxon644.jar
	cp saxon643.jar saxon65.jar
	cp saxon643.jar saxon651.jar
	cp saxon643.jar saxon652.jar
	cp saxon643.jar saxon653.jar

xalan25.jar:
	$(MAKE) -C xalan2/.classes
	jar cf xalan25.jar `find xalan2/.classes/com -name "*.class" -print`

clean:
	$(MAKE) -C saxon643/.classes clean
	$(MAKE) -C xalan2/.classes clean
	rm -rf *.jar

realclean: clean
	$(MAKE) -C saxon643/.classes realclean
	$(MAKE) -C xalan2/.classes realclean
