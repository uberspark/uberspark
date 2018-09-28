# uberSpark: Composable Verification of Commodity System Software


## Introduction
uberSpark is an innovative system architecture and programming principle 
for compositional verification of security properties of 
commodity (extensible) system software written in C and Assembly.

uberSpark has been used to building and verifying security invariants of 
the uber eXtensible Micro-Hypervisor Framework (<http://uberxmhf.org>)
and several of its extensions, and demonstrating only minor
performance overhead with low verification costs.

Visit: <http://uberspark.org> for more information on how to download, 
build, install and get involved.

Read the documentation at `docs/toc.md`. The formatted documentation can 
also be read online at: <http://uberspark.org/docs/toc.html>


## Contact and Maintainer
Amit Vasudevan (amitvasudevan@acm.org)


## Contributing

uberSpark is always open to contributions. The easiest mechanism is probably to
fork the git repository through the web UI, make the changes on your fork, 
and then issue a pull request through the web UI.


## Copying

The uberSpark project comprises multiple
open source licenses. See [COPYING.md](COPYING.md) for details.


## Releases and Changelog

* Version 4.0 (Alpha Prime)
	* first stand-alone uberspark release

* Version 3.1 (Flak)
	* fixed uxmhf build errors

* Version 3.0 (Ratchet)
	* added support for Frama-C Phosphorus-20170501
	* added support for Compcert 3.0.1
	* fixed [issue #1](https://github.com/hypcode/uberspark/issues/1)
	* minor build harness fixes and documentation updates


* Version 2.0 (Blades)
	* separated uberspark, uberspark libraries and uxmhf verification/build processes
	* refined and streamlined uberspark and uxmhf verification/build harness
	* fixed minor errors in documentation and updates to reflect release changes


* Version 1.0 (Cliff Jumper)
	* initial academic prototype release


