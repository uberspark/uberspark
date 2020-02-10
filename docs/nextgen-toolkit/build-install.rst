.. include:: ../macros.rst

Building and Installing |uspark|
=================================

Building |uspark| Tools
------------------------

You will need to build the |uspark| toolchain before performing any other task.
To achieve this, you need to issue the following command while in the top-level directory of 
the |uspark| source-tree (the directory where the file RELEASE is located):


::

    make

This will generate the required build truss to build the toolkit and documentation, 
build the toolkit binaries, and additionally build the ``.html`` version of the documentation.

.. note:: If you are re-building the tools after a prior build, you can perform a cleanup by
          issuing the command: ``make clean`` before issuing the 
          command ``make`` as above.


Building |uspark| Documentation in Other Formats
------------------------------------------------

You can (optionally) build documentation in the ``.pdf`` format.
To achieve this, you need to issue the following command while in the top-level directory of 
the |uspark| source-tree (the directory where the file RELEASE is located):


::

    make docs_pdf



Installing |uspark|
--------------------

Upon a successful build, you will need to install the |uspark| toolkit
comprising various components such as binaries, system headers, hardware
model etc.

You can do this using the following command,
while in the top-level directory of 
the |uspark| source-tree (the directory where the file RELEASE is located):

::

    make install


.. note:: |uspark| toolkit binaries are installed by default at: ``/usr/bin`` system location. 
          Your user account must be part of the sudo'ers and you may need to enter your
          sudo password during this step.
