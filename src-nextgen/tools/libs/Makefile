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
UBERSPARK_LIB_SOURCES += defs.ml
UBERSPARK_LIB_SOURCES += uberspark_logger.ml
UBERSPARK_LIB_SOURCES += uberspark_osservices.ml
UBERSPARK_LIB_SOURCES += uberspark_namespace.ml
UBERSPARK_LIB_SOURCES += uberspark_manifest.ml
UBERSPARK_LIB_SOURCES += uberspark_config.ml
UBERSPARK_LIB_SOURCES += uberspark_staging.ml
UBERSPARK_LIB_SOURCES += uberspark_bridge.ml
UBERSPARK_LIB_SOURCES += uberspark_codegen.ml
UBERSPARK_LIB_SOURCES += uberspark_actions.ml
UBERSPARK_LIB_SOURCES += uberspark_loader.ml
UBERSPARK_LIB_SOURCES += uberspark_uobj.ml
UBERSPARK_LIB_SOURCES += uberspark_uobjcoll.ml
UBERSPARK_LIB_SOURCES += uberspark_binary.ml
UBERSPARK_LIB_SOURCES += uberspark.ml


UBERSPARK_LIB_SOURCES_MLI := $(patsubst %.ml, %.mli, $(UBERSPARK_LIB_SOURCES))
UBERSPARK_LIB_INSTALL_CMX := $(patsubst %.ml, %.cmx, $(UBERSPARK_LIB_SOURCES))
UBERSPARK_LIB_INSTALL_CMI := $(patsubst %.ml, %.cmi, $(UBERSPARK_LIB_SOURCES))
UBERSPARK_LIB_INSTALL_CMT := $(patsubst %.ml, %.cmt, $(UBERSPARK_LIB_SOURCES))
UBERSPARK_LIB_INSTALL_CMTI := $(patsubst %.ml, %.cmti, $(UBERSPARK_LIB_SOURCES))

UBERSPARK_LIB_INSTALL := $(UBERSPARK_LIB_NAME).a 
UBERSPARK_LIB_INSTALL += $(UBERSPARK_LIB_NAME).cma 
UBERSPARK_LIB_INSTALL += $(UBERSPARK_LIB_NAME).cmxa
UBERSPARK_LIB_INSTALL += $(UBERSPARK_LIB_NAME).mli

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
	$(CP) defs.ml.cppo $(BUILDDIR)/.
	$(CP) defs.mli.cppo $(BUILDDIR)/.
	cd $(BUILDDIR) && $(CPPO) -n defs.ml.cppo -o defs.ml
	cd $(BUILDDIR) && $(CPPO) -n defs.mli.cppo -o defs.mli
	

.PHONY: prep_sources
prep_sources: prep_base prep_defs
	$(CP) -f *.ml $(BUILDDIR)/.
	$(CP) uberspark_manifest.ml.cppo $(BUILDDIR)/.
	cd $(BUILDDIR) && $(CPPO) -n uberspark_manifest.ml.cppo -o uberspark_manifest.ml
	$(CP) uberspark_bridge.ml.cppo $(BUILDDIR)/.
	cd $(BUILDDIR) && $(CPPO) -n uberspark_bridge.ml.cppo -o uberspark_bridge.ml
	$(CP) uberspark_codegen.ml.cppo $(BUILDDIR)/.
	cd $(BUILDDIR) && $(CPPO) -n uberspark_codegen.ml.cppo -o uberspark_codegen.ml
	$(CP) -f *.mli $(BUILDDIR)/.
	$(CP) uberspark.mli.cppo $(BUILDDIR)/.
	cd $(BUILDDIR) && $(CPPO) -n uberspark.mli.cppo -o uberspark.mli
	$(CP) -f ./META $(BUILDDIR)/.


.PHONY: all
all: prep_sources
	cd $(BUILDDIR) && $(OCAMLC) -c -bin-annot $(UBERSPARK_LIB_SOURCES_MLI) $(UBERSPARK_LIB_EXT_PACKAGES)
	cd $(BUILDDIR) && $(OCAMLC) -a -bin-annot $(UBERSPARK_LIB_SOURCES) $(UBERSPARK_LIB_EXT_PACKAGES) -o $(UBERSPARK_LIB_NAME).cma
	cd $(BUILDDIR) && $(OCAMLOPT) -a -bin-annot -ccopt -static $(UBERSPARK_LIB_SOURCES) $(UBERSPARK_LIB_EXT_PACKAGES) -o $(UBERSPARK_LIB_NAME).cmxa
	cd $(BUILDDIR) && $(OCAMLFIND) remove $(UBERSPARK_LIB_NAME) 
	cd $(BUILDDIR) && $(OCAMLFIND) install $(UBERSPARK_LIB_NAME) META $(UBERSPARK_LIB_INSTALL) $(UBERSPARK_LIB_INSTALL_CMX) $(UBERSPARK_LIB_INSTALL_CMI) $(UBERSPARK_LIB_INSTALL_CMT) $(UBERSPARK_LIB_INSTALL_CMTI)  


.PHONY: clean
clean:
	$(RM) -rf $(BUILDDIR)
	
