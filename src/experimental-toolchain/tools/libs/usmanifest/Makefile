######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -c -package str -package yojson -package unix -package ustypes -package usconfig -package uslog -package usosservices -package usextbinutils -linkpkg usmanifest.ml
	ocamlfind remove usmanifest 
	ocamlfind install usmanifest META usmanifest.cmi usmanifest.cmx usmanifest.o 


.PHONY: clean
clean:
	$(RM) -f usmanifest.cmi
	$(RM) -f usmanifest.cmx
	$(RM) -f usmanifest.o
	
	
