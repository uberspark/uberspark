######
# top-level Makefile for uberSpark
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### paths

export USPARK_SRCROOTDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
export USPARK_BUILDTRUSSESDIR := $(USPARK_SRCROOTDIR)/build-trusses
export USPARK_SRCDIR = $(USPARK_SRCROOTDIR)/src-nextgen
export USPARK_DOCSDIR = $(USPARK_SRCROOTDIR)/docs

export USPARK_NAMESPACEROOTDIR := ~/uberspark
export USPARK_INSTALL_BINDIR := /usr/bin

export SUDO := sudo

###### helper functions

define docker_run
	docker run --rm -i \
		-e D_CMD="$(1)" \
		-e D_CMDARGS="$(2)" \
		-e MAKE="make" \
		-v $(USPARK_SRCROOTDIR):/home/docker/uberspark \
		-t hypcode/uberspark-build-x86_64 
	find  -type f  -exec touch {} + 
endef




###### default target

.PHONY: all
all: build_bootstrap docs_html frontend
	@echo uberspark toolkit build success!


###### build bootstrap target
.PHONY: build_bootstrap
build_bootstrap: generate_buildtruss build_sdefpp


### shared definitions pre-processing tool
.PHONY: build_sdefpp
build_sdefpp: generate_buildtruss
	$(call docker_run,make -f sdefpp.mk, -w all)

#.PHONY: run_sdefpp
#run_sdefpp: build_sdefpp
#	$(call docker_run,make -f sdefpp.mk, -w run)



###### build truss generation targets

### generate x86_64 build truss
.PHONY: buildcontainer-x86_64
buildcontainer-x86_64: 
	@echo building x86_64 build truss...
	docker build --rm -f $(USPARK_BUILDTRUSSESDIR)/build-x86_64.Dockerfile -t hypcode/uberspark-build-x86_64 $(USPARK_BUILDTRUSSESDIR)/.
	@echo successfully built x86_64 build truss!


### arch independent build truss target
.PHONY: generate_buildtruss
generate_buildtruss: buildcontainer-x86_64


###### documentation targets

.PHONY: docs_html
docs_html: build_bootstrap
	$(call docker_run,make -f build-docs.mk, -w docs_html)

.PHONY: docs_pdf
docs_pdf: build_bootstrap
	$(call docker_run,make -f build-docs.mk, -w docs_pdf)


###### libraries targets

### build libraries
.PHONY: libs
libs: build_bootstrap
	$(call docker_run,make -f build-libs.mk, -w all)


###### frontend build targets
.PHONY: frontend
frontend: build_bootstrap
	$(call docker_run,make -f build-frontend.mk, -w all)


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
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/uobjslt
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
	cp -rf $(USPARK_SRCDIR)/uobjslt/* $(USPARK_NAMESPACEROOTDIR)/uobjslt/.
	cp -rf $(USPARK_SRCDIR)/uobjs/* $(USPARK_NAMESPACEROOTDIR)/uobjs/.
	@echo Namespace populated.


# install tool binary to /usr/bin and namespace to ~/uberspark/
.PHONY: install
install: install_createnamespace install_populateamespace
	@echo Installing binary to $(USPARK_INSTALL_BINDIR)...
	@echo Note: You may need to enter your sudo password. 
	$(SUDO) cp -f $(USPARK_SRCDIR)/tools/frontend/_build/uberspark $(USPARK_INSTALL_BINDIR)/uberspark
	@echo Installation success! Use uberspark --version to check.


###### (debug) shell target
.PHONY: dbgshell
dbgshell: generate_buildtruss
	$(call docker_run,/bin/bash,)


###### cleanup targets
.PHONY: clean
clean: generate_buildtruss
	$(call docker_run,make -f sdefpp.mk, -w all)
	$(call docker_run,make -f build-docs.mk, -w docs_clean)
	$(call docker_run,make -f build-frontend.mk, -w clean)



