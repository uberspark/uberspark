######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

#include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -ccopt -static -c ustypes.ml
	ocamlfind remove ustypes 
	ocamlfind install ustypes META ustypes.cmi ustypes.cmx ustypes.o 


.PHONY: clean
clean:
	$(RM) -f ustypes.cmi
	$(RM) -f ustypes.cmx
	$(RM) -f ustypes.o
	
	
