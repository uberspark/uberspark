######
# uberSpark build shim for GNU Make based builds
# author: amit vasudevan (amitvasudevan@acm.org)
######

######
# input variables
# UBERSPARK_UOBJCOLL = uobj collection name
# UBERSPARK_UOBJCOLL_DIR = uobj collection directory
# UBERSPARK_UOBJ = uobj name
######

__UBERSPARK_GNUMAKE_DEFAULT_GOAL := $(.DEFAULT_GOAL)
.DEFAULT_GOAL := all


__UBERSPARK_INCLUDES = -I$(shell uberspark --info --get-includedir)
__UBERSPARK_INCLUDES += -I$(shell ubersparkconfig --print-uberspark-hwmincludedir)
__UBERSPARK_INCLUDES += -I$(shell ubersparkconfig --print-uberspark-loadersincludesdir)
__UBERSPARK_INCLUDES += -I$(shell uberspark --info --uobjcoll $(UBERSPARK_UOBJCOLL) --uobj $(UBERSPARK_UOBJ) --get-includedir)


UBERSPARK_CFLAGS = $(__UBERSPARK_INCLUDES)
UBERSPARK_CFLAGS += $(shell ubersparkconfig --print-uberspark-basedefs)


__UBERSPARK_LIBS_DIRS = $(shell ubersparkconfig --print-uberspark-loadersdir)


UBERSPARK_LFLAGS = -Wl,-L,$(shell ubersparkconfig --print-uberspark-loadersdir)
UBERSPARK_LFLAGS += -Wl,-l,usloader-linux-um
UBERSPARK_LFLAGS += -Wl,-L,$(shell uberspark --info --uobjcoll app-fviews --uobj uobj_afvsensitive --get-libdir)
UBERSPARK_LFLAGS += -Wl,-l,$(shell uberspark --info --uobjcoll app-fviews --uobj uobj_afvsensitive --arch x86_32 --get-libsentinels)
UBERSPARK_LFLAGS += $(shell cat $(__UBERSPARK_LIBS_DIRS)/libusloader-linux-um.a.deps)


#targets
.PHONY: uberspark_uobjcoll_build
uberspark_uobjcoll_build:
	cd $(UBERSPARK_UOBJCOLL_DIR) && uberspark --uobjlist $(UBERSPARK_UOBJCOLL).usmf --builduobj

.PHONY: uberspark_uobjcoll_install
uberspark_uobjcoll_install:
	cd $(UBERSPARK_UOBJCOLL_DIR) && uberspark --uobjlist $(UBERSPARK_UOBJCOLL).usmf --install


.DEFAULT_GOAL := $(__UBERSPARK_GNUMAKE_DEFAULT_GOAL)
	