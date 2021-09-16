######
# Makefile to build uberSpark toolkit bridge plugins
# currently we have the following bridge plugins
#
# 1. as-bridge --> CASM assembler bridge plugin
# 2. vf-bridge --> uberSpark verification bridge plugin
#
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ./commondefs.mk

###### targets

.PHONY: all
all: 
	$(MAKE) -f build-libs.mk -w all
	cd $(UBERSPARK_SRCDIR)/tools/bridge-plugins/vf-bridge && $(MAKE) -w all

.PHONY: clean
clean: 
	$(MAKE) -f build-libs.mk -w clean
	cd $(UBERSPARK_SRCDIR)/tools/bridge-plugins/vf-bridge && $(MAKE) -w clean
	cd $(UBERSPARK_SRCDIR)/tools/bridge-plugins/vf-bridge && rm -rf top/
