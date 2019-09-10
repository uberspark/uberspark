######
# common Makefile definition boilerplate for uberSpark
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### paths

export UBERSPARK_ROOTDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/.. )
export UBERSPARK_DOCSDIR := $(UBERSPARK_ROOTDIR)/docs
export UBERSPARK_SRCDIR := $(UBERSPARK_ROOTDIR)/src-exptoolchain
export UBERSPARK_BUILDDIR := $(UBERSPARK_ROOTDIR)/_build

