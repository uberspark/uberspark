#
# top-level Makefile for uberspark loaders
# author: amit vasudevan (amitvasudevan@acm.org)
#

###### archive name
ARCHIVE = libusloader-linux-um.a
ARCHIVE_DEPS = -Wl,-l,hugetlbfs

###### create archive deps file
#ARCHIVE_DEPSFILE = `echo $(ARCHIVE) | tr a-z A-Z`
ARCHIVE_DEPSFILE = $(ARCHIVE).deps

###### compute source directory where this Makefile resides
srcdir := $(dir $(lastword $(MAKEFILE_LIST)))
vpath %.c $(srcdir)

###### populate sources and objects
C_SOURCES := $(wildcard $(srcdir)/*.c)
C_SOURCES := $(patsubst $(srcdir)/%, %, $(C_SOURCES))
OBJECTS = $(patsubst %.c, %.o, $(C_SOURCES))


###### targets
.PHONY: all
all: build

.PHONY: build
build: $(ARCHIVE)
	@echo $(ARCHIVE_DEPS) >$(ARCHIVE_DEPSFILE)
	
$(ARCHIVE): $(OBJECTS)
	$(AR) -rcs $(ARCHIVE) $(OBJECTS)

%.o: %.c
	@echo Building "$@" from "$<"
	$(CC) -c $(CC_CFLAGS) -o $@ $<


.PHONY: clean
clean:
	$(RM) $(OBJECTS)
	$(RM) $(ARCHIVE)
