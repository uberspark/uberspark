######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -ccopt -static -c -package str -package yojson -package unix  -package ustypes -package usconfig -package uslog -package usosservices -package usmanifest -package usuobj -linkpkg usbin.ml
	ocamlfind remove usbin 
	ocamlfind install usbin META usbin.cmi usbin.cmx usbin.o 


.PHONY: clean
clean:
	$(RM) -f usbin.cmi
	$(RM) -f usbin.cmx
	$(RM) -f usbin.o
	
	
