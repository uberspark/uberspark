#   hello_mul Makefile refactored to use überSpark
#
#   minimal coss example application that multiplies two unsigned 32-bit integers 
#   specified via integer parameters and returns the result
#   
#    author: amit vasudevan <amitvasudevan@acm.org>
#

###### targets

.PHONY: all
all: 
	@echo building hello_mul...
	uberspark staging switch generic-platform
	uobjcoll && uberspark uobjcoll build --root-dir=~/uberspark -v --platform=generic --arch=x86_32 --cpu=generic .
	@echo built hello_mul successfully!


.PHONY: clean
clean: 
	rm -f uobjcoll/_build
