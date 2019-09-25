######
# Makefile for UberSpark tools (common)
# author: amit vasudevan (amitvasudevan@acm.org)
######

###### targets

.PHONY: all
all: 

	$(OCAMLC) -a uberspark_log.ml uberspark.ml -o uberspark.cma
	$(OCAMLOPT) -a -ccopt -static uberspark_log.ml uberspark.ml -o uberspark.cmxa
	$(OCAMLFIND) remove uberspark 
	$(OCAMLFIND) install uberspark META uberspark.cma uberspark.cmxa uberspark.a
	$(OCAMLOPT) -ccopt -static -package unix -package uberspark -linkpkg -o hello hello.ml


.PHONY: clean
clean:
	$(RM) -f *.o *.cmx *.cmi *.cmo *.cma *.cmxa *.a
	
	
