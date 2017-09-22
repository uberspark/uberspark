######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	$(OCAMLC) -o uslog.o unix.cma uslog.ml
	ocamlfind install uslog META uslog.cmi uslog.cmo uslog.o 
	

.PHONY: clean
clean:
	
