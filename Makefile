######
# top-level Makefile for uberSpark
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### paths

export USPARK_SRCDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
export USPARK_BUILDTRUSSESDIR := $(USPARK_SRCDIR)/build-trusses

###### targets

.PHONY: all
all: 
	@echo $(USPARK_SRCDIR)

.PHONY: bldcontainer-x86_64
bldcontainer-x86_64: 
	@echo building x86_64 build truss...
	docker build -f $(USPARK_BUILDTRUSSESDIR)/Makefile-truss-x86_64.Dockerfile -t local/ubersparkbuild $(USPARK_BUILDTRUSSESDIR)/.
	@echo successfully built x86_64 build truss!
