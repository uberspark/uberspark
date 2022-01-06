.. include:: /macros.rst

Building and Installing |uspark|
=================================

Building |uspark| Tools
------------------------

You will need to build the |uspark| toolchain before any other tasks.
For this purpose, While in the top-level directory of the |uspark| repository,
switch directory to |uspark| sources:

::

    cd src


Then prepare for the build as below:


::

    ./bsconfigure.sh
    ./configure


And finally, build the toolchain:


::

    make


Building |uspark| Documentation
-------------------------------

You can (optionally) build this documentation locally. 
For this purpose, While in the top-level directory of the |uspark| repository,
switch directory to |uspark| sources:

::

    cd src


Now, build the `.pdf` documentation using the following command:

::

    make docs_pdf

Upon a successful build, the generated `.pdf` of the documentation can be 
found at ``docs/_build/uberspark_documentation.pdf``,
relative to the top-level directory of the |uspark| repository.

.. note:: For ``make docs_pdf`` to work successfuly, you will need to install the 
          packages required for generating documents locally as described 
          in :ref:`swreqs_documentation`.


You can also build the `.html` version of the document using the following command:

::

    make docs_html

In this case, upon a successful build, the generated `.html` documentation can be 
found at ``docs/_build/index.html``,
relative to the top-level directory of the |uspark| repository.


Installing |uspark|
--------------------

Upon a successful build, you will need to install the |uspark| toolchain, 
system headers and hardware-model related files. You can do this using the
following command (while in the same directory of |uspark| sources ``src/``):

::

    sudo make install

