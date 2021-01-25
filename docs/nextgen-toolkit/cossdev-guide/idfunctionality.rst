.. include:: /macros.rst

.. _cossdev-guide-idfunctionality:

Identify |coss| (Sensitive) Functionality
=========================================


The first step in refactoring an existing |coss| source-code base to use |uberspark|, is to
identify the |coss| (sensitive) functionality that needs to be protected and reasoned about.

As a running example we will use the ``hello_mul`` minimal coss example that is written in C,
and computes the product of two unsigned 32-bit integers. The sources to ``hello_mul`` can be found within 
the ``src-nextgen/coss-examples/hello_mul/coss_src`` folder. 

Below is the listing of ``src-nextgen/coss-examples/hello_mul/coss_src/main.c``, the main module of ``hello_mul``:

.. literalinclude:: /../src-nextgen/coss-examples/hello_mul/coss_src/main.c
   :language: c
   :linenos:

Here the function ``h_mul`` takes two unsigned 32-bit integer parameters ``multiplicand`` and ``multiplier``
and computes the product before returning the result via the variable ``res_mul``.

Function ``main`` is the entry point of the ``hello_mul`` application and
invokes ``h_mul`` with two global variables ``g_multiplicand`` and
``g_multiplier`` as arguments to compute the product.

Our running example ``hello_mul`` requires the GNU gcc compiler v5.4.0, GNU Assembler and Linkers v2.26.1 (as
part of GNU binutils). It is built using the ``GNU Make`` tool as below:

.. highlight:: bash

::

    make clean
    make

We now proceed with the task of paring away the ``hello_mul`` |coss| application as a single 
|uobjcoll| leveraging |uberspark|.
