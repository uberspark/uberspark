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

.. seealso:: |cossdev-guide-ref|:::ref:`cossdev-guide-create-uobjs` and |cossdev-guide-ref|:::ref:`cossdev-guide-create-uobjcoll`


.. _reference-manifest-uberspark-manifesthdr:


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
            "namespace" : [ "uberspark-uobjcoll", "uberspark-config" ],
            "version_min" : "6.0.0",
            "version_max" : "any"
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

   :property cc_bridge_namespace: C compiler <bridge namespace path>
   :proptype cc_bridge_namespace: string
   :options cc_bridge_namespace: "<bridge namespace path>"

   :property as_bridge_namespace: Assembler <bridge namespace path>
   :proptype as_bridge_namespace: string
   :options as_bridge_namespace: "<bridge namespace path>"

   :property ld_bridge_namespace: Linker <bridge namespace path>
   :proptype ld_bridge_namespace: string
   :options ld_bridge_namespace: "<bridge namespace path>"


An example definition of the ``uberspark-config`` node within |ubersparkmff| follows:

.. code-block:: JSON
    
    {
        "uberspark-manifest":{
            "namespace" : [ "uberspark-config" ],
            "version_min" : "any",
            "version_max" : "any"
        },

        "uberspark-config":{
    		"binary_uobj_section_alignment" : "0x200000",
    		"cc_bridge_namespace" : "container/amd64/x86_32/generic/gcc/v5.4.0"
        }
    }

The aforementioned definition selectively overrides the *binary_uobj_section_alignment* and *cc_bridge_namespace* 
configuration settings within the current staging environment.


.. _reference-manifest-uberspark-bridge:

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

   :property category: bridge type
   :proptype category: string
   :options category: "container", "native"

   :property name: <bridge-name> as identified by |uberspark| 
   :proptype name: string
   :options name: "<brige-name>"

   :property executable_name: <executable-name> that carries out the functionality of the bridge 
   :proptype executable_name: string
   :options executable_name: "<executable-name>"

   :property dev_environment: development environment where the bridge executable runs 
   :proptype dev_environment: string
   :options dev_environment: "amd64"

   :property dev_environment: development environment where the bridge executable runs 
   :proptype dev_environment: string
   :options dev_environment: "amd64"

   :property arch: CPU architecture supported by the bridge 
   :proptype arch: string
   :options arch: "x86_32"

   :property cpu: CPU model supported by the bridge 
   :proptype cpu: string
   :options cpu: "generic"

   :property version: <version> of the bridge (executable) 
   :proptype version: string
   :options version: "<version>"

   :property path: filesystem <path> to the bridge executable (ignored if category is "container")
   :proptype path: string
   :options path: "<path>"

   :property parameters: comma delimited (optional) string options for the bridge executable
   :proptype parameters: string list

   :property container_filename: <filename> of the container dockerfile (ignored if category is "native")
   :proptype container_filename: string
   :options container_filename: "<filename>"


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
            "namespace" : [ "uberspark-bridge-as" ],
            "version_min" : "any",
            "version_max" : "any"
        },

        "uberspark-bridge-as":{
            "bridge-hdr":{
                "category" : "container",
                "name" : "gnu-as",
                "executable_name" : "gcc",
                "dev_environment" : "amd64",
                "arch" : "x86_32",
                "cpu" : "generic",
                "version" : "v2.26.1",
                "path" : ".",
                "parameters" : [ "-m32" ],
                "container_filename" : "uberspark_bridges.Dockerfile"
            },

            "params_prefix_obj" : "-c",
            "params_prefix_output" : "-o",
            "params_prefix_include" : "-I"
        }
    }


.. note::   Here the Assembler bridge type is defined to be a container and ``uberspark_bridges.Dockerfile``
            is the container dockerfile that includes the build for running GNU-as within an ``amd64`` 
            environment (e.g., ubuntu or alpine)



``uberspark-bridge-cc`` Manifest Node
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``uberspark-bridge-cc`` node within the |ubersparkmf| is used to describe a C compiler 
bridge. The JSON declaration of the ``uberspark-bridge-cc`` node is as below:

.. json:object:: uberspark-bridge-cc

   :property bridge-hdr: the common bridge header declaration
   :proptype bridge-hdr: :json:object:`bridge-hdr`

   :property params_prefix_obj: command line option prefix to generate object file from C source
   :proptype params_prefix_obj: string

   :property params_prefix_asm: command line option prefix to generate Assembly source from C source
   :proptype params_prefix_asm: string
  
   :property params_prefix_output: command line option prefix to specify output file name
   :proptype params_prefix_output: string

   :property params_prefix_include: command line option prefix to include a header file
   :proptype params_prefix_include: string

   :property params_cclib: full pathname to compiler runtime library (e.g., libgcc.a)
   :proptype params_cclib: string

