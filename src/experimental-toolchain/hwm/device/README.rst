home for various supported devices and their internal state modeling (e.g., what the device does in response
to a particular input). interacts with ``arch-cpu`` via a general device interface abstraction

folders here are of the form:

``device-class``
    type of function that the device performs (e.g., network controller)

    ``device-subclass``
        specific functionality of the device (e.g., ethernet controller)

        ``device-vendor``
            vendor name of the device (e.g., marvell)

            ``device-id``
                specific id or instance of the device (e.g., marvel ppv2)