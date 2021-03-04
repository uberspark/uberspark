# common Makefile boilerplate for überSpark baremetal loaders
# author: amit vasudevan (amitvasudevan@acm.org)

srcdir := $(dir $(lastword $(MAKEFILE_LIST)))
srcdir := $(realpath $(srcdir))

######
# basic build tool variables
######

export MKDIR := mkdir
export CP := cp
export CC := gcc-8
export CCOMP := ccomp
export FRAMAC := frama-c
export LD := ld
export OBJCOPY := objcopy
export CAT := cat


######
# directories
######
#DIR_UBERSPARK_ROOT := $(realpath $(srcdir)/../../../../../../../)

DIR_UBERSPARK_ROOT := $(realpath $(BRIDGE_UBERSPARK_ROOT_DIR_PREFIX))
DIR_UBERSPARK_STAGING := $(realpath $(BRIDGE_UBERSPARK_STAGING_DIR_PREFIX))
DIR_CONTAINER_MOUNT_POINT := $(realpath $(BRIDGE_CONTAINER_MOUNT_POINT))

DIR_UBERSPARK_VBRIDGE_PLUGIN := $(DIR_UBERSPARK_ROOT)/tools/vbridge-plugin

DIR_UOBJRTL_CRT_SRC := $(DIR_CONTAINER_MOUNT_POINT)/uberspark/uobjrtl/crt/src/
DIR_UOBJRTL_CRT_SRC := $(realpath $(DIR_UOBJRTL_CRT_SRC))
UOBJRTL_CRT_OBJECTS := $(shell find $(DIR_UOBJRTL_CRT_SRC)/ -type f -name '*.o')

DIR_UOBJRTL_HW_SRC := $(DIR_CONTAINER_MOUNT_POINT)/uberspark/uobjrtl/hw/src/
DIR_UOBJRTL_HW_SRC := $(realpath $(DIR_UOBJRTL_HW_SRC))
UOBJRTL_HW_OBJECTS := $(shell find $(DIR_UOBJRTL_HW_SRC)/ -type f -name '*.o')


######
# build flags
######

INCFLAGS := -I. -I $(DIR_CONTAINER_MOUNT_POINT) -I $(BRIDGE_UBERSPARK_STAGING_DIR_PREFIX)
ASMFLAGS := -m32 $(INCFLAGS) -D__ASSEMBLY__
CFLAGS := -nostdinc -nostdlib -nostartfiles -ffreestanding -m32 $(INCFLAGS)
CCOMPFLAGS := $(INCFLAGS) -O0 -fpacked-structs -c -dmach
CCLIB := $(shell $(CC) -m32 --print-lib)
