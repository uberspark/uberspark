######
# Makefile to build uberSpark toolkit v-bridge plugin
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ./commondefs.mk

###### targets

.PHONY: all
all: 
	cd $(UBERSPARK_SRCDIR)/tools/vbridge-plugin && $(MAKE) -w all

.PHONY: clean
clean: 
	cd $(UBERSPARK_SRCDIR)/tools/vbridge-plugin && $(MAKE) -w clean

