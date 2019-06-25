######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	#$(CPP) -P -E $(ASMFLAGS_LOCAL) usuobj.ml.c -o usuobj.ml
	$(OCAMLC) -o usuobj.o -package str -package yojson -package unix -package ustypes -package usconfig -package uslog -package usosservices -package usextbinutils -package usmanifest -package usuobjgen -linkpkg usuobj.ml
	ocamlfind remove usuobj 
	ocamlfind install usuobj META usuobj.cmi usuobj.cmo usuobj.o 


.PHONY: clean
clean:
	$(RM) -f usuobj.cmi
	$(RM) -f usuobj.cmo
	$(RM) -f usuobj.o
	
	
