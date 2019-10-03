######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######


###### variables

UBERSPARK_LIB_EXT_PACKAGES := -package unix
UBERSPARK_LIB_EXT_PACKAGES += -package str 
UBERSPARK_LIB_EXT_PACKAGES += -package yojson 


UBERSPARK_LIB_SOURCES := basedefs.ml
UBERSPARK_LIB_SOURCES += uberspark_config.ml
UBERSPARK_LIB_SOURCES += uberspark_logger.ml
UBERSPARK_LIB_SOURCES += uberspark_osservices.ml
UBERSPARK_LIB_SOURCES += uberspark_manifest.ml
UBERSPARK_LIB_SOURCES += uberspark_binary.ml
UBERSPARK_LIB_SOURCES += uberspark_uobj.ml

UBERSPARK_LIB_SOURCES_MAIN := uberspark.ml
UBERSPARK_LIB_SOURCES_MAIN_MLI := uberspark.mli
UBERSPARK_LIB_SOURCES_MAIN_CMX := uberspark.cmx
UBERSPARK_LIB_SOURCES_MAIN_CMI := uberspark.cmi
UBERSPARK_LIB_SOURCES_MAIN_CMT := uberspark.cmt
UBERSPARK_LIB_SOURCES_MAIN_CMTI := uberspark.cmti


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



.PHONY: prep
prep:
	$(RM) -rf $(BUILDDIR)
	$(MKDIR) -p $(BUILDDIR)
	$(CP) -f $(UBERSPARK_LIB_SOURCES) $(BUILDDIR)/.
	$(CP) -f $(UBERSPARK_LIB_SOURCES_MAIN) $(BUILDDIR)/.
	$(CP) -f ./META $(BUILDDIR)/.
	$(CP) -f $(UBERSPARK_LIB_SOURCES_MLI) $(BUILDDIR)/.
	$(CPPO) -n uberspark.mli.cppo -o $(BUILDDIR)/uberspark.mli
	#@cd temp && $(UBERSPARK_SDEFPP) test.mli.us test.mli $(UBERSPARK_SRCDIR)/config/uberspark-constdefs-mf.json	
	#cppo -n inputfile -o outputfile

.PHONY: all
all: prep
	cd $(BUILDDIR) && $(OCAMLC) -c -bin-annot $(UBERSPARK_LIB_SOURCES_MLI) $(UBERSPARK_LIB_SOURCES_MAIN_MLI) $(UBERSPARK_LIB_EXT_PACKAGES)
	cd $(BUILDDIR) && $(OCAMLC) -a -bin-annot $(UBERSPARK_LIB_SOURCES) $(UBERSPARK_LIB_SOURCES_MAIN) $(UBERSPARK_LIB_EXT_PACKAGES) -o $(UBERSPARK_LIB_NAME).cma
	cd $(BUILDDIR) && $(OCAMLOPT) -a -bin-annot -ccopt -static $(UBERSPARK_LIB_SOURCES) $(UBERSPARK_LIB_SOURCES_MAIN) $(UBERSPARK_LIB_EXT_PACKAGES) -o $(UBERSPARK_LIB_NAME).cmxa
	cd $(BUILDDIR) && $(OCAMLFIND) remove $(UBERSPARK_LIB_NAME) 
	cd $(BUILDDIR) && $(OCAMLFIND) install $(UBERSPARK_LIB_NAME) META $(UBERSPARK_LIB_INSTALL) $(UBERSPARK_LIB_INSTALL_CMX) $(UBERSPARK_LIB_SOURCES_MAIN_CMX) $(UBERSPARK_LIB_INSTALL_CMI) $(UBERSPARK_LIB_SOURCES_MAIN_CMI) $(UBERSPARK_LIB_INSTALL_CMT) $(UBERSPARK_LIB_SOURCES_MAIN_CMT) $(UBERSPARK_LIB_INSTALL_CMTI) $(UBERSPARK_LIB_SOURCES_MAIN_CMTI)


.PHONY: clean
clean:
	$(RM) -rf $(BUILDDIR)
	
