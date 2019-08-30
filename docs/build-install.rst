Building and Installing uberSpark
=================================

Building uberSpark Tools
------------------------

You will need to build the uberSpark toolchain before any other tasks.
For this purpose, While in the top-level directory of the uberSpark repository,
switch directory to uberSpark sources:

::

    cd src


Then prepare for the build as below:


::

    ./bsconfigure.sh
    ./configure


And finally, build the toolchain:


::

    make



Installing uberSpark
--------------------

Upon a successful build, you will need to install the uberSpark toolchain, 
system headers and hardware-model related files. You can do this using the
following command (while in the same directory of uberSpark sources ``src/``):

::

    sudo make install

