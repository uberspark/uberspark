.. include:: /macros.rst


.. _reference-manifest-intro:

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
        "manifest_node" : "",
        ...
        "manifest_node" : [
            ...
        ],
        ...
        "manifest_node" : {
            ...
        }
        ...
    }

  
Here ``manifest_node`` can be one or more of the following specific node definitions as described below.

.. note:: The type and combination of specific node definitions will vary based on the functionality the
          manifest is describing. For example, the manifest describing a |uobj| will have a 
          different set of nodes when compared to a manifest describing a |uobjcoll|.

.. seealso:: |cossdev-guide-ref|:::ref:`cossdev-guide-create-uobjs` and |cossdev-guide-ref|:::ref:`cossdev-guide-create-uobjcoll`


.. _reference-manifest-uberspark-manifesthdr:


``uberspark.manifest.xxx`` Nodes
--------------------------------

Every |uberspark| manifest needs to define a set of ``uberspark.manifest.xxx`` nodes at the bare minimum, 
which describes the type of manifest (e.g., |uobj|, |uobjcoll|, etc.) along with the |uberspark| framework version 
requirements. 

The following are the currently supported ``uberspark.manifest.xxx`` node definitions:

.. json:object:: uberspark.manifest.xxx
    
   :property uberspark.manifest.namespace: describes the type of manifest
   :proptype uberspark.manifest.namespace: string  
   :options uberspark.manifest.namespace: "uberspark/uobj", "uberspark/uobjcoll", "uberspark/sentinels", "uberspark/bridges", "uberspark/uobjrtl", "uberspark/uobjslt", "uberspark/loaders"
   :property uberspark.manifest.version_min: minimum <version> of |uberspark| required
   :proptype uberspark.manifest.version_min: string  
   :options uberspark.manifest.version_min: "<version>", "any"
   :property uberspark.manifest.version_max: maximum <version> of |uberspark| supported
   :proptype uberspark.manifest.version_max: string  
   :options uberspark.manifest.version_max: "<version>", "any"

    
An example definition for a |uobjcoll| manifest follows:

.. code-block:: JSON
    
    {
        "uberspark.manifest.namespace" : "uberspark/uobjcoll",
        "uberspark.manifest.version_min" : "6.0.0",
        "uberspark.manifest.version_max" : "any"
    }




.. _reference-manifest-uberspark-platform:

``uberspark.platform.xxx`` Nodes
--------------------------------
    

The ``uberspark.platform.xxx`` nodes within the |ubersparkmf| define platform
configuration settings for a given platform. Platform definitions can be (optionally)
overriden within a |uobjcoll| manifest.

.. note::   You can define only the required node properties that you want to override within
            the ``uberspark.platform.xxx`` node definition. See example that follows below.

The JSON declaration of the ``uberspark.platform.xxx`` node is as below:

