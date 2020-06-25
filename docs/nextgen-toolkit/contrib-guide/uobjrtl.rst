.. include:: /macros.rst


.. _contrib-guide-uobjrtl-intro:

|uspark| |uobj| Runtime Libraries
=================================

The |uberspark| |uobj| runtime libraries consist of a set of library functions that a |uobj| can use to support
its functionality. The following sections describe how you can add a new |uobj| runtime library or new functions
within an existing |uobj| runtime library.

..  note::  See |genuser-guide-ref|:::ref:`reference-uobjrtl-intro` and |reference-uobjrtl-ref| for a description of 
            currently available |uobj| runtime libraries and associated function documentation.


.. _contrib-guide-uobjrtl-nsdirorg:

|uobjrtl| Namespace and Directory Layout
----------------------------------------

A |uobjrtl| namespace starts with the ``uberspark/uobrtl/`` prefix, followed by the name of the |uobjrtl|.
For example, the ``crt`` |uobjrtl| has the following namespace:

``uberspark/uobjrtl/crt``

A |uobjrtl| source directory is housed within ``src-nextgen/uobjrtl``.
For example, the ``crt`` |uobj| runtime library is housed under ``src-nextgen/uobjrtl/crt``.

Within the |uobj| runtime library top-level source directory, there are two sub-directories ``src`` and ``include``.
The ``src`` sub-directory houses the |uobj| runtime library source modules while the ``include`` sub-directory houses
the header files.

The organization within the ``src`` and ``include`` directories is left upto the library implementation, but must have
the same sub-directory tree structure. For example if the ``src`` directory contains no sub-directories, the ``include`` 
directory will house the top-level header. If the ``src`` directory contains a sub-directory ``src\test\`` which
houses the a hypothetical ``test`` module implementation (e.g., ``src\test\test.c``), then there is a corresponding ``include\test\`` directory that
houses the ``test`` module header (e.g., ``include\test\test.h``).


.. _contrib-guide-uobjrtl-hdrcontents:

|uobjrtl| Header-file Details
-----------------------------

An |uobjrtl| source module header filename can match the corresponding source file name or can named differently.
However, the header filename should always end with a ``.h`` suffix.

The header file contents should be embedded within the following prologue and
epilogue:

.. code-block: c

    #ifndef __UOBJRTL_<RTLNAME>__<RTLHEADERPATHSPEC>_H__
    #define __UOBJRTL_<RTLNAME>__<RTLHEADERPATHSPEC>_H__


    #endif /* __UOBJRTL_<RTLNAME>__<RTLHEADERPATHSPEC>_H__ */

Here ``<RTLNAME>`` is the name of the |uobjrtl| (e.g., crt), ``<RTLHEADERPATHSPEC>`` is the path specification
(delimited by ``_``) of the header file (sans the ``.h`` suffix). For example, for ``string.h`` within ``crt`` 
|uobjrtl|, the prologue and epilogue will are as shown below:

.. code-block: c

    #ifndef __UOBJRTL_CRT__STRING_H__
    #define __UOBJRTL_CRT__STRING_H__

    #endif /* __UOBJRTL_CRT__STRING_H__ */

Similarly, for the ``sha1.h`` header within the ``crypto`` |uobjrtl|, the following is the prologue and epilogue.

.. code-block: c

    #ifndef __UOBJRTL_CRYPTO__HASHES_SHA1_H__
    #define __UOBJRTL_CRYPTO__HASHES_SHA1_H__


    #endif /* __UOBJRTL_CRYPTO__HASHES_SHA1_H__ */

.. note::  The prologue and epilogue naming (__HASHES_SHA1_H__) in the above case follows the directory tree 
           of ``uobjrtl/crypto/include`` sub-directory (``uobjrtl/crypto/include/hashes/sha1/sha1.h``).


A |uobjrtl| header file can prevent contents from being available to Assembly language source modules via
the following construct:

.. code-block: c

    #ifndef __ASSEMBLY__

    #end /* __ASSEMBLY__ */


A |uobjrtl| header file must include declaration for all the functions that are described by the corresponding
collection of source modules.

.. note:: |uobjrtl| header file function declarations must not include special documentation comments 
          preceeding it (See :ref:`contrib-guide-uobjrtl-hdrsrccomments` below)



.. _contrib-guide-uobjrtl-srccontents:

|uobjrtl| Source-file Details
-----------------------------

An |uobjrtl| source module filename can be any name without the ``_`` or ``-`` characters.
A source module can define one or more functions which are named as follows:

``uberspark_uobjrtl_<RTLNAME>__<RTLSRCMODULEPATH>__<FNNAME>``

where ``<RTLNAME>`` is the |uobjrtl| name (e.g., crt), ``<RTLSRCMODULEPATH>`` is the  
is the path specification (delimited by ``_``) of the source file (sans the suffix), and
``<FNNAME>`` is the function name (e.g., memcpy).

.. note::   If ``<RTLSRCMODULEPATH>`` is an empty string, then the function name is as follows:
            ``uberspark_uobjrtl_<RTLNAME>__<FNNAME>``

