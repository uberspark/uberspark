######
# Makefile for UberSpark tools
# author: amit vasudevan (amitvasudevan@acm.org)
######

#include ../uberspark-common.mk


###### targets

.PHONY: all
all: build-tools


.PHONY: build-tools
build-tools:
	cd ./libs && $(MAKE) -w all
	#cd ./driver && $(MAKE) -w all
	

.PHONY: clean
clean:
	cd ./libs && $(MAKE) -w clean
	cd ./driver && $(MAKE) -w clean
	$(RM) *_DEP
	
