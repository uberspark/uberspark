.. include:: /macros.rst


.. _contrib-guide-docs-intro:

|uspark| Documentation
======================

The |uberspark| documentation makes use of Sphinx (with restructured text) at a high-level.
We also use Breathe and Doxygen in order to automatically pull in documentation from C and
Assembly language code (e.g., |uobj| runtime libraries, sentinels etc.).


.. note::   The high level documentation build is controlled by ``docs/conf.py``, the Sphinx documentation
            build configuration file. 
            See `Sphinx Configuration File <https://www.sphinx-doc.org/en/master/usage/configuration.html>`_



.. _contrib-guide-docs-uobjrtl:

|uobj| Runtime Library Functions
--------------------------------

Every |uobj| runtime library function definition must have a special block comment just before
the definition that describes certain important elements of the function. This is parsed by
Breathe and Doxygen in order to bring in relevant function documentation. 

As an example let us consider the function :cpp:func:`uberspark_uobjrtl_crt__memcpy` and its
block comment just before its definition:

.. code-block:: c
   
    /** 
    * @brief Copy block of memory
    * 
    * @param[out] dst Pointer to the destination memory block where the content is to be copied, type-casted to a pointer of type void*
    * @param[in] src Pointer to the source of data to be copied, type-casted to a pointer of type const void*
    * @param[in] n Number of bytes to copy
    * 
    * @retval dst is returned
    *  
    * @details_begin 
    * Copies the values of ``n`` bytes from the location pointed to by ``src`` directly to the memory block pointed to 
    * by ``dst``. The underlying type of the objects pointed to by both the source and destination pointers are irrelevant for 
    * this function; The result is a binary copy of the data.
    * @details_end
    *
    *  @uobjrtl_namespace{uberspark/uobjrtl/crt}
    * 
    * @headers_begin 
    * #include <uberspark/uobjrtl/crt/include/string.h>
    * @headers_end
    * 
    * @comments_begin
    * The size of the blocks pointed to by both the ``dst`` and ``src`` parameters, shall be at least ``n`` bytes, and should not 
    * overlap. The function does not check for any terminating null character in ``src`` - it always copies exactly ``n`` bytes.
    * 
    * .. note:: Functional correctness specified
    * @comments_end
    * 
    * 
    */


We now dicuss the Doxygen tags as used in the above block comment definition. They fall into two groups: required and
optional tags

Describe required tags as list

Describe optional tags as list

