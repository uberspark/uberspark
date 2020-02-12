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

    
An example definition of the ``uberspark-manifesthdr`` node within |ubersparkmff| follows:

.. code-block:: JSON
    
    {
        "uberspark-manifest":{
            "manifest_node_types" : [ "uberspark-uobjcoll", "uberspark-config" ],
            "uberspark_min_version" : "6.0.0",
            "uberspark_max_version" : "any"
        }
    }



``uberspark-config`` Manifest Node
---------------------------------------

The ``uberspark-config`` node within the |ubersparkmf| can be (optionally) used to 
selectively override configuration settings within the current staging environment.

.. note::   You can define only the required node properties that you want to override within
            the ``uberspark-config`` node definition. See example that follows below.

The JSON declaration of the ``uberspark-config`` node is as below:

.. json:object:: uberspark-config

   :property binary_page_size: size in bytes of a memory page within the |uobj|/|uobjcoll| binary
   :proptype binary_page_size: string
   :options binary_page_size: "<hexadecimal integer>", default="0x200000"

   :property binary_uobj_default_section_size: size in bytes of a |uobj| binary section (e.g., code, data)
   :proptype binary_uobj_default_section_size: string
   :options binary_uobj_default_section_size: "<hexadecimal integer>", default="0x200000"

   :property binary_uobj_section_alignment: memory alignment in bytes, of |uobj| binary section
   :proptype binary_uobj_section_alignment: string
   :options binary_uobj_section_alignment: "<hexadecimal integer>", default="0x200000"

   :property uobj_binary_image_load_address: memory load address of |uobj| binary
   :proptype uobj_binary_image_load_address: string
   :options uobj_binary_image_load_address: "<hexadecimal integer>", default="0x200000"

   :property uobj_binary_image_uniform_size: indicates if all |uobjs| within a |uobjcoll| binary have the same size
   :proptype uobj_binary_image_uniform_size: boolean
   :options uobj_binary_image_uniform_size: true, false

   :property uobj_binary_image_size: size in bytes of a |uobj| binary
   :proptype uobj_binary_image_size: string
   :options uobj_binary_image_size: "<hexadecimal integer>", default="0x2400000"

   :property uobj_binary_image_alignment: memory alignment in bytes of a |uobj| binary image
   :proptype uobj_binary_image_alignment: string
   :options uobj_binary_image_alignment: "<hexadecimal integer>", default="0x200000"

   :property uobjcoll_binary_image_load_address: memory load address of |uobjcoll| binary
   :proptype uobjcoll_binary_image_load_address: string
   :options uobjcoll_binary_image_load_address: "<hexadecimal integer>", default="0x60000000"

   :property uobjcoll_binary_image_hdr_section_alignment: memory alignment in bytes, of |uobjcoll| binary header section
   :proptype uobjcoll_binary_image_hdr_section_alignment: string
   :options uobjcoll_binary_image_hdr_section_alignment: "<hexadecimal integer>", default="0x200000"

   :property uobjcoll_binary_image_hdr_section_size: size in bytes of a |uobjcoll| binary header section
   :proptype uobjcoll_binary_image_hdr_section_size: string
   :options uobjcoll_binary_image_hdr_section_size: "<hexadecimal integer>", default="0x200000"

   :property uobjcoll_binary_image_section_alignment: memory alignment in bytes, of |uobjcoll| binary section
   :proptype uobjcoll_binary_image_section_alignment: string
   :options uobjcoll_binary_image_section_alignment: "<hexadecimal integer>", default="0x200000"

   :property bridge_cc_bridge: C compiler <bridge namespace path>
   :proptype bridge_cc_bridge: string
   :options bridge_cc_bridge: "<bridge namespace path>"

   :property bridge_as_bridge: Assembler <bridge namespace path>
   :proptype bridge_as_bridge: string
   :options bridge_as_bridge: "<bridge namespace path>"

   :property bridge_ld_bridge: Linker <bridge namespace path>
   :proptype bridge_ld_bridge: string
   :options bridge_ld_bridge: "<bridge namespace path>"


An example definition of the ``uberspark-config`` node within |ubersparkmff| follows:

