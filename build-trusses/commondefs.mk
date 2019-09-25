######
# common Makefile definition boilerplate for uberSpark
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### paths

export UBERSPARK_ROOTDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/.. )
export UBERSPARK_DOCSDIR := $(UBERSPARK_ROOTDIR)/docs
export UBERSPARK_SRCDIR := $(UBERSPARK_ROOTDIR)/src-exptoolchain
export UBERSPARK_BUILDDIR := $(UBERSPARK_ROOTDIR)/_build

###### tools

export MAKE := make
export OCAMLFIND := ocamlfind
export OCAMLOPT := $(OCAMLFIND) ocamlopt
export OCAMLC := $(OCAMLFIND) ocamlc
export RM := rm
export MKDIR := mkdir
export CP := cp

###### variables
export BUILDDIR := _build
export UBERSPARK_LIB_NAME := uberspark
