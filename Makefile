######
# top-level Makefile for uberSpark
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### paths

###### configuration variables that are inputs to the top-level build process
ROOT_DIR ?= ${HOME}
export USPARK_INSTALL_BINDIR := /usr/bin
export USPARK_INSTALL_CONFIGDIR := /etc/uberspark
export USPARK_INSTALL_CONFIGFILENAME := uberspark.json
export USPARK_VERSION := 6.0.0
export USPARK_DEFAULT_PLATFORM := uberspark/platforms/pcintel-generic/x86/32-bit/core-gen1



###### automatic configuration variables
export USPARK_SRCROOTDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
export USPARK_BUILDTRUSSESDIR := $(USPARK_SRCROOTDIR)/build-trusses
export USPARK_SRCDIR = $(USPARK_SRCROOTDIR)/src-nextgen
export USPARK_DOCSDIR = $(USPARK_SRCROOTDIR)/docs
export USPARK_INSTALLPREPDIR = $(USPARK_SRCROOTDIR)/_install
export USPARK_NAMESPACEROOTDIR := $(ROOT_DIR)/uberspark

export USPARK_SRCDIR_MOUNT = /home/uberspark/uberspark
export USPARK_BUILDTRUSSESDIR_MOUNT := $(USPARK_SRCDIR_MOUNT)/build-trusses


export USPARK_VBRIDGE_DIR := $(USPARK_SRCROOTDIR)/src-nextgen/bridges/container/amd64/vf-bridge/generic/generic/uberspark/v6.0.0
export USPARK_VBRIDGE_DIR_DOCKERFILE := uberspark-bridge.Dockerfile
export USPARK_VBRIDGE_NS_AMD64 := uberspark/uberspark:bridges__container__amd64__vf-bridge__generic__generic__uberspark

export USPARK_BLDBRIDGE_DIR := $(USPARK_SRCROOTDIR)/src-nextgen/bridges/container/amd64/bldsys-bridge/uberspark/
export USPARK_BLDBRIDGE_DIR_DOCKERFILE := uberspark-bridge.Dockerfile
export USPARK_BLDBRIDGE_NS_AMD64 := uberspark/uberspark:bridges__container__amd64__bldsys-bridge__uberspark__

export SYS_PROC_VERSION := $(shell cat /proc/version)


define USPARK_CONFIG_CONTENTS 
{
		"uberspark.manifest.namespace" : "uberspark/installation",
		"uberspark.manifest.version_min" : "$(USPARK_VERSION)",
		"uberspark.manifest.version_max" : "$(USPARK_VERSION)",

    	"uberspark.installation.root_directory" : "$(ROOT_DIR)",
		"uberspark.installation.default_platform" : "$(USPARK_DEFAULT_PLATFORM)"
}
endef

export USPARK_INSTALLPREPDIR_CONFIGFILENAME = $(USPARK_INSTALLPREPDIR)/$(USPARK_INSTALL_CONFIGFILENAME)


export SUDO := sudo

###### helper functions

# this function installs the bridge common infrastructure
# as a "common" folder into every
# container bridge that is part of the bridge namespace
# $(1) = source directory of the bridge common infrastructure
# $(2) = bridge namespace root folder

define install_bridges_common
	@echo Installing bridge common infrastructure from: $(1)
	@echo Installing to bridge namespace: $(2)
	@find $(2) -name '*.Dockerfile' -exec sh -c \
		' bdir=`dirname {}` && mkdir -p $$bdir/common && \
		cp -Rf $(1)/* $$bdir/common/. \
		' \;
	@echo Done
endef

define docker_run
	docker run --rm \
		-e D_CMD="$(2)" \
		-e D_UID="$(3)" \
		-e D_GID="$(4)" \
		-e MAKE="make" \
		-v $(USPARK_SRCROOTDIR):$(USPARK_SRCDIR_MOUNT) \
		-t $(1) 
endef


define docker_run_interactive
	docker run --rm -i \
		-e D_CMD="$(2)" \
		-e D_UID="$(3)" \
		-e D_GID="$(4)" \
		-e MAKE="make" \
		-v $(USPARK_SRCROOTDIR):$(USPARK_SRCDIR_MOUNT) \
		-t $(1) 
endef



###### default target

.PHONY: all
all: all_but_docs docs_html
	@echo uberspark toolkit build success!

.PHONY: all_but_docs
all_but_docs: build_bootstrap frontend bridge-plugins
	@echo uberspark libs, front-end and bridge-plugins build success!


###### build bootstrap target
.PHONY: build_bootstrap
build_bootstrap: generate_buildtruss build_sdefpp


### shared definitions pre-processing tool
.PHONY: build_sdefpp
build_sdefpp: generate_buildtruss
	$(call docker_run, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f sdefpp.mk -w all, $(shell id -u), $(shell id -g))

.PHONY: dbgrun_sdefpp
dbgrun_sdefpp: build_sdefpp
	$(call docker_run, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) &&  make -f sdefpp.mk -w dbgrun, $(shell id -u), $(shell id -g))



###### build truss generation targets


### provision bridge common infrastructure for container bridges
.PHONY: provision-bridge-common-infrastructure
provision-bridge-common-infrastructure: 
	@echo Provisioning bridge common infrastructure for container bridges...
	$(call install_bridges_common, $(USPARK_SRCROOTDIR)/src-nextgen/bridges/container/amd64/common, $(USPARK_SRCROOTDIR)/src-nextgen/bridges )
	@echo Successfully populated bridge common infrastructure



