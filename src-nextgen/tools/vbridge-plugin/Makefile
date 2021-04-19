FRAMAC_SHARE := $(shell frama-c-config -print-share-path)
FRAMAC_LIBDIR := $(shell frama-c-config -print-libpath)

PLUGIN_NAME = Ubersparkvbridge

PLUGIN_CMO = ubersparkvbridge_options 
PLUGIN_CMO += ubersparkvbridge_print 
PLUGIN_CMO += ubersparkvbridge_casm 
PLUGIN_CMO += ubersparkvbridge_ast 
PLUGIN_CMO += ubersparkvbridge_main

# extra libraries that the plugin depends upon
PLUGIN_REQUIRES = uberspark

PLUGIN_OFLAGS = -linkall
PLUGIN_BFLAGS = -linkall
PLUGIN_LINK_OFLAGS = -linkall 
PLUGIN_LINK_BFLAGS = -linkall 

# extra library link dependencies that the plugin depends upon
# note: this has to include everything that the PLUGIN_REQUIRES depends upon
PLUGIN_EXTRA_OPT = $(shell ocamlfind query fileutils)/fileutils.cmxa
PLUGIN_EXTRA_OPT += $(shell ocamlfind query uberspark)/uberspark.cmxa

include $(FRAMAC_SHARE)/Makefile.dynamic