.. include:: /macros.rst

.. _genuser-guide-install:


Building and Installing |uspark|
=================================

Building |uspark| Tools
------------------------

You will need to build the |uspark| toolchain before performing any other
task.


.. note:: The |uspark| toolchain requires approximately 2.4 GB of disk space. Additionally, it is recommended to have configured at least 4GB-6GB of container memory.


	  
To achieve this, you need to issue the following command while in the
top-level directory of 
the |uspark| source-tree (the directory where the file RELEASE is located):


::

    make

This will generate the required build truss to build the toolkit and
documentation, build the toolkit binaries, and additionally build the
``.html`` version of the documentation.

.. note:: If you are re-building the tools after a prior build, you can
	  perform a cleanup by issuing the command: ``make clean`` before
	  issuing the command ``make`` as above.


.. note:: If you get a make warnings of the form 
          ``make: warning: Clock skew detected. Your build may be incomplete``, you may
          have to restart your docker daemon to ensure that time-clocks are synced between
          the host and the container. The build should still succeed even with this warning.
          


Building |uspark| Documentation in Other Formats
------------------------------------------------

You can (optionally) build documentation in the ``.pdf`` format.
To achieve this, you need to issue the following command while in the top-level directory of 
the |uspark| source-tree (the directory where the file RELEASE is located):


::

    make docs_pdf


.. _genuser-guide-install-installinguberspark:


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


.. note:: |uspark| is installed at ``~/uberspark`` by default and 
          toolkit binaries are installed by default at: ``/usr/bin`` system location. 
          Your user account must be part of the sudo'ers and you may need to enter your
          sudo password during this step.

.. note:: If you are using Windows Subsystem for Linux (WSL) as your development environment,
          you will need to issue ``make install ROOT_DIR=<NTFS volume path>`` instead of
          ``make install`` as above. For example,
          ``make install ROOT_DIR=/c/workspace/uberspark``; where ``/c/workspace/uberspark`` is
          where you would like |uspark| to be installed. This is due to the fact that
          docker is unable to mount host folders that are part of the WSL Linux filesystem (e.g., ``~/``) 
          under Windows.

.. note:: Insufficient container memory could manifest as an ``Error 137`` when building bridges. It is recommended to increase your container memory configuration if you experience these errors.
