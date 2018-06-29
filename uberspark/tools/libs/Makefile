######
# Makefile for UberSpark tools (libs)
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../uberspark-common.mk


###### targets

.PHONY: all
all: 
	cd libuslog && $(MAKE) -w all
	cd libusmf && $(MAKE) -w all
	#$(OCAMLC) -package unix -package str -package yojson -package uslog -package usmf -linkpkg -o test_usmf test_usmf.ml
	#$(OCAMLC) -package unix -package str -package yojson -package uslog -package usmf -linkpkg -o libubp libubp.ml
	#$(OCAMLC) -package unix -package str -package yojson -package uslog -package libusmf -linkpkg -o libusmf_test libusmf_test.ml
	

.PHONY: clean
clean:
	cd libuslog && $(MAKE) -w clean
	cd libusmf && $(MAKE) -w clean
	#$(RM) -f test.cmi
	#$(RM) -f test.cmo
	#$(RM) -f test
	#$(RM) -f test_usmf.cmi
	#$(RM) -f test_usmf.cmo
	#$(RM) -f test_usmf
	
	
