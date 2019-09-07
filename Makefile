######
# top-level Makefile for uberSpark
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### paths

export USPARK_SRCDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

###### targets

.PHONY: all
all: 
	@echo $(USPARK_SRCDIR)

