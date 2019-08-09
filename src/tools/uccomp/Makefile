######
# Makefile for UberSpark tools 
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../uberspark-common.mk

###### targets


.PHONY: all
all:  
	$(OCAMLC) -package unix -package str -package yojson -package uslog -package libusmf -linkpkg -o uccomp uccomp.ml	

.PHONY: clean
clean:
	$(RM) -f uccomp.cmi
	$(RM) -f uccomp.cmo
	$(RM) -f uccomp

