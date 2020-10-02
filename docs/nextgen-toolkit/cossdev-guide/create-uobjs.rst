.. include:: /macros.rst

.. _cossdev-guide-create-uobjs:

Create |uobjs|
==============

Creating |uobjs| that become part of a given |uobjcoll|, is facilitated by creating 
a |uberspark| manifest file, |ubersparkmff|, within each |uobj| source folder and 
organizing and refactoring relevant sources that comprise the corresponding |uobjs|.


Create |uobj| Manifest
----------------------

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


Specify |uobj| callees
----------------------

..  note::  ``uberspark-uobj`` *intrauobjcoll-callees*, *interuobjcoll-callees*,  and *legacy-callees* 
            node declarations are still work-in-progress and can be  omitted for discussion for the time being


Specify |uobj| Sections
-----------------------

The `section` sub-node of the `uberspark-uobj` manifest node is used to specify |uobj|
binary sectioning parameters. Such parameters include the section size, alignment and 
padding.

A |uobj| binary consists of certain standard sections corresponding to the |uobj| code, data and stack.
In addition, variables or functions within the |uobj| can be added to special developer-defined sections (e.g., 
for specific padding or memory alignment purposes). Such develper-defined section definitions are appropriately
qualified within the sources (e.g., via __attribute__((section()))) and specified using the `sections` sub-node of
the `uberspark-uobj` manifest node.

For example, consider the |uobj| C code below, that defines a variable `special` which needs to be output to a special
section that spans a page in size at maximum, is aligned on a page-boundary, and is padded to a page size. 

.. code-block:: c
   :linenos:

   __attribute__((section(".specialsec"))) unsigned char special[512];

The following is a snippet of the `uberspark-uobj` manifest node specification for the |uobj| that specifies this
output section for the |uobj| binary.

.. code-block:: json
   :linenos:

   {
    	"uberspark-uobj" : {
         "sections": [
            {
               "name" : "specialsec",
               "size" : "0x1000",
               "output_names" : [ ".specialsec" ],
               "aligned_at" : "0x1000",
               "pad_to" : "0x1000"
            }
         ]
      }
   }

A similar approach can be used to place |uobj| function definitions within a desired output section in 
the |uobj| binary.

The `section` sub-node can also be used to specify section sizes, alignment and padding of pre-defined
|uobj| binary sections such as code, data and stack. 

As an example, the following is a snippet of the `uberspark-uobj` manifest node specification for 
the |uobj| that specifies the maximum size of the |uobj| code section (in bytes).

.. code-block:: json
   :linenos:

   {
    	"uberspark-uobj" : {
         "sections": [
            {
               "name" : "uobj_code",
               "size" : "0x1000"
            }
         ]
      }
   }

..  warning:: specifying a section size that is smaller than the actual |uobj| generated section
              size will result in a |uobj| build error.

..  note::  `uobj_code` is the name allocated to the standard |uobj| code section. 
            See |reference-manifest-ref|:::ref:`reference-manifest-uberspark-uobj` for further details on 
            standar |uobj| section names.

..  note::  *name* and *size* are required fields within the `sections` sub-node for all |uobj| section definitions.
            For developer-defined sections, the *output_names* field is an additional requirement.
            See |reference-manifest-ref|:::ref:`reference-manifest-uberspark-uobj` for further details on 
            the `sections` sub-node field definitions

..  note::  You can have multiple comma delimited output section definitions within the manifest. 
            See |reference-manifest-ref|:::ref:`reference-manifest-uberspark-uobj` for further details on 
            the `sections` sub-node list definition options within the `uberspark-uobj` manifest node.
            


Organize |uobj| Sources
-----------------------

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
