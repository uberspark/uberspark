namespace for various supported architecture and CPU specific instruction level hardware 
modeling, including a general device interface abstraction to integrate device level modeling

general form of a namespace node here:

``cpu-arch``
    where cpu-arch is the name of the processor architecture and revision/qualifier (e.g., armv8_32, x86, x86_32)

    ``cpu-type``
        where cpu-type is the processor type specific (e.g., generic, cortex_a53, intel, amd)

example namespace node:

``x86``
    generic x86 architecture specific hardware modeling of instructions
    that have the same semantics regardless of 32-bit or 64-bit

    ``generic``
        specific hardware modeling of instructions common to both Intel and AMD x86 architecture
        that have the same semantics regardless of 32-bit or 64-bit

    ``intel``
        specific hardware modeling of instructions for Intel x86 architecture
        that have the same semantics regardless of 32-bit or 64-bit