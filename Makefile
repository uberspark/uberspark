######
# top-level Makefile for uberSpark
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### paths

export USPARK_SRCROOTDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
export USPARK_BUILDTRUSSESDIR := $(USPARK_SRCROOTDIR)/build-trusses
export USPARK_SRCDIR = $(USPARK_SRCROOTDIR)/src-exptoolchain
export USPARK_DOCSDIR = $(USPARK_SRCROOTDIR)/docs

###### targets

.PHONY: all
all: 
	docker run --rm -i \
		-e MAKE_TARGET=all \
		-v $(USPARK_BUILDTRUSSESDIR):/home/docker/uberspark \
		-v $(USPARK_DOCSDIR):/home/docker/uberspark/docs \
		-v $(USPARK_SRCDIR):/home/docker/uberspark/src  \
		-t local/ubersparkbuild
	rm -rf $(USPARK_BUILDTRUSSESDIR)/src
	rm -rf $(USPARK_BUILDTRUSSESDIR)/docs

.PHONY: bldcontainer-x86_64
bldcontainer-x86_64: 
	@echo building x86_64 build truss...
	docker build -f $(USPARK_BUILDTRUSSESDIR)/Makefile-truss-x86_64.Dockerfile -t local/ubersparkbuild $(USPARK_BUILDTRUSSESDIR)/.
	@echo successfully built x86_64 build truss!