For example, within the ``crt`` |uobjrtl| the ``memcpy.c`` source module is housed at 
``src-nextgen/uobjrtl/crt/memcpy.c`` and has the memory copy function with the following name:

``uberspark_uobjrtl_crt__memcpy``

For the ``crypto`` |uobjrtl| the ``sha1.c`` source module is housed at
``src-nextgen/uobjrtl/crypto/hashes/sha1/sha1.c`` and has the SHA-1 compress function with the following name:

``uberspark_uobjrtl_crypto__hashes_sha1__sha1_compress``

Every |uobjrtl| source module must include the corresponding header file that includes its declaration.
For example, ``uobjrtl/crt/memcmp.c`` defines the function ``uberspark_uobjrtl_crt__memcpy`` and includes:

.. code-block:: c
    
    #include <uberspark/uobjrtl/crt/include/string.h> 

where ``uberspark_uobjrtl_crt__memcpy`` is declared as follows:

.. code-block:: c
    
    unsigned char *uberspark_uobjrtl_crt__memcpy(unsigned char *dst, const unsigned char *src, size_t n);


Every function within a |uobjrtl| source module must be preceeded by a special documentation comment 
markup as described in the next section


.. _contrib-guide-uobjrtl-hdrsrccomments:

|uobjrtl| Header and Source Comments
------------------------------------

Special comments within the source and header files of the following types are solely reserved for 
documentation that is generated for the |uobjrtl|:

.. code-block: c

    /**

    */

or

.. code-block: c

    /**
    *
    */

The actual documentation format and tags are specified within :ref:`contrib-guide-docs-uobjrtl`.

.. note::   Any other comment style (e.g., ``//`` or ``/*   */``) will not make it into the documentation and 
            is solely intended for implementation level remarks.



.. _contrib-guide-uobjrtl-adduobjrtl:

Adding a new |uobjrtl|
----------------------

1.  Choose a namespace: ``uberspark/uobjrtl/<RTLNAME>`` where ``RTLNAME`` is the name of the |uobjrtl|. 
    The selected name should not conflict with previous libs and should be a single word without ``_`` or ``-``.

2.  Create |uobjrtl| directory and directory structure as described in :ref:`contrib-guide-uobjrtl-nsdirorg` 

3.  Add |uobjrtl| source modules and headers following content rules as described in :ref:`contrib-guide-uobjrtl-hdrcontents`
    and :ref:`contrib-guide-uobjrtl-srccontents`

4.  Add the JSON |ubersparkmf| named |ubersparkmff| which describes the |uobjrtl|. An example for 
    the ``crt`` |uobjrtl| is shown below:

    .. literalinclude:: /../src-nextgen/uobjrtl/crt/uberspark.json
        :language: bash
        :linenos:

    .. seealso:: |reference-manifest-ref|:::ref:`reference-manifest-uberspark-uobjrtl`

5.  Modify ``docs/conf.py`` (See :ref:`contrib-guide-docs-intro`) to add the new |uobjrtl| XML documentation
    sources within the variable ``breathe_projects``. Use the format
    ``"uobjrtl-<RTLNAME>": "_build/breathe/doxygen/uobjrtl-<RTLNAME>/xml/"`` where ``<RTLNAME>`` is the name of the
    |uobjrtl| (e.g., crt).

    
6.  Modify ``docs/conf.py`` (See :ref:`contrib-guide-docs-intro`) to add the new |uobjrtl| 
    sources and headers within the variable ``breathe_projects_source``. Use the format
    ``"uobjrtl-<RTLNAME>": ( "../src-nextgen/uobjrtl/<RTLNAME>", ["src/file1.c", ..., "include/file1.h", ...])``
    where ``<RTLNAME>`` is the name of the |uobjrtl| (e.g., crt) and the values are all the source modules and
    headers. An example for the ``crt`` |uobjrtl| is given below:

    .. code-block:: python

        breathe_projects_source = {
        "uobjrtl-crt" : ( "../src-nextgen/uobjrtl/crt", ["src/memcmp.c", 
                                                        "src/memcpy.c",
                                                        "src/memmove.c",
                                                        "src/memset.c",
                                                        "src/strchr.c",
                                                        "src/strcmp.c",
                                                        "src/strlen.c",
                                                        "src/strncmp.c",
                                                        "src/strncpy.c",
                                                        "src/strnlen.c",
                                                        "include/string.h",
                                                        "include/stdint.h"] )
        }




Modifying an existing |uobjrtl|
-------------------------------

1.  Add or delete a given source or header module within the |uobjrtl| directory structure as 
    described in :ref:`contrib-guide-uobjrtl-nsdirorg`

2.  Update the JSON |ubersparkmf| named |ubersparkmff| which describes the |uobjrtl|. 
    See :ref:`contrib-guide-uobjrtl-adduobjrtl` for further details.

3.  Modify ``docs/conf.py`` (See :ref:`contrib-guide-docs-intro`) to add or remove the |uobjrtl| 
    sources and headers within the variable ``breathe_projects_source``. 
    See :ref:`contrib-guide-uobjrtl-adduobjrtl` for details on the format of the ``breathe_projects_source`` variable.






