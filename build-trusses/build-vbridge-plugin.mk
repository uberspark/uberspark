######
# Makefile to build uberSpark toolkit v-bridge plugin
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ./commondefs.mk

###### targets

.PHONY: all
all: 
	$(MAKE) -f build-libs.mk -w all
	cd $(UBERSPARK_SRCDIR)/tools/vbridge-plugin && $(MAKE) -w all

.PHONY: clean
clean: 
	$(MAKE) -f build-libs.mk -w clean
	cd $(UBERSPARK_SRCDIR)/tools/vbridge-plugin && $(MAKE) -w clean
	cd $(UBERSPARK_SRCDIR)/tools/vbridge-plugin && rm -rf top/
