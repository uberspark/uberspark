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

### run tool 
.PHONY: run
run:
	#@"$(UBERSPARK_SRCDIR)"/tools/configpp/_build/uberspark_configpp $(UBERSPARK_SRCDIR)/config/uberspark-constdefs-mf.json
	#@cd temp && "$(UBERSPARK_SRCDIR)"/tools/configpp/_build/uberspark_configpp test.ml.us 
	#@cd temp && "$(UBERSPARK_SRCDIR)"/tools/configpp/_build/uberspark_configpp $(UBERSPARK_SRCDIR)/config/uberspark-constdefs-mf.json
	#@cd temp && "$(UBERSPARK_SRCDIR)"/tools/configpp/_build/uberspark_configpp test.c.us test.c $(UBERSPARK_SRCDIR)/config/uberspark-constdefs-mf.json
	#@cd temp && "$(UBERSPARK_SRCDIR)"/tools/configpp/_build/uberspark_configpp test.ml.us test.ml $(UBERSPARK_SRCDIR)/config/uberspark-constdefs-mf.json	
	@cd temp && "$(UBERSPARK_SRCDIR)"/tools/sdefpp/_build/uberspark_sdefpp test.mli.us test.mli $(UBERSPARK_SRCDIR)/config/uberspark-constdefs-mf.json	

### cleanup
.PHONY: clean
clean: 
	cd $(UBERSPARK_SRCDIR)/tools/sdefpp && $(MAKE) -w clean
