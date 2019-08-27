home for supported target (a ``platform`` consisting of a set of ``devices``and ``cpus``) platform
configurations.

binding rules:

- platform includes set of cpus and devices
- platform can have different cpus of different architectures
- devices and cpus are independent and can be part of multiple platforms

this folder is organized as below:

``platform``.json
    for each ``platform`` within ``hwm/platform`` which includes the aforementioned binding rules for 
    platform specific cpus and devices


