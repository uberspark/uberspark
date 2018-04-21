# UberSpark: Enforcing Verifiable Object Abstractions for Automated Compositional Security Analysis of a Hypervisor



## Introduction
UberSpark (uSpark) is an innovative architecture for
compositional verification of security properties of extensible
hypervisors written in C and Assembly.

uSpark comprises two key ideas: 
(i) endowing low-level system software with abstractions found 
in higher-level languages (e.g., objects,
interfaces, function-call semantics for implementations of
interfaces, access control on interfaces, concurrency and
serialization), enforced using a combination of commodity
hardware mechanisms and light-weight static analysis; and
(ii) interfacing with platform hardware by programming
in Assembly using an idiomatic style (called CASM) that is
verifiable via tools aimed at C, while retaining its performance
and low-level access to hardware.

After verification, the C code is compiled using a
certified compiler while the CASM code is translated into its
corresponding Assembly instructions.
Collectively, these innovations
enable compositional verification of security invariants without
sacrificing performance.

We validate uSpark by building and verifying security invariants of an 
existing open-source commodity x86 micro-hypervisor, XMHF (available [here](http://xmhf.org))
and several of its extensions, and demonstrating only minor
performance overhead with low verification costs.



## Contact and Maintainer
Amit Vasudevan (amitvasudevan@acm.org)



## Related Publications

* UberSpark: Enforcing Verifiable Object Abstractions for Automated Compositional Security Analysis of a Hypervisor. Amit Vasudevan, Sagar Chaki, Petros Maniatis, Limin Jia, Anupam Datta. USENIX Security Symposium, 2016. [[pdf](http://hypcode.org/paper-uberspark-xmhf-USENIXSEC-2016.pdf)]

* UberSpark: Enforcing Verifiable Object Abstractions for Automated Compositional Security Analysis of a Hypervisor. Amit Vasudevan, Sagar Chaki, Petros Maniatis, Limin Jia, Anupam Datta. CMU CyLab Technical Report CMU-CyLab-16-003. June 2016. [[pdf](http://hypcode.org/tr_CMUCyLab16003.pdf)]


## Software Requirements and Dependencies

For the remainder of this section we assume your are working in: `/home/<home-dir>/<work-dir>`

Replace `<home-dir>` with your home-directory name and `<work-dir>` with any working directory 
you choose.


1.	Ubuntu 14.04.2 LTS 64-bit for development and verification (available [here](http://old-releases.ubuntu.com/releases/14.04.2/ubuntu-14.04.2-desktop-amd64.iso)).
   	You will need to install the following packages after doing an update:
   	
   	`sudo apt-get update`

   	`sudo apt-get install git gcc binutils autoconf` 

   	`sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0 gcc-multilib`

	`sudo apt-get install ocaml ocaml-findlib ocaml-native-compilers`

	`sudo apt-get install graphviz libzarith-ocaml-dev libfindlib-ocaml-dev`


2.	OPAM (OCaml Package Manager)

	`wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin`

	`` eval `opam config env` ``
		
	`opam switch 4.02.3`


3.	Menhir Parser (20170712), ocamlgraph (1.8.7), ocamlfind (1.7.3) and coq (8.6.1)

	`opam install menhir`

	`opam install ocamlgraph`

	`opam install ocamlfind`
	
	`opam install coq`


4.	Compcert (3.0.1)

	`wget http://compcert.inria.fr/release/compcert-3.1.tgz`

	`tar -xvzf compcert-3.1.tgz`

	`cd CompCert-3.1`

	`./configure x86_32-linux`

	`make all`

	`sudo make install`

	`cd ..`


5.	Frama-C (version Phosphorus-20170501)

	`wget http://frama-c.com/download/frama-c-Phosphorus-20170501.tar.gz`

	`tar -xvzf frama-c-Phosphorus-20170501.tar.gz`

	`cd frama-c-Phosphorus-20170501`

	`./configure`

	`make`

	`sudo make install`

	`cd ..`
	
 	You must also install CVC3, Alt-Ergo and Z3 as backend theorem provers. The WP Frama-C plugin manual
 	(available [here](http://frama-c.com/download/wp-manual-Phosphorus-20170501.pdf)) contains a chapter on
 	installing the theorem provers.


## Building and Installing UberSpark

Execute the following, in order, while in the top-level 
directory of the UberSpark 
source-tree (where this README.md resides):

1.	Switch directory to UberSpark sources
   
	`cd uberspark`


2.	Prepare for build
   
	`./bsconfigure.sh`
   
	`./configure`
      
      
3.  Build UberSpark sources

	`make`


4.  Install UberSpark binaries

	`sudo make install`



## Verifying, Building and Installing UberSpark Libraries

Execute the following, in order, while in the top-level 
directory of the UberSpark 
source-tree (where this README.md resides):

1.	Switch directory to UberSpark libraries sources
   
	`cd uberspark/libs`


2.	Prepare for build
   
	`./bsconfigure.sh`
   
	`./configure`


3.  Verify UberSpark libraries 

	`make verify-ubersparklibs`


4.  Build UberSpark libraries

	`make build-ubersparklibs`


5.  Install UberSpark libraries

	`sudo make install`




## Releases and Changelog

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


