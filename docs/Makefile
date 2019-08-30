#
# uberSpark documentation makefile 
# author: Amit Vasudevan (amitvasudevan@acm.org)
#

UBERSPARK_DOC_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SPHINXBUILD   ?= sphinx-build
UBERSPARK_DOC_SOURCEDIR     = $(UBERSPARK_DOC_PATH).
UBERSPARK_DOC_BUILDDIR      = $(UBERSPARK_DOC_PATH)_build

###### targets

.PHONY: all
all:
	echo $(UBERSPARK_DOC_PATH)
	echo $(UBERSPARK_DOC_SOURCEDIR)
	echo $(UBERSPARK_DOC_BUILDDIR)

.PHONY: clean
clean:
	rm -rf $(USPARK_DOC_PATH)/_build
