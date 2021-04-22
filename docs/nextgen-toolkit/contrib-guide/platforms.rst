.. include:: /macros.rst


.. _contrib-guide-platform-intro:

|uspark| Platforms
==================

There can be multiple platforms housed within a compute *board*. Thus, a compute board is 
essentially a substrate for |chic| platforms interconnected both within a board (e.g., 
monitoring, AI, compute) and across physical 
boards (e.g., beagleboard, intel motherboard etc.). A |chic| system is then a collection
of such |chic| platforms, spanning multiple boards.

A platform namespace is composed of: a ``uberspark/platforms/`` prefix,
followed by a board name, CPU architecture, and CPU triad.
For example, ``uberspark/platforms/generic/x86/32-bit/generic`` refers to a platform 
that does not depend on
any particular board or CPU but is specific only to the `x86/32-bit` architecture. 
Of course |uobjcolls| developed for such as platform can only include functionality that
falls within the `x86/32-bit` architecture specification.


|uspark| Platform Definition
----------------------------

Platforms are defined via a ``uberspark.json`` manifest file which include appropriate
platform definition nodes that allow specifying the platform CPU architecture
and type, memory and devices, in addition to specifying platform default compiler,
linker, assembler, and associated configuration options.

..  seealso::  |reference-manifest-ref|:::ref:`reference-manifest-uberspark-platform` 
                for detailed 
                information on various platform manifest definition JSON nodes and 
                their description.


..  code-block:: bash    

    .
    ├── baremetal
    │   └── x86_32
    │       └── grub-legacy
    │           └── debug
    └── os
        └── linux
            ├── backends
            ├── common
            ├── kmode
            └── umode


Uncategorized Notes
-------------------

platform configuration rules:

- devices and cpus are independent and can be part of multiple platforms

connection to hardware model:

``uberspark.json`` - CPU and devices we specify here should have a hardware model
equivalent within ``hwm/`` folder and library interface in ``uobjrtl/hw``.


