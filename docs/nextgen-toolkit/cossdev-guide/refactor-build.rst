.. include:: /macros.rst

.. _cossdev-guide-refactor-build:

Refactor |coss| Build
=====================

The last step within refactoring a |coss| source code-base to use |uberspark| framework
capabilities, is to revise the existing |coss| source code build process to build the
|uobjcolls|.

In our running example, ``hello-mul`` |coss| source code-base uses the ``GNU Makefile`` build 
harness to build an executable. Below is the listing of the original ``hello-mul`` ``Makefile``:

.. literalinclude:: /../src-nextgen/coss-examples/hello-mul/coss-src/Makefile
   :language: bash
   :linenos:


We revise this ``Makefile`` to now use the |uberspark| front-end command line tool in order to
build the ``hello-mull`` |uobjcoll|. The revised ``Makefile`` is shown below:

.. literalinclude:: /../src-nextgen/coss-examples/hello-mul/ucoss-src/Makefile
   :language: bash
   :linenos:

As seen from the aforementioned listing, we amend the ``Makefile`` target ``all`` to first 
switch to the |uberspark| ``generic-platform`` staging that we created earlier. We then
use the staging command line interface in order to set our compiler, assembler and
linker bridges. Finally, we invoke the |uobjcoll| build command in order to build the ``hello-mul``
|uobjcoll|. 

Upon successful build, the ``hello-mul`` |uobjcoll| can be found within the ``uobjcoll/_build`` 
folder.

Similarly, we amend the ``Makefile`` ``clean`` target to remove the ``uobjcoll/_build`` folder, which
will cleanup all the |uobjcoll| build artifacts.

At this point the |coss| source-code base has been successfully integrated with |uberspark|. 
Development can now be continued on the ``hello-mull`` |uobjcoll| as before.

..  note::  This section is still a work-in-progress

..
    - link with uberspark |coss| library to get uberspark_loaduobjcoll resolved
    - link with uobjcoll library to get existing hello_world resolved correctly
    - prep install and/or package manager 
    - package installer should check for uberspark dependency on the platform and instruct user accordingly