An example definition of the ``uberspark-bridge-cc`` node for the GNU gcc C compiler, within |ubersparkmff| follows:


.. code-block:: JSON
    
    {
        "uberspark-manifest":{
            "namespace" : [ "uberspark-bridge-cc" ],
            "version_min" : "any",
            "version_max" : "any"
        },

        "uberspark-bridge-cc":{
            "bridge-hdr":{
                "category" : "container",
                "name" : "gcc",
                "executable_name" : "gcc",
                "dev_environment" : "amd64",
                "arch" : "x86_32",
                "cpu" : "generic",
                "version" : "v5.4.0",
                "path" : ".",
                "parameters" : [ "-m32" ],
                "container_filename" : "uberspark_bridges.Dockerfile"
            },

            "params_prefix_obj" : "-c",
            "params_prefix_asm" : "-S",
            "params_prefix_output" : "-o",
            "params_prefix_include" : "-I",
            "params_cclib" : "/usr/lib/gcc/x86_64-linux-gnu/5/libgcc.a"
       }
    }


.. note::   Here the C compiler bridge type is defined to be a container and ``uberspark_bridges.Dockerfile``
            is the container dockerfile that includes the build for running GNU gcc within an ``amd64`` 
            environment (e.g., ubuntu or alpine)




``uberspark-bridge-ld`` Manifest Node
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``uberspark-bridge-ld`` node within the |ubersparkmf| is used to describe a Linker 
bridge. The JSON declaration of the ``uberspark-bridge-ld`` node is as below:

.. json:object:: uberspark-bridge-ld

   :property bridge-hdr: the common bridge header declaration
   :proptype bridge-hdr: :json:object:`bridge-hdr`

   :property params_prefix_lscript: command line option prefix to specify input linker script file
   :proptype params_prefix_lscript: string

   :property params_prefix_libdir: command line option prefix to specify library directory
   :proptype params_prefix_libdir: string

   :property params_prefix_lib: command line option prefix to include a library
   :proptype params_prefix_lib: string

   :property params_prefix_output: command line option prefix to specify output file name
   :proptype params_prefix_output: string

   :property cmd_generate_flat_binary: command prefix to generate a flat-form binary. note that the input and output file will be added to this automatically
   :proptype cmd_generate_flat_binary: string

An example definition of the ``uberspark-bridge-ld`` node for the GNU ld linker, within |ubersparkmff| follows:


.. code-block:: JSON
    
    {
        "uberspark-manifest":{
            "namespace" : [ "uberspark-bridge-ld" ],
            "version_min" : "any",
            "version_max" : "any"
        },

        "uberspark-bridge-ld":{
            "bridge-hdr":{
                "category" : "container",
                "name" : "gnu-ld",
                "executable_name" : "ld",
                "dev_environment" : "amd64",
                "arch" : "x86_32",
                "cpu" : "generic",
                "version" : "v2.26.1",
                "path" : ".",
                "parameters" : [ "-m elf_i386", "--oformat=elf32-i386"  ],
                "container_filename" : "uberspark_bridges.Dockerfile"
            },

            "params_prefix_lscript" : "-T",
            "params_prefix_libdir" : "-L",
            "params_prefix_lib" : "-l",
            "params_prefix_output" : "-o",

    		"cmd_generate_flat_binary" : "arm-linux-gnueabihf-objcopy -O binary"

        }
    }


.. note::   Here the Linker bridge type is defined to be a container and ``uberspark_bridges.Dockerfile``
            is the container dockerfile that includes the build for running GNU ld within an ``amd64`` 
            environment (e.g., ubuntu or alpine) and producing a 32-bit ELF binary. It also uses the 
            `objcopy` tool to generate flat-form binary image.


``uberspark-bridge-vf`` Manifest Node
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``uberspark-bridge-vf`` node within the |ubersparkmf| is used to describe a
verification bridge. The JSON declaration of the ``uberspark-bridge-vf`` node is 
as below:

.. json:object:: uberspark-bridge-vf

   :property bridge-hdr: the common bridge header declaration
   :proptype bridge-hdr: :json:object:`bridge-hdr`

   :property bridge_cmd: list of command line strings that will be executed towards verification. Note: environment variable ``$(SOURCE_C_FILES)`` contains space seperated list of C source files.
   :proptype bridge_cmd: string list

An example definition of the ``uberspark-bridge-vf`` node for the 
Frama-C verification framework, within |ubersparkmff| follows:


