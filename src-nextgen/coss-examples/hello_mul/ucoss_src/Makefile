#   hello_mul Makefile refactored to use überSpark
#
#   minimal coss example application that multiplies two unsigned 32-bit integers 
#   specified via integer parameters and returns the result
#   
#    author: amit vasudevan <amitvasudevan@acm.org>
#

COMPILER := uberspark/bridges/container/amd64/cc-bridge/armv8_32/generic/gcc/v4.9.3
ASSEMBLER := uberspark/bridges/container/amd64/as-bridge/armv8_32/generic/gnu-as/v2.26.1
LINKER := uberspark/bridges/container/amd64/ld-bridge/armv8_32/generic/gnu-ld/v2.26.1

UBERSPARK_NAMESPACE := $(shell uberspark staging list | grep generic-platform)
UBERSPARK_CC := $(shell uberspark staging --setting-name=cc_bridge_namespace config-get)
UBERSPARK_AS := $(shell uberspark staging --setting-name=as_bridge_namespace config-get)
UBERSPARK_LD := $(shell uberspark staging --setting-name=ld_bridge_namespace config-get)


###### targets

.PHONY: all
all: prep build 


.PHONY: build
build: prep
	@echo building hello_mul...
	uberspark staging switch generic-platform
	cd uobjcoll && uberspark uobjcoll build -v --platform=generic --arch=armv8_32 --cpu=generic .
	@echo built hello_mul successfully!

.PHONY: verify
verify: prep
	@echo verifying hello_mul...
	uberspark staging switch generic-platform
	cd uobjcoll && uberspark uobjcoll verify -v --platform=generic --arch=armv8_32 --cpu=generic .
	@echo verified hello_mul successfully!


.PHONY: prep
prep:
ifeq ("$(UBERSPARK_NAMESPACE)", "")
	uberspark staging create generic-platform
endif
	uberspark staging config-set --setting-name=cc_bridge_namespace --setting-value=$(COMPILER)
	uberspark staging config-set --setting-name=as_bridge_namespace --setting-value=$(ASSEMBLER)
	uberspark staging config-set --setting-name=ld_bridge_namespace --setting-value=$(LINKER)
	uberspark staging config-set --setting-name=uobjcoll_binary_image_size --setting-value=0x02500000

.PHONY: clean
clean: 
	rm -rf uobjcoll/_build

