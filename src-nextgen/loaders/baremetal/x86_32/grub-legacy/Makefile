# makefile for xmhf bootloader
# author: amit vasudevan (amitvasudevan@acm.org)

srcdir := $(dir $(lastword $(MAKEFILE_LIST)))
srcdir := $(realpath $(srcdir))

#vpath %.c $(srcdir)
#vpath %.S $(srcdir)

include $(srcdir)/common.mk


# grab list of all source files
C_SOURCES := $(shell find $(srcdir)/ -type f -name '*.c')
A_SOURCES := $(shell find $(srcdir)/ -type f -name '*.S')


C_SOURCES := $(patsubst $(srcdir)/%, %, $(C_SOURCES))
A_SOURCES := $(patsubst $(srcdir)/%, %, $(A_SOURCES))


# grab list of file names only for binary generation
C_SOURCES_FILENAMEONLY := $(notdir $(C_SOURCES))
A_SOURCES_FILENAMEONLY := $(notdir $(A_SOURCES))



OBJECTS_ARCHIVE := $(patsubst %.c, %.o, $(C_SOURCES_FILENAMEONLY))
OBJECTS_ARCHIVE += $(patsubst %.S, %.o, $(A_SOURCES_FILENAMEONLY))
OBJECTS_ARCHIVE += $(UOBJRTL_CRT_OBJECTS_ARCHIVE)
OBJECTS_ARCHIVE += $(UOBJRTL_HW_OBJECTS_ARCHIVE)

# list of object dependencies
OBJECTS := $(patsubst %.c, %.o, $(C_SOURCES))
OBJECTS += $(patsubst %.S, %.o, $(A_SOURCES))
OBJECTS += $(UOBJRTL_CRT_OBJECTS)
OBJECTS += $(UOBJRTL_HW_OBJECTS)


# folder where objects go
XMHF_BOOTLOADER_OBJECTS_DIR = _build

# archive name
THE_ARCHIVE = loader

# targets
.PHONY: all
all: $(THE_ARCHIVE)
#all:
#	echo $(DIR_UOBJRTL_CRT_SRC)
#	echo $(UOBJRTL_CRT_C_SOURCES)
#	echo $(UOBJRTL_CRT_A_SOURCES)
#	echo $(UOBJRTL_CRT_C_SOURCES_FILENAMEONLY)
#	echo $(UOBJRTL_CRT_A_SOURCES_FILENAMEONLY)
#	echo $(OBJECTS)
#	echo $(CCLIBX)
#	echo $(CCLIB)
#	which gcc
#	gcc --version
#	gcc-8 --version
#	gcc-8 --print-lib
#	ls -lR /usr/lib/gcc/x86_64-linux-gnu/
#	ls -l /m/*

$(THE_ARCHIVE): $(OBJECTS)
	cd $(XMHF_BOOTLOADER_OBJECTS_DIR) && $(LD) --oformat elf32-i386 -T $(srcdir)/init.lds -o $(THE_ARCHIVE).exe $(OBJECTS_ARCHIVE) $(CCLIB)
	cd $(XMHF_BOOTLOADER_OBJECTS_DIR) && $(OBJCOPY) --output-format=binary $(THE_ARCHIVE).exe $(THE_ARCHIVE).exe.flat

%.o: %.S
	$(MKDIR) -p $(XMHF_BOOTLOADER_OBJECTS_DIR)
	@echo Building "$(@F)" from "$<"
	$(CC) -c $(ASMFLAGS) -o $(XMHF_BOOTLOADER_OBJECTS_DIR)/$(@F) $<

%.o: %.c
	$(MKDIR) -p $(XMHF_BOOTLOADER_OBJECTS_DIR)
	@echo Building "$(@F)" from "$<"
	$(CC) -c $(CFLAGS) -o $(XMHF_BOOTLOADER_OBJECTS_DIR)/$(@F) $<

%.o: %.cS
	$(MKDIR) -p $(XMHF_BOOTLOADER_OBJECTS_DIR)
	@echo Building "$(@F)" from "$<" 
	$(CP) -f $< $(XMHF_BOOTLOADER_OBJECTS_DIR)/$(notdir $<).c
	cd $(XMHF_BOOTLOADER_OBJECTS_DIR) && $(CCOMP) $(CCOMPFLAGS) $(notdir $<).c 
	cd $(XMHF_BOOTLOADER_OBJECTS_DIR) && $(FRAMAC) -load-module $(DIR_UBERSPARK_VBRIDGE_PLUGIN)/Ubersparkvbridge -machdep gcc_x86_32 -kernel-msg-key pp -casm -casm-infile $(notdir $<).mach -casm-outfile $(notdir $<).s 
	cd $(XMHF_BOOTLOADER_OBJECTS_DIR) && $(CC) -c $(ASMFLAGS) -o $(@F) $(notdir $<).s


.PHONY: clean
clean:
	$(RM) -rf $(XMHF_BOOTLOADER_OBJECTS_DIR)




