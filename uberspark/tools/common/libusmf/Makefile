######
# Makefile for libusmf --- uobj manifest parsing module
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLC) -package unix -package str -package yojson -package uslog	-linkpkg -o libusmf.o libusmf.ml
	ocamlfind remove libusmf 
	ocamlfind install libusmf META libusmf.cmi libusmf.cmo libusmf.o 


.PHONY: clean
clean:
	$(RM) -f libusmf.cmi
	$(RM) -f libusmf.cmo
	$(RM) -f libusmf.o
	
	
