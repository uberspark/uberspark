######
# top-level Makefile for uberSpark loaders
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### compute current path (where this Makefile resides)
export US_LOADERSDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))


###### include biolerplate Makefile code
include ../uberspark-common.mk


###### targets
.PHONY: build
build:	build-loaders

.PHONY: install
install: install-loaders


.PHONY: build-loaders
build-loaders:
	cd $(USPARK_LOADERSDIR)/linux-um && make -w build	

.PHONY: install-loaders
install-loaders:
	$(MKDIR) -p $(USPARK_INSTALL_LOADERSDIR)
	#$(MKDIR) -p $(USPARK_INSTALL_LOADERSINCLUDESDIR)
	$(CP) -f $(USPARK_LOADERSDIR)/linux-um/libusloader-linux-um.a $(USPARK_INSTALL_LOADERSDIR)/.
	$(CP) -f $(USPARK_LOADERSDIR)/linux-um/libusloader-linux-um.a.deps $(USPARK_INSTALL_LOADERSDIR)/.
	$(CP) -f $(USPARK_LOADERSDIR)/linux-um/usloader-linux-um.h $(USPARK_INSTALL_LOADERSDIR)/.
	

.PHONY: clean
clean:
	cd $(USPARK_LOADERSDIR)/linux-um && make -w clean	
	

