######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	cd uslog && $(MAKE) -w all
	$(OCAMLC) -package uslog -package unix -package str -package yojson -linkpkg -o test test.ml
	

.PHONY: clean
clean:
	cd uslog && $(MAKE) -w clean
	$(RM) -f test.cmi
	$(RM) -f test.cmo
	$(RM) -f test
	
	
