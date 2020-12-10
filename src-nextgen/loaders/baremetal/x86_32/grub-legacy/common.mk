# common Makefile boilerplate for überSpark baremetal loaders
# author: amit vasudevan (amitvasudevan@acm.org)

srcdir := $(dir $(lastword $(MAKEFILE_LIST)))
srcdir := $(realpath $(srcdir))

######
# basic build tool variables
######

export MKDIR := mkdir
export CC := gcc
export LD := ld
export OBJCOPY := objcopy
export CAT := cat


######
# directories
######

DIR_UOBJRTL_CRT_SRC := $(srcdir)/../../../../uobjrtl/crt/src/
DIR_UOBJRTL_CRT_SRC := $(realpath $(DIR_UOBJRTL_CRT_SRC))
export DIR_UOBJRTL_CRT_SRC
UOBJRTL_CRT_C_SOURCES := $(shell find $(DIR_UOBJRTL_CRT_SRC)/ -type f -name '*.c')
UOBJRTL_CRT_A_SOURCES := $(shell find $(DIR_UOBJRTL_CRT_SRC)/ -type f -name '*.S')
UOBJRTL_CRT_C_SOURCES_FILENAMEONLY := $(notdir $(UOBJRTL_CRT_C_SOURCES))
UOBJRTL_CRT_A_SOURCES_FILENAMEONLY := $(notdir $(UOBJRTL_CRT_A_SOURCES))
UOBJRTL_CRT_OBJECTS := $(patsubst %.c, %.o, $(UOBJRTL_CRT_C_SOURCES))
UOBJRTL_CRT_OBJECTS += $(patsubst %.S, %.o, $(UOBJRTL_CRT_A_SOURCES))
UOBJRTL_CRT_OBJECTS_ARCHIVE := $(patsubst %.c, %.o, $(UOBJRTL_CRT_C_SOURCES_FILENAMEONLY))
UOBJRTL_CRT_OBJECTS_ARCHIVE += $(patsubst %.S, %.o, $(UOBJRTL_CRT_A_SOURCES_FILENAMEONLY))


DIR_UOBJRTL_HW_SRC := $(srcdir)/../../../../uobjrtl/hw/src/
DIR_UOBJRTL_HW_SRC := $(realpath $(DIR_UOBJRTL_HW_SRC))
export DIR_UOBJRTL_HW_SRC
UOBJRTL_HW_C_SOURCES := $(shell find $(DIR_UOBJRTL_HW_SRC)/ -type f -name '*.c')
UOBJRTL_HW_A_SOURCES := $(shell find $(DIR_UOBJRTL_HW_SRC)/ -type f -name '*.S')
UOBJRTL_HW_C_SOURCES_FILENAMEONLY := $(notdir $(UOBJRTL_HW_C_SOURCES))
UOBJRTL_HW_A_SOURCES_FILENAMEONLY := $(notdir $(UOBJRTL_HW_A_SOURCES))
UOBJRTL_HW_OBJECTS := $(patsubst %.c, %.o, $(UOBJRTL_HW_C_SOURCES))
UOBJRTL_HW_OBJECTS += $(patsubst %.S, %.o, $(UOBJRTL_HW_A_SOURCES))
UOBJRTL_HW_OBJECTS_ARCHIVE := $(patsubst %.c, %.o, $(UOBJRTL_HW_C_SOURCES_FILENAMEONLY))
UOBJRTL_HW_OBJECTS_ARCHIVE += $(patsubst %.S, %.o, $(UOBJRTL_HW_A_SOURCES_FILENAMEONLY))



######
# build flags
######

ASMFLAGS := -m32 -I. -I../../../../../ -D__ASSEMBLY__
CFLAGS := -nostdinc -nostdlib -nostartfiles -ffreestanding -m32 -I. -I../../../../../
CCLIB := $(shell $(CC) -m32 --print-lib)


