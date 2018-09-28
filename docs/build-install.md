---
layout: page
tocref: uberSpark (Composable Verification of Commodity System Software) Documentation
title: Building and Installing
---

While in the top-level directory of the uberSpark source-tree, perform the
following tasks in order:

* Switch directory to UberSpark sources
{% highlight bash %}
cd uberspark
{% endhighlight %}

* Prepare for build
{% highlight bash %}
./bsconfigure.sh
./configure
{% endhighlight %}

* Build UberSpark sources
{% highlight bash %}
make
{% endhighlight %}

* Install UberSpark binaries
{% highlight bash %}
sudo make install
{% endhighlight %}


<br>
<hr>

