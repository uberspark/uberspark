.. include:: /macros.rst


.. _contrib-guide-tools-intro:

|uspark| Toolkit
================

The |uberspark| toolkit consists of the following components:

   * docgen -- documentation generation tools; currently includes an automated
     reference generator for doxygen documentation within code
   * frontend -- the |uspark| front-end command line tool
   * lib -- the |uspark| core library which is used both by the frontend command line
     tool as well as the verficiation bridge plugin
   * sdefpp -- a pre-processor to specify and generate shared definitions between C/Assembly code
     and Ocaml code
   * vbridge-plugin -- the |uspark| verification bridge plugin for |uobjcoll| and |uobj|
     verification


|uspark| lib
------------

The |uspark| core library which is used both by the frontend command line
tool as well as the verficiation bridge plugin. It is written in Ocaml in a modular
fashion. The following are the modules which are exposed as ``Uberspark.xxx``. 
For example, ``uberspark__namespace.{ml,mli}`` is available as ``Uberspark.Namespace``:

..  code-block:: bash    

.
├── defs
│   ├── basedefs.mli.us
│   ├── basedefs.ml.us
│   ├── binformat.mli.us
│   └── binformat.ml.us
├── Makefile
├── META
├── uberspark__actions.ml
├── uberspark__actions.mli
├── uberspark__bridge_container.ml
├── uberspark__bridge.ml.cppo
├── uberspark__bridge.mli
├── uberspark__bridge_native.ml
├── uberspark__codegen.ml.cppo
├── uberspark__codegen.mli
├── uberspark__codegen_uobjcoll.ml
├── uberspark__codegen_uobj.ml
├── uberspark__context.ml
├── uberspark__context.mli
├── uberspark__defs.ml.cppo
├── uberspark__defs.mli.cppo
├── uberspark__logger.ml
├── uberspark__logger.mli
├── uberspark__manifest_bridge.ml
├── uberspark__manifest_installation.ml
├── uberspark__manifest_loader.ml
├── uberspark__manifest.ml.cppo
├── uberspark__manifest.mli
├── uberspark__manifest_platform.ml
├── uberspark__manifest_sentinel.ml
├── uberspark__manifest_uobjcoll.ml
├── uberspark__manifest_uobj.ml
├── uberspark__manifest_uobjrtl.ml
├── uberspark__manifest_uobjslt.ml
├── uberspark.ml
├── uberspark__module_template.ml
├── uberspark__module_template.mli
├── uberspark__namespace.ml
├── uberspark__namespace.mli
├── uberspark__osservices.ml
├── uberspark__osservices.mli
├── uberspark__staging.ml
├── uberspark__staging.mli
├── uberspark__utils.ml
├── uberspark__utils.mli
└── unit_test
    ├── META
    ├── mylib__a.ml
    ├── mylib__a.mli
    ├── mylib__b.ml
    ├── mylib__b.mli
    ├── mylib.ml
    └── test.ml


The following are the various modules (in order of dependencies) and are
available as ``Uberspark.xxx`` where ``xxx`` is the
module name:

    * Uberspark.Defs -- top-level type definitions
    * Uberspark.Logger -- console logging functionality
    * Uberspark.Osservices -- operating system/shell services
    * Uberspark.Utils -- general utility functions
    * Uberspark.Namespace -- namespace and associated functions
    * Uberspark.Manifest -- manifest support
    * Uberspark.Staging -- staging related functionality (work-in-progress)
    * Uberspark.Bridge -- bridge support (native and containerized)
    * Uberspark.Platform -- for platform (CPU, arch, devices, memory) information
    * Uberspark.Codegen -- code generation 
    * Uberspark.Actions -- |uobjcoll| and |uobj| manifest action orchestration
    * Uberspark.Context -- module that establishes operating context for build and/or verification

``Uberspark.Context`` is the top-level module that maintains the context for 
verification and build. It also
contains global variables and interfaces that allow
creating, querying and destroying operation context. 
The ``Uberspark.Context`` module uses the 
``Uberspark.Actions`` module interfaces in order to consolidate
all manifest actions and execute them.

