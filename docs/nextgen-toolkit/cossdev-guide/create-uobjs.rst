.. include:: /macros.rst

.. _cossdev-guide-create-uobjs:

Create |uobjs|
==============

Creating |uobjs| that become part of a given |uobjcoll|, is facilitated by creating 
a |uberspark| manifest file, |ubersparkmff|, within each |uobj| source folder.

In our running example, the ``hello-mul`` |uobjcoll| that we want to create consists of
a single ``main`` |uobj| housed within the folder:

``src-nextgen/coss-examples/hello-mul/coss-src/uobjcoll/main``

Within the aforementioned folder create the |ubersparkmf| file |ubersparkmff| with the
following contents:

.. literalinclude:: /../src-nextgen/coss-examples/hello-mul/ucoss-src/uobjcoll/main/uberspark.json
   :language: bash
   :linenos:

As seen from the aforementioned listing, a |uobj| manifest consists of a manifest header
(defined using `uberspark-manifest` JSON node), which identifies the JSON as a |ubersparkmf|.
The manifest header also includes all the relevant manifest node types (`uberspark-uobj` in our case) 
that are present within the manifest, in addition to specifying the minimum and maximum version of
|uberspark| that is required. See 
|reference-manifest-ref|:::ref:`reference-manifest-uberspark-manifesthdr` for further details on the manifest header and 
definitions.

The `uberspark-uobj` manifest node declares a |uobj|. At a high level the `uberspark-uobj` node
declares the |uobj| namespace, the platform, architecture and CPU requirements as well as sources
and publicmethods in addition to other attributes. See 
|reference-manifest-ref|:::ref:`reference-manifest-uberspark-uobj` for further details on the ``uberspark-uobj``
manifest node and definitions.

The |uobj| *namespace* in our example (`uberspark/ubjcoll/generic/hello-mul/main`) has a 
|uobjcoll| prefix (`uberspark/ubjcoll/generic/hello-mul`) followed by the name 
of the |uobj| folder (`main`).  Here the |uobjcoll| prefix is required to start with `uberspark/uobjcoll`.
We choose `generic/hello-mul` as our user-defined |uobjcoll| namespace suffix since ``hello-mul`` is 
architecture agnostic. Accordingly ``platform``, ``arch``, and ``cpu`` fields are set to ``generic``.

|uobj| *sources* can be composed of a mix of C source files (``c-files``), C header files (``h-files``), 
Assembly source files (``asm-files``), and CASM (``casm-files``).

|uobj| *publicmethods* declare the externally visible interfaces of the |uobj| and for our example is set to
the function ``main`` within the C source file ``main.c`` with return value ``uint32_t``, parameters
``(uint32_t multiplicand, uint32_t multiplier)``, followed by the number of positional parameters (``2`` in our case).

..  note::  ``uberspark-uobj`` *intrauobjcoll-callees*, *interuobjcoll-callees*,  and *legacy-callees* 
            node declarations are still work-in-progress and can be  omitted for discussion for the time being


After declararing the |uobj| via the manifest, the next step is to move over the relevant sources as
specified within the manifest and add the ``uberspark`` header definitions. 
In our case we move ``main.c`` into our |uobj| folder and add the header definition as below:

.. literalinclude:: /../src-nextgen/coss-examples/hello-mul/ucoss-src/uobjcoll/main/main.c
   :language: c
   :linenos:

..  note::  |uberspark| framework headers always have the ``uberspark/include`` prefix and in this case
            we include ``uberspark/include/uberspark.h`` which brings in top-level framework declarations into
            scope.




.. 
    - describe uobj singleton uobj
    - describe a uobj manifest example; take it from test uobj 
    - describe uobj manifest nodes in the context of hello world
    - talk about sources that we add
    - talk about cli; (ref to manifest and cli
