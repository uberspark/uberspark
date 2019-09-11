######
# Makefile for uberSpark driver 
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### targets

MODULE_PACKAGES := -package unix
MODULE_PACKAGES += -package str 
MODULE_PACKAGES += -package yojson 
MODULE_PACKAGES += -package usconfig  
MODULE_PACKAGES += -package uslog 
MODULE_PACKAGES += -package usosservices  
MODULE_PACKAGES += -package usextbinutils 
MODULE_PACKAGES += -package libusmf 
MODULE_PACKAGES += -package usmanifest  
MODULE_PACKAGES += -package usuobjgen
MODULE_PACKAGES += -package usuobjlib 
MODULE_PACKAGES += -package usuobj 
MODULE_PACKAGES += -package usuobjcollection
MODULE_PACKAGES += -package usbin


MODULE_SOURCES := uberspark.ml
MODULE_SOURCES += cmd_uobj.ml

.PHONY: all
all:  
	$(OCAMLOPT) -ccopt -static $(MODULE_PACKAGES) -linkpkg -o uberspark $(MODULE_SOURCES)

.PHONY: clean
clean:
	$(RM) -f *.cmi *.cmx *.o
	$(RM) -f uberspark

