######
# top-level Makefile for uberSpark
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### paths

export USPARK_SRCROOTDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
export USPARK_BUILDTRUSSESDIR := $(USPARK_SRCROOTDIR)/build-trusses
export USPARK_SRCDIR = $(USPARK_SRCROOTDIR)/src-exptoolchain
export USPARK_DOCSDIR = $(USPARK_SRCROOTDIR)/docs

export USPARK_NAMESPACEROOTDIR := ~/uberspark
export USPARK_INSTALL_BINDIR := /usr/bin

export SUDO := sudo

###### helper functions

define docker_run
	docker run --rm -i \
		-e MAKE_TARGET=$(1) \
		-v $(USPARK_BUILDTRUSSESDIR):/home/docker/uberspark \
		-v $(USPARK_DOCSDIR):/home/docker/uberspark/docs \
		-v $(USPARK_SRCDIR):/home/docker/uberspark/src  \
		-t hypcode/uberspark-build-x86_64 
	rm -rf $(USPARK_BUILDTRUSSESDIR)/src
	rm -rf $(USPARK_BUILDTRUSSESDIR)/docs
	find  -type f  -exec touch {} + 
endef

###### default target

.PHONY: all
all: generate_buildtruss docs_html
	@echo building uberspark toolkit...
	$(call docker_run,all)
	@echo uberspark toolkit build success!



###### build truss generation targets

### generate x86_64 build truss
.PHONY: bldcontainer-x86_64
bldcontainer-x86_64: 
	@echo building x86_64 build truss...
	docker build --rm -f $(USPARK_BUILDTRUSSESDIR)/Makefile-truss-x86_64.Dockerfile -t hypcode/uberspark-build-x86_64 $(USPARK_BUILDTRUSSESDIR)/.
	@echo successfully built x86_64 build truss!

### arch independent build truss target
.PHONY: generate_buildtruss
generate_buildtruss: bldcontainer-x86_64


###### documentation targets

### target to generate html documentation
.PHONY: docs_html
docs_html: 
	rm -rf $(USPARK_DOCSDIR)/_build
	$(call docker_run,docs_html)

### target to generate pdf documentation
.PHONY: docs_pdf
docs_pdf: 
	rm -rf $(USPARK_DOCSDIR)/_build
	$(call docker_run,docs_pdf)



###### installation targets

### installation helper target to create namespace
.PHONY: install_createnamespace
install_createnamespace: 
	@echo Creating namespace within: $(USPARK_NAMESPACEROOTDIR)...
	rm -rf $(USPARK_NAMESPACEROOTDIR)
	mkdir -p $(USPARK_NAMESPACEROOTDIR)
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/bridges
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/docs
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/hwm
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/include
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/loaders
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/platforms
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/sentinels
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/uobjcoll
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/uobjrtl
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/uobjs
	@echo Namespace created.

### installation helper target to populate namespace
.PHONY: install_populatenamespace
install_populateamespace: 
	@echo Populating namespace within: $(USPARK_NAMESPACEROOTDIR)...
	cp -rf $(USPARK_SRCDIR)/bridges/* $(USPARK_NAMESPACEROOTDIR)/bridges/.
	cp -rf $(USPARK_DOCSDIR)/_build/* $(USPARK_NAMESPACEROOTDIR)/docs/.
	cp -rf $(USPARK_SRCDIR)/hwm/* $(USPARK_NAMESPACEROOTDIR)/hwm/.
	cp -rf $(USPARK_SRCDIR)/include/* $(USPARK_NAMESPACEROOTDIR)/include/.
	cp -rf $(USPARK_SRCDIR)/loaders/* $(USPARK_NAMESPACEROOTDIR)/loaders/.
	cp -rf $(USPARK_SRCDIR)/platforms/* $(USPARK_NAMESPACEROOTDIR)/platforms/.
	cp -rf $(USPARK_SRCDIR)/sentinels/* $(USPARK_NAMESPACEROOTDIR)/sentinels/.
	cp -rf $(USPARK_SRCDIR)/uobjcoll/* $(USPARK_NAMESPACEROOTDIR)/uobjcoll/.
	cp -rf $(USPARK_SRCDIR)/uobjrtl/* $(USPARK_NAMESPACEROOTDIR)/uobjrtl/.
	cp -rf $(USPARK_SRCDIR)/uobjs/* $(USPARK_NAMESPACEROOTDIR)/uobjs/.
	@echo Namespace populated.


# install tool binary to /usr/bin and namespace to ~/uberspark/
.PHONY: install
install: install_createnamespace install_populateamespace
	@echo Installing binary to $(USPARK_INSTALL_BINDIR)...
	@echo Note: You may need to enter your sudo password. 
	$(SUDO) cp -f $(USPARK_SRCDIR)/tools/driver/uberspark $(USPARK_INSTALL_BINDIR)/uberspark
	@echo Installation success! Use uberspark --version to check.



###### cleanup targets
.PHONY: clean
clean: generate_buildtruss
	rm -rf $(USPARK_DOCSDIR)/_build
	$(call docker_run,clean)


.PHONY: distclean
distclean: 
	rm -rf $(USPARK_DOCSDIR)/_build
	rm -rf $(USPARK_BUILDTRUSSESDIR)/src
	rm -rf $(USPARK_BUILDTRUSSESDIR)/docs
	# http://www.gnu.org/software/automake/manual/automake.html#Clean
	rm -rf $(USPARK_BUILDTRUSSESDIR)/autom4te.cache 
	rm -f $(USPARK_BUILDTRUSSESDIR)/Makefile 
	rm -f $(USPARK_BUILDTRUSSESDIR)/config.log 
	rm -f $(USPARK_BUILDTRUSSESDIR)/config.status
	rm -f $(USPARK_BUILDTRUSSESDIR)/configure
	rm -f $(USPARK_BUILDTRUSSESDIR)/uberspark-common.mk
