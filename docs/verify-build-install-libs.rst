Verifying, Building and Installing uberSpark Libraries
======================================================

The uberSpark core libraries provide commonly used runtime functionality
for a uberobject. The core libraries current comprise a tiny C runtime 
library, a fledging crypto library (currently SHA-1 supported) and a 
library for platform hardware access. 

This section of the documentation will describe how you 
can verify, build and install the aforementioned libraries. For the
subsections that follow, you need to be in the top-level of the
uberSpark source repository.


Verifying uberSpark Libraries
-----------------------------

To verify the uberSpark libraries first switch to the uberSpark 
library sources:

::

   cd src/libs

Then prepare for verification and subsequent build:

::

    ./bsconfigure.sh
    ./configure


And, finally verify the libraries using:

::

    make verify-ubersparklibs


Note: The verification typically takes a few minutes to complete and should finally 
terminate with a success message.


Building uberSpark Libraries
----------------------------

uberSpark uobject runtime libraries are built using the certified CompCert compiler
in combination with uberSpark tools (to handle Assembly as CASM). To build the 
uberSpark libraries you need to use the following command:

::

   make build-ubersparklibs 
   

Installing uberSpark Libraries
------------------------------

uberSpark libraries are installed to the development system using the following
command:

::

    sudo make install


Note: The libraries are installed to the default location ``/usr/local/uberspark`` but can
be over-ridden by the ``--prefix`` option during configuration using the ``configure``
utility.

