######
# Makefile for ubreSpark shared definition pre-processor tool
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ./commondefs.mk

###### targets

### build tool
.PHONY: all
all: 
	cd $(UBERSPARK_SRCDIR)/tools/sdefpp && $(MAKE) -w all

### (debug) run tool 
.PHONY: dbgrun
dbgrun:
	@cd $(UBERSPARK_SRCDIR)/tools/sdefpp/temp && $(UBERSPARK_SDEFPP) test.h.us test.h test.json	

### cleanup
.PHONY: clean
clean: 
	cd $(UBERSPARK_SRCDIR)/tools/sdefpp && $(MAKE) -w clean