.. code-block:: JSON
    
    {
        "uberspark-manifest":{
            "namespace" : [ "uberspark-bridge-vf" ],
            "version_min" : "any",
            "version_max" : "any"
        },

        "uberspark-bridge-vf":{
            "bridge-hdr":{
                "category" : "container",
                "name" : "frama-c",
                "executable_name" : "frama-c",
                "dev_environment" : "amd64",
                "arch" : "generic",
                "cpu" : "generic",
                "version" : "v20.0",
                "path" : ".",
                "parameters" : [ ],
                "container_filename" : "uberspark-bridge.Dockerfile"
            },

            "bridge_cmd" : []
        }
    }


.. note::   Here the Frama-C verification bridge type is defined to be a container and ``uberspark_bridges.Dockerfile``
            is the container dockerfile that includes the build for running Frama-C within an ``amd64`` 
            environment (e.g., ubuntu or alpine)





.. _reference-manifest-uberspark-uobj:


``uberspark-uobj`` Manifest Node
---------------------------------

The ``uberspark-uobj`` node within the |ubersparkmf| is used to describe a |uobj|.
The JSON declaration of the ``uberspark-uobj`` node is as below:

.. json:object:: uberspark-uobj

    :property namespace: |uobj| namespace path as identified by |uberspark| 
    :proptype namespace: string

    :property arch: |uobj| target hardware platform 
    :proptype arch: string
    :options arch: "generic"

    :property arch: |uobj| target CPU architecture 
    :proptype arch: string
    :options arch: "x86_32"

    :property cpu: |uobj| target CPU model 
    :proptype cpu: string
    :options cpu: "generic"

    :property sources: |uobj| sources definition sub-node 
    :proptype sources: :json:object:`sources`

    :property public_methods: comma delimited |uobj| public methods declarations of the format: *"<publicmethod-name>" : [ "<publicmethod-return-type>", "<publicmethod-parameters-decl>", "<public_methods-numberof-parameters">]*
    :proptype public_methods: {}

    :property intra_uobjcoll_callees: comma delimited declarations of public methods of other |uobjs| that this |uobj| invokes within the same |uobjcoll|. The declarations are of the format: *"<uobj-namespace-path>" : [ "<publicmethod-1-name>", ..., "<publicmethod-n-name>"]*
    :proptype intra_uobjcoll_callees: {}

    :property inter_uobjcoll_callees: comma delimited declarations of public methods of other |uobjs| that this 
                                     |uobj| invokes across |uobjcoll|. The declarations are of the format:
                                     *"<uobjcoll-namespace-path>" : [ "<publicmethod-1-name>", ..., "<publicmethod-n-name>"]*
    :proptype inter_uobjcoll_callees: {}

    :property legacy_callees: comma delimited legacy |coss| function names that this |uobj| invokes 
    :proptype legacy_callees: string list


    :property uobjrtl: comma delimited list of |uobj| runtime library definition sub-nodes
    :proptype uobjrtl: :json:object:`uobjrtl` list

    :property sections: (optional) comma delimited list of |uobj| additional sections definition sub-nodes
    :proptype sections: :json:object:`sections` list


.. json:object:: sources

    :property h_files: comma delimited list of |uobj| header files 
    :proptype h_files: string list
    
    :property c_files: comma delimited list of |uobj| C source files 
    :proptype c_files: string list
 
    :property casm_files: comma delimited list of |uobj| CASM source files 
    :proptype casm_files: string list

    :property asm_files: comma delimited list of |uobj| Assembly source files 
    :proptype asm_files: string list


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

    :property prot: (optional) hexadecimal protection of the section 
    :proptype prot: string 
    :options prot: "0x0"

    :property aligned_at: (optional) hexadecimal alignment (in bytes) of the section 
    :proptype aligned_at: string 

    :property pad_to: (optional) hexadecimal padding boundary (in bytes) of the section 
    :proptype pad_to: string 

An example definition of the ``uberspark-uobj`` node for a sample |uobj| called ``add``, within |ubersparkmff| follows:

