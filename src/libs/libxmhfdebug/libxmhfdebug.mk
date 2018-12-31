######
# libxmhfdebug Makefile
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### archive name
ARCHIVE = libxmhfdebug.a

###### compute source directory where this Makefile resides
srcdir := $(dir $(lastword $(MAKEFILE_LIST)))
vpath %.c $(srcdir)

###### populate sources and objects
C_SOURCES := $(wildcard $(srcdir)/*.c)
C_SOURCES := $(patsubst $(srcdir)/%, %, $(C_SOURCES))
OBJECTS = $(patsubst %.c, %.o, $(C_SOURCES))

###### targets
.PHONY: verify
verify:

.PHONY: build
build: $(ARCHIVE)

$(ARCHIVE): $(OBJECTS)
	$(AR) -rcs $(ARCHIVE) $(OBJECTS)

%.o: %.c
	@echo Building "$@" from "$<"
	$(CCERT) -c $(CCERT_CFLAGS) -o $@ $<


.PHONY: clean
clean:
	$(RM) $(OBJECTS)
	$(RM) $(ARCHIVE)
	


