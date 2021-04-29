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
├── uberspark__binary.ml
├── uberspark__binary.mli
├── uberspark__bridge_container.ml
├── uberspark__bridge.ml.cppo
├── uberspark__bridge.mli
├── uberspark__bridge_native.ml
├── uberspark__codegen.ml.cppo
├── uberspark__codegen.mli
├── uberspark__codegen_uobjcoll.ml
├── uberspark__codegen_uobj.ml
├── uberspark__defs.ml.cppo
├── uberspark__defs.mli.cppo
├── uberspark__loader.ml
├── uberspark__loader.mli
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
├── uberspark.mli.cppo
├── uberspark__module_template.ml
├── uberspark__module_template.mli
├── uberspark__namespace.ml
├── uberspark__namespace.mli
├── uberspark__osservices.ml
├── uberspark__osservices.mli
├── uberspark__platform.ml
├── uberspark__platform.mli
├── uberspark__staging.ml
├── uberspark__staging.mli
├── uberspark__uobjcoll.ml
├── uberspark__uobjcoll.mli
├── uberspark__uobj.ml
├── uberspark__uobj.mli
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


``Uberspark.Context`` is the top-level module that maintains the context for 
verification and build. It contains several submodules (in order of dependency) which are
available as ``Uberspark.Context.xxx`` (e.g., ``Uberspark.Context.Uobjcoll``):

   * Platform -- for platform (CPU, arch, devices, memory) information
   * Codegen -- code generation 
   * Loader -- |uobjcoll| loader related functionality
   * Uobjrtl -- |uobjrtl| related functionality
   * Uobj -- |uobj| related functionality
   * Actions -- |uobjcoll| and |uobj| manifest action orchestration
   * Uobjcoll -- |uobjcoll| related functionality


   ``Uberspark.Context`` also contains global variables and interfaces that allow
creating, querying and destroying operation context. Once an operation context is
created, the context information can be accessed via the ``Uberspark.Context`` and
associated submodule interfaces.

The following modules (in order of dependencies) are context independent:

   * Uberspark.Defs -- top-level type definitions
   * Uberspark.Logger -- console logging functionality
   * Uberspark.Osservices -- operating system/shell services
   * Uberspark.Utils -- general utility functions
   * Uberspark.Namespace -- namespace and associated functions
   * Uberspark.Manifest -- manifest support
   * Uberspark.Staging -- staging related functionality (work-in-progress)
   * Uberspark.Bridge -- bridge support (native and containerized)
   * Uberspark.Binary -- for binary support




