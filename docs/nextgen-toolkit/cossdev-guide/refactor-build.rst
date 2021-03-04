.. include:: /macros.rst

.. _cossdev-guide-refactor-build:

Refactor |coss| Build
=====================

The last step within refactoring a |coss| source code-base to use |uberspark| framework
capabilities, is to revise the existing |coss| source code build process to build the
|uobjcoll|.

In our running example, ``hello_mul`` |coss| source code-base uses the ``GNU Makefile`` build 
harness to build an executable. Below is the listing of the original ``hello_mul`` ``Makefile``:

.. literalinclude:: /../src-nextgen/coss-examples/hello_mul/coss_src/Makefile
   :language: bash
   :linenos:


We revise this ``Makefile`` to now use the |uberspark| front-end command line tool in order to
build the ``hello_mul`` |uobjcoll|. The revised ``Makefile`` is shown below:

.. literalinclude:: /../src-nextgen/coss-examples/hello_mul/ucoss_src/Makefile
   :language: bash
   :linenos:

As seen from the aforementioned listing, we amend the ``Makefile`` target ``all`` to first 
switch to the |uberspark| ``generic-platform`` staging that we created earlier.
Finally, we invoke the |uobjcoll| build command in order to build the ``hello_mul``
|uobjcoll|. 

Similarly, we amend the ``Makefile`` ``clean`` target to remove the ``uobjcoll/_build`` folder, which
will cleanup all the |uobjcoll| build artifacts.

At this point the ``hello_mul`` |coss| source-code base has been successfully integrated with |uberspark| with
the creation of the ``hello_mul`` |uobjcoll|. 
Development can now be continued on the ``hello_mull`` |uobjcoll| from this point onwards.

The ``hello_mul`` |uobjcoll| can be built using the same sequence of ``make`` commands as before:


.. highlight:: bash

::

    make clean
    make


Upon successful build, the ``hello_mul`` |uobjcoll| binary can be found within the ``uobjcoll/_build`` 
folder.


..
    - link with uberspark |coss| library to get uberspark_loaduobjcoll resolved
    - link with uobjcoll library to get existing hello_world resolved correctly
    - prep install and/or package manager 
    - package installer should check for uberspark dependency on the platform and instruct user accordingly
    - describe legacy code build system bridge when we have that ready