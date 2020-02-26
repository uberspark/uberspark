#
# uberSpark documentation makefile 
# author: Amit Vasudevan (amitvasudevan@acm.org)
#

UBERSPARK_DOC_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SPHINXBUILD   ?= sphinx-build
UBERSPARK_DOC_SOURCEDIR     = $(UBERSPARK_DOC_PATH).
UBERSPARK_DOC_BUILDDIR      = $(UBERSPARK_DOC_PATH)_build

###### targets

### common documentation build prep
.PHONY: docs_build_prep
docs_build_prep:
	mkdir -p $(UBERSPARK_DOC_PATH)/_temp
	mkdir -p $(UBERSPARK_DOC_PATH)/_build
	mkdir -p $(UBERSPARK_DOC_PATH)/_themes
	cd $(UBERSPARK_DOC_PATH)/_temp && git clone https://github.com/hypcode/uberspark-htmlcss-themes.git uberspark-htmlcss-themes.git
	cd $(UBERSPARK_DOC_PATH)/_themes && ln -sf ../_temp/uberspark-htmlcss-themes.git/rtd_uberspark/sphinx_rtd_theme/ rtd_uberspark

### common documentation build prep
.PHONY: docs_build_prep
docs_build_prep:
	cd $(UBERSPARK_DOC_PATH) && git clone https://github.com/hypcode/uberspark-htmlcss-themes.git _themes
	mkdir -p $(UBERSPARK_DOC_PATH)/_build

.PHONY: docs_pdf
docs_pdf: docs_build_prep
	@$(SPHINXBUILD) -b latex "$(UBERSPARK_DOC_SOURCEDIR)" "$(UBERSPARK_DOC_BUILDDIR)"
	@cd $(UBERSPARK_DOC_BUILDDIR) && make 

.PHONY: docs_html
docs_html: docs_build_prep
	@$(SPHINXBUILD) -b html "$(UBERSPARK_DOC_SOURCEDIR)" "$(UBERSPARK_DOC_BUILDDIR)"

.PHONY: clean
clean:
	rm -rf $(UBERSPARK_DOC_PATH)_build
	rm -rf $(UBERSPARK_DOC_PATH)_themes
	rm -rf $(UBERSPARK_DOC_PATH)_temp
