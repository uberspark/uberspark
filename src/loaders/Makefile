######
# top-level Makefile for uberSpark loaders
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### compute current path (where this Makefile resides)
export US_LOADERSDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))


###### include biolerplate Makefile code
include ../uberspark-common.mk


###### targets
.PHONY: all
all:	build-loaders

.PHONY: install
install: install-loaders


.PHONY: build-loaders
build-loaders:
	cd $(USPARK_LOADERSDIR)/linux-um && make -w build	

.PHONY: install-loaders
install-loaders:
	

.PHONY: clean
clean:
	cd $(USPARK_LOADERSDIR)/linux-um && make -w clean	
	

