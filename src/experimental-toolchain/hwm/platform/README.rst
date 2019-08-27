namespace for cpu and device agnostic platform-level modeling. 
e.g., for pc platform, the BIOS and option ROM functionality.

example namespace node:

``pc``
    PC computing platform
    contains namespace development recipe (e.g., pc_32 or pc_64)

    ``common``
        common pc platform modeling

    ``pc_16``
        pc 16-bit computing platform

    ``pc_32``
        pc 32-bit computing platform
        includes logic within ``common``

    ``pc_64``
        pc 64-bit computing platform
        includes logic within ``common``