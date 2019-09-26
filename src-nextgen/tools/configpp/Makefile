######
# Makefile for uberSpark configuration pre-processing tool
# author: amit vasudevan (amitvasudevan@acm.org)
######


###### variables

UBERSPARK_CONFIGPP_EXT_PACKAGES := -package unix
UBERSPARK_CONFIGPP_EXT_PACKAGES += -package str 
UBERSPARK_CONFIGPP_EXT_PACKAGES += -package yojson 

UBERSPARK_CONFIGPP_SOURCES := uberspark_configpp.ml


###### targets

.PHONY: prep
prep:
	$(MKDIR) -p $(BUILDDIR)
	$(CP) -f $(UBERSPARK_CONFIGPP_SOURCES) $(BUILDDIR)/.


.PHONY: all
all:  prep
	cd $(BUILDDIR) && $(OCAMLOPT) -ccopt -static $(UBERSPARK_CONFIGPP_EXT_PACKAGES) -linkpkg -o $(UBERSPARK_CONFIGPP_BIN_NAME) $(UBERSPARK_CONFIGPP_SOURCES)

.PHONY: clean
clean:
	$(RM) -rf $(BUILDDIR)

