.. uberSpark documentation master index
   author: Amit Vasudevan (amitvasudevan@acm.org)

.. include:: /macros.rst

Welcome to |uspark|'s documentation!
=====================================

|uspark| is an innovative system architecture and programming principle for compositional 
verification of (security) properties of commodity (extensible) system software written in 
C and Assembly.

The salient features of |uspark| include:

- provide a verifiable object abstraction (uberObject) to endow low-level system software with 
  abstractions found in higher-level languages (e.g., objects, interfaces, function-call 
  semantics, serialization, access-control etc.)
- facilitate easy refactoring of existing commodity (low-level) system software stack into a 
  collection of (composable) |uobjs|
- enforce |uobj| abstractions using a combination of commodity hardware mechanisms, light-weight 
  static analysis and formal verification.

This documentation describes the details on the software requirements and
dependencies, build, verification and intallation of the core |uspark| tools and
libraries and |coss|

.. toctree::
   :maxdepth: 2
   :caption: Current Generation Toolkit:
   
   sw-requirements
   build-install
   verify-build-install-libs

.. toctree::
   :maxdepth: 2
   :caption: [ (Experimental) Next-Gen Toolkit ]
   :includehidden:

   nextgen-toolkit/preface




.. toctree::
   :maxdepth: 4
   :caption: General User's Guide


   nextgen-toolkit/genuser-guide/intro
   nextgen-toolkit/genuser-guide/swreq
   nextgen-toolkit/genuser-guide/install
   nextgen-toolkit/genuser-guide/terminology411
   nextgen-toolkit/genuser-guide/staging
   nextgen-toolkit/genuser-guide/install-uobjsuobjcolls
   nextgen-toolkit/genuser-guide/reporting


.. toctree::
   :maxdepth: 4
   :caption: CoSS Developer's Guide

   nextgen-toolkit/cossdev-guide/intro
   nextgen-toolkit/cossdev-guide/idfunctionality
   nextgen-toolkit/cossdev-guide/prepnamespace
   nextgen-toolkit/cossdev-guide/create-uobjs
   nextgen-toolkit/cossdev-guide/use-uobjrtl
   nextgen-toolkit/cossdev-guide/create-uobjcoll
   nextgen-toolkit/cossdev-guide/reintegrate-uobjcoll
   nextgen-toolkit/cossdev-guide/refactor-build



.. toctree::
   :maxdepth: 4
   :caption: Contributor's Guide

   nextgen-toolkit/contrib-guide/intro


.. toctree::
   :maxdepth: 4
   :caption: Reference

   nextgen-toolkit/reference/manifest
   nextgen-toolkit/reference/frontend-cli
   nextgen-toolkit/reference/uobjrtl/intro
