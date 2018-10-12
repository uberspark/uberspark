######
# Makefile for UberSpark tools (libs)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	cd usconfig && $(MAKE) -w all
	cd libuslog && $(MAKE) -w all
	cd usosservices && $(MAKE) -w all 
	cd usextbinutils && $(MAKE) -w all 
	cd libusmf && $(MAKE) -w all
	cd usuobjlib && $(MAKE) -w all

.PHONY: clean
clean:
	cd usconfig && $(MAKE) -w clean
	cd libuslog && $(MAKE) -w clean
	cd usosservices && $(MAKE) -w clean
	cd usextbinutils && $(MAKE) -w clean
	cd libusmf && $(MAKE) -w clean
	cd usuobjlib && $(MAKE) -w clean
	
