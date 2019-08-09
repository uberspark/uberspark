######
# Makefile for UberSpark tools 
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../uberspark-common.mk

###### targets


.PHONY: all
all:  
	$(OCAMLC) -package unix -package str -package yojson -package uslog -package libusmf -linkpkg -o umf umf.ml	

.PHONY: clean
clean:
	$(RM) -f umf.cmi
	$(RM) -f umf.cmo
	$(RM) -f umf

