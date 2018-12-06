# Docker

### Practical Exercise

**compose Dockerfile**

```markdown
# Base image ubuntu16.04
FROM <baseImage>:<version>
# you can find images in [Docker Hub](https://hub.docker.com/)
MAINTAINER <maitainer-name> <maitainer-mail>

# Configure your enviroment
ADD <local-file-path> <target-path>
# Use ADD to copy your local files into docker

WORKDIR <docker-path>
# use WORKDIR to define the directory in docker for command executing

RUN apt-get update
# use RUN to execute shell scripts in WORKDIR

# start monitor
CMD python m.py
# use CMD to set your mount option when run a docker
```

### docker jenkins

1. Enabling Docker Remote API

   ````shell
   # create /etc/docker/daemon.json if not exists
   touch /etc/docker/daemon.json
   # add the contents into it
   # {
   #    "hosts": [
   #        "tcp://0.0.0.0:2375",
   #        "unix:///var/run/docker.sock"
   #    ]
   # }
   # restart docker service
   sudo systemctl daemon-reload
   sudo systemctl restart docker
   # test whether it works
   curl http://localhost:2375/version
   # {"Version":"17.09.1-ce","ApiVersion":"1.32","MinAPIVersion":"1.12","GitCommit":"19e2cf6","GoVersion":"go1.8.3","Os":"linux","Arch":"amd64","KernelVersion":"4.10.0-35-generic","BuildTime":"2017-12-07T22:23:00.000000000+00:00"}
   ````

### recommended tutorials

1. [Docker 入门教程](http://www.ruanyifeng.com/blog/2018/02/docker-tutorial.html)

