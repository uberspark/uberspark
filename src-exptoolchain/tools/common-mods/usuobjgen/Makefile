######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######


###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -ccopt -static -c -package str -package yojson -package unix -package ustypes -package usconfig -package uslog -package usosservices -package usextbinutils -package usmanifest -linkpkg usuobjgen.ml
	ocamlfind remove usuobjgen 
	ocamlfind install usuobjgen META usuobjgen.cmi usuobjgen.cmx usuobjgen.o 


.PHONY: clean
clean:
	$(RM) -f usuobjgen.cmi
	$(RM) -f usuobjgen.cmx
	$(RM) -f usuobjgen.o
	
	
