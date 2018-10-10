######
# Makefile for uberSpark driver 
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../uberspark-common.mk

###### targets


.PHONY: all
all:  
	$(OCAMLC) -package unix -package str -package usconfig -package uslog -package usosservices -package usextbinutils -package yojson -package libusmf -linkpkg -o uberspark uberspark.ml	

.PHONY: clean
clean:
	$(RM) -f uberspark.cmi
	$(RM) -f uberspark.cmo
	$(RM) -f uberspark

