.. include:: /macros.rst


.. _contrib-guide-hwm-intro:

|uspark| Hardware Model
=================================

The |uberspark| Hardware Model (HWM) consists of various hardware 
component models such as the CPU, memory, I/O devices, and associated 
hardware-conduit end-points. These models interact with |uobjs| through
the hardware |uobjrtl|, which exposes various interfaces to the
platform hardware.

The following sections describe how you can model and add a new 
hardware component to the HWM.

..  seealso::   :ref:`überSpark üobject HW Runtime Library Reference<uobjrtl-hw>` 
                for a description of the associated hardware |uobj| 
                runtime library and associated function documentation.

..  seealso::   |reference-hwm-ref| for a description of currently 
                modeled hardware and associated functions.


.. _contrib-guide-hwm-nsdirorg:

HWM Namespace and Directory Layout
----------------------------------

The HWM organization is split into various sub-models, each housing 
a CPU, device, or platform specific hardware model:

* CPU is organized as ``hwm/cpu/<cpu-subtree>``
* Device is organized as ``hwm/src/device/<device-subtree>`` for model sources and ``hwm/include/device/<device-subtree>`` for headers
* Platform is organized as ``hwm/src/platform/<platform-subtree>`` for model sources and ``hwm/include/platform/<platform-subtree>`` for headers

The organization of ``<cpu-subtree>``, ``<device-subtree>``, and ``<platform-subtree>`` 
are detailed below

CPU HWM Namespace Layout
^^^^^^^^^^^^^^^^^^^^^^^^

The ``<cpu-subtree>`` is organized as ``<arch>/<addressing>/<cpumodel>``
Here <arch> is the CPU instruction architecture (x86, ARM, RISC-V),
<adressing> is the addressing mode (32-bit/64-bit) and <cpumodel> is the
model of the CPU (e.g. AMD-Opteron, Intel core-genx). This scheme allows us
to target a specific CPU architecture along with architecture customization
and micro-architectural details with <cpumodel>. Below is a snapshot of the currently
available CPU HWM and their layout.

..  code-block:: bash    

.
├── armv7-a
│   └── 32-bit
│       ├── cortex-a7
│       │   ├── include
│       │   │   ├── cpu.h
│       │   │   └── hwm.h
│       │   └── uberspark.json
│       └── generic
│           ├── include
│           │   ├── cpu.h
│           │   └── hwm.h
│           └── src
│               └── cpu.c
├── armv8-a
│   └── 32-bit
│       ├── cortex-a53
│       │   ├── include
│       │   │   ├── cpu.h
│       │   │   └── hwm.h
│       │   └── uberspark.json
│       └── generic
│           └── include
│               ├── cpu.h
│               └── hwm.h
└── x86
    └── 32-bit
        ├── core-gen1
        │   ├── include
        │   │   ├── cpu.h
        │   │   ├── hwm.h
        │   │   └── txt.h
        │   ├── src
        │   │   └── txt.c
        │   └── uberspark.json
        └── generic
            ├── include
            │   ├── casm.h
            │   ├── cpu.h
            │   ├── hwm.h
            │   ├── lapic.h
            │   └── mem.h
            └── src
                ├── cpu.c
                ├── lapic.c
                └── mem.c


As seen from the above layout, every CPU HWM leaf folder consists of a ``src`` and ``include`` 
folder and the |ubersparkmf| file |ubersparkmff|. Further the 
``include`` folder contains a ``hwm.h`` file which provides the
top-level include header for the hardware model. The HWM source file names and supporting
header files do not have any specific naming convention.

..  note::  The `generic` ``<cpumodel>`` is reserved for common model sources and headers
            that may be included from within the manifest of a particular ``<cpumodel>``. 
            As an example, ``armv7-a/32-bit/cortex-a7/uberspark.json`` includes
            ``armv7-a/32-bit/generic/src/cpu.c``    
    
..  note::  Any `generic` model sources must be specified in relative path format within
            a particular ``<cpumodel>`` |ubersparkmf|


Device HWM Namespace Layout
^^^^^^^^^^^^^^^^^^^^^^^^^^^
            
The device HMM models various supported devices including their internal state modeling 
(e.g., what the device does in response to a particular input). 
Device HWMs interact with the CPU HWM via a general device interface abstraction.

..  todo::  Flesh out general device interface abstraction section

The following is the general organization of the ``<device-subtree>``.

``device-class``
type of function that the device performs (e.g., network controller)

    ``device-subclass``
    specific functionality of the device when applicable (e.g., ethernet controller)

        ``device-vendor``
        vendor name of the device (e.g., intel)

            ``device-id``
            specific id or instance of the device (e.g., e1000)

    ``device-vendor``
    vendor name of the device if no `device-subclass` exists (e.g., intel)

For example, below is a snapshot of the currently supported device models that showcases the
aforementioned namespace organization.

..  code-block:: bash    

.
├── iommu
│   └── intel
│       └── vtd.c
└── net
    └── ethernet
        └── intel
            └── e1000
                └── e1000.c



Platform HWM Namespace Layout
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Platform HWM includes device agnostic platform-level modeling. e.g., for pc platform BIOS 
and option ROM functionality.

The following is the general organization of the ``<platform-subtree>``.

``platform-name``
    The name of the computing platform (e.g., pc, rpi3, beagleboard)

