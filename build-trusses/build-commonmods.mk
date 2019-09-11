######
# Makefile to build uberSpark toolkit common modules
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ./commondefs.mk

###### targets

### common modules build prep
.PHONY: commonmods_build_prep
commonmods_build_prep:
	mkdir -p $(UBERSPARK_BUILDDIR)
	mkdir -p $(UBERSPARK_BUILDDIR)/commonmods


### build common modules
.PHONY: commonmods
commonmods: commonmods_build_prep
	mkdir -p $(UBERSPARK_BUILDDIR)/commonmods/ustypes && \
		cd $(UBERSPARK_BUILDDIR)/commonmods/ustypes && \
		make -f $(UBERSPARK_SRCDIR)/tools/libs/ustypes/build.mk -w all