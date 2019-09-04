######
# Makefile for libusmf --- uobj manifest parsing module
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -c -package unix -package str -package yojson -package usconfig -package uslog	-package usosservices -package usextbinutils -linkpkg libusmf.ml
	ocamlfind remove libusmf 
	ocamlfind install libusmf META libusmf.cmi libusmf.cmx libusmf.o 


.PHONY: clean
clean:
	$(RM) -f libusmf.cmi
	$(RM) -f libusmf.cmx
	$(RM) -f libusmf.o
	
	
