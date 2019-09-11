namespace for linux OS specific uobj runtime loaders (e.g., linux user and kernel mode)

namespace organization:

``backends``
    backend abstraction implementations for generic as well as specific linux kernel versions

``common``
    commond linux support routines

``kmode``
    linux kernel mode loader; uses backend abstraction

``umode``
    linux user mode loader; uses backend abstraction


namespace build:

- it can have its unique set of inputs (e.g., uobj collection manifest, version pinning etc.)
- it will produce its unique set of outputs  (e.g., static library, executable)
- it will select one or more of the following components based on inputs
