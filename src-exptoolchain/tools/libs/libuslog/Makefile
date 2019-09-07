######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### targets

.PHONY: all
all: 
	$(OCAMLOPT) -ccopt -static -c unix.cmxa uslog.ml
	ocamlfind remove uslog 
	ocamlfind install uslog META uslog.cmi uslog.cmx uslog.o 

.PHONY: clean
clean:
	$(RM) -f uslog.cmi
	$(RM) -f uslog.cmo
	$(RM) -f uslog.o
	
	
