namespace for uberSpark hardware model specifications toward verifying uobject mediated/accessed platform
hardware states

``cpu``
    various supported architecture and CPU specific instruction level hardware modeling,
    including a general device interface abstraction to integrate device level modeling

``device``
    various supported devices and their internal state modeling (e.g., what the device does 
    in response to a particular input). interacts with ``cpu`` via a general device interface abstraction

``platform``
    device agnostic platform-level modeling. e.g., for pc platform BIOS and option 
    ROM functionality.