.. json:object:: uberspark.platform.xxx

   :property uberspark.platform.binary.page_size: size in bytes of a memory page within the |uobj|/|uobjcoll| binary
   :proptype uberspark.platform.binary.page_size: string
   :options uberspark.platform.binary.page_size: "<hexadecimal integer>", default="0x200000"

   :property uberspark.platform.binary.uobj_default_section_size: size in bytes of a |uobj| binary section (e.g., code, data)
   :proptype uberspark.platform.binary.uobj_default_section_size: string
   :options uberspark.platform.binary.uobj_default_section_size: "<hexadecimal integer>", default="0x200000"

   :property uberspark.platform.binary.uobj_section_alignment: memory alignment in bytes, of |uobj| binary section
   :proptype uberspark.platform.binary.uobj_section_alignment: string
   :options uberspark.platform.binary.uobj_section_alignment: "<hexadecimal integer>", default="0x200000"

   :property uberspark.platform.binary.uobj_image_load_address: memory load address of |uobj| binary
   :proptype uberspark.platform.binary.uobj_image_load_address: string
   :options uberspark.platform.binary.uobj_image_load_address: "<hexadecimal integer>", default="0x200000"

   :property uberspark.platform.binary.uobj_image_uniform_size: indicates if all |uobjs| within a |uobjcoll| binary have the same size
   :proptype uberspark.platform.binary.uobj_image_uniform_size: boolean
   :options uberspark.platform.binary.uobj_image_uniform_size: true, false

   :property uberspark.platform.binary.uobj_image_size: size in bytes of a |uobj| binary
   :proptype uberspark.platform.binary.uobj_image_size: string
   :options uberspark.platform.binary.uobj_image_size: "<hexadecimal integer>", default="0x2400000"

   :property uberspark.platform.binary.uobj_image_alignment: memory alignment in bytes of a |uobj| binary image
   :proptype uberspark.platform.binary.uobj_image_alignment: string
   :options uberspark.platform.binary.uobj_image_alignment: "<hexadecimal integer>", default="0x200000"

   :property uberspark.platform.binary.uobjcoll_image_load_address: memory load address of |uobjcoll| binary
   :proptype uberspark.platform.binary.uobjcoll_image_load_address: string
   :options uberspark.platform.binary.uobjcoll_image_load_address: "<hexadecimal integer>", default="0x60000000"

   :property uberspark.platform.binary.uobjcoll_image_hdr_section_alignment: memory alignment in bytes, of |uobjcoll| binary header section
   :proptype uberspark.platform.binary.uobjcoll_image_hdr_section_alignment: string
   :options uberspark.platform.binary.uobjcoll_image_hdr_section_alignment: "<hexadecimal integer>", default="0x200000"

   :property uberspark.platform.binary.uobjcoll_image_hdr_section_size: size in bytes of a |uobjcoll| binary header section
   :proptype uberspark.platform.binary.uobjcoll_image_hdr_section_size: string
   :options uberspark.platform.binary.uobjcoll_image_hdr_section_size: "<hexadecimal integer>", default="0x200000"

   :property uberspark.platform.binary.uobjcoll_image_section_alignment: memory alignment in bytes, of |uobjcoll| binary section
   :proptype uberspark.platform.binary.uobjcoll_image_section_alignment: string
   :options uberspark.platform.binary.uobjcoll_image_section_alignment: "<hexadecimal integer>", default="0x200000"

   :property uberspark.platform.bridges: comma delimited list of platform bridge decaration sub-nodes
   :proptype uberspark.platform.bridges: :json:object:`bridges` list

.. json:object:: bridges

   :property bridge_id: identifier of the bridge
   :proptype bridge_id: string 
   :options bridge_id: @@<id>@@ where id is a identifier name. Pre-defined values of id are @@CC_BRIDGE@@, @@AS_BRIDGE@@, @@CASM_BRIDGE@@, @@LD_BRIDGE@@, and @@VF_BRIDGE_UBERSPARK@@
   
   :property bridge_namespace: namespace for the bridge
   :proptype bridge_namespace: string 


An example definition of the ``uberspark.platform.xxx`` nodes within |ubersparkmff| follows:

.. code-block:: JSON
    
    {
        "uberspark.manifest.namespace" : "uberspark/uobjcoll",
        "uberspark.manifest.version_min" : "any",
        "uberspark.manifest.version_max" : "any",

        "uberspark.platform.binary.uobj_section_alignment" : "0x200000"
    }

The aforementioned definition selectively overrides the 
*uobj_section_alignment* definition within the current platform definition.





.. _reference-manifest-uberspark-bridge:

``uberspark.bridge.xxx`` Nodes
-------------------------------

|uberspark| supports a variety of bridges such as compilers, assemblers, linkers, verification tools, build system etc.
A supported bridge is described by a bridge manifest node which follows the general layout given below:

.. code-block:: console

    {
        "uberspark.bridge.namespace" : "<namespace>"
   		"uberspark.bridge.category" : "<category>",
		"uberspark.bridge.container_build_filename" : "<build_filename>",

		"uberspark.bridge.bridge_cmd" : [
            "command1",
            "command2",
            ...
        }
    }

The JSON declaration of the ``uberspark.bridges.xxx`` nodes are as below:

.. json:object:: uberspark.bridges.xxx

   :property uberspark.bridges.namespace: namespace for the bridge of the format - "uberspark/bridges/<category>/<devenv>/<bridge-type>/<name>/<arch>/<cpu>/<name>/<version>"
   :proptype uberspark.bridges.namespace: string
   :options uberspark.bridges.namespace: <category>=container or native; <devenv>=amd64; <bridge-type>=as-bridge,cc-bridge,ld-bridge,vf-bridge,loader-bridge; <arch>=x86_32,armv8_32; <cpu>=generic; <name>=name of the bridge; <version>=vx.y.z
   
   :property uberspark.bridges.category: category of the bridge
   :proptype uberspark.bridges.category: string
   :options uberspark.bridges.category: "container", "native"

   :property uberspark.bridge.container_build_filename: if uberspark.bridges.category is container, then specifies the container build filename
   :proptype uberspark.bridge.container_build_filename: string
   :options uberspark.bridge.container_build_filename: "<filename>"

   :property uberspark.bridge.bridge_cmd: comma seperated string list of commands to be executed within the bridge
   :proptype uberspark.bridge.bridge_cmd: string list
   :options uberspark.bridge.bridge_cmd: 

