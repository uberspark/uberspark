######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLC) -o usosservices.o -package unix -package uslog -linkpkg usosservices.ml
	ocamlfind remove usosservices 
	ocamlfind install usosservices META usosservices.cmi usosservices.cmo usosservices.o 


.PHONY: clean
clean:
	$(RM) -f usosservices.cmi
	$(RM) -f usosservices.cmo
	$(RM) -f usosservices.o
	
	
