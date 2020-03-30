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



- describe uobj singleton uobj
- describe a uobj manifest example; take it from test uobj 
- describe uobj manifest nodes in the context of hello world
- talk about sources that we add
- talk about cli; (ref to manifest and cli
