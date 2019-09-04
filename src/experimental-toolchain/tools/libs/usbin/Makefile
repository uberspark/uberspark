######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -c -package str -package yojson -package unix  -package ustypes -package usconfig -package uslog -package usosservices -package usextbinutils -package usmanifest -package usuobjgen -package usuobj -package usuobjcollection -linkpkg usbin.ml
	ocamlfind remove usbin 
	ocamlfind install usbin META usbin.cmi usbin.cmx usbin.o 


.PHONY: clean
clean:
	$(RM) -f usbin.cmi
	$(RM) -f usbin.cmx
	$(RM) -f usbin.o
	
	
