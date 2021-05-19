######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######


###### variables

UBERSPARK_LIB_EXT_PACKAGES := -package unix
UBERSPARK_LIB_EXT_PACKAGES := -package fileutils
UBERSPARK_LIB_EXT_PACKAGES += -package str 
UBERSPARK_LIB_EXT_PACKAGES += -package yojson 


UBERSPARK_LIB_SOURCES := 
UBERSPARK_LIB_SOURCES += uberspark__defs.ml
UBERSPARK_LIB_SOURCES += uberspark__logger.ml
UBERSPARK_LIB_SOURCES += uberspark__osservices.ml
UBERSPARK_LIB_SOURCES += uberspark__utils.ml
UBERSPARK_LIB_SOURCES += uberspark__namespace.ml
UBERSPARK_LIB_SOURCES += uberspark__manifest.ml
UBERSPARK_LIB_SOURCES += uberspark__bridge.ml
UBERSPARK_LIB_SOURCES += uberspark__codegen.ml
UBERSPARK_LIB_SOURCES += uberspark__actions.ml
UBERSPARK_LIB_SOURCES += uberspark__context.ml

UBERSPARK_LIB_SOURCES_MLI := $(patsubst %.ml, %.mli, $(UBERSPARK_LIB_SOURCES))

UBERSPARK_LIB_INSTALL_CMO := $(patsubst %.ml, %.cmo, $(UBERSPARK_LIB_SOURCES))
UBERSPARK_LIB_INSTALL_CMX := $(patsubst %.ml, %.cmx, $(UBERSPARK_LIB_SOURCES))
UBERSPARK_LIB_INSTALL_CMI := $(patsubst %.ml, %.cmi, $(UBERSPARK_LIB_SOURCES))
UBERSPARK_LIB_INSTALL_CMT := $(patsubst %.ml, %.cmt, $(UBERSPARK_LIB_SOURCES))
UBERSPARK_LIB_INSTALL_CMTI := $(patsubst %.ml, %.cmti, $(UBERSPARK_LIB_SOURCES))

UBERSPARK_LIB_INSTALL := $(UBERSPARK_LIB_NAME).a 
UBERSPARK_LIB_INSTALL += $(UBERSPARK_LIB_NAME).cma 
UBERSPARK_LIB_INSTALL += $(UBERSPARK_LIB_NAME).cmxa

###### targets

.PHONY: prep_base
prep_base: 
	$(RM) -rf $(BUILDDIR)
	$(MKDIR) -p $(BUILDDIR)


.PHONY: prep_defs
prep_defs: prep_base
	$(MKDIR) -p $(BUILDDIR)/defs
	$(UBERSPARK_SDEFPP) defs/basedefs.ml.us $(BUILDDIR)/defs/basedefs.ml $(UBERSPARK_SDEFSDIR)/basedefs.json	
	$(UBERSPARK_SDEFPP) defs/basedefs.mli.us $(BUILDDIR)/defs/basedefs.mli $(UBERSPARK_SDEFSDIR)/basedefs.json	
	$(UBERSPARK_SDEFPP) defs/binformat.ml.us $(BUILDDIR)/defs/binformat.ml $(UBERSPARK_SDEFSDIR)/binformat.json	
	$(UBERSPARK_SDEFPP) defs/binformat.mli.us $(BUILDDIR)/defs/binformat.mli $(UBERSPARK_SDEFSDIR)/binformat.json	
	$(CP) uberspark__defs.ml.cppo $(BUILDDIR)/.
	$(CP) uberspark__defs.mli.cppo $(BUILDDIR)/.
	cd $(BUILDDIR) && $(CPPO) -n uberspark__defs.ml.cppo -o uberspark__defs.ml
	cd $(BUILDDIR) && $(CPPO) -n uberspark__defs.mli.cppo -o uberspark__defs.mli
	

