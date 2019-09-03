#
# uberSpark documentation makefile 
# author: Amit Vasudevan (amitvasudevan@acm.org)
#

UBERSPARK_DOC_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SPHINXBUILD   ?= sphinx-build
UBERSPARK_DOC_SOURCEDIR     = $(UBERSPARK_DOC_PATH).
UBERSPARK_DOC_BUILDDIR      = $(UBERSPARK_DOC_PATH)_build

###### targets

.PHONY: docs_pdf
docs_pdf:
	@$(SPHINXBUILD) -b latex "$(UBERSPARK_DOC_SOURCEDIR)" "$(UBERSPARK_DOC_BUILDDIR)"
	@cd $(UBERSPARK_DOC_BUILDDIR) && make 

.PHONY: docs_html
docs_html:
	@$(SPHINXBUILD) -b html "$(UBERSPARK_DOC_SOURCEDIR)" "$(UBERSPARK_DOC_BUILDDIR)"

.PHONY: clean
clean:
	rm -rf $(UBERSPARK_DOC_PATH)_build
