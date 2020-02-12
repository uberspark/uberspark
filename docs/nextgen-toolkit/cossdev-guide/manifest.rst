.. include:: /macros.rst


.. _manifest-intro:

|uspark| Manifest
=================

|uspark| uses a unified manifest interface for specifying and configuring various framework options.

A |uspark| manifest uses the JavaScript Object Notation (JSON) text format and is identified by the 
file name ``uberspark.json``

The |uspark| JSON manifest is essentially a collection of name/value pairs and/or ordered list of values.
See the JSON official specification (https://json.org) for more details on the JSON format.


.. note:: We chose JSON for its lightweight nature that allows reading and writing of options with ease. JSON
          also has a `formal specification <https://cswr.github.io/JsonSchema/spec/why/>`_ of its 
          `schema <https://json-schema.org>`_ which is turn
          enables creation of correct-by-construction parsers and generators for runtime use.


A |uspark| manifest (``uberspark.json``) has the following general high-level structure:

.. code-block:: console

    {
        /* user-defined block comments can appear anywhere */
        ...
        // user-defined single line comments can appear anywhere
        ...
        "manifest_node" : {
            ...
        },

        ...

        "manifest_node" : {

        }
    }

  
Here ``manifest_node`` can be one or more of the following specific node definitions as described below.

.. note:: The type and combination of specific node definitions will vary based on the functionality the
          manifest is describing. For example, the manifest describing a |uobj| will have a 
          ``uberspark-uobj`` node, whereas a manifest describing a |uobjcoll| will not.

.. seealso:: |cossdev-guide|:ref:`uobj-intro` and |cossdev-guide|:ref:`uobjcoll-intro`




``uberspark-manifesthdr`` Manifest Node
---------------------------------------

Every |uberspark| manifest needs to define a ``uberspark-manifesthdr`` node at the bare minimum, 
which describes the 
types of manifest nodes contained in the manifest along with the |uberspark| framework version 
requirements. 

The JSON declaration of the ``uberspark-manifesthdr`` node is as below:

.. json:object:: uberspark-manifesthdr
    
   :property manifest_node_type: comma seperated list of zero or more manifest node types (as strings) that are part of the manifest
   :proptype manifest_node_type: string list  
   :options manifest_node_type: "uberspark-uobj", "uberspark-uobjcoll", "uberspark-config", "uberspark-sentinel"
   :property uberspark_min_version: minimum <version> of |uberspark| required
   :proptype uberspark_min_version: string  
   :options uberspark_min_version: "<version>", "any"
   :property uberspark_max_version: maximum <version> of |uberspark| supported
   :proptype uberspark_max_version: string  
   :options uberspark_max_version: "<version>", "any"

    
An example definition of the ``uberspark-manifesthdr`` within |ubersparkmf| follows:

.. code-block:: JSON
    
    {
        "uberspark-manifest":{
            "manifest_node_types" : [ "uberspark-uobjcoll", "uberspark-config" ],
            "uberspark_min_version" : "6.0.0",
            "uberspark_max_version" : "any"
        }
    }

