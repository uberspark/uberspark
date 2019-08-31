.. include:: macros.hrst

Software Requirements and Dependencies
======================================

We assume your are working in: ``/home/<home-dir>/<work-dir>``

Replace ``<home-dir>`` with your home-directory name and ``<work-dir>``
with any working directory of your choice.

Development OS and Base Packages
--------------------------------

You will need a working Ubuntu 16.04.x LTS 64-bit environment for development and 
verification. This can either be a Virtual Machine (VM) (e.g., VirtualBox) or a 
container (e.g., Windows WSL). As of this writing, the Ubuntu 16.04.x LTS VM ISO 
image is available at:

.. parsed-literal::

    http://releases.ubuntu.com/16.04/ubuntu-16.04.6-desktop-amd64.iso

You will need to first perform an ``update`` to download the latest package
lists from the repositories as shown below:

::

    sudo apt-get update

After the update completes, you will need to install the following base
packages required for development as shown below:

::

   sudo apt-get install git gcc binutils autoconf 
   sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0 gcc-multilib 
   sudo apt-get install ocaml ocaml-findlib ocaml-native-compilers 
   sudo apt-get install graphviz libzarith-ocaml-dev libfindlib-ocaml-dev 
   sudo apt-get install make unzip 


.. _swreqs_documentation:

Packages for Generating Documentation
-------------------------------------

Optionally, you will need to install Latex, Python and Sphinx in order to 
generate the documentation locally for |uspark|. More specifically, you will need 
to perform the following operations:

::

    sudo apt install python3 python3-pip 
    sudo apt install texlive-latex-recommended texlive-fonts-recommended 
    sudo apt install texlive-latex-extra latexmk
	pip3 install -U 'Sphinx==2.2.0'



OCaml Compiler and Base Packages
--------------------------------

You will then need to install the OCaml Package manager as shown below:

::

    wget https://raw.github.com/ocaml/opam/master/shell/opam\_installer.sh -O - \| sh -s /usr/local/bin


After the OCaml Package Manager installs successfully, configure the opam environment and switch to
the appropriate OCaml compiler version as shown below:

::

    eval ``opam config env`` 
    opam switch 4.02.3

After the opam environment switch, install the following opam packages in order:

::

    opam install menhir.20170712
    opam install ocamlgraph.1.8.7
    opam install ocamlfind.1.7.3
    opam install zarith
    opam install yojson 
 

Coq Proof Assistant 
-------------------

The Coq Proof Assistant is a required package for both CompCert as well as Frama-C. 
You need to install the Coq Proof Assistant via opam as shown below:

::

    opam install coq.8.6.1


CompCert Certified Compiler 
---------------------------

The CompCert compiler is used to compile the C code for verified uberobjects within 
|uspark|. The Compcert version currently supported is v3.0.1 and can be installed 
as shown below:

::

    wget http://compcert.inria.fr/release/compcert-3.1.tgz 
    tar -xvzf compcert-3.1.tgz 
    cd CompCert-3.1 
    ./configure x86_32-linux 
    make all
    sudo make install 
    cd ..


Frama-C Verification Framework 
------------------------------

The Frama-C verification framework is used to discharge uberobject invariants and
properties within |uspark|. The Frama-C version currently supported is 
``Phosphorus-20170501`` and can be installed as shown below:

::

    wget http://frama-c.com/download/frama-c-Phosphorus-20170501.tar.gz 
    tar -xvzf frama-c-Phosphorus-20170501.tar.gz 
    cd frama-c-Phosphorus-20170501 
    ./configure 
    make 
    sudo make install 
    cd ..
   
You will also need to install Frama-C backend theorem provers such as
CVC3, Alt-Ergo and Z3. The WP Frama-C plugin manual referenced below
contains a chapter on installing the theorem provers:

.. parsed-literal::

    http://frama-c.com/download/wp-manual-Phosphorus-20170501.pdf

Note that you will need to install the correct versions of Why3 and the 
provers as described in the aforementioned Frama-C WP plugin manual.
For example,  Why3 version 0.87.3 and Alt-ergo version 1.30. This can be 
done via opam as shown below in the context of Why3:

::

    opam install why3.0.87.3


