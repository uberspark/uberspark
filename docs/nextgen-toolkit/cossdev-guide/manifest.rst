.. include:: /macros.rst


|uspark| Manifest
=================

|uspark| uses a unified manifest interface for specifying and configuring various framework options.

A |uspark| manifest uses the JavaScript Object Notation (JSON) text format and is identified by the 
file name ``uberspark.json``

The |uspark| JSON manifest is essentially a collection of name/value pairs and/or ordered list of values.
See the JSON official specification (https://json.org) for more details on the JSON format.


.. note:: We chose JSON for its lightweight nature that allows reading and writing of options with ease. JSON
          also enables creation of simple parsers and generators which allows (potentially verifiable) 
          manifest parsing at runtime.


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



.. _manifest-intro:

``uberspark-manifesthdr`` Manifest Node
---------------------------------------

Every |uberspark| manifest needs to define a ``uberspark-manifesthdr`` node at the bare minimum, 
which describes the 
types of manifest nodes contained in the manifest along with the |uberspark| framework version 
requirements. The JSON declaration of the ``uberspark-manifesthdr`` node is as below:

.. code-block:: console

    "uberspark-manifest":{
		"manifest_node_types" : [  ],
		"uberspark_min_version" : "",
		"uberspark_max_version" : ""
	}

The following are the field descriptions, field type and possible values for the ``uberspark-manifesthdr`` node:

.. tabularcolumns:: |c|c|c|c|

.. csv-table:: ``uberspark-manifesthdr`` node
   :header: "field name", "field type", "description", "possible values"
   :class: longtable
   :widths: 20, 20, 20, 20
   :escape: \

   "manifest_node_types", "string list", "comma seperated list of manifest node types (as strings) that are part of this manifest", "\"``uberspark-uobj``\", \"``uberspark-uobjcoll``\", \"``uberspark-config``\", \"``uberspark-sentinel``\""
   "uberspark_min_version", "string", "minimum version of |uberspark| required", "version number as string (e.g., \"6.0.0\" ) OR \"any\""
   "uberspark_max_version", "string", "maximum version of |uberspark| supported", "version number as string (e.g., \"6.0.0\" ) OR \"any\""

