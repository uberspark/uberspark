######
# Makefile for UberSpark tools 
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../uberspark-common.mk

###### targets


.PHONY: all
all:  
	$(OCAMLC) -package unix -package str -package yojson -package uslog -package libusmf -linkpkg -o ubp ubp.ml	

.PHONY: clean
clean:
	$(RM) -f ubp.cmi
	$(RM) -f ubp.cmo
	$(RM) -f ubp

