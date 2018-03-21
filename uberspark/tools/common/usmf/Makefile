######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLC) -package uslog -package unix -package str -package yojson -linkpkg -o usmf.o usmf.ml
	ocamlfind remove usmf 
	ocamlfind install usmf META usmf.cmi usmf.cmo usmf.o 


.PHONY: clean
clean:
	$(RM) -f usmf.cmi
	$(RM) -f usmf.cmo
	$(RM) -f usmf.o
	
	
