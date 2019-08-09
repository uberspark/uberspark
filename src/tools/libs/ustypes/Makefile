######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLC) -o ustypes.o ustypes.ml
	ocamlfind remove ustypes 
	ocamlfind install ustypes META ustypes.cmi ustypes.cmo ustypes.o 


.PHONY: clean
clean:
	$(RM) -f ustypes.cmi
	$(RM) -f ustypes.cmo
	$(RM) -f ustypes.o
	
	
