# CompCert 3.1 Compiler Docker Container

The contents of this folder will build a CompCert 3.1 compiler that can be run
from within a container.

The container should build for you, using just the contents of this directory.
The basic requirements are:

* Recent version of Docker
* Internet connection for downloading dependencies

Log off any VPN before running the build. When the build completes, you can run
the new container with:

```
docker run -it -u ubuntu <CONTAINER_ID> /bin/bash
```

No docker-compose is provided at this time. You can exit the container shell by
typing `exit`. If you want to run this container again, this can be done using
a sequence similar to the following:

```
docker container ps -a

CONTAINER ID     IMAGE                  COMMAND                  CREATED          STATUS        NAMES
<CONTAINER_ID>   <IMAGE_ID>   "/bin/bash"              15 minutes ago   Exited (0)    wonderful_cori
<CONTAINER_ID>   <IMAGE_ID>   "-u ubuntu /bin/bash"    15 minutes ago   Created       serene_hypatia

docker start <CONTAINER_ID>
<CONTAINER_ID>

docker ps
CONTAINER ID     IMAGE                  COMMAND                  CREATED          STATUS        NAMES
<CONTAINER_ID>   <IMAGE_ID>   "/bin/bash"              16 minutes ago   Up 3 seconds  wonderful_cori

docker exec -it -u ubuntu <CONTAINER_ID> /bin/bash
```

Notice how we identify the container we want to start by its container ID. With
the ID, start the container, check that it's ready, then log into it using the
exec command and the container ID.