An example definition of the ``uberspark.bridged.xxx`` nodes for the GNU-as Assembler, within |ubersparkmff| follows:

.. code-block:: JSON
    
    {
        "uberspark.manifest.namespace" : "uberspark/bridges",
        "uberspark.manifest.version_min" : "any",
        "uberspark.manifest.version_max" : "any",

        "uberspark.bridge.namespace" : "uberspark/bridges/container/amd64/as-bridge/x86_32/generic/gnu-as/v2.26.1",
        "uberspark.bridge.category" : "container",
        "uberspark.bridge.container_build_filename" : "uberspark_bridges.Dockerfile",

        "uberspark.bridge.bridge_cmd" : [
            "export var_bridge_include_dirs_with_prefix",
            "export var_bridge_source_files",
            "var_bridge_include_dirs_with_prefix=\" @@BRIDGE_INCLUDE_DIRS_WITH_PREFIX@@ \"",
            "var_bridge_source_files=\" @@BRIDGE_SOURCE_FILES@@ \"",
            "vararray_bridge_source_files=$(echo $var_bridge_source_files | tr \" \" \"\\n\")",
            "for source_file_name in $vararray_bridge_source_files; do echo \"Compiling ${source_file_name} ...\" && gcc @@BRIDGE_COMPILEDEFS_WITH_PREFIX@@ -m32 -c ${var_bridge_include_dirs_with_prefix} ${source_file_name} -o ${source_file_name}.o ; done"
        ] 

    }

.. note::   Here the Assembler bridge type is defined to be a container and ``uberspark_bridges.Dockerfile``
            is the container dockerfile that includes the build for running GNU-as within an ``amd64`` 
            environment (e.g., ubuntu or alpine)


.. note::   Variables within ``@@`` are special bridge environment variables that are pre-populated by 
            the framework and can be used by the bridge commands as shown in the above example with source
            files and include directories





.. _reference-manifest-uberspark-uobj:


``uberspark.uobj.xxx`` Nodes
----------------------------

The ``uberspark.uobj.xxx`` nodes within the |ubersparkmf| is used to describe a |uobj|.
The JSON declaration of the ``uberspark.uobj.xxx`` nodes are as below:

.. json:object:: uberspark.uobj.xxx

    :property uberspark.uobj.namespace: |uobj| namespace path as identified by |uberspark| 
    :proptype uberspark.uobj.namespace: string

    :property uberspark.uobj.platform: |uobj| target hardware platform 
    :proptype uberspark.uobj.platform: string
    :options uberspark.uobj.platform: "generic"

    :property uberspark.uobj.arch: |uobj| target CPU architecture 
    :proptype uberspark.uobj.arch: string
    :options uberspark.uobj.arch: "x86_32"

    :property uberspark.uobj.cpu: |uobj| target CPU model 
    :proptype uberspark.uobj.cpu: string
    :options uberspark.uobj.cpu: "generic"

    :property uberspark.uobj.source_h_files: comma separated list of |uobj| header source filenames  
    :proptype uberspark.uobj.source_h_files: string list

    :property uberspark.uobj.source_c_files: comma separated list of |uobj| C source filenames  
    :proptype uberspark.uobj.source_c_files: string list

    :property uberspark.uobj.source_casm_files: comma separated list of |uobj| CASM source filenames  
    :proptype uberspark.uobj.source_casm_files: string list

    :property uberspark.uobj.source_asm_files: comma separated list of |uobj| Assembly source filenames  
    :proptype uberspark.uobj.source_asm_files: string list

    :property uberspark.uobj.public_methods: comma delimited |uobj| public methods declarations of the format: *"<publicmethod-name>" : [ "<publicmethod-return-type>", "<publicmethod-parameters-decl>", "<public_methods-numberof-parameters">]*
    :proptype uberspark.uobj.public_methods: {}

    :property uberspark.uobj.intra_uobjcoll_callees: comma delimited declarations of public methods of other |uobjs| that this |uobj| invokes within the same |uobjcoll|. The declarations are of the format: *"<uobj-namespace-path>" : [ "<publicmethod-1-name>", ..., "<publicmethod-n-name>"]*
    :proptype uberspark.uobj.intra_uobjcoll_callees: {}

    :property uberspark.uobj.inter_uobjcoll_callees: comma delimited declarations of public methods of other |uobjs| that this 
                                     |uobj| invokes across |uobjcoll|. The declarations are of the format:
                                     *"<uobjcoll-namespace-path>" : [ "<publicmethod-1-name>", ..., "<publicmethod-n-name>"]*
    :proptype uberspark.uobj.inter_uobjcoll_callees: {}

    :property uberspark.uobj.legacy_callees: comma delimited legacy |coss| function names that this |uobj| invokes 
    :proptype uberspark.uobj.legacy_callees: string list

    :property uberspark.uobj.uobjrtl: comma delimited list of |uobj| runtime library definition sub-nodes
    :proptype uberspark.uobj.uobjrtl: :json:object:`uobjrtl` list

    :property uberspark.uobj.sections: (optional) comma delimited list of |uobj| additional sections definition sub-nodes
    :proptype uberspark.uobj.sections: :json:object:`sections` list

