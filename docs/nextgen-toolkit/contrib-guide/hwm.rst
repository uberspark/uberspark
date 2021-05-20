.. include:: /macros.rst


.. _contrib-guide-hwm-intro:

|uspark| Hardware Model
=================================

The |uberspark| Hardware Model (HWM) consists of various hardware component models such as the CPU, memory, I/O devices, and associated hardware-conduit end-points. 
These models interact with |uobjs| through the hardware |uobjrtl|, which exposes various hardware interfaces.
The following sections describe how you can model and add a new hardware component to the HWM.

..  seealso::   :ref:`überSpark üobject HW Runtime Library Reference<uobjrtl-hw>` for a description of the associated hardware |uobj| runtime library and 
                associated function documentation.

..  seealso::   |reference-hwm-ref| for a description of currently modeled hardware and associated functions.


.. _contrib-guide-hwm-nsdirorg:

HWM Namespace and Directory Layout
----------------------------------

The HWM organization is split into various sub-models, each housing an architecture, device, or platform specific hardware model:

CPU is organized as hwm/cpu/<arch>/<addressing>/<cpumodel>
Here <arch> is the CPU instruction architecture (x86, ARM, RISC-V),
<adressing> is the addressing mode (32-bit/64-bit) and <cpumodel> is the
model of the CPU (e.g. AMD-Opteron, intelcore-genx). This scheme allows us
to target a specific CPU architecture along with architecture customization
and micro-architectural details with <cpumodel>


``arch``
    various supported architecture and CPU specific instruction level hardware modeling,    
    including a general device interface abstraction to integrate device level modeling
    
    ``cpu-arch``
    where cpu-arch is the name of the processor architecture and revision/qualifier (e.g., armv8_32, x86, x86_32)
    
        ``cpu-type``
        where cpu-type is the processor type specific (e.g., generic, cortex_a53, intel, amd)

``device``
    various supported devices and their internal state modeling (e.g., what the device does 
    in response to a particular input). interacts with ``arch`` via a general device interface abstraction

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

``platform``
    device agnostic platform-level modeling. e.g., for pc platform BIOS and option 
    ROM functionality.

    ``pc``
    PC computing platform contains namespace development recipe (e.g., pc, pc_32)

Examples:
 A 32-bit Intel TXT hardware model would go in ``arch/x86_32/intel/``. |br|
 An intel e1000 hardware model would go in ``device/net/ethernet/intel/e1000/``. |br|
 Intel vt-d would go in ``device/iommu/intel/``. |br|
 The PC BIOS hardware model would fit into ``platform/pc/``. |br|

The HWM directory itself is split into a ``src`` and ``include`` folder, both following the namespace organization above.


.. _contrib-guide-hwm-hdrcontents:

HWM Source Header-file Details
------------------------------

An HWM source model header should be placed in ``hwm/include/{model-path-specification}``.
The header filename should always end with a ``.h`` suffix.

The header file contents should be embedded within the following prologue and
epilogue:


.. code-block:: c

    #ifndef __HWM_<HWMMODPATH>__<FILENAME>_H__
    #define __HWM_<HWMMODPATH>__<FILENAME>_H__


    #endif /* __HWM_<HWMMODPATH>__<FILENAME>_H__ */


Here ``<HWMMODPATH>`` is the path specification (delimited by ``_``) of the header file (sans the filename),
and ``<FILENAME>`` is the name of the file (sans the ``.h``). For example, for ``cpu.h`` within the ``include/arch/x86/generic/``
namespace, the prologue and epilogue are as shown below:

.. code-block:: c

    #ifndef __HWM_ARCH_X86_GENERIC__CPU_H__
    #define __HWM_ARCH_X86_GENERIC__CPU_H__

    #endif /* __HWM_ARCH_X86_GENERIC__CPU_H__ */


An HWM header file can prevent contents from being available to Assembly language source models via
the following construct:

.. code-block:: c

    #ifndef __ASSEMBLY__

    #end /* __ASSEMBLY__ */


An HWM source header file must include declarations for all the functions that are described by the corresponding collection of source files, when applicable
(a source file implementation is not always required, i.e. if the model only defines structs and definitions).
 
..  note::  Every model namespace should also contain an ``hwm.h`` header file, see :ref:`contrib-guide-hwm-hwmhdrcontents`


.. _contrib-guide-hwm-hwmhdrcontents:

HWM Model Header-file Details
-----------------------------

Each model folder should contain an ``hwm.h`` header-file that ``#include`` s all the other source header-files from that namespace.

In addition, the ``hwm.h`` should layer includes from more general, yet related, model namespaces. For instance, the ``arch/x86_32/intel/hwm.h`` should include
``arch/x86/intel/hwm.h``, while ``arch/x86/intel/hwm.h`` should include ``arch/x86/generic/hwm.h``.

The ``hwm.h`` can also contain other specific structs and definitions that are shared by that entire model.


.. _contrib-guide-hwm-srccontents:

HWM Source-file Details
-----------------------

An HWM model source file should be placed in ``hwm/src/{model-path-specification}``.

CASM interfaces should be prefixed with ``_impl__casm__``. |br|
CASM functions exposed for |uobjs| should be prefixed with ``__casm__``. |br|
Interfaces should be prefixed with ``_impl_hwm``. |br|
Functions exposed for |uobjs| and |uobjrtl| should be prefixed with ``hwm_``. |br|

Source files can also ``#include`` necessary headers (i.e. ``<uberspark/include/uberspark.h>``)


.. _contrib-guide-hwm-addhwm:

Adding a new model to the HWM
-----------------------------

1.  Choose a namespace: ``uberspark/hwm/<MODELPATH>`` where ``MODELPATH`` is the path that best specifies 
    the new hardware model as described in :ref:`contrib-guide-hwm-nsdirorg`.

2.  Create the necessary directories.

3.  Add HWM source modules, source headers, and model headers following content rules as described in :ref:`contrib-guide-hwm-hdrcontents`,
    :ref:`contrib-guide-hwm-hwmhdrcontents`, and :ref:`contrib-guide-hwm-srccontents`.

4.  Add reference documentation for the newly modeled interfaces in ``docs/nextgen-toolkit/reference/hwm.rst`` (See :ref:`contrib-guide-docs-intro`).


.. _contrib-guide-hwm-includes:

Including HWM in |uobjs| and |uobjrtl|
--------------------------------------

The ``#include`` directive for the HWM is as follows: ``#include <uberspark/hwm/include/{model-path-specification}/hwm.h>.`` |br|
The HWM is modular yet layered, so if including the ``arch/x86_32/intel`` model, you will also include the ``arch/x86/generic`` 
and ``arch/x86/intel`` models. 
