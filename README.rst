uberSpark: Composable Verification of Commodity System Software
===============================================================

Introduction
------------

uberSpark is an innovative system architecture and programming principle 
for compositional verification of security properties of 
commodity (extensible) system software written in C and Assembly.

uberSpark has been used to build and verify security invariants of 
the uber eXtensible Micro-Hypervisor Framework (<https://uberxmhf.org>)
and several of its extensions, and demonstrating only minor
performance overhead with low verification costs.

Visit: <https://uberspark.org> for more information on how to download, 
build, install, contribute and get involved.


Documentation
-------------

Documentation sources are within ``docs/`` in reStructuredText (reST)
format and can be browsed using a simple text editor (start at
``docs/index.rst``).

HTML version of the documentation can also be built locally using
``make clean`` followed by ``make docs_html`` within the ``docs/``
folder. Load the resulting ``docs/_build/index.html`` into a browser of
your choice.

Note that you will need a working installation of sphinx to build the
documentation within your development environment. For example, within
Ubuntu/Debian distributions the following will install sphinx:

``sudo apt install python3-pip``
``python3 -m pip install sphinx==2.2.0``
``python3 -m pip install sphinx-jsondomain==0.0.3``

The formatted documentation can be read online at:
http://docs.uberspark.org


## Contact and Maintainer
Amit Vasudevan (<http://hypcode.org>)


## Copying

The uberSpark project comprises multiple
open source licenses. See [COPYING.md](COPYING.md) for details.


