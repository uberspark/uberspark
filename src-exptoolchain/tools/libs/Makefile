######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######


###### variables

UBERSPARK_LIB_EXT_PACKAGES := -package unix
UBERSPARK_LIB_EXT_PACKAGES += -package str 
UBERSPARK_LIB_EXT_PACKAGES += -package yojson 



UBERSPARK_LIB_SOURCES := uberspark_basetypes.ml
UBERSPARK_LIB_SOURCES += uberspark_config.ml
UBERSPARK_LIB_SOURCES += uberspark_logger.ml
UBERSPARK_LIB_SOURCES += uberspark_osservices.ml
UBERSPARK_LIB_SOURCES += uberspark_manifest.ml
UBERSPARK_LIB_SOURCES += uberspark_binary.ml
UBERSPARK_LIB_SOURCES += uberspark_uobj.ml
UBERSPARK_LIB_SOURCES += uberspark.ml


UBERSPARK_LIB_SOURCES_MLI := $(patsubst %.ml, %.mli, $(UBERSPARK_LIB_SOURCES))
UBERSPARK_LIB_INSTALL_CMX := $(patsubst %.ml, %.cmx, $(UBERSPARK_LIB_SOURCES))

UBERSPARK_LIB_INSTALL := $(UBERSPARK_LIB_NAME).a 
UBERSPARK_LIB_INSTALL += $(UBERSPARK_LIB_NAME).cma 
UBERSPARK_LIB_INSTALL += $(UBERSPARK_LIB_NAME).cmi
UBERSPARK_LIB_INSTALL += $(UBERSPARK_LIB_NAME).cmt
UBERSPARK_LIB_INSTALL += $(UBERSPARK_LIB_NAME).cmti
UBERSPARK_LIB_INSTALL += $(UBERSPARK_LIB_NAME).cmxa
UBERSPARK_LIB_INSTALL += $(UBERSPARK_LIB_NAME).mli

###### targets


.PHONY: prep
prep:
	$(RM) -rf $(BUILDDIR)
	$(MKDIR) -p $(BUILDDIR)
	$(CP) -f *.ml $(BUILDDIR)/.
	$(CP) -f ./META $(BUILDDIR)/.
	$(CP) -f *.mli $(BUILDDIR)/.


.PHONY: all
all: prep
#	cd $(BUILDDIR) && $(OCAMLC) -i $(UBERSPARK_LIB_SOURCES) $(UBERSPARK_LIB_EXT_PACKAGES) > test.mli
	cd $(BUILDDIR) && $(OCAMLC) -c -bin-annot $(UBERSPARK_LIB_SOURCES_MLI) $(UBERSPARK_LIB_EXT_PACKAGES)
	cd $(BUILDDIR) && $(OCAMLC) -a -bin-annot $(UBERSPARK_LIB_SOURCES) $(UBERSPARK_LIB_EXT_PACKAGES) -o $(UBERSPARK_LIB_NAME).cma
	cd $(BUILDDIR) && $(OCAMLOPT) -a -bin-annot -ccopt -static $(UBERSPARK_LIB_SOURCES) $(UBERSPARK_LIB_EXT_PACKAGES) -o $(UBERSPARK_LIB_NAME).cmxa
	cd $(BUILDDIR) && $(OCAMLFIND) remove $(UBERSPARK_LIB_NAME) 
	cd $(BUILDDIR) && $(OCAMLFIND) install $(UBERSPARK_LIB_NAME) META $(UBERSPARK_LIB_INSTALL) $(UBERSPARK_LIB_INSTALL_CMX)
#	$(OCAMLOPT) -ccopt -static -package $(UBERSPARK_LIB_NAME) -linkpkg -o test test.ml


.PHONY: clean
clean:
	$(RM) -rf $(BUILDDIR)
	
