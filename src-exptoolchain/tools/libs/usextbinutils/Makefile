######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -ccopt -static -c -package unix -package ustypes -package usconfig -package uslog -package usosservices -linkpkg usextbinutils.ml
	ocamlfind remove usextbinutils 
	ocamlfind install usextbinutils META usextbinutils.cmi usextbinutils.cmx usextbinutils.o 


.PHONY: clean
clean:
	$(RM) -f usextbinutils.cmi
	$(RM) -f usextbinutils.cmx
	$(RM) -f usextbinutils.o
	
	
