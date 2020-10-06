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

    * `<type>` is the type of bridge and can be one of *cc-bridge* (compiler bridge), *as-bridge* (assembler bridge), *ld-bridge* (linker bridge), or *vf-bridge* (verification bridge)
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

The following sequence of steps are followed to add a new bridge
to the framework source:

1. Identify the `<type>` of bridge you want to add. See 
   :ref:`contrib-guide-bridges-nsdirlayout` to see the current
   bridge types supported.

2. Follow instructions within :ref:`contrib-guide-bridges-nsdirlayout` 
   to construct the bridge namespace and source directory
   depending on whether the 
   bridge will be natively supported or supported via containers.

3. Add a bridge |ubersparkmff| manifest file describing the
   bridge. See |reference-manifest-ref|:::ref:`reference-manifest-uberspark-bridge` 
   for further details on the |uspark| bridge manifest JSON file
   format and bridge node and field descriptions
            
4. For bridges supported via containers, add the bridge dockerfile 
   and other dockerfile build scripts within the bridge source 
   directory. 

   ..  note::  The bridge dockerfile *must* use a specific template
               for the specific container architecture and distribution.
               Templates for Ubuntu and Alpine distributions for
               ``amd64`` architecture can be found within:
               ``src-nextgen/bridges/common/container/amd64``. 
               Copy the relevant ``.template`` file to the bridge 
               |ubersparkbridgedff| and customize sections labeled
               as *CUSTOMIZABLE* with the bridge specific details
               and commands.




.. _contrib-guide-bridges-remove:

Removing a Bridge
-----------------

1. Identify the `<type>` of bridge you want to add. See 
   :ref:`contrib-guide-bridges-nsdirlayout` to see the current
   bridge types supported.

2. Follow instructions within :ref:`contrib-guide-bridges-nsdirlayout` 
   to construct the bridge namespace and source directory
   depending on whether the 
   bridge will be natively supported or supported via containers.

3. Remove the bridge source directory (as identified the 
   previous step) and contents


.. _contrib-guide-bridges-configtest:

Building/Testing a Bridge
-------------------------

Briges supported by containers can be built and tested via
the commaldn line tool interface (see :ref:`frontend-cli-intro`) as below:

``uberspark bridge config --cc-bridge --build <bridge-ns>``

where `<bridge-ns>` is the bridge namespace as described in
:ref:`contrib-guide-bridges-nsdirlayout` without the `container` prefix.

The following example builds the Compcert v3.1 compiler bridge:

``uberspark bridge config --cc-bridge --build amd64/x86_32/generic/compcert/v3.1``

..  note::  The above command uses `--cc-bridge` to identify a 
            compiler bridge. See and |reference-manifest-ref|:::ref:`frontend-cli-bridges`
            for flags and more details on 
            how to select other (e.g., assembler, linker
            and verification) bridges.




