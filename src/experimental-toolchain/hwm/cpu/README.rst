home for various supported architecture and CPU specific instruction level hardware modeling,
including a general device interface abstraction to integrate device level modeling

folders here are of the form:

``cpu-arch``
    where cpu-arch is the name of the processor architecture (e.g., arm, x86)

    ``cpu-subarch``
        where cpu-subarch is a processor architecture revision/qualifier (e.g., armv8_32, x86_32)

        ``cpu-type``
            where cpu-type is the processor type specific (e.g., generic, cortex_a53, intel, amd)