.. code-block:: JSON

    {
        "uberspark-manifest":{
            "namespace" : [ "uberspark-uobj" ],
            "version_min" : "5.1",
            "version_max" : "any"
        },

        "uberspark-uobj" : {
            "namespace" : "uberspark/uobjs/generic/test/add",
            "platform" : "generic",
            "arch" : "generic",
            "cpu" : "generic",

            "sources" : {
                "h_files": [ ],
                "c_files": [ "add.c" ],
                "casm_files": [ ],
                "asm_files": [ ]
            },
        
            "public_methods" : {
                "add" : [
                    "uint32_t",
                    "(uint32_t param1, uint32_t param2)", 
                    "2" 
                ],

                "inc" : [
                    "uint32_t",
                    "(uint32_t param1)", 
                    "1" 
                ],

            },

            "intra_uobjcoll_callees" : {
            "uberspark/uobjs/generic/test/uobj1": ["pm_one", "pm_two", "pm_three"],
            "uberspark/uobjs/generic/test/uobj2": ["pm_one"]
            },
        
            "inter_uobjcoll_callees": {
                "uberspark/uobjcoll/test" : ["pm_one" ]
            },
        
            "legacy_callees": [
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
    }



.. _reference-manifest-uberspark-uobjcoll:


``uberspark-uobjcoll`` Manifest Node
------------------------------------


The ``uberspark-uobjcoll`` node within the |ubersparkmf| is used to describe a |uobjcoll|.
The JSON declaration of the ``uberspark-uobjcoll`` node is as below:

.. json:object:: uberspark-uobjcoll

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

    :property sentinels-intrauobjcoll: type of intra-|uobjcoll| sentinel 
    :proptype sentinels-intrauobjcoll: string list
    :options sentinels-intrauobjcoll: "call"

    :property uobjs: list of |uobjs| within the |uobjcoll| 
    :proptype uobjs: :json:object:`uobjs`

    :property public_methods: comma delimited |uobjcoll| public methods declarations of the 
                             format: *"<uobj-namespace-path>" : { "<uobj-publicmethod-1-name>" : [ "<sentinel-type>", ..., "<sentinel-type>"], ... , "<uobj-publicmethod-n-name>" : [ "<sentinel-type>", ..., "<sentinel-type>"]}*
    :proptype public_methods: {}
    :options public_methods: <sentinel-type>="call"

 
.. json:object:: uobjs

    :property master: <uobj-namespace-path> of the master |uobj| within the |uobjcoll| 
    :proptype master: string 
    :options master: "", "<uobj-namespace-path>"
 
    :property templars: comma delimited list of <uobj-namespace-path> for all the templar |uobjs| within the |uobjcoll| 
    :proptype templars: string list
    :options templars: "", "<uobj-namespace-path>"
 
An example definition of the ``uberspark-uobjcoll`` node for a sample |uobjcoll| called ``test``, within |ubersparkmff| follows:

.. code-block:: JSON

    {

        "uberspark-manifest":{
            "namespace" : [ "uberspark-uobjcoll" ],
            "version_min" : "5.1",
            "version_max" : "any"
        },

        "uberspark-uobjcoll":{
            "namespace" : "uberspark/uobjcoll/generic/test",
            "platform" : "generic",
            "arch" : "generic",
            "cpu" : "generic",
            "hpl" : "any",
            "sentinels-intrauobjcoll" : [ "call" ],

            "uobjs" : {
                "master" : "",
                "templars" : [
                    "uberspark/uobjcoll/generic/test/main",
                    "uberspark/uobjs/generic/test/add"
                ]
            },

            "public_methods" : {
                "uberspark/uobjcoll/generic/test/main" : {
                    "main" : [ "call" ]
                },
                
                "uberspark/uobjs/generic/test/add" : {
                    "add" : [ "call" ]
                }
            }	

        }
    }



.. _reference-manifest-uberspark-uobjrtl:


``uberspark-uobjrtl`` Manifest Node
-----------------------------------

The ``uberspark-uobjrtl`` node within the |ubersparkmf| is used to describe a |uobjrtl|.
The JSON declaration of the ``uberspark-uobjrtl`` node is as below:

.. json:object:: uberspark-uobjrtl

    :property namespace: <uobjrtl-namespace-path> as identified by |uberspark| 
    :proptype namespace: string
    :options namespace: "<uobjrtl-namespace-path>"

    :property arch: |uobjrtl| target hardware platform 
    :proptype arch: string
    :options arch: "generic"

    :property arch: |uobjrtl| target CPU architecture 
    :proptype arch: string
    :options arch: "x86_32"

    :property cpu: |uobjrtl| target CPU model 
    :proptype cpu: string
    :options cpu: "generic"

    :property modules-spec: |uobjrtl| modules definition sub-node 
    :proptype modules-spec: :json:object:`modules-spec` list

.. json:object:: modules-spec

    :property module-path: <module-path> relative to the |uobjrtl| top-level source directory 
    :proptype module-path: string
    :options module-path: "src/<module-filename-with-path>"

    :property modules-funcdecls: |uobjrtl| modules function declarations 
    :proptype modules-funcdecls: :json:object:`modules-funcdecls` list


.. json:object:: modules-funcdecls

    :property funcname: canonical function name (See |contrib-guide-ref|:::ref:`contrib-guide-uobjrtl-srccontents`) 
    :proptype funcname: string


An example definition of the ``uberspark-uobjrtl`` node for the ``crt`` |uobjrtl|, within |ubersparkmff| follows:

.. literalinclude:: /../src-nextgen/uobjrtl/crt/uberspark.json
    :language: bash
    :linenos:

