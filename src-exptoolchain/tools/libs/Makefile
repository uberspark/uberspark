######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######


###### variables
BUILDDIR = _build
LIB_NAME = uberspark

LIB_EXT_PACKAGES := -package unix
LIB_EXT_PACKAGES += -package str 
LIB_EXT_PACKAGES += -package yojson 


LIB_SOURCES := uberspark_basetypes.ml
LIB_SOURCES += uberspark_config.ml
LIB_SOURCES += uberspark_logger.ml
LIB_SOURCES += uberspark_osservices.ml
LIB_SOURCES += uberspark_manifest.ml
LIB_SOURCES += uberspark_binary.ml
LIB_SOURCES += uberspark_uobj.ml
LIB_SOURCES += uberspark.ml


###### targets


.PHONY: prep
prep:
	$(MKDIR) -p $(BUILDDIR)
	$(CP) -f *.ml $(BUILDDIR)/.
	$(CP) -f ./META $(BUILDDIR)/.

.PHONY: all
all: prep
	cd $(BUILDDIR) && $(OCAMLC) -a $(LIB_SOURCES) $(LIB_EXT_PACKAGES) -o $(LIB_NAME).cma
	cd $(BUILDDIR) && $(OCAMLOPT) -a -ccopt -static $(LIB_SOURCES) $(LIB_EXT_PACKAGES) -o $(LIB_NAME).cmxa
	cd $(BUILDDIR) && $(OCAMLFIND) remove $(LIB_NAME) 
	cd $(BUILDDIR) && $(OCAMLFIND) install $(LIB_NAME) META $(LIB_NAME).cma $(LIB_NAME).cmxa $(LIB_NAME).a
	cd $(BUILDDIR) && $(OCAMLOPT) -ccopt -static -package $(LIB_NAME) -linkpkg -o test test.ml


.PHONY: clean
clean:
	$(RM) -rf $(BUILDDIR)
	
