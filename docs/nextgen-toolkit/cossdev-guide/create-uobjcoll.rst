.. include:: /macros.rst

.. _cossdev-guide-create-uobjcoll:

Create a |uobjcoll|
===================

Creating a |uobjcoll| with desired |uobjs| is facilitated by creating 
a |uberspark| manifest file, |ubersparkmff|, within the top-level |uobjcoll| folder.

In our running example, the ``hello-mul`` |uobjcoll| top-level folder is:

``src-nextgen/coss-examples/hello-mul/coss-src/uobjcoll``

Within the aforementioned folder create the |ubersparkmf| file |ubersparkmff| with the
following contents:

.. literalinclude:: /../src-nextgen/coss-examples/hello-mul/ucoss-src/uobjcoll/uberspark.json
   :language: bash
   :linenos:

As seen from the aforementioned listing, a |uobjcoll| manifest consists of a manifest header
(defined using `uberspark-manifest` JSON node), which identifies the JSON as a |ubersparkmf|.
The manifest header also includes all the relevant manifest node types (`uberspark-uobjcoll` in our case) 
that are present within the manifest, in addition to specifying the minimum and maximum version of
|uberspark| that is required. See 
|reference-manifest-ref|:::ref:`reference-manifest-uberspark-manifesthdr` for further details on the manifest header and 
definitions.

The `uberspark-uobjcoll` manifest node declares a |uobjcoll|. At a high level the `uberspark-uobjcoll` node
declares the |uobjcoll| namespace, the platform, architecture and CPU requirements, various
|uobjs| that are part of the |uobjcoll|, |uobj| publicmethods that need to be exposed as |uobjcoll| publicmethods
for interaction with legacy |coss| code, in addition to other attributes. See 
|reference-manifest-ref|:::ref:`reference-manifest-uberspark-uobjcoll` for further details on the ``uberspark-uobjcoll``
manifest node and definitions.

The |uobjcoll| *namespace* in our example (`uberspark/ubjcoll/generic/hello-mul`) is composed of
two parts. 
A |uobjcoll| prefix that is always is required to start with `uberspark/uobjcoll`, followed by
a user-defined |uobjcoll| namespace suffix. We choose `generic/hello-mul` as our user-defined |uobjcoll| namespace suffix 
since ``hello-mul`` is architecture agnostic. 

Accordingly |uobjcoll| *platform*, *arch*, and *cpu* fields are set to ``generic``.

The *hpl* field within ``uberspark-uobjcoll`` JSON node specifies the hardware privilege level of
the |uobjcoll|. The currently supported values are ``any`` to signify the |uobjcoll| can execute under
any hardware privilege level.            

The *uobjs* node within the ``uberspark-uobjcoll`` manifest node, describes all the |uobjs| that are part of the
|uobjcoll|. The |uobjs| are categorized into *master* and *templars*. 

The *master* |uobj| is optional, and is a special |uobj| that performs execution environment initialization. We
will omit this for our example. A |uobjcoll| can have at most one *master* |uobj|.

The typical category of |uobjs| within a |uobjcoll| are *templar* |uobjs|. 
A |uobjcoll| can have multiple, comma seperated, *templar* |uobjs|.
See 
|reference-manifest-ref|:::ref:`reference-manifest-uberspark-uobjcoll` for further details.

In our running example, we specify the ``main`` |uobj| of
``hello-mul`` in terms of its canonical namespace (e.g., ``uberspark/uobjcoll/generic/hello-mul/main``) within
the *uobjs* node.

Finally, |uobjcoll| *publicmethods* declare the externally visible interfaces of the |uobjcoll| from the
perspective of legacy |coss| code. 
In our example, we lift the ``main`` function of the ``main`` |uobj| to have such an external visibility.

Every |uobjcoll| *publicmethods* declaration also includes a comma seperated list of ``sentinels``, which are
essentially gateways into the |uobjcoll| from legacy code. In our case, we use the ``call`` sentinel to specify
this gateway as a regular branch/call instruction.

The same is true for the *sentinels-intrauobjcoll* field within ``uberspark-uobjcoll`` JSON node 
that describes the gateway type for |uobj| to |uobj| invocations within a |uobjcoll|. We use the ``call`` sentinel
to specify this gateway as a regular branch/call instruction.

..  note::  There can be multiple types of sentinel implementations in principle and the sentinel types for
            *sentinels-intrauobjcoll* can be different from that of the *publicmethods*.
            Presently only the ``call`` sentinel is supported.

.. 
    - describe collection
    - describe uobjcollection manifest example; take it from test uobj
    - talk about public method and sentinel
    - also talk about interobjcoll and legacy calls
    - select load address within address space
    - specify loader

