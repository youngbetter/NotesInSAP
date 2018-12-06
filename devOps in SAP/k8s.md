# K8S

[TOC]

## set up jenkins on k8s step by step

### preparation

before setting up jenkins on kubernetes, we need a k8s cluster established at the very first. 

### set up local private docker image registry

* please refer to [Deploy a registry server](https://docs.docker.com/registry/deploying/).
* k8s cluster information

| role       | **ip**    |
| ---------- | --------- |
| k8s-master | ip-master |
| k8s-node1  | ip-node1  |
| k8s-node2  | ip-node2  |

* make customized docker image:

  Dockerfile

  ```dockerfile
  from jenkins/jenkins:latest
  
  # Distributed Builds plugins
  RUN /usr/local/bin/install-plugins.sh ssh-slaves
  
  # install Notifications and Publishing plugins
  RUN /usr/local/bin/install-plugins.sh email-ext
  RUN /usr/local/bin/install-plugins.sh mailer
  RUN /usr/local/bin/install-plugins.sh slack
  
  # Artifacts
  RUN /usr/local/bin/install-plugins.sh htmlpublisher
  
  # UI
  RUN /usr/local/bin/install-plugins.sh greenballs
  RUN /usr/local/bin/install-plugins.sh simple-theme-plugin
  
  # Scaling
  RUN /usr/local/bin/install-plugins.sh kubernetes
  
  # install Maven
  USER root
  RUN apt-get update && apt-get install -y maven
  USER jenkins
  ```

  build image

  ` docker build -t <ip-master>:<port>/my-jenkins-image .`

  push image to local registry

  ` docker push <ip-master>:<port>/my-jenkins-image `

* http error solution

  there is a problem when use local image registry:

  example:

  local docker registry has been deployed on k8s-master, and now I want to pull docker image on k8s-node1, maybe we will encounter this error:

  `Error response from daemon: ******:http: server gave HTTP response to HTTPS client.`

  that's because in new edition of docker, https is mandatory.

  solution is to add the following configuration and restart docker:

  ```json
  # on k8s-node1 && k8s-node2
  # /etc/docker/daemon.json
  {
    "insecure-registries": ["<ip-master>:<port>"]
  }
  ```

### compose yaml

1. jenkins-deployment.yaml

   ```yaml
   apiVersion: extensions/v1beta1
   kind: Deployment
   metadata:
     name: jenkins
     namespace: nick
   spec:
     replicas: 1
     template:
       metadata:
         labels:
           app: jenkins
       spec:
         containers:
           - name: jenkins
             image: <ip-master>:<port>/jenkins-master:latest
             imagePullPolicy: IfNotPresent
             env:
               - name: JAVA_OPTS
                 value: -Djenkins.install.runSetupWizard=false
             ports:
               - name: http-port
                 containerPort: 8080
               - name: jnlp-port
                 containerPort: 50000
             volumeMounts:
               - name: jenkins-home
                 mountPath: /var/jenkins_home
         volumes:
           - name: jenkins-home
             emptyDir: {}
   ```

   * kind

     the main option that presents the purpose of this yaml file

   * metadata

     * namespace

       different namespaces offer isolated workspace

       create namespace before used

       * create a yaml for namespace

         ```yaml
         # nick_namespace.yaml
         apiVersion: v1
         kind: Namespace
         metadata:
           name: nick
         ```

       * apply yaml

         ```shell
         kubectl apply -f nick_namespace.yaml
         kubectl get namespaces
         ```

   * spec

     * containers

       a section containing all the containers that should be run within the specified deployment

       * image

         a Docker image that will be used to spin up the container

       * ports

         sections with ports that will be forwarded outside the containers

       * volumeMounts

         shows the path by which we will mount the volume to persist the data inside the container

     * volumes

2. jenkins-service.yaml

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: jenkins
     namespace: nick
   spec:
     type: NodePort
     ports:
       - port: 8080
         name: "http-port"
         nodePort: 30000
         targetPort: 8080
       - port: 50000
         name: "jnlp-port"
         nodePort: 30010
         targetPort: 50000
     selector:
       app: jenkins
   ```

   * spec

     * type

       * NodePort

         enable access the service from outside network by mapping the container port to host port

     * **Port**: Port is the port number which makes a [service](https://kubernetes.io/docs/concepts/services-networking/service/) visible to other services running within the same K8s cluster.  In other words, in case a service wants to invoke another service running within the same Kubernetes cluster, it will be able to do so using port specified against “port” in the service spec file.

     * **Target Port**: Target port is the port on the POD where the service is running.

     * **Node Port**: Node port is the port on which the service can be accessed from external users using [Kube-Proxy](https://kubernetes.io/docs/admin/kube-proxy/).

   * selector

     here you need to specify the deployment name that is associated with this service


   Install jenkins master

   * ` kubectl apply -f jenkins-deployment.yaml` 
   * `kubectl create -f jenkins-service.yaml`

   check the information:

   ` kubectl describe pods --namespace nick|grep jenkins`

 ![1542789300105](https://github.com/youngbetter/pichub/blob/master/notes/1542789300105.png)

   ` kubectl get svc --namespace nick|grep jenkins`

   ![1542789391713](https://github.com/youngbetter/pichub/blob/master/notes/1542789391713.png)

   Congratulations!

   the jenkins service is now running successfully on your kubernetes slave node. 

   log in kubernetes dashboard to check information:

   ![1542790949168](https://github.com/youngbetter/pichub/blob/master/notes/1542790949168.png)

### configure jenkins kubernetes plugin

1. log in jenkins dashboard

   in k8s dashboard we know the jenkins pod is running on k8s-node1, so we can type 'http://<ip-node1>:<nodeport>' in browser to access jenkins.

2. configure kubernetes cloud

   1. navigate to "Manage Jenkins" and choose "Configure System"

      ![1542791323568](https://github.com/youngbetter/pichub/blob/master/notes/1542791323568.png)

      ![1542791450675](https://github.com/youngbetter/pichub/blob/master/notes/1542791450675.png)

   2. on the bottom of configure page, toggle "Add a new cloud" and choose "Kubernetes"

      ![1542791663220](https://github.com/youngbetter/pichub/blob/master/notes/1542791663220.png)

   3. configure base information

      ![1542791854100](https://github.com/youngbetter/pichub/blob/master/notes/1542791854100.png)

      * Kubernetes URL

        on k8s-master:

        ` kubectl cluster-info | grep master`

        ![1542792025787](https://github.com/youngbetter/pichub/blob/master/notes/1542792025787.png)

      * Jenkins URL

        on k8s-master:

        ```shell
        kubectl get pods --namespace nick| grep jenkins
        kubectl describe pod jenkins-78bf9fccd9-kxtvg --namespace nick
        # the IP:10.244.1.74 is what we want
        ```

        ![1542792254226](https://github.com/youngbetter/pichub/blob/master/notes/1542792254226.png)

      * <b>Credentials</b>

        when you have filled 'Kubernetes URL' without add credentials, and click "Test Connection", you will encounter the error below:![1542792525942](https://github.com/youngbetter/pichub/blob/master/notes/1542792525942.png)

        here is the steps to add credentials correctly:

        1. on k8s-master, grab the data from '~/.kube/config'

           there are three values matter:

           ```json
           certificate-authority-data
           client-certificate-data
           client-key-data
           ```

        2. decode the values we described upon:

           ```shell
           # on any linux machine
           echo certificate-authority-data.value | base64 -d > ca.crt
           echo client-certificate-data.value | base64 -d > client.crt
           echo client-key-data.value | base64 -d > client.key
           # Using the three files we need to generate client certificate file in PKCS12 format
           openssl pkcs12 -export -out cert.pfx -inkey client.key -in client.crt -certfile ca.crt
           # during the process you need to enter a passphrase, and it will be used below
           ```

        3. add credential

           ![1542793473309](https://github.com/youngbetter/pichub/blob/master/notes/1542793473309.png)

           ![1542793658201](https://github.com/youngbetter/pichub/blob/master/notes/1542793658201.png)

           * choose "Certificate" as "Kind"

           * choose "Upload PKCS#12 certificate"

           * "Upload certificate"

             choose the file we generated: ` cert.pfx`

           * fill the Password with passphrase upon

        4. choose the credential just added and test connection

           ![1542794061025](https://github.com/youngbetter/pichub/blob/master/notes/1542794061025.png)

      * Add pod Template

        ![1542794146229](https://github.com/youngbetter/pichub/blob/master/notes/1542794146229.png)



        fill the information like this template. Of course, you can customized your own docker image based on jenkins/jnlp-slave.

   4. save 

5. Test the configuration whether it works

   * create an new item with a item name you like

   * fill the correct label expression

     ![1542794540703](https://github.com/youngbetter/pichub/blob/master/notes/1542794540703.png)

   * execute some shell

     ![1542794621029](https://github.com/youngbetter/pichub/blob/master/notes/1542794621029.png)

   * build the project

   * log in k8s dashboard to check if there is a 'jenkins-slave-xxxxx' pod is running, this is the jenkins slave created by k8s

     ![1542794841632](https://github.com/youngbetter/pichub/blob/master/notes/1542794841632.png)

   * check the console output 

     ![1542794983357](https://github.com/youngbetter/pichub/blob/master/notes/1542794983357.png)

6. Completed !



### Error

1. situation

   I have a k8s cluster(1 master and 2 slaves) deployed on masoon3, and now I deployed jenkins master on k8s-node-1, the problem is when k8s plugin try to spin up a jenkins slave on the different k8s node(here is k8s-node-2), there will be a connect error between jenkins slave and jenkins mater:

   ![1543298433841](https://github.com/youngbetter/pichub/blob/master/notes/1543298433841.png)

   this is because the network plugin flannel based on UDP, whose default port is blocked on mosoon3 by , so enable the port on mosoon3 will solve the problem.