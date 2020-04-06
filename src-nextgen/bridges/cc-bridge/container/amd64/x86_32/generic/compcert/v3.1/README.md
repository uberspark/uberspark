# CompCert 3.1 Compiler Docker Container

The contents of this folder will build a CompCert 3.1 compiler that can be run
from within a container.

The container should build for you, using just the contents of this directory
and a Fish shell. If you don't have Fish shell, you can get it from here:

[Fish Shell](https://fishshell.com)

The build process will kick off with:

```
./container_build.fish
```

This command sets up the build context for the Docker build and actually calls
docker build. If you are missing pre-reqs, the script will tell you, but the
basic requirements are:

* Recent version of Docker
* Internet connection for downloading dependencies

The scripts are set up to handle normal proxy issues, in case you are behind a
proxy. However, the Docker build will fail if you are connected to the SEI VPN,
due to a routing restriction. Thus, log off the VPN before running the build.
When the build completes, it will tag the new container and add it to your
local Docker container store. You can run this new container with:

```
docker run -it -u ubuntu compcert-v3.1:latest /bin/bash
```

No docker-compose is provided at this time. You can exit the container shell by
typing `exit`. If you want to run this container again, this can be done using
a sequence similar to the following:

```
docker container ps -a

CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS        NAMES
964d656535cf   compcert-v3.1:latest   "/bin/bash"              15 minutes ago   Exited (0)    wonderful_cori
42aa3386d41e   compcert-v3.1:latest   "-u ubuntu /bin/bash"    15 minutes ago   Created       serene_hypatia

docker start 964d656535cf
964d656535cf

docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS        NAMES
964d656535cf   compcert-v3.1:latest   "/bin/bash"              16 minutes ago   Up 3 seconds  wonderful_cori

docker exec -it -u ubuntu 964d656535cf /bin/bash
```

Notice how we identify the container we want to start by its container ID. With
the ID, start the container, check that it's ready, then log into it using the
exec command and the container ID.


This container is a work-in-progress. Please use it and provide feedback, as
needed. The container will be integrated with the UberSpark framework, once it
is ready and has been tested.
