######
# Makefile for UberSpark tools 
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ../../uberspark-common.mk

export CCERT_FLAGS := -fno-fpu -fbitfields -fpacked-structs -fstruct-return -fno-inline-asm -nostdinc -I/usr/local/uberspark/include -I/usr/local/uberspark/hwm/include -I/usr/local/uberspark/libs/include -I/home/dv/data/hypcode/projs/pubrepos-bleeding-edge/uberxmhf.git/uxmhf/include -I/home/dv/data/hypcode/projs/pubrepos-bleeding-edge/uberxmhf.git/uxmhf/xmhf-uobjs/include -I/home/dv/data/hypcode/projs/pubrepos-bleeding-edge/uberxmhf.git/uxmhf/libs/libxmhfdebug/include -I/home/dv/data/hypcode/projs/pubrepos-bleeding-edge/uberxmhf.git/uxmhf/libs/libxmhfgeec/include -D___XMHF_BUILD_VERSION___="1.0" -D___XMHF_BUILD_REVISION___="cliff-jumper" -D__XMHF_TARGET_CPU_X86__ -D__XMHF_TARGET_CONTAINER_VMX__ -D__XMHF_TARGET_PLATFORM_X86PC__ -D__XMHF_TARGET_TRIAD_X86_VMX_X86PC__ -D__DEBUG_SERIAL__ -DDEBUG_PORT=0x3f8 -D__XMHF_CONFIG_DEBUG_SERIAL_MAXCPUS__=8 -D__DRT__ -D__DMAP__ -D__XMHFGEEC_TOTAL_UHSLABS__=1 -D__XMHFGEEC_TOTAL_UGSLABS__=1 -D__XMHF_CONFIG_LOADADDR__=0x03200000 -D__XMHF_CONFIG_LOADMAXSIZE__=0x1C200000 -D__XMHF_CONFIG_LOADMAXADDR__=0x1F400000 -D__XMHF_CONFIG_MAXSYSADDR__=0xFFFFFFFF -D__XMHF_CONFIG_MAX_INCLDEVLIST_ENTRIES__=6 -D__XMHF_CONFIG_MAX_EXCLDEVLIST_ENTRIES__=6 -D__XMHF_CONFIG_MAX_MEMOFFSET_ENTRIES__=64
export UOBJ_NAMES := geec_prime uapi_slabmempgtbl
export UOBJ_OBJDIR := ./testbed/_objects

###### targets

.PHONY: _uobjs_preprocessmanifests
_uobjs_preprocessmanifests:
	@echo $(CCERT_FLAGS)
	mkdir -p $(UOBJ_OBJDIR)
	@for i in $(UOBJ_NAMES); \
	do \
		(cd $(UOBJ_OBJDIR) && echo "Prepping uobj manifest for $$i..." && cp -f ../$$i/$$i.gsm $$i.gsm.c && ccomp -P -E $(CCERT_CFLAGS) -D__ASSEMBLY__ $$i.gsm.c >../$$i/$$i.gsm.pp) || exit 1; \
	done;
	@echo uobj manifests prepped


.PHONY: all
all: _uobjs_preprocessmanifests 
	#cd uslog && $(MAKE) -w all
	#cd usmf && $(MAKE) -w all
	#$(OCAMLC) -package unix -package str -package yojson -package uslog -package usmf -linkpkg -o test_usmf test_usmf.ml
	#$(OCAMLC) -package unix -package str -package yojson -package uslog -package usmf -linkpkg -o libubp libubp.ml
	#$(OCAMLC) -package unix -package str -package yojson -package uslog -package libusmf -linkpkg -o libusmf_test libusmf_test.ml
	$(OCAMLC) -package unix -package str -package yojson -package uslog -package libusmf -linkpkg -o umfparse umfparse.ml	

.PHONY: clean
clean:
	$(RM) -f libusmf_test.cmi
	$(RM) -f libusmf_test.cmo
	$(RM) -f libusmf_test
