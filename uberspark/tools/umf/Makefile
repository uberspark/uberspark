######
# Makefile for UberSpark tools 
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	#cd uslog && $(MAKE) -w all
	#cd usmf && $(MAKE) -w all
	#$(OCAMLC) -package unix -package str -package yojson -package uslog -package usmf -linkpkg -o test_usmf test_usmf.ml
	#$(OCAMLC) -package unix -package str -package yojson -package uslog -package usmf -linkpkg -o libubp libubp.ml
	$(OCAMLC) -package unix -package str -package yojson -package uslog -package libusmf -linkpkg -o libusmf_test libusmf_test.ml
	

.PHONY: clean
clean:
	$(RM) -f libusmf_test.cmi
	$(RM) -f libusmf_test.cmo
	$(RM) -f libusmf_test
