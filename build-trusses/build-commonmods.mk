######
# Makefile to build uberSpark toolkit common modules
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ./commondefs.mk

###### targets

### build common modules
.PHONY: commonmods
commonmods: 
	cd $(UBERSPARK_SRCDIR)/tools/libs/ustypes && $(MAKE) -w all
	cd $(UBERSPARK_SRCDIR)/tools/libs/usconfig && $(MAKE) -w all
	cd $(UBERSPARK_SRCDIR)/tools/libs/libuslog && $(MAKE) -w all
	cd $(UBERSPARK_SRCDIR)/tools/libs/usosservices && $(MAKE) -w all 
	cd $(UBERSPARK_SRCDIR)/tools/libs/usextbinutils && $(MAKE) -w all 
	cd $(UBERSPARK_SRCDIR)/tools/libs/usmanifest && $(MAKE) -w all
	cd $(UBERSPARK_SRCDIR)/tools/libs/libusmf && $(MAKE) -w all
	cd $(UBERSPARK_SRCDIR)/tools/libs/usuobjgen && $(MAKE) -w all
	cd $(UBERSPARK_SRCDIR)/tools/libs/usuobjlib && $(MAKE) -w all
	cd $(UBERSPARK_SRCDIR)/tools/libs/usuobj && $(MAKE) -w all
	cd $(UBERSPARK_SRCDIR)/tools/libs/usuobjcollection && $(MAKE) -w all
	cd $(UBERSPARK_SRCDIR)/tools/libs/usbin && $(MAKE) -w all
