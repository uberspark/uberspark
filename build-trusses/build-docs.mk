######
# Makefile to build uberSpark documentation
# author: amit vasudevan (amitvasudevan@acm.org)
######

include ./commondefs.mk

###### targets

### common documentation build prep
.PHONY: docs_build_prep
docs_build_prep:
	mkdir -p $(UBERSPARK_DOCSDIR)/_temp
	mkdir -p $(UBERSPARK_DOCSDIR)/_build
	mkdir -p $(UBERSPARK_DOCSDIR)/_themes
	# create symlink for doxygen include headers
	ln -s $(UBERSPARK_SRCDIR)/ $(UBERSPARK_DOCSDIR)/_build/
	mv -T $(UBERSPARK_DOCSDIR)/_build/src-nextgen $(UBERSPARK_DOCSDIR)/_build/uberspark

	cd $(UBERSPARK_DOCSDIR)/_temp && git clone https://github.com/uberspark/uberspark-htmlcss-themes.git uberspark-htmlcss-themes.git
	cd $(UBERSPARK_DOCSDIR)/_themes && ln -sf ../_temp/uberspark-htmlcss-themes.git/rtd_uberspark/sphinx_rtd_theme/ rtd_uberspark


### generate .pdf documentation
.PHONY: docs_pdf
docs_pdf: docs_clean docs_build_prep
	sphinx-build -b latex "$(UBERSPARK_DOCSDIR)" "$(UBERSPARK_DOCSDIR)"/_build
	@cd "$(UBERSPARK_BUILDDIR)"/docs && make 

### generate .html documentation
.PHONY: docs_html
docs_html: docs_clean docs_build_prep
	sphinx-build -b html "$(UBERSPARK_DOCSDIR)" "$(UBERSPARK_DOCSDIR)"/_build

### cleanup documentation build
.PHONY: docs_clean
docs_clean:
	rm -rf $(UBERSPARK_DOCSDIR)/_build
	rm -rf $(UBERSPARK_DOCSDIR)/_themes
	rm -rf $(UBERSPARK_DOCSDIR)/_temp
