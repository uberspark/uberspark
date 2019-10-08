######
# Makefile for ubreSpark shared definition pre-processor tool
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ./commondefs.mk

###### targets

### install everything within the top-level _install/ folder
.PHONY: all
all: install_createnamespace install_populateamespace
	cp -f $(UBERSPARK_SRCDIR)/tools/frontend/_build/uberspark $(UBERSPARK_INSTALLDIR)/bin/uberspark
	@echo Installation ready to be committed.


### installation helper target to create namespace
.PHONY: install_createnamespace
install_createnamespace: 
	@echo Creating namespace within: $(UBERSPARK_INSTALLDIR)...
	rm -rf $(UBERSPARK_INSTALLDIR)
	mkdir -p $(UBERSPARK_INSTALLDIR)
	mkdir -p $(UBERSPARK_INSTALLDIR)/bin
	mkdir -p $(UBERSPARK_INSTALLDIR)/bridges
	mkdir -p $(UBERSPARK_INSTALLDIR)/config
	mkdir -p $(UBERSPARK_INSTALLDIR)/docs
	mkdir -p $(UBERSPARK_INSTALLDIR)/hwm
	mkdir -p $(UBERSPARK_INSTALLDIR)/include
	mkdir -p $(UBERSPARK_INSTALLDIR)/loaders
	mkdir -p $(UBERSPARK_INSTALLDIR)/platforms
	mkdir -p $(UBERSPARK_INSTALLDIR)/sentinels
	mkdir -p $(UBERSPARK_INSTALLDIR)/uobjcoll
	mkdir -p $(UBERSPARK_INSTALLDIR)/uobjrtl
	mkdir -p $(UBERSPARK_INSTALLDIR)/uobjslt
	mkdir -p $(UBERSPARK_INSTALLDIR)/uobjs
	@echo Namespace created.


### installation helper target to populate include namespace
.PHONY: install_populatenamespace_include
install_populateamespace_include: 
	cp -rf $(UBERSPARK_SRCDIR)/include/uberspark.h $(UBERSPARK_INSTALLDIR)/include/.
	$(UBERSPARK_SDEFPP) $(UBERSPARK_SRCDIR)/include/basedefs.h.us $(UBERSPARK_INSTALLDIR)/include/basedefs.h $(UBERSPARK_SDEFSDIR)/basedefs.json
	$(UBERSPARK_SDEFPP) $(UBERSPARK_SRCDIR)/include/binformat.h.us $(UBERSPARK_INSTALLDIR)/include/binformat.h $(UBERSPARK_SDEFSDIR)/binformat.json




### installation helper target to populate namespace
.PHONY: install_populatenamespace
install_populateamespace: install_populateamespace_include
	@echo Populating namespace within: $(UBERSPARK_INSTALLDIR)...
	cp -rf $(UBERSPARK_SRCDIR)/bridges/* $(UBERSPARK_INSTALLDIR)/bridges/.
	cp -rf $(UBERSPARK_SRCDIR)/config/* $(UBERSPARK_INSTALLDIR)/config/
	cp -rf $(UBERSPARK_DOCSDIR)/_build/* $(UBERSPARK_INSTALLDIR)/docs/.
	cp -rf $(UBERSPARK_SRCDIR)/hwm/* $(UBERSPARK_INSTALLDIR)/hwm/.
	cp -rf $(UBERSPARK_SRCDIR)/loaders/* $(UBERSPARK_INSTALLDIR)/loaders/.
	cp -rf $(UBERSPARK_SRCDIR)/platforms/* $(UBERSPARK_INSTALLDIR)/platforms/.
	cp -rf $(UBERSPARK_SRCDIR)/sentinels/* $(UBERSPARK_INSTALLDIR)/sentinels/.
	cp -rf $(UBERSPARK_SRCDIR)/uobjcoll/* $(UBERSPARK_INSTALLDIR)/uobjcoll/.
	cp -rf $(UBERSPARK_SRCDIR)/uobjrtl/* $(UBERSPARK_INSTALLDIR)/uobjrtl/.
	cp -rf $(UBERSPARK_SRCDIR)/uobjslt/* $(UBERSPARK_INSTALLDIR)/uobjslt/.
	cp -rf $(UBERSPARK_SRCDIR)/uobjs/* $(UBERSPARK_INSTALLDIR)/uobjs/.
	@echo Namespace populated.



### cleanup
.PHONY: clean
clean: 
	rm -rf $(UBERSPARK_INSTALLDIR) 