.. json:object:: uobjrtl

    :property namespace: namespace of the |uobj| runtime library
    :proptype namespace: string 

.. json:object:: sections

    :property name: name of the |uobj| section 
    :proptype name: string 
    :options type: "uobj_code", "uobj_rodata", "uobj_rwdata", "uobj_dmadata", "uobj_ustack", "uobj_tstack", "<developer-defined>" where 
                   <developer-defined> is a developer defined section name

    :property size: hexadecimal size (in bytes) of the section 
    :proptype size: string 

    :property output_names: comma delimited list of |uobj| output section names for developer-defined 
                            sections (e.g., defined via __attribute__((section())) ). This field is optional for 
                            standard |uobj| sections (e.g., uobj_code).
    :proptype output_names: string list 

    :property type: (optional) hexadecimal type of the section 
    :proptype type: string 
    :options type: "0x0"

    :property attribute: (optional) hexadecimal protection of the section 
    :proptype attribute: string 
    :options attribute: "0x0"

    :property aligned_at: (optional) hexadecimal alignment (in bytes) of the section 
    :proptype aligned_at: string 

    :property pad_to: (optional) hexadecimal padding boundary (in bytes) of the section 
    :proptype pad_to: string 

An example definition of ``uberspark.uobj.xxx`` nodes for a sample |uobj| called ``add``, within |ubersparkmff| follows:

.. code-block:: JSON

    {
        "uberspark.manifest.namespace" : "uberspark/uobj",
        "uberspark.manifest.version_min" : "5.1",
        "uberspark.manifest.version_max" : "any",

        "uberspark.uobj.namespace" : "uberspark/uobjs/generic/test/add",
        "uberspark.uobj.platform" : "generic",
        "uberspark.uobj.arch" : "generic",
        "uberspark.uobj.cpu" : "generic",

        "uberspark.uobj.source_h_files": [ ],
        "uberspark.uobj.source_c_files": [ "add.c" ],
        "uberspark.uobj.source_casm_files": [ ],
        "uberspark.uobj.source_asm_files": [ ],
    
        "uberspark.uobj.public_methods" : {
            "add" : [
                "uint32_t",
                "(uint32_t param1, uint32_t param2)", 
                "2" 
            ],

            "inc" : [
                "uint32_t",
                "(uint32_t param1)", 
                "1" 
            ]
        },

        "uberspark.uobj.intra_uobjcoll_callees" : {
            "uberspark/uobjs/generic/test/uobj1": ["pm_one", "pm_two", "pm_three"],
            "uberspark/uobjs/generic/test/uobj2": ["pm_one"]
         },
        
        "uberspark.uobj.inter_uobjcoll_callees": {
            "uberspark/uobjcoll/test" : ["pm_one" ]
        },
        
        "uberspark.uobj.legacy_callees": [
            "untrusted_func_1",	
            "untrusted_func_2"
        ],

        "uobjrtl": [
            {
                "namespace" : "uberspark/uobjrtl/crt"
            },

            {
                "namespace" : "uberspark/uobjrtl/crypto"
            }
        ],

        "sections": [
            {
                "name" : "example_additional_section",
                "output_names" : [ ".exaddsec" ],
                "type" : "0x0",
                "prot" : "0x0",
                "size" : "0x200000",
                "aligned_at" : "0x1000",
                "pad_to" : "0x1000"
            }
        ]

    }





