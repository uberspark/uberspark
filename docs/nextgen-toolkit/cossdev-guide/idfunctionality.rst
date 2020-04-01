.. include:: /macros.rst

.. _cossdev-guide-idfunctionality:

Identify |coss| (Sensitive) Functionality
=========================================


The first step in refactoring an existing |coss| source-code base to use |uberspark|, is to
identify the |coss| (sensitive) functionality that needs to be protected and reasoned about.

As a running example we will use the ``hello-mul`` minimal coss example that is written in C,
and multiples two unsigned 32-bit integers. The sources to ``hello-mul`` can be found within 
the ``coss-examples/hello-mul/coss-src`` folder. 

Below is the listing of ``coss-examples/hello-mul/coss-src/main.c``, the main module of ``hello-mul``:

.. literalinclude:: /../src-nextgen/coss-examples/hello-mul/coss-src/main.c
   :language: c
   :linenos:

Here the function ``h_mul`` takes two integer parameters ``multiplicand`` and ``multiplier``
and computes the product before returning the result via the variable ``res_mul``.

Function ``main`` is the entry point of the ``hello-mul`` application and
invokes ``h_mull`` with two global variables ``g_multiplicand`` and
``g_multiplier`` as arguments to compute the product.

Our running example ``hello-mul`` requires GNU GCC v5.4.0, GNU Assembler and Linkers v2.26.1 (as
part of GNU binutils). It is built using the ``GNU Make`` tool as below:

.. highlight:: bash

::

    make clean
    make

We now proceed assuming that we would like to pare-away the ``hello-mul`` application as a single 
|uobjcoll|
