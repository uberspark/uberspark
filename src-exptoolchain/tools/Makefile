######
# Makefile for UberSpark tools
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../uberspark-common.mk

###### opam libraries
#export OPAM_LIBRARIES := -I $(OCAML_TOPLEVEL_PATH)/../yojson

###### targets

.PHONY: all
all: build-tools


.PHONY: build-tools
build-tools:
	@echo $(OPAM_LIBRARIES)
	cd ./libs && $(MAKE) -w all
	#$(OCAMLC) -o ubersparkconfig unix.cma ubersparkconfig.ml
	cd ./driver && $(MAKE) -w all
	

.PHONY: clean
clean:
	cd ./libs && $(MAKE) -w clean
	cd ./driver && $(MAKE) -w clean
	$(RM) *_DEP
	#$(RM) ubersparkconfig ubersparkconfig.cmi ubersparkconfig.cmo
	