.PHONY: prep_sources
prep_sources: prep_base prep_defs
	$(CP) -f *.ml $(BUILDDIR)/.
	$(CP) uberspark__manifest.ml.cppo $(BUILDDIR)/.
	cd $(BUILDDIR) && $(CPPO) -n uberspark__manifest.ml.cppo -o uberspark__manifest.ml
	$(CP) uberspark__bridge.ml.cppo $(BUILDDIR)/.
	cd $(BUILDDIR) && $(CPPO) -n uberspark__bridge.ml.cppo -o uberspark__bridge.ml
	$(CP) uberspark__codegen.ml.cppo $(BUILDDIR)/.
	cd $(BUILDDIR) && $(CPPO) -n uberspark__codegen.ml.cppo -o uberspark__codegen.ml
	$(CP) -f *.mli $(BUILDDIR)/.
	$(CP) -f ./META $(BUILDDIR)/.


.PHONY: all
all: prep_sources
	cd $(BUILDDIR) && $(OCAMLC) -no-alias-deps -c uberspark.ml
	cd $(BUILDDIR) && $(OCAMLC) -no-alias-deps -c -bin-annot -linkall -bin-annot $(UBERSPARK_LIB_SOURCES_MLI) $(UBERSPARK_LIB_SOURCES) $(UBERSPARK_LIB_EXT_PACKAGES)
	cd $(BUILDDIR) && $(OCAMLC) -a -linkall -bin-annot $(UBERSPARK_LIB_INSTALL_CMO) $(UBERSPARK_LIB_EXT_PACKAGES) -o $(UBERSPARK_LIB_NAME).cma
	cd $(BUILDDIR) && $(OCAMLOPT) -no-alias-deps -c uberspark.ml
	cd $(BUILDDIR) && $(OCAMLOPT) -no-alias-deps -c -bin-annot -linkall -bin-annot $(UBERSPARK_LIB_SOURCES_MLI) $(UBERSPARK_LIB_SOURCES) $(UBERSPARK_LIB_EXT_PACKAGES)
	cd $(BUILDDIR) && $(OCAMLOPT) -a -linkall -bin-annot $(UBERSPARK_LIB_INSTALL_CMX) $(UBERSPARK_LIB_EXT_PACKAGES) -o $(UBERSPARK_LIB_NAME).cmxa
	cd $(BUILDDIR) && $(OCAMLFIND) remove $(UBERSPARK_LIB_NAME) 
	cd $(BUILDDIR) && $(OCAMLFIND) install $(UBERSPARK_LIB_NAME) META $(UBERSPARK_LIB_INSTALL) $(UBERSPARK_LIB_INSTALL_CMO) $(UBERSPARK_LIB_INSTALL_CMX) $(UBERSPARK_LIB_INSTALL_CMI) $(UBERSPARK_LIB_NAME).cmi $(UBERSPARK_LIB_INSTALL_CMT) $(UBERSPARK_LIB_INSTALL_CMTI)  


#.PHONY: all
#all: unit_test


.PHONY: unit_test
unit_test: prep_base
	$(CP) -f unit_test/*.ml $(BUILDDIR)/.
	$(CP) -f unit_test/*.mli $(BUILDDIR)/.
	$(CP) -f unit_test/META $(BUILDDIR)/.
	cd $(BUILDDIR) && $(OCAMLC) -no-alias-deps -c mylib.ml
	cd $(BUILDDIR) && $(OCAMLC) -c -no-alias-deps mylib__*.mli mylib__*.ml
	cd $(BUILDDIR) && $(OCAMLC) -a -bin-annot mylib*.cmo -o mylib.cma
	cd $(BUILDDIR) && $(OCAMLOPT) -no-alias-deps -c mylib.ml
	cd $(BUILDDIR) && $(OCAMLOPT) -c -no-alias-deps mylib__*.mli mylib__*.ml
	cd $(BUILDDIR) && $(OCAMLOPT) -a -bin-annot mylib*.cmx -o mylib.cmxa
	cd $(BUILDDIR) && $(OCAMLFIND) remove mylib 
	cd $(BUILDDIR) && $(OCAMLFIND) install mylib META mylib.a mylib.cma mylib.cmxa mylib*.cmo mylib*.cmx mylib*.cmi   
	cd $(BUILDDIR) && $(OCAMLOPT) -ccopt -static -package mylib -linkpkg -o test test.ml


.PHONY: clean
clean:
	$(RM) -rf $(BUILDDIR)
	
