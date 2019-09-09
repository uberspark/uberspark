.. include:: ../macros.hrst

Software Requirements and Dependencies
======================================

The |uspark| toolkit relies on the ``docker`` independent container platform, with the goal of supporting a wide variety of CoSS 
development environments and architectures (e.g., Ubuntu, Debian, Fedora, Windows WSL. etc.). The toolkit
has the following pre-requisites:

-   a x86_64 Linux-based development environment (e.g., Ubuntu). This can be a baremetal 
    system, a VM or Windows Subsystem for Linux.
-   the ``docker`` independent container platform (see https://docker.com)
-   a ``make`` utility capable of reading Makefiles with ``GNU make`` compatible syntax.  


.. _swreqs_dockerbaremetal:

Docker Installation on Baremetal System or VM
---------------------------------------------

If you are using a baremetal system or VM you can use the official docker installation 
guide as your reference:

https://docs.docker.com/install/

The docker installation guide covers all the necessary steps required to install the Docker-CLI and 
Docker-daemon on a variety of Linux platforms such as Ubuntu, Debian, Fedora etc.

For example, on Ubuntu 18.04 LTS x86_64 you need to execute the following commands in a terminal:

::

    # Update the apt package list.
    sudo apt-get update -y

    # Install Docker's package dependencies.
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

    # Download and add Docker's official public PGP key.
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Verify the fingerprint.
    sudo apt-key fingerprint 0EBFCD88

    # Add the `stable` channel's Docker upstream repository.
    # You can change `stable` below to `test` or `nightly` if you prefer living on the edge!
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

    # Update the apt package list (for the new apt repo).
    sudo apt-get update -y

    # Install the latest version of Docker CE.
    sudo apt-get install -y docker-ce

    # Allow your user to access the Docker CLI without needing root access.
    sudo usermod -aG docker $USER

At this point you must close your terminal and open a new one so that you can run
Docker without sudo. 


Docker Installation on Windows Subsystem for Linux
--------------------------------------------------

If you are using Windows Subsystem for Linux (WSL), then as a first step you need to
install the Docker Desktop on Windows as described in the link below:

https://docs.docker.com/docker-for-windows/install/

When the docker installation wizard starts up be sure to ``uncheck`` the checkbox
prompt: *use Windows containers instead of Linux Containers*. This will allow Docker
to use Linux Containers within a Hyper-V light-weight VM.

After Docker installs successfully, and the Docker Desktop application starts up,
right-click on the Docker Desktop tray icon. Then proceed to 
click ``Settings``-> ``General`` and ``check`` the 
*expose daemon on tcp://localhost:2375 without TLS* option. 

You may also want to share any drives you plan on having your source
code on. This can be accomplished via ``Settings``--> ``Shared Drives`` dialog.

At this point, you need to start a WSL instance and install Docker as
described in the previous section: :ref:`swreqs_dockerbaremetal`.

The next step is to configure WSL so that it knows how to connect to the remote Docker 
daemon running in Docker for Windows (listening on port 2375). This can be done 
with a one-liner within the WSL terminal as shown below:

::

    echo "export DOCKER_HOST=tcp://localhost:2375" >> ~/.bashrc && source ~/.bashrc

The above command just adds the export line to your .bashrc file so it’s available every 
time you open your WSL terminal.

.. note:: The source command in the one-liner above reloads your bash configuration so you do not
          have to open a new terminal right now for it to take effect.


GNU Make Installation
---------------------

You can install GNU Make within a terminal (baremetal, VM or WSL) using your distribution 
specific method. For example, on Ubuntu and Debian based distributions you would use:

::

    sudo apt-get update
    sudo apt-get -y install make

