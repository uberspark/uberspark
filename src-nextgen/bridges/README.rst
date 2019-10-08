namespace for uberobject verification and compilation bridges along with integration shims

``ar-bridge``
    namespace for archiver bridges to interface with archiving tools to create archives for uobject code


``as-bridge``
    namespace for assemlber bridges to interface with assembler tools to create uobject assembly code


``bldsys-bridge``
    support trusses for specific coss build systems (e.g., gnu make, cmake) to tie in and interface 
    with uobjects


``cc-bridge``
    compilation bridges to interface with compiler tools to compile uobject 
    sources (e.g., gcc, clang, compcert)


``ld-bridge``
  namespace for linker bridges to interface with linker tools to create uobject binary


``pp-bridge``
  namespace for pre-processor bridges to interface with pre-processing tools to pre-process uobject code


``v-bridge``
    verification bridges to interface with verification tools to verify uobjects (e.g., frama-c, coq)


source tree organization

``bldsys-bridge'' will have subdirectories for each build system tool supported
``v-bridge'' will have the subdirectories: 386, amd64, arm/v7, amd64/v8 etc. as in the docker hub images for ubuntu, alpine, fedora, debian
all other bridges will have the following two-level directory structure: 

level-1: 386, amd64, arm/v7, amd64/v8 etc. as in the docker hub images for ubuntu, alpine, fedora, debian
level-2: uberspark supported architectures x86_32, x86_64, armv8_32, armv8_64 etc.


