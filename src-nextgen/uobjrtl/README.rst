namespace for various library functions that can be used by a uobject (e.g., hardware related,
c runtime and crypto)

top-level folders are:

``hw``
    namespace for uobject hardware runtime libraries which provides an interface to platform hardware

``crt``
    namepace for uobject C runtime library providing basic facilities such as memory and string manipulation

    organization of this folder is as below:

    ``include``
        header files for c runtime library (e.g., stdint.h, string.h)

    ``modulename.c``
        implementation of the c runtime library (e.g., memcpy.c, memcmp.c

``crypto``
    namepace for uobject crypto runtime library providing basic crypto facilities including ciphers, hashes etc.
