namespace for supported hardware computing platform configurations.

platform configuration rules:

- platform includes set of cpus and devices
- platform can have different cpus of different architectures
- devices and cpus are independent and can be part of multiple platforms

namespace node organization:

``platform``.json
    for each ``platform`` within ``hwm/platform`` which includes the aforementioned binding rules for 
    platform specific cpus and devices


