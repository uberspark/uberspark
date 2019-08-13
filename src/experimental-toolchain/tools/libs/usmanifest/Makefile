######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLC) -o usmanifest.o -package str -package yojson -package unix -package ustypes -package usconfig -package uslog -package usosservices -package usextbinutils -linkpkg usmanifest.ml
	ocamlfind remove usmanifest 
	ocamlfind install usmanifest META usmanifest.cmi usmanifest.cmo usmanifest.o 


.PHONY: clean
clean:
	$(RM) -f usmanifest.cmi
	$(RM) -f usmanifest.cmo
	$(RM) -f usmanifest.o
	
	
