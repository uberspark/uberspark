.. include:: /macros.rst

.. _cossdev-guide-use-uobjrtl:

Using |uobj| Runtime Libraries
==============================

|uobjs| can use pre-defined library functions to support their functionality. Examples of such functions include
basic C runtime support type definitions (e.g., ``int32_t``) as well as memory, string and crypto functions.

.. note::   See |reference-uobjrtl-ref| for further details on the various libraries 
            currently supported and available type definitions and functions.


|uobj| runtime libraries are brought into the current scope via ``#include`` directives within the source code.
The include namespace starts with the following prefix:

 ``uberspark/uobjrtl/<uobjrtl-name>/include/<uobjrtl-specific>``


Here ``<uobjrtl-name>`` is the name of the |uobjrtl| (e.g., crt, crypto, see |reference-uobjrtl-ref|). 
``<uobjrtl-specific-path>`` is the folder path specific to the |uobjrtl|.

For example, 

.. code-block:: c
   
   #include <uberspark/uobjrtl/crt/include/string.h> 


will bring in string and memory function declarations from the C runtime library (crt) within the scope of the 
|uobj| source code.


.. note::  |uobj| runtime library header inclusions must come after ``uberspark`` framework headers 
            (e.g., ``uberspark/include/uberspark.h``). 
            
.. seealso::   See also :ref:`cossdev-guide-create-uobjs`


The exact include header path can be found within the \` Header(s) \` field for the function that is being used. 
For example, if the |uobj| wishes to use the :cpp:func:`uberspark_uobjrtl_crypto__ciphers_aes__rijndael_ecb_decrypt()`
for AES descryption functionality, the `Headers(s)` field in the documentation of the above function mandates the
inclusion of the following header within the |uobj| source code:

.. code-block:: c
   
   #include <uberspark/uobjrtl/crypto/include/ciphers/aes/aes.h>


As a final step, the |uobj| manifest needs to include a ``uobjrtl`` manifest sub-node within the ``uberspark-uobj``
manifest node. See |reference-manifest-ref|:::ref:`reference-manifest-uberspark-uobj` for further details on the 
``uobjrtl`` sub-node definition.

Thus, for an |uobj| using the function :cpp:func:`uberspark_uobjrtl_crypto__ciphers_aes__rijndael_ecb_decrypt()` as
described above, we would need to add the ``crypto`` |uobjrtl| namespace in the |uobj| manifest 
(in addition to other nodes as described in :ref:`cossdev-guide-create-uobjs`) as below:


.. code-block:: json

   {
      "uberspark.uobj.uobjrtl" : [
            {
               "namespace" : "uberspark/uobjrtl/crypto"
            }
      ]
   }


..  note::  The |uobj| runtime library namespace for a given function can be found within the 
            \` |uobjrtlshort| Namespace \` field in the corresponding function documentation (See |reference-uobjrtl-ref|)
            
