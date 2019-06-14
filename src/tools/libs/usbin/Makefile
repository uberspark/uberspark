######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLC) -o usbin.o usbin.ml
	ocamlfind remove usbin 
	ocamlfind install usbin META usbin.cmi usbin.cmo usbin.o 


.PHONY: clean
clean:
	$(RM) -f usbin.cmi
	$(RM) -f usbin.cmo
	$(RM) -f usbin.o
	
	
