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

``uberspark/bridges/<type>/container/<devenv-arch>/<cpu>/<arch>/<cpu>/<name>/<version>/``

and the corresponding bridge *manifest* and source files
that describes the bridge details are housed within the following 
framework source directory:

``src-nextgen/bridges/<type>/container/<devenv-arch>/<cpu>/<arch>/<cpu>/<name>/<version>/``


Similarly, for |uspark| native bridges the namespace is as below:

``uberspark/bridges/<type>/native/<cpu>/<arch>/<cpu>/<name>/<version>/``

and the corresponding bridge *manifest* and source files are
are housed within the following framework source directory:

``src-nextgen/bridges/<type>/native/<cpu>/<arch>/<cpu>/<name>/<version>/``

Here,

uberspark bridge manifest is a json manifest; see reference. and source
files are essentially docker container file and associated scripts
for installation (in case of containerized bridges)




.. _contrib-guide-bridges-add:

Adding a new Bridge
-------------------


.. _contrib-guide-bridges-remove:

Removing a Bridge
-----------------



.. _contrib-guide-bridges-configtest:

Testing a Bridge
----------------


