SUBDIRS= dtd relaxng xsd

all:
.for d in $(SUBDIRS)
	$(MAKE) -C ${d}
.endfor

clean:
.for d in $(SUBDIRS)
	$(MAKE) -C ${d} clean
.endfor

maintainer-clean: clean
.for d in $(SUBDIRS)
	$(MAKE) -C ${d} maintainer-clean
.endfor
