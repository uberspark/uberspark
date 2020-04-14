namespace for various supported uobj and uobj collection sentinels.

the name space organization is as follows:

``platform``
    this namespace node organization is the same as that of ``hwm/platform`` namespace node with
    entries corresponding to the development recipes

``cpu``
    this namespace node organization is the same as that of ``hwm/cpu`` namespace node with entries
    corresponding to the development receipies

the leaf nodes of the above namespace tree contain a sentinel node with the following 
general organization:

``sentinel_name``
    name of the sentinel (e.g., call) and has the following files:
    - sentinel implementation
    - sentinel manifest which includes sentinel size, platform and cpu details and dependencies

example namespace node:

``call`` sentinel running on a generic platform and a generic x86 32-bit cpu architecture will be
housed under:

``cpu/x86_32/generic/call``

