.. include:: ../macros.hrst

Introduction
============

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
- provide runtime local and remote attestation mechanisms to ascertain the load and execution of
  |uobj| collections on a given platform

This documentation describes the details on the pre-requisites, installation and use of the
|uspark| framework.

.. note:: This is an experimental, work-in-progress, next generation of the |uspark| toolkit
          that enables stand-alone |uobj| build, verification and runtime attestation mechanisms



