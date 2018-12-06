# CHEF IN PRACTICE

[TOC]

### Description

* Environments management

  : use chef to help manage the environments just like use Github to help manage the code

### Construction

* Chef Server

  : central database for cookbooks

* Workstation

  : write the cookbook and upload it to chef server

* Node

  : pull cookbook from server and configure itself according the cookbook

![1537931116371](https://github.com/youngbetter/pichub/blob/master/notes/1537931116371.png)

### Installation

At the very beginning, check out  the ip address of your machine and configure the host name

| IP ADDRESS      | HOST NAME               |
| --------------- | ----------------------- |
| 192.168.211.138 | chef-server-workstation |
| 192.168.211.143 | chef-agent-0            |
| 192.168.211.133 | chef-agent              |

* Chef Server

* Workstation

  : here we use 192.168.211.138 as both server and workstation

  1. configure hostname and add ip-hostname mapping to /etc/hosts

     ``` shell
     hostname chef-server-workstation
     vi /etc/hosts
     # add the following contents
     # 192.168.211.138 chef-server-workstation
     # 192.168.211.143 chef-agent-0
     # 192.168.211.133 chef-agent
     ```

  2. install server on host <b>chef-server-workstation</b>

     : suppose u have downloaded the packages from [chef downloads](https://downloads.chef.io/)

     | packagE                                            | name              |
     | -------------------------------------------------- | ----------------- |
     | https://downloads.chef.io/chef-server/12.17.33     | <server.deb>      |
     | https://downloads.chef.io/manage/2.5.16            | <manage.deb>      |
     | https://downloads.chef.io/chef-workstation/0.1.162 | <workstation.deb> |
     | https://downloads.chef.io/chef/14.5.33             | <client.deb>      |

     ```shell
     ## install server
         # install deb package
         dpkg -i <server.deb>
         # rpm -i <server.rpm>
         # configure server
         chef-server-ctl reconfigure
         # install server manage console
         chef-server-ctl install chef-manage --path <manage.deb>
     	# reconfigure server
     	chef-server-ctl reconfigure
     	# reconfigure manage
     	chef-manage-ctl reconfigure
     	# create a user----the <username>.pem is your private key----[root : admain]
     	chef-server-ctl user-create <username> <first-name> <last-name> <email> 		'<password>' --filename /etc/chef/<username>.pem
     	# access in manage console and create organization
     	# in broswer type https://chef-server-workstation
     	# log in and create org.
     ## install Workstation
     	# install package
     	dpkg -i <workstation.deb>
     	# verify intstall
     	chef verify
     	# configue default ruby
         echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
         source ~/.bash_profile
         which ruby
         # download starter kit
         # in your manage console download the kit and copy to the chef-data dir and 	unzip it
         cd /opt/chef-data
         unzip chef-starter.zip
         cd chef-repo/
         # verify installation
         ## must use sudo or you will encounter the below Error
         sudo knife ssl fetch
         sudo knife ssl check
         sudo knife node list
     ```

  ![1538024812833](https://github.com/youngbetter/pichub/blob/master/notes/1538024812833.png)

  <center>figure-1: Service temporarily unavailable Error</center>

  If you encounter this error message, just use ` sudo` to solve it no matter  you are a root user or normal user. And here we talk about a more general question, what's the difference between 'execute commands with ` sudo` ' and 'execute commands for root user'?

  : 

3. install  client on <b>chef-agent-0</b>

```shell
dpkg -i <chef-client.deb>
chef-client -v
```

4. register the node to server on <b>workstation</b>

```shell
sudo knife bootstrap 192.168.211.143 --ssh-user <user> --ssh-password <password> --node-name <hostname>
```

![1538027385142](https://github.com/youngbetter/pichub/blob/master/notes/1538027385142.png)

<center>figure-2: Permission denied Error</center>

when you meet this error, on the <b>client</b> machine, change you ssh configuration(***please be make sure that your computer has installed ssh service**):

```shell
sudo vi /etc/ssh/sshd_config
# PermitRootLogin yes
```

### Hello world

on <b> workstation</b> 

1. create and edit cookbook

``` shell
# 1.create my_test
cd /opt/chef-data/chef-repo/cookbooks
chef generate cookbook my_test
# 2.edit it
vi my_test/recipes/default.rb
# execute 'repo_ifconfig' do
#        command 'ifconfig >> /root/ifconfig.txt'
#        ignore_failure true
# end
```

2. upload the cookbook to server

```shell
# 1.upload cookbook to Server
knife cookbook upload my_test
# 2.lookup the cookbook list 
knife cookbook list
```

3. distribute cookbook for client node

```shell
knife node run_list add chef-agent-0 my_test
```

on <b>client node</b>

1. execute cookbook

```shell
sudo chef-client
```

2. verify the result

   ```shell
   # 1.check whether the ifconfig.txt generated
   ls /root
   # 2.look up the ifconfig.txt contents
   cat /root/ifconfig.txt
   ```

### chef role

1. add role

   ` sudo knife role from file <role-file>.rb`

   login server dashboard and add role to runlist

2. execute



### Extends

1. enable ssh connect

2. install chef-server/workstation

3. register chef node use ssh-key

   ` sudo knife bootstrap <target-ip> -i ~/.ssh/id_rsa -N <client-name>`

4. on server execute update configuration

   `ssh -i ~/.ssh/id_rsa 192.168.64.132 'sudo chef-client'`

### More Information

[chef in production](https://github.com/youngbetter/Notes/blob/master/devOps%20in%20SAP/chefInProduction.md)