For example, below is a snapshot of the currently supported platform models that showcases the
aforementioned namespace organization.
    
..  code-block:: bash    
    
.
└── pc
    └── bios.c



.. _contrib-guide-hwm-hdrcontents:

HWM Source Header-file Details
------------------------------

An HWM source model header should be placed in ``hwm/include/{model-path-specification}``.
The header filename should always end with a ``.h`` suffix.

The header file contents should be embedded within the following prologue and
epilogue:


.. code-block:: c

    #ifndef __HWM__<HWMTYPE>__<HWMTYPETREEPATH>__<FILENAME>__H__
    #define __HWM__<HWMTYPE>__<HWMTYPETREEPATH>__<FILENAME>__H__


    #endif /* __HWM__<HWMTYPE>__<HWMTYPETREEPATH>__<FILENAME>__H__ */


Here ``<HWMTYPE>`` is one of ``CPU``, ``DEVICE`` or ``PLATFORM`` 
and <HWMTYPETREEPATH> is the corresponding ``<cpu-subtree>``, ``<device-subtree>`` or 
``<platform-subtree>`` path specification (delimited by ``__``) of the header file 
(sans the filename). Finally, ``<FILENAME>`` is the name of the file (sans the ``.h``). 


x86
    └── 32-bit
        ├── core-gen1
        │   ├── include
        │   │   ├── cpu.h
        │   │   ├── hwm.h
        │   │   └── txt.h
        │   ├── src
        │   │   └── txt.c
        │   └── uberspark.json
        └── generic
            ├── include
            │   ├── casm.h
            │   ├── cpu.h

For example, for ``cpu.h`` within the ``<cpu-subtree>`` of 
``x86/32-bit/core-gen1/include``, the namespace, the prologue and epilogue are as 
shown below:

.. code-block:: c

    #ifndef __HWM__CPU__X86__32_BIT__CORE_GEN1__CPU__H__
    #define __HWM__CPU__X86__32_BIT__CORE_GEN1__CPU__H__

    #endif /* __HWM__CPU__X86__32_BIT__CORE_GEN1__CPU__H__ */

..  note::  All ``-`` within the ``<cpu-subtree>`` path specification is converted 
            into ``_``
            

An HWM header file can prevent contents from being available to Assembly language 
source models via the following construct:

.. code-block:: c

    #ifndef __ASSEMBLY__

    #end /* __ASSEMBLY__ */


An HWM source header file must include declarations for all the functions that are 
described by the corresponding collection of source files, when applicable
(a source file implementation is not always required, i.e. if the model only defines 
structs and definitions).
 
..  note::  Every model namespace should also contain an ``hwm.h`` header file, 
            see :ref:`contrib-guide-hwm-hwmhdrcontents`




.. _contrib-guide-hwm-hwmhdrcontents:

HWM Model Header-file Details
-----------------------------

Each model folder should contain an ``hwm.h`` header-file that ``#include`` s all the 
other source header-files from that namespace.

In addition, the ``hwm.h`` should layer includes from more general, yet related, model 
namespaces. For instance, the ``hwm/cpu/x86/32-bit/core-gen1/hwm.h`` should include
``hwm/cpu/x86/32-bit/generic/include/hwm.h``.

The ``hwm.h`` can also contain other specific structs and definitions that are shared by 
that entire model.


.. _contrib-guide-hwm-srccontents:

HWM Source-file Details
-----------------------

An HWM model source file should be placed in ``src`` folder of the corresponding ``<cpu/device/platform-tree>``.

CASM interfaces should be prefixed with ``_impl__casm__``. |br|
CASM functions exposed for |uobjs| should be prefixed with ``__casm__``. |br|
Interfaces should be prefixed with ``_impl_hwm``. |br|
Functions exposed for |uobjs| and |uobjrtl| should be prefixed with ``hwm_``. |br|

Source files can also ``#include`` necessary 
headers (i.e. ``<uberspark/include/uberspark.h>``)


.. _contrib-guide-hwm-addhwm:

Adding a new model to the HWM
-----------------------------

1.  Choose a CPU, device, or platform namespace as described in :ref:`contrib-guide-hwm-nsdirorg`.

2.  Create the necessary directories.

3.  Add HWM source modules, source headers, and model headers following content rules as described in :ref:`contrib-guide-hwm-hdrcontents`,
    :ref:`contrib-guide-hwm-hwmhdrcontents`, and :ref:`contrib-guide-hwm-srccontents`.

4.  Add reference documentation for the newly modeled interfaces 
    in ``docs/nextgen-toolkit/reference/hwm.rst`` (See :ref:`contrib-guide-docs-intro`).


.. _contrib-guide-hwm-includes:

Including HWM in |uobjs| and |uobjrtl|
--------------------------------------

The ``#include`` directive for the HWM is as follows: 
``#include <uberspark/hwm/<HWMTYPE>/<HWMTYPETREEPATH>/include/hwm.h>.`` |br|

Where <HWMTYPE> and <HWMTYPETREEPATH> are as decribed in :ref:`contrib-guide-hwm-hdrcontents`

The HWM is modular yet layered, so if including the 
``hwm/cpu/x86/32-bit/core-gen1`` model, you will also include the 
``hwm/cpu/x86/32-bit/generic`` model automatically.
