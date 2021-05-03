######
# Makefile for uberSpark driver 
# author: amit vasudevan (amitvasudevan@acm.org)
######


###### variables

UBERSPARK_FRONTEND_EXT_PACKAGES := -package unix
UBERSPARK_FRONTEND_EXT_PACKAGES := -package sys
UBERSPARK_FRONTEND_EXT_PACKAGES := -package fileutils
UBERSPARK_FRONTEND_EXT_PACKAGES += -package str 
UBERSPARK_FRONTEND_EXT_PACKAGES += -package yojson 
UBERSPARK_FRONTEND_EXT_PACKAGES += -package cmdliner
UBERSPARK_FRONTEND_EXT_PACKAGES += -package astring
UBERSPARK_FRONTEND_EXT_PACKAGES += -package $(UBERSPARK_LIB_NAME)


UBERSPARK_FRONTEND_SOURCES := commonopts.ml
UBERSPARK_FRONTEND_SOURCES += common.ml
#UBERSPARK_FRONTEND_SOURCES += cmd_uobj.ml
#UBERSPARK_FRONTEND_SOURCES += cmd_uobjcoll.ml
UBERSPARK_FRONTEND_SOURCES += cmd_staging.ml
UBERSPARK_FRONTEND_SOURCES += cmd_bridge.ml
UBERSPARK_FRONTEND_SOURCES += cmd_build.ml
UBERSPARK_FRONTEND_SOURCES += cmd_verify.ml
UBERSPARK_FRONTEND_SOURCES += cmd_default.ml
UBERSPARK_FRONTEND_SOURCES += uberspark_frontend.ml


###### targets

.PHONY: prep
prep:
	$(MKDIR) -p $(BUILDDIR)
	$(CP) -f *.ml $(BUILDDIR)/.


.PHONY: all
all:  prep
	cd $(BUILDDIR) && $(OCAMLOPT) -ccopt -static $(UBERSPARK_FRONTEND_EXT_PACKAGES) -linkpkg -o $(UBERSPARK_BIN_NAME) $(UBERSPARK_FRONTEND_SOURCES)

.PHONY: clean
clean:
	$(RM) -rf $(BUILDDIR)

