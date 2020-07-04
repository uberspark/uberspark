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



###### automatic configuration variables
export USPARK_SRCROOTDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
export USPARK_BUILDTRUSSESDIR := $(USPARK_SRCROOTDIR)/build-trusses
export USPARK_SRCDIR = $(USPARK_SRCROOTDIR)/src-nextgen
export USPARK_DOCSDIR = $(USPARK_SRCROOTDIR)/docs
export USPARK_INSTALLPREPDIR = $(USPARK_SRCROOTDIR)/_install
export USPARK_NAMESPACEROOTDIR := $(ROOT_DIR)/uberspark

export SYS_PROC_VERSION := $(shell cat /proc/version)

define USPARK_CONFIG_CONTENTS 
{
	"uberspark-manifest":{
		"manifest_node_types" : [ "uberspark-installation" ],
		"uberspark_min_version" : "$(USPARK_VERSION)",
		"uberspark_max_version" : "$(USPARK_VERSION)"
	},

    "uberspark-installation" : {
		"rootDirectory" : "$(ROOT_DIR)"
	}
}
endef

export USPARK_INSTALLPREPDIR_CONFIGFILENAME = $(USPARK_INSTALLPREPDIR)/$(USPARK_INSTALL_CONFIGFILENAME)


export SUDO := sudo

###### helper functions

define docker_run
	docker run --rm \
		-e D_CMD="$(1)" \
		-e D_CMDARGS="$(2)" \
		-e MAKE="make" \
		-v $(USPARK_SRCROOTDIR):/home/docker/uberspark \
		-t hypcode/uberspark-build-x86_64 
	find  -type f  -exec touch {} + 
endef


define docker_run_interactive
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

.PHONY: dbgrun_sdefpp
dbgrun_sdefpp: build_sdefpp
	$(call docker_run,make -f sdefpp.mk, -w dbgrun)



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
	$(call docker_run,make -f install.mk, -w all)
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
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/docs
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/bridges
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/platforms
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/staging_golden/uberspark
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/staging
	mkdir -p $(USPARK_NAMESPACEROOTDIR)/staging/default/uberspark
	cp -Rf $(USPARK_INSTALLPREPDIR)/docs/* $(USPARK_NAMESPACEROOTDIR)/docs/ 
	cp -Rf $(USPARK_INSTALLPREPDIR)/bridges/* $(USPARK_NAMESPACEROOTDIR)/bridges/ 
	cp -Rf $(USPARK_INSTALLPREPDIR)/platforms/* $(USPARK_NAMESPACEROOTDIR)/platforms/ 
	cp -Rf $(USPARK_INSTALLPREPDIR)/staging/* $(USPARK_NAMESPACEROOTDIR)/staging_golden/uberspark 
	cp -Rf $(USPARK_INSTALLPREPDIR)/staging/* $(USPARK_NAMESPACEROOTDIR)/staging/default/uberspark 
	ln -sf $(USPARK_NAMESPACEROOTDIR)/staging/default $(USPARK_NAMESPACEROOTDIR)/staging/current
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
	$(call docker_run_interactive,/bin/bash,)


###### cleanup targets
.PHONY: clean
clean: generate_buildtruss
	$(call docker_run,make -f sdefpp.mk, -w clean)
	$(call docker_run,make -f build-docs.mk, -w docs_clean)
	$(call docker_run,make -f build-frontend.mk, -w clean)
	$(call docker_run,make -f install.mk, -w clean)



