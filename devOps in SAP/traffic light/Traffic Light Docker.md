# Traffic Light Docker

## Explore Experience

#### Build the docker image

1. Pull base ubuntu image(use Shanghai Regional Cache)

   `docker pull saas-docker-pvg.pvgl.sap.corp/base/ubuntu:16.04`

2. Create a container and get into it

   ~~` docker run --rm -it [IMAGE ID] /bin/bash`~~

   ` docker run --rm -it --privileged [IMAGE ID] bin/bash `

3. Configure the light drive environment

   * Download the newest packaged "clewarecontrol-4.4.tgz" and copy to your container and extract it

     ` docker cp /root/clewarecontrol-4.4.tgz [CONTAINER ID]:/usr/local`

     ` gunzip -c clewarecontrol-4.4.tgz | tar xvf -`

   * Install two necessary libraries

     ` apt-get install libhidapi-dev pkg-config`

   * Navigate into the folder and make the project

     ` make install`

   * Verify by list all connected cleware USB devices

     `clewarecontrol -l`

4. Check whether the lights work

   switch to your `clewarecontrol-4.4/examples/ampel` directory and execute the script

   ` ./script.sh`

   and you will see the light turning on

5. Install python 3.6 and set alias for it

   `add-apt-repository ppa:deadsnakes/ppa`

   `apt update`

   `apt install python3.6`

   switch to **/usr/bin**

   `alias python=python3.6`

6. Install pip for python3.6

   ` curl https://bootstrap.pypa.io/get-pip.py | python3.6`

7. Clone the PiLight Project from github

   ` https://github.wdf.sap.corp/i343687/PiLights.git`

8. Make the DockerFile

   ` docker build -t [image_name]:[version] .`

9. Start the container 

   ` docker run --privileged -d [image_name]:[version]`

#### Construct private docker registry

1. pull the registry image

   ` docker pull registry`

2. start the docker container 

   ` docker run -d -p 5000:5000 --restart=always --name=registry-srv -v /data/dockerRegistry:/var/lib/registry registry`

## Solution to Some Errors

1. **add-apt-repository: command not found**->run the command:

   ` apt-get update` 

   `apt-get install software-properties-common`

2. **make: command not found**->run the command:

   ` apt-get install build-essential`

## Operations

1. Delete docker containers with Exited status

   ` docker rm 'docker ps -a|grep Exited|awk '{print $1}''`

2. Access into a running container

   ` docker exec -it [container_id] /bin/bash`