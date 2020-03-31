.. include:: /macros.rst

.. _cossdev-guide-create-uobjcoll:

Create |uobjcoll|
=================

Creating a |uobjcoll| with desired |uobjs| is facilitated by creating 
a |uberspark| manifest file, |ubersparkmff|, within the top-level |uobjcoll| folder.

In our running example, the ``hello-mul`` |uobjcoll| top-level folder is:

``coss-examples/hello-mul/ucoss-src/``

Within the aforementioned folder create the |ubersparkmf| file |ubersparkmff| with the
following contents:

.. literalinclude:: /../src-nextgen/coss-examples/hello-mul/ucoss-src/uberspark.json
   :language: bash
   :linenos:


.. 
    - describe collection
    - describe uobjcollection manifest example; take it from test uobj
    - talk about public method and sentinel
    - also talk about interobjcoll and legacy calls
    - select load address within address space
    - specify loader

