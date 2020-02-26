######
# Makefile for uberSpark shared definitions pre-processing tool
# author: amit vasudevan (amitvasudevan@acm.org)
######


###### variables

UBERSPARK_SDEFPP_EXT_PACKAGES := -package unix
UBERSPARK_SDEFPP_EXT_PACKAGES += -package str 
UBERSPARK_SDEFPP_EXT_PACKAGES += -package yojson 

UBERSPARK_SDEFPP_SOURCES := uberspark_sdefpp.ml


###### targets

.PHONY: prep
prep:
	$(MKDIR) -p $(BUILDDIR)
	$(CP) -f $(UBERSPARK_SDEFPP_SOURCES) $(BUILDDIR)/.


.PHONY: all
all:  prep
	cd $(BUILDDIR) && $(OCAMLOPT) -ccopt -static $(UBERSPARK_SDEFPP_EXT_PACKAGES) -linkpkg -o $(UBERSPARK_SDEFPP_BIN_NAME) $(UBERSPARK_SDEFPP_SOURCES)

.PHONY: clean
clean:
	$(RM) -rf $(BUILDDIR)

