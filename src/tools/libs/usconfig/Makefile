######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLC) -o usconfig.o usconfig.ml
	ocamlfind remove usconfig 
	ocamlfind install usconfig META usconfig.cmi usconfig.cmo usconfig.o 


.PHONY: clean
clean:
	$(RM) -f usconfig.cmi
	$(RM) -f usconfig.cmo
	$(RM) -f usconfig.o
	
	
