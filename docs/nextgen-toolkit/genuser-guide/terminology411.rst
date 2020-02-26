.. include:: /macros.rst

|uspark| Architecture 411
=========================

The following are architectural terminology specific to the |uspark| framework which anyone (system integrator, 
|coss| developer, or contributor) need to be familiar with, before using the framework.

Platform
    The target hardware platform where the |coss| software stack enhanced with |uspark| executes. e.g., 
    ``pc``, ``raspberry pi``, ``odroid`` etc.

CPU
    The processor(s) model that executes programs on the aforementioned target hardware platform. e.g.,
    ``Intel Core 2nd Gen``,  ``AMD Opteron``, ``Cortex A53``, etc.

Arch
    The architecture on which the CPU(s) of the target hardware platform is based upon. e.g., ``x86 32-bit``, 
    ``armv6 32-bit``, ``armv8 64-bit`` etc.

|b_uobj|
    The atomic programming and system runtime abstraction within |uspark|. 
    Logically, a |uobj| is a *singleton object* guarding some indivisible resources such as 
    platform CPU registers, memory, and device end-points and implementing 
    *public methods* to access them.


|b_uobjcollcaps|
    A |uobjcoll| is a set of |uobjs|  that  share the same memory  address  space,  and  are
    bridged to other |uobjcolls| via *platform hardware conduits*
    or software entities called *sentinels*. In principle, |uobjcolls| can also be nested, modulo the 
    platform hardware providing necessary conduits.


**Platform Hardware Conduits**
    These are hardware pathways for signaling and data transfer on a given computing platform, 
    such as DMA, inter-processor interrupts,  and mail-boxes.

|b_uobj|/|b_uobjcollcaps| **Public Methods**
    |uobj| public methods are regular function signatures (e.g., ``main()`` but can be restricted to specific caller 
    |uobjs|.
    |uobjcoll| public methods are selected public-methods of the individual |uobjs| that the collection encompasses, but
    which can be restricted to specific caller |uobjcoll| and/or legacy code.


