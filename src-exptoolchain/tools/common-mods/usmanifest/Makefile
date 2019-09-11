######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -ccopt -static -c -package yojson -package str -package unix -package ustypes -package usconfig -package uslog -package usosservices -package usextbinutils -linkpkg usmanifest.ml
	ocamlfind remove usmanifest 
	ocamlfind install usmanifest META usmanifest.cmi usmanifest.cmx usmanifest.o 


.PHONY: clean
clean:
	$(RM) -f usmanifest.cmi
	$(RM) -f usmanifest.cmx
	$(RM) -f usmanifest.o
	
	
