.. include:: /macros.rst


.. _contrib-guide-bridges-intro:

|uspark| |uobj| Bridges
=======================

|uberspark| bridges are framework connections to existing 
development (compiler, assembler, linker, build system) and
verification tools. Such connections are either established via
containers (we currently use docker) or can exist natively (e.g., installed 
directly on the development system).

The following sections describe the |uspark| bridge namespace
and source directory layout, and how you can add, remove and
test bridges when contributing bridges to the framework.


.. _contrib-guide-bridges-nsdirlayout:

|uspark| Bridge Namespace and Directory Layout
----------------------------------------------


The |uspark| bridge namespace for containerized bridges has
the following format:

``uberspark/bridges/<type>/container/<devenv-arch>/<arch>/<cpu>/<name>/<version>/``

and the corresponding bridge *manifest* and source files
that describes the bridge details are housed within the following 
framework source directory:

``src-nextgen/bridges/<type>/container/<devenv-arch>/<arch>/<cpu>/<name>/<version>/``


Similarly, for |uspark| native bridges the namespace is as below:

``uberspark/bridges/<type>/native/<arch>/<cpu>/<name>/<version>/``

and the corresponding bridge *manifest* and source files are
are housed within the following framework source directory:

``src-nextgen/bridges/<type>/native/<arch>/<cpu>/<name>/<version>/``

The following is a description of the various placeholders
within the aforementioned namespace and source directory layout:

    * `<type>` is the type of bridge and can be one of *cc-bridge* (compiler bridge), *as-bridge* (assembler bridge) or *ld-bridge* (linker bridge)
    * `<arch>` is the CPU architecture the bridge is tailored for    
    * `<cpu>` is the CPU model supported the bridge is tailored for
    * `<name>` is the name of the bridge. This can be any non-conflicting
      bridge names except for the name *uberspark* which is reserved
      for the core framework
    * `<version>` is the version of the bridge

Every |uspark| bridge contains a bridge manifest JSON file 
named |ubersparkmff| within the bridge source directory folder
root.
The bridge manifest describes the relevant bridge details for 
use by the 
framework. 

..  note::  See |reference-manifest-ref|:::ref:`reference-manifest-intro`
            and |reference-manifest-ref|:::ref:`reference-manifest-uberspark-bridge` 
            for further details on the |uspark| bridge manifest JSON file
            format and bridge node and field descriptions
            
For container based bridges, the bridge source directory folder
contains the bridge dockerfile that is named |ubersparkbridgedff|.
The dockerfile contains relevant commands corresponding to the
bridge installation environment.


..  note::  The bridge dockerfile can source other scripts for
            installation purposes. All such scripts will reside in 
            the same top-level bridge source directory where the
            bridge |ubersparkmff| and |ubersparkbridgedff| files
            exist.


.. _contrib-guide-bridges-add:

Adding a new Bridge
-------------------


.. _contrib-guide-bridges-remove:

Removing a Bridge
-----------------



.. _contrib-guide-bridges-configtest:

Testing a Bridge
----------------


