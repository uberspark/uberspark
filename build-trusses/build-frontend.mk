######
# Makefile to build uberSpark toolkit common modules
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ./commondefs.mk

###### targets

### build uberspark frontend
.PHONY: all
all: 
	$(MAKE) -f build-commonmods.mk -w all
	cd $(UBERSPARK_SRCDIR)/tools/frontend && $(MAKE) -w all

### cleanup
.PHONY: clean
clean: 
	$(MAKE) -f build-commonmods.mk -w clean
	cd $(UBERSPARK_SRCDIR)/tools/frontend && $(MAKE) -w clean