### generate amd64 build truss
.PHONY: buildcontainer-amd64
buildcontainer-amd64: 
	@echo building amd64 build truss...
	docker build --rm -f $(USPARK_BLDBRIDGE_DIR)/$(USPARK_BLDBRIDGE_DIR_DOCKERFILE) -t $(USPARK_BLDBRIDGE_NS_AMD64) $(USPARK_BLDBRIDGE_DIR)/.
	docker build --rm -f $(USPARK_VBRIDGE_DIR)/$(USPARK_VBRIDGE_DIR_DOCKERFILE) -t $(USPARK_VBRIDGE_NS_AMD64) $(USPARK_VBRIDGE_DIR)/.
	@echo successfully built amd64 build truss!


### arch independent build truss target
.PHONY: generate_buildtruss
generate_buildtruss: provision-bridge-common-infrastructure buildcontainer-amd64


###### documentation targets

.PHONY: docs_html
docs_html: build_bootstrap
	$(call docker_run,  $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f build-docs.mk -w docs_html, $(shell id -u), $(shell id -g))
	@echo successfully built HTML docs!

.PHONY: docs_pdf
docs_pdf: build_bootstrap
	$(call docker_run, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f build-docs.mk -w docs_pdf, $(shell id -u), $(shell id -g))
	@echo successfully built PDF docs!


###### libraries targets

### build libraries
.PHONY: libs
libs: build_bootstrap
	$(call docker_run, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f build-libs.mk -w all, $(shell id -u), $(shell id -g))


### frontend build targets
.PHONY: frontend
frontend: libs
	$(call docker_run, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f build-frontend.mk -w all, $(shell id -u), $(shell id -g))

### build bridge plugins
.PHONY: bridge-plugins
bridge-plugins: libs
	$(call docker_run, $(USPARK_VBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f build-bridge-plugins.mk -w all, $(shell id -u), $(shell id -g))


###### check to see if ROOT_DIR is specified when we are operating under WSL 
.PHONY: check_wslrootdir
check_wslrootdir:	
ifeq "$(findstring Microsoft, $(SYS_PROC_VERSION))" "Microsoft"
	@echo "Windows Subsystem for Linux (WSL) environment detected"
ifeq "$(ROOT_DIR)" "${HOME}"
	@echo "Error: ROOT_DIR needs to be specified and has to point to a NTFS path. See documentation!"
	exit 1
endif
endif


###### installation targets


# install tool binary, global configuration manifest and namespace
.PHONY: install
install: check_wslrootdir build_bootstrap
	@echo $(USPARK_INSTALLPREPDIR_CONFIGFILENAME)
	$(call docker_run, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f install.mk -w all, $(shell id -u), $(shell id -g))
	@echo Populating namespace within: $(USPARK_NAMESPACEROOTDIR)...
	@if [ -d $(USPARK_NAMESPACEROOTDIR) ]; then \
		echo "$(USPARK_NAMESPACEROOTDIR) already exists. "; \
		read -p "Would you like to continue (rm -rf $(USPARK_NAMESPACEROOTDIR)) [y/N]? " action; \
		if [ "$$action" != "y" ] && [ "$$action" != "Y" ]; then \
			echo "Please remove $(USPARK_NAMESPACEROOTDIR) (e.g., rm -rf $(USPARK_NAMESPACEROOTDIR)) in order to allow installation"; \
			exit 1; \
		fi; \
	fi
	rm -rf $(USPARK_NAMESPACEROOTDIR)
	mkdir -p $(USPARK_NAMESPACEROOTDIR)
	cp -Rf $(USPARK_INSTALLPREPDIR)/* $(USPARK_NAMESPACEROOTDIR)/. 
	@echo Populated install namespace successfully
	@echo Installing global configuration to $(USPARK_INSTALL_CONFIGDIR)...
	@echo Note: You may need to enter your sudo password. 
	$(file >$(USPARK_INSTALL_CONFIGFILENAME), $(USPARK_CONFIG_CONTENTS))
	@mv ./$(USPARK_INSTALL_CONFIGFILENAME) $(USPARK_INSTALLPREPDIR_CONFIGFILENAME)
	$(SUDO) mkdir -p $(USPARK_INSTALL_CONFIGDIR)
	$(SUDO) cp -f $(USPARK_INSTALLPREPDIR_CONFIGFILENAME) $(USPARK_INSTALL_CONFIGDIR)/$(USPARK_INSTALL_CONFIGFILENAME)
	@echo Wrote global configuration.
	@echo Installing binary to $(USPARK_INSTALL_BINDIR)...
	@echo Note: You may need to enter your sudo password. 
	$(SUDO) cp -f $(USPARK_INSTALLPREPDIR)/bin/uberspark $(USPARK_INSTALL_BINDIR)/uberspark
	@echo Installation success! Use uberspark --version to check.


###### (debug) shell target
.PHONY: dbgshell
dbgshell: generate_buildtruss
	$(call docker_run_interactive, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && /bin/bash, $(shell id -u), $(shell id -g))


###### cleanup targets
.PHONY: clean
clean: generate_buildtruss
	$(call docker_run, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f sdefpp.mk -w clean, $(shell id -u), $(shell id -g))
	$(call docker_run, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f build-docs.mk -w docs_clean, $(shell id -u), $(shell id -g))
	$(call docker_run, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f build-frontend.mk -w clean, $(shell id -u), $(shell id -g))
	$(call docker_run, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f build-libs.mk -w clean, $(shell id -u), $(shell id -g))
	$(call docker_run, $(USPARK_VBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f build-bridge-plugins.mk -w clean, $(shell id -u), $(shell id -g))
	$(call docker_run, $(USPARK_BLDBRIDGE_NS_AMD64), cd $(USPARK_BUILDTRUSSESDIR_MOUNT) && make -f install.mk -w clean, $(shell id -u), $(shell id -g))



