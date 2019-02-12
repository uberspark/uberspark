#
# top-level Makefile for uberspark loaders
# author: amit vasudevan (amitvasudevan@acm.org)
#
srcdir := $(dir $(lastword $(MAKEFILE_LIST)))
vpath %.c $(srcdir)

# bring in common definitions
include $(srcdir)/../../../common.mk


C_SOURCES := $(wildcard $(srcdir)/*.c)
C_SOURCES := $(patsubst $(srcdir)/%, %, $(C_SOURCES))

OBJECTS = $(patsubst %.c, %.o, $(C_SOURCES))

OBJECTS_DIR = _objs_libusloader-linux-um
THE_ARCHIVE = libusloader-linux-um.a

# targets
.PHONY: all
all: $(THE_ARCHIVE)

$(THE_ARCHIVE): $(OBJECTS)
	cd $(OBJECTS_DIR) && $(AR) -rcs $(THE_ARCHIVE) $(OBJECTS)
	$(CP) $(OBJECTS_DIR)/$(THE_ARCHIVE) .

%.o: %.c
	mkdir -p $(OBJECTS_DIR)
	@echo Building "$@" from "$<"
	$(CC) -c $(CC_CFLAGS) -o $(OBJECTS_DIR)/$@ $<

.PHONY: clean
clean:
	$(RM) -rf $(OBJECTS_DIR)

