include ../../../buildtools/Makefile.incl

ifeq ($(RUNTRANG),)
$(error Cannot find "runtrang" script. Please do a "cvs update" of your buildtools directory)
endif

all: slides.rng

%.rng: %.rnc
	$(RUNTRANG) $< $@

clean:

maintainer-clean: clean
	rm -f slides.rng