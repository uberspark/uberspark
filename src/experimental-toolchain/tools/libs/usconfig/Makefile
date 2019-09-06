######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLOPT) $(OPAM_LIBRARIES) -c usconfig.ml
	ocamlfind remove usconfig 
	ocamlfind install usconfig META usconfig.cmi usconfig.cmx usconfig.o 


.PHONY: clean
clean:
	$(RM) -f usconfig.cmi
	$(RM) -f usconfig.cmx
	$(RM) -f usconfig.o
	
	
