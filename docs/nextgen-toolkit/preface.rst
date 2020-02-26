.. include:: /macros.rst

|uspark| Next-generation
========================

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


.. note::   |uspark| next-generation toolkit is currently in alpha stage and experimental. 
            It aims to enable stand-alone |uobj| build, integration into |coss| code-base, 
            verification and runtime attestation mechanisms. The next-generation toolkit is 
            under active development and at some point 
            in the near future, will replace the existing toolkit. 

.. note::   The next-generation toollkit documentation currently comprises of three 
            overarching guides: the |genuser-guide-ref|,   
            the |cossdev-guide-ref|, and the |contrib-guide-ref|. 
