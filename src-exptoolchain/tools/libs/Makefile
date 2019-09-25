######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### targets
BUILDDIR = _build


.PHONY: prep
prep:
	$(MKDIR) -p $(BUILDDIR)
	$(CP) -f *.ml $(BUILDDIR)/.
	$(CP) -f ./META $(BUILDDIR)/.

.PHONY: all
all: prep
	cd $(BUILDDIR) && $(OCAMLC) -a uberspark_log.ml uberspark.ml -o uberspark.cma
	cd $(BUILDDIR) && $(OCAMLOPT) -a -ccopt -static uberspark_log.ml uberspark.ml -o uberspark.cmxa
	cd $(BUILDDIR) && $(OCAMLFIND) remove uberspark 
	cd $(BUILDDIR) && $(OCAMLFIND) install uberspark META uberspark.cma uberspark.cmxa uberspark.a
	cd $(BUILDDIR) && $(OCAMLOPT) -ccopt -static -package unix -package uberspark -linkpkg -o test test.ml


.PHONY: clean
clean:
	$(RM) -rf $(BUILDDIR)
	
