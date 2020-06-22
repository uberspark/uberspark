.. include:: /macros.rst


.. _contrib-guide-uobjrtl-intro:

|uspark| |uobj| Runtime Libraries
=================================

The |uberspark| |uobj| runtime libraries consist of a set of library functions that a |uobj| can use to support
its functionality. The following sections describe how you can add a new |uobj| runtime library or new functions
within an existing |uobj| runtime library.

..  note::  See |genuser-guide-ref|:::ref:`reference-uobjrtl-intro` and |reference-uobjrtl-ref| for a description of 
            currently available |uobj| runtime libraries and associated function documentation.


Namespace and Directory organization
------------------------------------

|uobj| runtime library source directory is housed within ``src-nextgen/uobjrtl`` under the source root folder.
For example, the ``crt`` |uobj| runtime library is housed under ``src-nextgen/uobjrtl/crt``.

Within the |uobj| runtime library top-level source directory, there are two sub-directories ``src`` and ``include``.
The ``src`` sub-directory houses the |uobj| runtime library source modules while the ``include`` sub-directory houses
the header files.

The organization within the ``src`` and ``include`` directories is left upto the library implementation, but must have
the same sub-directory tree structure. For example if the ``src`` directory contains no sub-directories, the ``include`` 
directory will house the top-level header. If the ``src`` directory contains a sub-directory ``src\test\`` which
houses the a hypothetical ``test`` module implementation (e.g., ``src\test\test.c``), then there is a corresponding ``include\test\`` directory that
houses the ``test`` module header (e.g., ``include\test\test.h``).


Header-file Name and Contents
------------------------------

An |uobj| source module header filename can match the source file name or can be a different name.
However, the header filename should always end with a ``.h`` suffix.

The header file contents should be embedded within the following prologue and
epilogue:

#ifndef __UOBJRTL_<RTLNAME>__<RTLHEADERPATHSPEC>_H__
#define __UOBJRTL_<RTLNAME>__<RTLHEADERPATHSPEC>_H__


#endif /* __UOBJRTL_<RTLNAME>__<RTLHEADERPATHSPEC>_H__ */

Here ``<RTLNAME>`` is the name of the |uobj| runtime library (e.g., crt), ``<RTLHEADERPATHSPEC>`` is the path specification
(delimited by ``_``) of the header file (sans the ``.h`` suffix). For example, for ``string.h`` within ``crt`` |uobj| runtime
library, the prologue and epilogue will be as below:

#ifndef __UOBJRTL_CRT__STRING_H__
#define __UOBJRTL_CRT__STRING_H__

#endif /* __UOBJRTL_CRT__STRING_H__ */

For the ``sha1.h`` header within the ``crypto`` |uobj| runtime library, the following is the prolgue and epilogue that
follows the directory tree of ``uobjrtl/crypto/include`` sub-directory.

#ifndef __UOBJRTL_CRYPTO__HASHES_SHA1_H__
#define __UOBJRTL_CRYPTO__HASHES_SHA1_H__


#endif /* __UOBJRTL_CRYPTO__HASHES_SHA1_H__ */

Can prevent sections that should be masked from assembly language source modules via

#ifndef __ASSEMBLY__

#end /* __ASSEMBLY__ */


header must include declaration for the function that is described by a collection of source modules.
These declarations must not include special documentation comments preceeding it (see comments below)



Source-file Name and Contents
------------------------------

An |uobj| source module filename can be any name without the ``_`` or ``-`` characters.
A source module can define one or more functions which are named as follows:

uberspark_uobjrtl_<RTLNAME>__<RTLSRCMODULEPATH>__<FNNAME>

where ``<RTLNAME>`` is the |uobj| runtime library name, ...

For example, memcpy.c module and the function it defines

Another example is sha1


Every source module must include the corresponding header file that includes its declaration.

For example, ``uobjrtl/crt/memcmp.c`` includes:

#include <uberspark/uobjrtl/crt/include/string.h> 

where memcpy is declared.

sha1 example

Every function within the source module must be preceded by a special documentation comment 
markup as described in the next section



Header and Source comments
--------------------------

Special comments within the source and header files of the following types are solely reserved for 
documentation that is generated for the |uobj| runtime library:

/**

*/

or

/**
 *
 */

See documentation of library functions ref in docs

Any other comment style (e.g., ``//`` or ``/*   */``) will not make it into the documentation and 
is solely intended for implementation level remarks.