.. _reference-manifest-uberspark-uobjcoll:


``uberspark.uobjcoll.xxx`` Nodes
--------------------------------


The ``uberspark.uobjcoll.xxx`` nodes within the |ubersparkmf| is used to describe a |uobjcoll|.
The JSON declaration of the ``uberspark.uobjcoll.xxx`` nodes are as below:

.. json:object:: uberspark.uobjcoll.xxx

    :property namespace: <uobjcoll-namespace-path> as identified by |uberspark| 
    :proptype namespace: string
    :options namespace: "<uobjcoll-namespace-path>"

    :property arch: |uobjcoll| target hardware platform 
    :proptype arch: string
    :options arch: "generic"

    :property arch: |uobjcoll| target CPU architecture 
    :proptype arch: string
    :options arch: "x86_32"

    :property cpu: |uobjcoll| target CPU model 
    :proptype cpu: string
    :options cpu: "generic"

    :property hpl: |uobjcoll| hardware privilege level 
    :proptype hpl: string
    :options hpl: "generic"

    :property sentinels_intra_uobjcoll: type of intra-|uobjcoll| sentinel 
    :proptype sentinels_intra_uobjcoll: string list
    :options sentinels_intra_uobjcoll: "call"

    :property configdefs: configuration definition variables for the |uobjcoll|, available to source and header files for conditional builds
    :proptype configdefs: :json:object:`configdefs`

    :property uobjs: list of |uobjs| within the |uobjcoll| 
    :proptype uobjs: :json:object:`uobjs`

    :property init_method: initialization method for the |uobjcoll| 
    :proptype init_method: :json:object:`init_method`

    :property public_methods: comma delimited |uobjcoll| public methods declarations of the 
                             format: *"<uobj-namespace-path>" : { "<uobj-publicmethod-1-name>" : [ "<sentinel-type>", ..., "<sentinel-type>"], ... , "<uobj-publicmethod-n-name>" : [ "<sentinel-type>", ..., "<sentinel-type>"]}*
    :proptype public_methods: {}
    :options public_methods: <sentinel-type>="call"

    :property loaders: comma separated list of |uobjcoll| loader namespaces; these loaders will be built as part of building the |uobjcoll| 
    :proptype loaders: string list


.. json:object:: configdefs

    :property name: name of the configuration definition, this will be available as ``UBERSPARK_UOBJCOLL_CONFIGDEF_name`` to the sources and headers
    :proptype name: string 
 
    :property value: value of the configuration definition that can be a number, string or special boolean string below for definitions that just need to be set or unset
    :proptype value: string 
    :options value: "<number>", "<string>", "@@TRUE@@" for definition that is set, "@@FALSE@@" for definition that is unset
 
.. json:object:: uobjs

    :property master: <uobj-namespace-path> of the master |uobj| within the |uobjcoll| 
    :proptype master: string 
    :options master: "", "<uobj-namespace-path>"
 
    :property templars: comma delimited list of <uobj-namespace-path> for all the templar |uobjs| within the |uobjcoll| 
    :proptype templars: string list
    :options templars: "", "<uobj-namespace-path>"

.. json:object:: init_method

    :property namespace: <uobj> namespace as identified by |uberspark| 
    :proptype namespace: string

    :property public_method: name of the public method definied within ``uberspark.uobjcoll.public_methods`` 
    :proptype public_method: string

    :property sentinels: list of sentinels for the init_method 
    :proptype sentinels: :json:object:`sentinels`

.. json:object:: sentinels

    :property sentinel_type: sentinel namespace as identified by |uberspark| 
    :proptype sentinel_type: string



An example definition of the ``uberspark.uobjcoll.xxx`` nodes within |ubersparkmff|, for a |uobjcoll|, follows:

