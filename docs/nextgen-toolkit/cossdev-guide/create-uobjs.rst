.. include:: /macros.rst

.. _cossdev-guide-create-uobjs:

Create |uobjs|
==============

..  note::  This section is still a work-in-progress

Creating |uobjs| that become part of a given |uobjcoll|, is facilitated by creating 
a |uberspark| manifest file, |ubersparkmff|, within each |uobj| source folder.

In our running example, the ``hello-mul`` |uobjcoll| that we want to create consists of
a single ``main`` |uobj| housed within the folder:

``coss-examples/hello-mul/ucoss-src/main``

Within the aforementioned folder create the |ubersparkmf| file |ubersparkmff| with the
following contents:

.. literalinclude:: /../src-nextgen/coss-examples/hello-mul/ucoss-src/main/uberspark.json
   :language: bash
   :linenos:

describe the above listing; manifest header (ref), uobj declaration (ref)

for now let us just focus on namespace; always begin with uberspark/uobjcoll, 
for hello-mul, since its architecture agnostic, we decide to house it within uberspark/ubjcoll/generic/hello-mul
and the main uobj at uberspark/ubjcoll/generic/hello-mul/main
platform, arch, cpu are set to generic

within sources we have c-files as main.c; include files gfo into h-files and asm-files into asm-files.

publicmethods define the externally visible interfaces of the uobj and for our example is set to
the function main within main.c with return value uint32_t, x, y

note: intrauobjcoll, interuobjcoll and legacy are work-in-progress and can be omitted for our
discussion for the time being

within the uobj folder create main.c borrowing from the original coss definition
list main.c

.. literalinclude:: /../src-nextgen/coss-examples/hello-mul/ucoss-src/main/main.c
   :language: c
   :linenos:


note the inclusion of uberspark.h to bring in uberspark specific definitions



.. 
    - describe uobj singleton uobj
    - describe a uobj manifest example; take it from test uobj 
    - describe uobj manifest nodes in the context of hello world
    - talk about sources that we add
    - talk about cli; (ref to manifest and cli
