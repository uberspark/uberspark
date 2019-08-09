######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLC) -o usextbinutils.o -package unix -package ustypes -package usconfig -package uslog -package usosservices -linkpkg usextbinutils.ml
	ocamlfind remove usextbinutils 
	ocamlfind install usextbinutils META usextbinutils.cmi usextbinutils.cmo usextbinutils.o 


.PHONY: clean
clean:
	$(RM) -f usextbinutils.cmi
	$(RM) -f usextbinutils.cmo
	$(RM) -f usextbinutils.o
	
	
