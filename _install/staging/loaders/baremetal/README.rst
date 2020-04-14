namespace for baremetal environment uobj runtime loaders (e.g., grub, uboot)

example namespace node organization:

``vcldr``
    namespace for vccore based baremetal loader
    it can have its unique set of inputs (e.g., uobj collection manifest, vcldr version pinning etc.)
    it will produce its unique set of outputs  (e.g., consolidated image)
    it will select one or more of the following components based on inputs

    ``common`` 
        this folder will contain vcldr version and platform agnostic logic

    ``vx.y.z``
        version x.y.z specific 

    ``platform``
        this folder will contain subfolders that has to exist within ``targets/``
        for example, below:
        
        ``rpi3_32``
            for raspberry pi3 32-bit platform
