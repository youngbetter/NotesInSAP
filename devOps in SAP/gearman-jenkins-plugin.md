# jenkins plugin gearman

### what is gearman

Gearman provides a generic application framework to farm out work to other machines or processes that are better suited to do the work. It allows you to do work in parallel, to load balance processing, and to call functions between languages. It can be used in a variety of applications, from high-availability web sites to the transport of database replication events. In other words, it is the nervous system for how distributed processing communicates.

![Gearman Stack](http://gearman.org/img/stack.png)

### how to configure it

1. install gearman server

   here we install gearman server on kubernetes cluster.

   ```yaml
   # gearman-deployment.yaml
   apiVersion: extensions/v1beta1
   kind: Deployment
   metadata:
     name: gearman
     namespace: nick
   spec:
     replicas: 1
     template:
       metadata:
         labels:
           app: gearman
       spec:
         containers:
           - name: gearman
             image: artefactual/gearmand
             ports:
               - name: gearman-port
                 containerPort: 4730
   ```

   ```yaml
   # gearman-service.yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: gearman
     namespace: nick
   spec:
     type: NodePort
     ports:
       - port: 4730
         name: "gearman-port"
         nodePort: 30020
         targetPort: 4730
     selector:
       app: gearman
   ```

   ```shell
   kubectl apply -f gearman-deployment.yaml
   kubectl apply -f gearman-service.yaml
   ```

2. install and configure jenkins gearman plugin

   * install
     *  log on jenkins dashboard
     * "Manage Jenkins" on the left top![1544073074185](https://github.com/youngbetter/pichub/blob/master/notes/1544073074185.png)
     * "Manage Plugins"install gearman client ![1544073112806](https://github.com/youngbetter/pichub/blob/master/notes/1544073112806.png)
     * search and install "Gearman" plugin

   * configure

     * in "Manage Jenkins" choose "Configure System"

     * fill the information of "Gearman Plugin Config"

       ![1544073400253](https://github.com/youngbetter/pichub/blob/master/notes/1544073400253.png)

       Gearman Server Host: is the server deployed on kubernetes

       if "Test Connection" returns "Success", it means your gearman server runs correctly.

3. install gearman client

   A gearman client can be written in any language

   Here are a few sample clients that work with this plugin

   - [gearman-plugin-client](https://github.com/zaro0508/gearman-plugin-client) is a simple test client (below examples use this client)

   - [Zuul client](http://git.openstack.org/cgit/openstack-infra/zuul) is the smart client we use in production. [Documentation](http://ci.openstack.org/zuul/zuul.html) is available as well.

   - [java client](https://www.github.com/openstack-infra/gearman-plugin/tree/master/src/main/java/hudson/plugins/gearman/example) is a simple client included with jenkins-plugin.hpi

4. build a jenkins job by gearman

   * create a job on jenkins dashboard

     **Gearman doesn't support dynamic jenkins-slave node as kubernetes, so make sure the node label assigned to new job is of static jenkins node**

     * check gearman workers

     ![1544074323436](https://github.com/youngbetter/pichub/blob/master/notes/1544074323436.png)

   * build the job by gearman client

     ```shell
     python gear_client.py -s 10.102.166.118 --function=build:second_job
     ```

     ![1544074548005](https://github.com/youngbetter/pichub/blob/master/notes/1544074548005.png)

     back to jenkins dashboard and the job does built successfully.