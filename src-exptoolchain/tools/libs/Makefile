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


###### targets


.PHONY: prep
prep:
	$(MKDIR) -p $(BUILDDIR)
	$(CP) -f *.ml $(BUILDDIR)/.
	$(CP) -f ./META $(BUILDDIR)/.

.PHONY: all
all: prep
	cd $(BUILDDIR) && $(OCAMLC) -a $(UBERSPARK_LIB_SOURCES) $(UBERSPARK_LIB_EXT_PACKAGES) -o $(UBERSPARK_LIB_NAME).cma
	cd $(BUILDDIR) && $(OCAMLOPT) -a -ccopt -static $(UBERSPARK_LIB_SOURCES) $(UBERSPARK_LIB_EXT_PACKAGES) -o $(UBERSPARK_LIB_NAME).cmxa
	cd $(BUILDDIR) && $(OCAMLFIND) remove $(UBERSPARK_LIB_NAME) 
	cd $(BUILDDIR) && $(OCAMLFIND) install $(UBERSPARK_LIB_NAME) META $(UBERSPARK_LIB_NAME).cma $(UBERSPARK_LIB_NAME).cmxa $(UBERSPARK_LIB_NAME).a
	cd $(BUILDDIR) && $(OCAMLOPT) -ccopt -static -package $(UBERSPARK_LIB_NAME) -linkpkg -o test test.ml


.PHONY: clean
clean:
	$(RM) -rf $(BUILDDIR)
	
