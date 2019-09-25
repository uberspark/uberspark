######
# Makefile to build uberSpark toolkit common modules
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ./commondefs.mk

###### targets

.PHONY: all
all: 
	cd $(UBERSPARK_SRCDIR)/tools/libs && $(MAKE) -w all

.PHONY: clean
clean: 
	cd $(UBERSPARK_SRCDIR)/tools/libs && $(MAKE) -w clean


### build common modules
#.PHONY: ball
#ball: 
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/ustypes && $(MAKE) -w all
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/usconfig && $(MAKE) -w all
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/uslog && $(MAKE) -w all
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/usosservices && $(MAKE) -w all 
#	#cd $(UBERSPARK_SRCDIR)/tools/common-mods/usextbinutils && $(MAKE) -w all 
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/usmanifest && $(MAKE) -w all
#	#cd $(UBERSPARK_SRCDIR)/tools/common-mods/libusmf && $(MAKE) -w all
#	#cd $(UBERSPARK_SRCDIR)/tools/common-mods/usuobjgen && $(MAKE) -w all
#	#cd $(UBERSPARK_SRCDIR)/tools/common-mods/usuobjlib && $(MAKE) -w all
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/usuobj && $(MAKE) -w all
#	#cd $(UBERSPARK_SRCDIR)/tools/common-mods/usuobjcollection && $(MAKE) -w all
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/usbin && $(MAKE) -w all

### cleanup
#.PHONY: clean
#clean: 
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/ustypes && $(MAKE) -w clean
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/usconfig && $(MAKE) -w clean
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/uslog && $(MAKE) -w clean
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/usosservices && $(MAKE) -w clean 
#	#cd $(UBERSPARK_SRCDIR)/tools/common-mods/usextbinutils && $(MAKE) -w clean 
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/usmanifest && $(MAKE) -w clean
#	#cd $(UBERSPARK_SRCDIR)/tools/common-mods/libusmf && $(MAKE) -w clean
#	#cd $(UBERSPARK_SRCDIR)/tools/common-mods/usuobjgen && $(MAKE) -w clean
#	#cd $(UBERSPARK_SRCDIR)/tools/common-mods/usuobjlib && $(MAKE) -w clean
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/usuobj && $(MAKE) -w clean
#	#cd $(UBERSPARK_SRCDIR)/tools/common-mods/usuobjcollection && $(MAKE) -w clean
#	cd $(UBERSPARK_SRCDIR)/tools/common-mods/usbin && $(MAKE) -w clean
