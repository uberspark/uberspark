######
# libubersparkcrypto Makefile
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### archive name
ARCHIVE = libubersparkcrypto.a

###### compute source directory where this Makefile resides
srcdir := $(dir $(lastword $(MAKEFILE_LIST)))
vpath %.c $(srcdir) $(srcdir)/hashes/sha1
vpath %.c $(srcdir) $(srcdir)/hashes/sha2
vpath %.c $(srcdir) $(srcdir)/cipher/aes
vpath %.c $(srcdir) $(srcdir)/mac/hmac-sha1
vpath %.c $(srcdir) $(srcdir)/mac/hmac-sha2

###### populate sources and objects
C_SOURCES := hashes/sha1/sha1.c
C_SOURCES += hashes/sha2/sha256.c
C_SOURCES += ciphers/aes/aes.c
C_SOURCES += ciphers/aes/aes_tab.c
C_SOURCES += ciphers/aes/aes_cbc.c
C_SOURCES += mac/hmac-sha1/hmac-sha1.c
C_SOURCES += mac/hmac-sha2/hmac-sha256.c
O_SOURCES := $(C_SOURCES)
O_SOURCES := $(patsubst hashes/sha1/%, %, $(O_SOURCES))
O_SOURCES := $(patsubst hashes/sha2/%, %, $(O_SOURCES))
O_SOURCES := $(patsubst ciphers/aes/%, %, $(O_SOURCES))
O_SOURCES := $(patsubst mac/hmac-sha1/%, %, $(O_SOURCES))
O_SOURCES := $(patsubst mac/hmac-sha2/%, %, $(O_SOURCES))
OBJECTS = $(patsubst %.c, %.o, $(O_SOURCES))


###### targets
.PHONY: verify
verify:
	$(FRAMAC) -no-frama-c-stdlib -main sha1 -lib-entry -wp -wp-model +cint -wp-prover alt-ergo,cvc3,z3 -cpp-extra-args=-nostdinc $(V_FLAGS) $(srcdir)/hashes/sha1/sha1.c

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
