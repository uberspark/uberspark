FRAMAC_SHARE := $(shell frama-c-config -print-share-path)
FRAMAC_LIBDIR := $(shell frama-c-config -print-libpath)
PLUGIN_NAME = Ubersparkvbridge
PLUGIN_CMO = ubersparkvbridge_options ubersparkvbridge_print ubersparkvbridge_casm ubersparkvbridge_ast ubersparkvbridge_main
PLUGIN_REQUIRES = uberspark
PLUGIN_OFLAGS = -linkall
PLUGIN_BFLAGS = -linkall
PLUGIN_LINK_OFLAGS = -linkall 
PLUGIN_LINK_BFLAGS = -linkall 
PLUGIN_EXTRA_OPT = /home/uberspark/.opam/4.09.0+flambda/lib/uberspark/uberspark.cmxa
include $(FRAMAC_SHARE)/Makefile.dynamic