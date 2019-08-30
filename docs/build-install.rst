.. include:: macros.hrst

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



Installing |uspark|
--------------------

Upon a successful build, you will need to install the |uspark| toolchain, 
system headers and hardware-model related files. You can do this using the
following command (while in the same directory of |uspark| sources ``src/``):

::

    sudo make install

