######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -ccopt -static -c -package str -package yojson -package unix  -package ustypes -package usconfig -package uslog -package usosservices -package usextbinutils -package usmanifest -package usuobjgen -package usuobj -linkpkg usuobjcollection.ml
	ocamlfind remove usuobjcollection 
	ocamlfind install usuobjcollection META usuobjcollection.cmi usuobjcollection.cmx usuobjcollection.o 


.PHONY: clean
clean:
	$(RM) -f usuobjcollection.cmi
	$(RM) -f usuobjcollection.cmx
	$(RM) -f usuobjcollection.o
	
	
