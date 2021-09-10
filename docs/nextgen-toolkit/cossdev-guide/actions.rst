.. include:: /macros.rst

.. _cossdev-guide-actions:

|uspark| Manifest Actions
=========================

Manifest actions are a generic abstraction that allows specifying an extensible set of operations for
a given |uspark| manifest. 

Action Targets
--------------

Actions can be applied towards (and executed for) one or more targets as below:

    * `build` - |uobjcoll| binary generation
    * `verify` - |uobjcoll| verification
    * `docs` - |uobjcoll| documentation generation
    * `install` - |uobjcoll| installation operation

A single action can apply to one or more targets. For example, an action that specifies both
`build` and `verify` targets will be executed during both |uobjcoll| build and verify operations.

Action Categories
-----------------

Actions fall into one of the following broad categories:

    *   `translation` - this category is for any form of translation from a set of input files to a set of output files
        Translations can be compilation, linking, code generation or verification. Note that for certain translation
        actions, the set of output files can be the same as the set of input files (e.g., for verification)

    *   `uobj_action` - this category is to bring in actions from a set of |uobjs|. This action will be replaced by the
        target set of actions that this action selects. 

    *   `uobjrtl_action` - this category is to bring in actions from a set of |uobjrtl|. This action will be replaced by the
        target set of actions that this action selects. 

    *   `loader_action` - this category is to bring in actions from a set of loaders. This action will be replaced by the
        target set of actions that this action selects. 

    *   `default_action` - this category is to bring in the default set of actions for a |uobj| or a |uobjcoll|. This action will be replaced by the
        target set of default actions. 


Specifying Actions
------------------

Actions are specified within the |ubersparkmf| file |ubersparkmff| via the ``uberspark.manifest.actions`` 
JSON node. The following is an example action node specification for a build action that achieves source .c file compilation 
within a |uobj| manifest:

.. code-block:: json
   :linenos:

   {
    	"uberspark.manifest.actions" : [
            {
                "targets" : [ "build" ],
                "name" : "user specified action name",
                "category" : "translation",
                "input" : [".c"],
                "output" : [".o"],
                "bridge_namespace" : "compiler bridge namespace",
            }
        ]
   }

Below is another example action node specification for a verify action that achieves source .c file verification 
within a |uobj| manifest:

.. code-block:: json
   :linenos:

   {
    	"uberspark.manifest.actions" : [
            {
                "targets" : [ "verify" ],
                "name" : "user specified action name",
                "category" : "translation",
                "input" : ["sample.c"],
                "output" : ["sample.c"],
                "bridge_namespace" : "verification bridge namespace",
                "bridge_cmd" : "verification bridge command"
            }
        ]
   }

Action node specifications can also be definied for simple source to source translation on the |uobj|
sources within a |uobj| manifest:

.. code-block:: json
   :linenos:

   {
    	"uberspark.manifest.actions" : [
            {
                "targets" : [ "verify" ],
                "name" : "source to source translation",
                "category" : "translation",
                "input" : [".cS"],
                "output" : [".c"],
                "bridge_namespace" : "native",
                "bridge_cmd" : [
                    "cp *.cS *.c"
                ]
                
            }
        ]
   }


Yet another example action node specification for a verify action that achieves basic uberspark invariant checks 
on the |uobj| sources within a |uobj| manifest:

.. code-block:: json
   :linenos:

   {
    	"uberspark.manifest.actions" : [
            {
                "targets" : [ "verify" ],
                "name" : "uberSpark invariant checks",
                "category" : "translation",
                "input" : [".c"],
                "output" : [".c"],
                "bridge_namespace" : "uberSpark verification bridge namespace"
            }
        ]
   }

Finally, here is the action node spefication which brings in all the uobj actions in 
sequence into a |uobjcoll| manifest action node:

.. code-block:: json
   :linenos:

   {
    	"uberspark.manifest.actions" : [
            {
                "targets" : [ "build", "verify", "docs", "install" ],
                "name" : "uobjaction specification",
                "category" : "uobjaction",
                "uobj_namespace" : "uobjnamespace"
            }
        ]
   }

The above means that for any of the targets, bring in the uobj actions of the specified target in place of this action in the sequence specified 
within the |uobj| manifest. 

The action node spefication for including default actions into a |ubersparkmf| is
as below:

.. code-block:: json
   :linenos:

   {
    	"uberspark.manifest.actions" : [
            {
                "targets" : [ "build", "verify", "docs", "install" ],
                "name" : "default actions",
                "category" : "default"
            }
        ]
   }

The above will replace this action node with a list of default actions for a given
|uspark| manifest type (e.g., |uobj|, |uobjcoll|, |uobjrtl| etc.)


The above action pipeline allows us to do the following things:

    *   If the actions are empty, we autofill them with the default actions
    *   If actions contain some user-defined values, the user can inject the default actions at any point
    *   The actions contain a fully user-defined set of values

In any of the above situtations, we can have a sanity check that the uberspark invariant actions are always present in the action workflow.




..  note::  bridges specified within an action node specification is passed the standard bridge
            variables. The input files is overriden by the values constructed from the action input, and
            output files is overridden from values constructed using the action output.

..  note::  |uobj| and |uobjcoll| manifest specify sources and headers as a list of files with the 
            appropriate source extension. Then there are actions that basically go from translating the
            source extension into the target .c, .h, .o, and .exe extensions.
            

Actions input and output
------------------------

Sources can only be in .c or .cS. For example, 

.. code-block:: bash

    1.c
    2.c
    3.c
    4.cS
    5.cS
    6.c


Action input/output list can be a set of different input files resulting in
one of the outputs or multiple outputs; but outputs must always end
with either .c or .CS which is in the sources list. For example,

.. code-block:: bash

    input: 6.v, 7.v, 8.v, 9.v
    output: 6.c
    
    input: 45.s,42.s,43.s, 
    output: 5.cS

Action input/output can be wildcards in which case it selects a 
set from the sources and outputs files of that set into the extension specified.

.. code-block:: bash

    *.cS --> *.o
    *.cS --> *.cSs (see note below)


..  note::
    *.cSs is only used if we need to bundle all the assembly into one single
    file to be used by a certified assembler for example. The assembler bridge
    will then have the targets *.cSs --> *.o or *.cSs --> *.flat for binary generation


The above will select 4.cS and 5.cS as inputs and produce outputs with
the specified extensions (e.g., 4.o, 5.o)

.. code-block:: bash

    *.c --> *.o
    *.c --> *.cSs (iff c compiler is certified)

The above will select 1.c, 2.c, 3.c, and 6.c as inputs and produce outputs
with specified extensions (e.g., 1.s, 2.s, 3.s, 4.s)

Two special wildcard input rules always select all the sources with
the specified wildcard extension. For example,

.. code-block:: bash

    *.o --> uobjcoll.flat
    *.cSs --> uobjcoll.flat (iff using certified assembler)

The above will select 1.s, 2.s, 3.s, 4.s, 5.s, 6.s as inputs and produce the
desired output. 