.. code-block:: JSON

    {

        "uberspark.manifest.namespace" : [ "uberspark-uobjcoll" ],
        "uberspark.manifest.version_min" : "5.1",
        "uberspark.manifest.version_max" : "any",

        "uberspark.uobjcoll.namespace" : "uberspark/uobjcoll/platform/pc/uxmhf",
        "uberspark.uobjcoll.platform" : "pc",
        "uberspark.uobjcoll.arch" : "x86_32",
        "uberspark.uobjcoll.cpu" : "generic",
        "uberspark.uobjcoll.hpl" : "any", 
        "uberspark.uobjcoll.sentinels_intra_uobjcoll" : [ "generic/generic/any/call" ],

        "uberspark.uobjcoll.configdefs" : [

            { "name": "uxmhf_build_version", "value": "\"6.0.0\""},
            { "name": "uxmhf_build_revision", "value": "\"you-gotta-have-faith-not-in-who-you-are-but-who-you-can-be\""},
            { "name": "debug_serial", "value": "@@TRUE@@"},
            { "name": "debug_port", "value": "0x3f8"},
            { "name": "debug_serial_maxcpus", "value": "8"},
            { "name": "drt", "value": "@@TRUE@@"},
            { "name": "dmap", "value": "@@TRUE@@"},
            { "name": "uapp_aprvexec", "value": "@@FALSE@@"},
            { "name": "uapp_hyperdep", "value": "@@FALSE@@"},
            { "name": "uapp_ssteptrace", "value": "@@FALSE@@"},
            { "name": "uapp_syscalllog", "value": "@@FALSE@@"},
            { "name": "uapp_uhcalltest", "value": "@@TRUE@@"},
            { "name": "uapp_nwlog", "value": "@@FALSE@@"}

        ],

        "uberspark.uobjcoll.uobjs" : {
            "master" : "",
            "templars" : [
                "uberspark/uobjcoll/platform/pc/uxmhf/main"
            ]
        },

        "uberspark.uobjcoll.init_method" : {
            "uobj_namespace" : "uberspark/uobjcoll/platform/pc/uxmhf/main",
            "public_method" : "entry",
            "sentinels" : [
                {
                    "sentinel_type" : "drot/intel/pc/pmr0/call"
                }	
            ]
        },	

        "uberspark.uobjcoll.public_methods" : {
            "uberspark/uobjcoll/platform/pc/uxmhf/main" : {
                "entry" : [ "generic/generic/any/call" ]
            }
        },

        "uberspark.uobjcoll.loaders" : [
            "uberspark/loaders/baremetal/x86_32/grub-legacy"    
        ]

    }



.. _reference-manifest-uberspark-uobjrtl:


``uberspark.uobjrtl.xxx`` Nodes
-------------------------------

The ``uberspark.uobjrtl.xxx`` nodes within the |ubersparkmf| is used to describe a |uobjrtl|.
The JSON declaration of the ``uberspark.uobjrtl.xxx`` nodes are as below:

.. json:object:: uberspark.uobjrtl.xxx

    :property uberspark.uobjrtl.namespace: <uobjrtl-namespace-path> as identified by |uberspark| 
    :proptype uberspark.uobjrtl.namespace: string
    :options uberspark.uobjrtl.namespace: "<uobjrtl-namespace-path>"

    :property uberspark.uobjrtl.platform: |uobjrtl| target hardware platform 
    :proptype uberspark.uobjrtl.platform: string
    :options uberspark.uobjrtl.platform: "generic"

    :property uberspark.uobjrtl.arch: |uobjrtl| target CPU architecture 
    :proptype uberspark.uobjrtl.arch: string
    :options uberspark.uobjrtl.arch: "x86_32"

    :property uberspark.uobjrtl.cpu: |uobjrtl| target CPU model 
    :proptype uberspark.uobjrtl.cpu: string
    :options uberspark.uobjrtl.cpu: "generic"

    :property uberspark.uobjrtl.source_c_files: |uobjrtl| definitions for source C files 
    :proptype uberspark.uobjrtl.source_c_files: :json:object:`uobjrtl_sources` list

    :property uberspark.uobjrtl.source_casm_files: |uobjrtl| definitions for source CASM files
    :proptype uberspark.uobjrtl.source_casm_files: :json:object:`uobjrtl_sources` list

.. json:object:: uobjrtl_sources

    :property path: <path> relative to the |uobjrtl| top-level source directory 
    :proptype path: string
    :options path: "src/<source-filename-with-path>"

    :property fn_decls: |uobjrtl| modules function declarations 
    :proptype fn_decls: :json:object:`fn_decls` list


.. json:object:: fn_decls

    :property fn_name: canonical function name (See |contrib-guide-ref|:::ref:`contrib-guide-uobjrtl-srccontents`) 
    :proptype fn_name: string


An example definition of the ``uberspark.uobjrtl.xxx`` nodes  within |ubersparkmff|, for the ``crt`` |uobjrtl| follows:

.. literalinclude:: /../src-nextgen/uobjrtl/crt/uberspark.json
    :language: bash
    :linenos:

