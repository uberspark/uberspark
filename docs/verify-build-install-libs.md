---
layout: page
tocref: uberSpark (Composable Verification of Commodity System Software) Documentation
title: Verifying, Building and Installing uberSpark Libraries
---

Verifying, Building and Installing uberSpark Libraries
======================================================

While in the top-level directory of the uberSpark source-tree, perform the
following tasks in order:

* Switch directory to UberSpark libraries sources
{% highlight bash %}
cd src/libs
{% endhighlight %}

* Prepare for build
{% highlight bash %}
./bsconfigure.sh
./configure
{% endhighlight %}

* Verify UberSpark libraries
{% highlight bash %}
make verify-ubersparklibs
{% endhighlight %}

* Build UberSpark libraries
{% highlight bash %}
make build-ubersparklibs
{% endhighlight %}

* Install UberSpark libraries
{% highlight bash %}
sudo make install
{% endhighlight %}

<br>
<hr>