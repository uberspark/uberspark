######
# common Makefile definition boilerplate for uberSpark
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### paths

export UBERSPARK_ROOTDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/.. )
export UBERSPARK_DOCSDIR := $(UBERSPARK_ROOTDIR)/docs
export UBERSPARK_SRCDIR := $(UBERSPARK_ROOTDIR)/src-nextgen
export UBERSPARK_BUILDDIR := $(UBERSPARK_ROOTDIR)/_build
export UBERSPARK_INSTALLDIR := $(UBERSPARK_ROOTDIR)/_install
export UBERSPARK_SDEFSDIR := $(UBERSPARK_SRCDIR)/sdefs

###### tools

export MAKE := make
export OCAMLFIND := ocamlfind
export OCAMLOPT := $(OCAMLFIND) ocamlopt -g
export OCAMLC := $(OCAMLFIND) ocamlc -g
#export OCAML := ocaml
export RM := rm
export MKDIR := mkdir
export CP := cp
export UBERSPARK_SDEFPP := $(UBERSPARK_SRCDIR)/tools/sdefpp/_build/uberspark_sdefpp
export CPPO := cppo

###### variables
export BUILDDIR := _build
export UBERSPARK_LIB_NAME := uberspark
export UBERSPARK_BIN_NAME := uberspark
export UBERSPARK_SDEFPP_BIN_NAME := uberspark_sdefpp

