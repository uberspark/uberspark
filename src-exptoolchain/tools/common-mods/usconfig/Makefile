######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -ccopt -static -c unix.cmxa usconfig.ml
	ocamlfind remove usconfig 
	ocamlfind install usconfig META usconfig.cmi usconfig.cmx usconfig.o 


.PHONY: clean
clean:
	$(RM) -f usconfig.cmi
	$(RM) -f usconfig.cmx
	$(RM) -f usconfig.o
	
	
