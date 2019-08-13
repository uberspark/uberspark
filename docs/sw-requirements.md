---
layout: page
tocref: uberSpark (Composable Verification of Commodity System Software) Documentation
title: Software Requirements and Dependencies
---

We assume your are working in: `/home/<home-dir>/<work-dir>`

Replace `<home-dir>` with your home-directory name and `<work-dir>` with 
any working directory of your choice.

* Ubuntu 16.04.x LTS 64-bit (VM or Windows WSL) for development and verification 
(VM ISO available [here](http://releases.ubuntu.com/16.04/ubuntu-16.04.6-desktop-amd64.iso)):
You will need to install the following packages after doing an update:
{% highlight bash %}
sudo apt-get update
sudo apt-get install git gcc binutils autoconf
sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0 gcc-multilib
sudo apt-get install ocaml ocaml-findlib ocaml-native-compilers
sudo apt-get install graphviz libzarith-ocaml-dev libfindlib-ocaml-dev
sudo apt-get install make unzip
{% endhighlight %}

* OPAM (OCaml Package Manager)
{% highlight bash %}
wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin
eval `opam config env`
opam switch 4.02.3
{% endhighlight %}

* Menhir Parser (20170712)
{% highlight bash %}
opam install menhir.20170712
{% endhighlight %}

* ocamlgraph (1.8.7)
{% highlight bash %}
opam install ocamlgraph.1.8.7
{% endhighlight %}

* ocamlfind (1.7.3) 
{% highlight bash %}
opam install ocamlfind.1.7.3
{% endhighlight %}

* coq proof assistant (8.6.1)
{% highlight bash %}
opam install coq.8.6.1
{% endhighlight %}

* zarith
{% highlight bash %}
opam install zarith
{% endhighlight %}

* yojson
{% highlight bash %}
opam install yojson
{% endhighlight %}

* Compcert (3.0.1)
{% highlight bash %}
wget http://compcert.inria.fr/release/compcert-3.1.tgz
tar -xvzf compcert-3.1.tgz
cd CompCert-3.1
./configure x86_32-linux
make all
sudo make install
cd ..
{% endhighlight %}

* Frama-C (version Phosphorus-20170501)
{% highlight bash %}
wget http://frama-c.com/download/frama-c-Phosphorus-20170501.tar.gz
tar -xvzf frama-c-Phosphorus-20170501.tar.gz
cd frama-c-Phosphorus-20170501
./configure
make
sudo make install
cd ..
{% endhighlight %}

* Install CVC3, Alt-Ergo and Z3 as backend theorem provers. The WP Frama-C plugin 
manual (available [here](http://frama-c.com/download/wp-manual-Phosphorus-20170501.pdf)) 
contains a chapter on installing the theorem provers. Note that you will need to 
install the correct versions of Why3 and the provers as described in the 
aforementioned Frama-C WP plugin manual (e.g., Why3 0.87.3 and 
Alt-ergo 1.30). This can be done via opam (e.g., `opam install why3.0.87.3`).

<br>
<hr>
