.. include:: /macros.rst

.. _cossdev-guide-prepnamespace:

Prepare |coss| Namespace and Staging
====================================

Before paring-away desired |coss| functionality into |uobjs| and |uobjcolls|, we 
need to prepare the |coss| namespace and switch to a relevant |uberspark| staging.

We use our running example of ``hello-mul`` |coss| application with sources residing
within the ``coss-examples/hello-mul/coss-src`` folder.

As a first step, create a top-level folder to house the ``hello-mul`` |uobjcoll|.
We will use ``ucoss-src`` within the existing ``hello-mul`` source root. i.e., the
new folder where we will house the refactored ``hello-mul`` |uobjcoll| will be:

``coss-examples/hello-mul/ucoss-src``

Within the aforementioned folder, let us create another folder called ``main`` to house
our only |uobj| within the new ``hello-mul`` |uobjcoll|. i.e., the
new folder where we will house the the ``main`` |uobj| for the ``hello-mul`` |uobjcoll| will be:

``coss-examples/hello-mul/ucoss-src/main``

..  note::  In our example, we choose to create a single |uobj|. In principle, one can
            create multiple |uobjs| depending on |coss| code-base modules and functionality
            that is being pared-away into into a |uobjcoll|

At this point, you are ready to create a relevant staging for the ``hello-ml`` |uobjcoll|. 
|uberspark| staging environments are essentially development workspaces that target a given hardware platform
with associated CPU(s) and devices. Staging environments also provide configurable settings for 
the build tools related to the |coss| development such as compilers, assemblers, linkers and verification tools.

|uberspark| staging environments can be created using the :ref:`frontend-cli-intro` as shown below:

.. highlight:: bash

::

    uberspark staging create generic-platform --root-dir=~/uberspark


With the aforementioned command, we create (and automatically switch to) a staging 
named ``generic-platform`` that supports development on a generic hardware platform. 


We then configure the compiler, assembler and linker that ``hello-mul`` requires. 


.. highlight:: bash

::

    uberspark staging config-set --setting-name=bridge_cc_bridge --setting-value=container/amd64/x86_32/generic/gcc/v5.4.0 --root-dir=~/uberspark
    uberspark staging config-set --setting-name=bridge_as_bridge --setting-value=container/amd64/x86_32/generic/gnu-as/v2.26.1 --root-dir=~/uberspark
    uberspark staging config-set --setting-name=bridge_ld_bridge --setting-value=container/amd64/x86_32/generic/gnu-ld/v2.26.1 --root-dir=~/uberspark


The aforementioned commands will set the staging compiler bridge to use GCC v5.4.0, assembler bridge to use 
GNU Assembler v2.26.1, and the linker bridge to use GNU ld v2.26.1


..  note::  Here ``--root-dir`` is pointed to ``~/uberspark``, the typical installation 
            location of the framework. However, if you use Windows/WSL as your development
            environment, you will need to 
            adjust the path accordingly as described within  
            |genuser-guide-ref|:::ref:`genuser-guide-install-installinguberspark`

..  note::  You can also omit the ``--root-dir`` argument altogether if uberspark is installed to 
            the default location (``~/uberspark``) within your development environment.
