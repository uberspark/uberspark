######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -ccopt -static -c -package str -package yojson -package unix  -package usconfig -package uslog -package usosservices -package usextbinutils -package usmanifest -linkpkg usuobjlib.ml
	ocamlfind remove usuobjlib 
	ocamlfind install usuobjlib META usuobjlib.cmi usuobjlib.cmx usuobjlib.o 


.PHONY: clean
clean:
	$(RM) -f usuobjlib.cmi
	$(RM) -f usuobjlib.cmx
	$(RM) -f usuobjlib.o
	
	
