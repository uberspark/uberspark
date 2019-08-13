######
# Makefile for uberSpark driver 
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../uberspark-common.mk

###### targets


.PHONY: all
all:  
	$(OCAMLC) -package unix -package str -package yojson -package usconfig -package uslog -package usosservices -package usextbinutils -package libusmf -package usmanifest -package usuobjgen -package usuobjlib -package usuobj -package usuobjcollection -package usbin -linkpkg -o uberspark uberspark.ml	

.PHONY: clean
clean:
	$(RM) -f uberspark.cmi
	$(RM) -f uberspark.cmo
	$(RM) -f uberspark

