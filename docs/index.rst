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
   
   sw-requirements
   build-install
   verify-build-install-libs

