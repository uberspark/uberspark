.. include:: /macros.rst

.. _cossdev-guide-prepnamespace:

Prepare |coss| Namespace and Staging
====================================

Before paring-away desired |coss| functionality into |uobjs| and |uobjcolls|, we 
need to prepare the |coss| namespace and switch to a relevant |uberspark| staging.

We use our running example of ``hello-mul`` |coss| application with sources residing
within the ``coss-examples/hello-mul/coss-src`` folder.

As a first step, create a top-level folder to house the ``hello-mul`` |uobjcoll|.
We will use ``ucoss-src`` within the existing ``hello-mul`` source root. i.e., the
new folder where we will house the refactored ``hello-mul`` |uobjcoll| will be:

``coss-examples/hello-mul/ucoss-src``

Within the aforementioned folder, let us create another folder called ``main`` to house
our only |uobj| within the new ``hello-mul`` |uobjcoll|. i.e., the
new folder where we will house the the ``main`` |uobj| for the ``hello-mul`` |uobjcoll| will be:

``coss-examples/hello-mul/ucoss-src/main``

..  note::  In our example, we choose to create a single |uobj|. In principle, one can
            create multiple |uobjs| depending on |coss| code-base modules and functionality
            that is being pared-away into into a |uobjcoll|

At this point, you are ready to select a relevant staging for the ``hello-ml`` |uobjcoll|. 
This can be done using the :ref:`genuser-guide-intro` as shown below:

.. highlight:: bash

::

    uberspark 