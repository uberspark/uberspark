######
# Makefile for UberSpark tools
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../uberspark-common.mk


###### targets

.PHONY: all
all: build-tools


.PHONY: build-tools
build-tools:
	cd ./libs && $(MAKE) -w all
	$(OCAMLC) -o ubersparkconfig unix.cma ubersparkconfig.ml
	cd ./umf && $(MAKE) -w all
	cd ./ubp && $(MAKE) -w all
	cd ./ucasm && $(MAKE) -w all
	cd ./uhwm && $(MAKE) -w all
	cd ./uccomp && $(MAKE) -w all
	

.PHONY: clean
clean:
	cd ./libs && $(MAKE) -w clean
	cd ./umf && $(MAKE) -w clean
	cd ./ubp && $(MAKE) -w clean
	cd ./ucasm && $(MAKE) -w clean
	cd ./uccomp && $(MAKE) -w clean
	cd ./uhwm && $(MAKE) -w clean
	$(RM) *_DEP
	$(RM) ubersparkconfig ubersparkconfig.cmi ubersparkconfig.cmo
	