.. code-block:: JSON
    
    {
        "uberspark-manifest":{
            "manifest_node_types" : [ "uberspark-config" ],
            "uberspark_min_version" : "any",
            "uberspark_max_version" : "any"
        },

        "uberspark-config":{
    		"binary_uobj_section_alignment" : "0x200000",
    		"bridge_cc_bridge" : "container/amd64/x86_32/generic/gcc/v5.4.0"
        }
    }

The aforementioned definition selectively overrides the *binary_uobj_section_alignment* and *bridge_cc_bridge* 
configuration settings within the current staging environment.


Manifest Nodes for Bridges
--------------------------

|uberspark| supports a variety of bridges such as compilers, assemblers, linkers, verification tools, build system etc.
A supported bridge is described by a bridge manifest node which follows the general layout given below:

.. code-block:: console

    {
        "uberspark-bridge-<bridgename>" : {
            
            //common bridge header definition
            "bridge-hdr":{
                ...
            },

            //bridge specific properties
            ...
        }
    }


The JSON declaration of the common ``bridge-hdr`` sub-node is as below:

.. json:object:: bridge-hdr

   :property btype: bridge type
   :proptype btype: string
   :options btype: "container", "native"

   :property bname: <bridge-name> as identified by |uberspark| 
   :proptype bname: string
   :options bname: "<brige-name>"

   :property execname: <executable-name> that carries out the functionality of the bridge 
   :proptype execname: string
   :options execname: "<executable-name>"

   :property devenv: development environment where the bridge executable runs 
   :proptype devenv: string
   :options devenv: "amd64"

   :property devenv: development environment where the bridge executable runs 
   :proptype devenv: string
   :options devenv: "amd64"

   :property arch: CPU architecture supported by the bridge 
   :proptype arch: string
   :options arch: "x86_32"

   :property cpu: CPU model supported by the bridge 
   :proptype cpu: string
   :options cpu: "generic"

   :property version: <version> of the bridge (executable) 
   :proptype version: string
   :options version: "<version>"

   :property path: filesystem <path> to the bridge executable (ignored if btype is "container")
   :proptype path: string
   :options path: "<path>"

   :property params: comma delimited (optional) string options for the bridge executable
   :proptype params: string list

   :property container_fname: <filename> of the container dockerfile (ignored if btype is "native")
   :proptype container_fname: string
   :options container_fname: "<filename>"


The follow sections describe the bridge specific manifest node declarations for supported bridges. 


``uberspark-bridge-as`` Manifest Node
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``uberspark-bridge-as`` node within the |ubersparkmf| is used to describe an Assembler 
bridge. The JSON declaration of the ``uberspark-bridge-as`` node is as below:

.. json:object:: uberspark-bridge-as

   :property bridge-hdr: the common bridge header declaration
   :proptype bridge-hdr: :json:object:`bridge-hdr`

   :property params_prefix_obj: command line option prefix to generate object file from Assembly source
   :proptype params_prefix_obj: string

   :property params_prefix_output: command line option prefix to specify output file name
   :proptype params_prefix_output: string

   :property params_prefix_include: command line option prefix to include a header file
   :proptype params_prefix_include: string

An example definition of the ``uberspark-bridge-as`` node for the GNU-as Assembler, within |ubersparkmff| follows:


.. code-block:: JSON
    
    {
        "uberspark-manifest":{
            "manifest_node_types" : [ "uberspark-bridge-as" ],
            "uberspark_min_version" : "any",
            "uberspark_max_version" : "any"
        },

        "uberspark-bridge-as":{
            "bridge-hdr":{
                "btype" : "container",
                "bname" : "gnu-as",
                "execname" : "gcc",
                "devenv" : "amd64",
                "arch" : "x86_32",
                "cpu" : "generic",
                "version" : "v2.26.1",
                "path" : ".",
                "params" : [ "-m32" ],
                "container_fname" : "uberspark_bridges.Dockerfile"
            },

            "params_prefix_obj" : "-c",
            "params_prefix_output" : "-o",
            "params_prefix_include" : "-I"
        }
    }


.. note::   Here the Assembler bridge type is defined to be a container and ``uberspark_bridges.Dockerfile``
            is the container dockerfile that includes the build for running GNU-as within an ``amd64`` 
            environment (e.g., ubuntu or alpine)s