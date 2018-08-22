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
	$(OCAMLC) -o ubersparkconfig unix.cma ubersparkconfig.ml
	#$(CP) -f umfcommon.ml umf/.	
	cd ./umf && $(MAKE) -w all
	#$(CP) -f umfcommon.ml ubp/.	
	cd ./ubp && $(MAKE) -w all
	#$(CP) -f umfcommon.ml ucasm/.	
	cd ./ucasm && $(MAKE) -w all
	#$(CP) -f umfcommon.ml uhwm/.
	cd ./uhwm && $(MAKE) -w all
	#$(CP) -f umfcommon.ml uccomp/.
	cd ./uccomp && $(MAKE) -w all
	

.PHONY: clean
clean:
	cd ./umf && $(MAKE) -w clean
	cd ./ubp && $(MAKE) -w clean
	cd ./ucasm && $(MAKE) -w clean
	cd ./uccomp && $(MAKE) -w clean
	cd ./uhwm && $(MAKE) -w clean
	$(RM) *_DEP
	$(RM) ubersparkconfig ubersparkconfig.cmi ubersparkconfig.cmo
	
