namespace for various supported architecture and CPU specific instruction level hardware 
modeling, including a general device interface abstraction to integrate device level modeling

general form of a namespace node here:

``cpu-arch``
    where cpu-arch is the name of the processor architecture (e.g., arm, x86)

    ``cpu-subarch``
        where cpu-subarch is a processor architecture revision/qualifier (e.g., armv8_32, x86_32)

        ``cpu-type``
            where cpu-type is the processor type specific (e.g., generic, cortex_a53, intel, amd)

example namespace node:

``arm``
    ARM architecture
    contains namespace development recipe (e.g., armv8_32-cortex_a53)

    ``common``
        common ARM cpu architecture

    ``armv8_32``
        ARMv8 32-bit cpu architecture

        ``generic``
            generic ARMv8 32-bit cpu architecture

        ``cortex_a53``
            cortext_a53 specific ARMv8 32-bit cpu architecture

    ``armv7_32``
        ARMv7 32-bit cpu architecture
