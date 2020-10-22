#   hello_mul Makefile refactored to use überSpark
#
#   minimal coss example application that multiplies two unsigned 32-bit integers 
#   specified via integer parameters and returns the result
#   
#    author: amit vasudevan <amitvasudevan@acm.org>
#

COMPILER := container/amd64/x86_32/generic/gcc/v5.4.0
ASSEMBLER := container/amd64/x86_32/generic/gnu-as/v2.26.1
LINKER := container/amd64/x86_32/generic/gnu-ld/v2.26.1

UBERSPARK_NAMESPACE := $(shell uberspark staging list | grep generic-platform)
UBERSPARK_CC := $(shell uberspark staging --setting-name=bridge_cc_bridge config-get)
UBERSPARK_AS := $(shell uberspark staging --setting-name=bridge_as_bridge config-get)
UBERSPARK_LD := $(shell uberspark staging --setting-name=bridge_ld_bridge config-get)


###### targets

.PHONY: all
all: prep build 


.PHONY: build
build:
	@echo building hello_mul...
	uberspark staging switch generic-platform
	cd uobjcoll && uberspark uobjcoll build -v --platform=generic --arch=x86_32 --cpu=generic .
	@echo built hello_mul successfully!

.PHONY: verify
verify:
	@echo verifying hello_mul...
	uberspark staging switch generic-platform
	cd uobjcoll && uberspark uobjcoll verify -v --platform=generic --arch=x86_32 --cpu=generic .
	@echo verified hello_mul successfully!


.PHONY: prep
prep:
ifeq ("$(UBERSPARK_NAMESPACE)", "")
	uberspark staging create generic-platform
endif
	uberspark staging config-set --setting-name=bridge_cc_bridge --setting-value=$(COMPILER)
	uberspark staging config-set --setting-name=bridge_as_bridge --setting-value=$(ASSEMBLER)
	uberspark staging config-set --setting-name=bridge_ld_bridge --setting-value=$(LINKER)


.PHONY: clean
clean: 
	rm -rf uobjcoll/_build

