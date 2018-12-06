# CHEF IN PRODUCTION

[TOC]

## ON CLOUD

### Requirements

1. [monsoon3 platform](https://dashboard.eu-de-2.cloud.sap/monsoon3) authentication

### Steps

* **Add Node**

1. Login to monsoon3 dashboard

2. Choose your project

3. On the left-top tab menu, toggle "Services" and chose "Automation" and then click "Add Node"

   ![chefinproduction-1](https://github.com/youngbetter/pichub/blob/master/notes/chefinproduction-1.png)

4. Select the correct instance and the click "Get instructions"

5. Choose correct OS and the click "Get instructions"

6. Do the operations as the instructions

7. Click "Close" and you will find a new node was added

* **Create chef  Automation**

1. Switch to "Automation" tab
2. Click "New Automation"
3. Fill the form as [instructions](https://documentation.global.cloud.sap/docs/automation/start/lyra.html#lyra_automation_create_chef)
4. Click "Create" and you will see the automation record
5. Switch back to "Nodes"
6. Click the execute icon to trigger chef command![chefinproduction-2](https://github.com/youngbetter/pichub/blob/master/notes/chefinproduction-2.png)
7. View the logs to debug your automation

* **Configure the attributes**

  by overwriting the default value of attributes in your cookbook, you can customize your own recipes without changing the source code.

  ![chefinproduction-3](https://github.com/youngbetter/pichub/blob/master/notes/chefinproduction-3.png)

1. Switch to "Automation" tab
2. Choose the automation you want to edit and click the "setting" icon![chefinproduction-4](https://github.com/youngbetter/pichub/blob/master/notes/chefinproduction-4.png)and click "edit"
3. Edit the Attributes, just input the configure json data
4. Save it

### Errors

1. trust key error

   ![chefinproduction-5](https://github.com/youngbetter/pichub/blob/master/notes/chefinproduction-5.png)

   use ` zypper ar --no-gpgcheck <repo-url>`


## ON VM

### Preparation

| ip/hostname              | role                         |
| ------------------------ | ---------------------------- |
| 10.3.153.36/teamcity-qa1 | chef-server&chef-workstation |
| 10.3.153.49/teamcity-qa2 | chef-client                  |

### Install and Configure

1. synchronize time between server and client to avoid below error

   ```shell
   ntpdate -u 210.72.145.44
   # for more detail about ntp, go to below link
   # https://blog.csdn.net/jesseyoung/article/details/43488351
   ```

   ![ntp-error](https://github.com/youngbetter/pichub/blob/master/notes/1540886918007.png)

2. download rpm package of chef-server, chef-manage and chef-workstation.

   ```shell
   cd /tmp
   wget -O chef-server.rpm https://packages.chef.io/files/stable/chef-server/12.18.14/sles/12/chef-server-core-12.18.14-1.sles12.x86_64.rpm
   wget -O chef-manage.rpm <manage-link>
   wget -O chef-workstation.rpm <workstaion-link>
   # get proper packages' links at
   # https://downloads.chef.io/
   ```

3. install rpm packages and primary config

   ```shell
   ## install
   # install server
   rpm -i chef-server.rpm
   # reconfigure server
   chef-server-ctl reconfigure
   # if you encounter some errors related to postgresql, such as "cannot connetc to database...", suggest you change another machine as your chef-server, or solve the error with your talent, if you solve the error, please be kindly share with me at nick.yang01@sap.com
   
   # install manage
   chef-server-ctl install chef-manage --path /tmp/chef-manage.rpm
   # reconfigure server
   chef-server-ctl reconfigure
   # reconfigure manage
   chef-manage-ctl reconfigure
   
   # install workstation
   rpm -i chef-workstation.rpm
   # verify intstall
   chef verify
   # configue default ruby
   echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
   source ~/.bash_profile
   which ruby # /opt/chef-workstation/embedded/bin/ruby
   
   # config server
   # create user
   chef-server-ctl user-create <username> <first-name> <last-name> <email> 		'<password>' --filename /etc/chef/<username>.pem
   # create orgnization
   # could also create organization by server web_ui, but it may result an error descriped below at step 5.
   chef-server-ctl org-create <short-org-name> '<full-org-name>' --association_user <username> --filename /etc/chef/<short-org-name>-validator.pem
   ```

4. download starter kit and initiate chef-repo

   login server in browser use the <username> created before, http://<chef-server-ip>, download starter kit and transfer it to chef-server at `/opt/chef-data` , `scp`command is a choice.

   ![starter kit](https://github.com/youngbetter/pichub/blob/master/notes/1540889122662.png)

   ```shell
   # on chef-server
   cd /opt/chef-data
   unzip starter-kit.zip
   cd /chef-repo
   knife ssl fetch
   knife ssl check
   knife node list
   ```

5. bootstrap a chef client node

   try command

   ``` shell
   # knife bootstrap -i ~/.ssh/id_dsa <chef-client-ip> -N <chef-client-name>
   # pwd: /opt/chef-data/chef-repo
   knife bootstrap -i ~/.ssh/id_dsa 10.3.153.49 -N teamcity-qa2
   ```

   ![knife config error](https://github.com/youngbetter/pichub/blob/master/notes/1540889977318.png)

   this is a implicit error, type command ` knife config get`to get information

   ![knife default config](https://github.com/youngbetter/pichub/blob/master/notes/1540890402579.png)

   that's because `validation_key` is defined but never assigned value, so assign it value at `/opt/chef-data/chef-repo/.chef/knife.rb`, the value is `/etc/chef/<short-org-name>-validator.pem`, it's  actually the RSA private key of your org created before. If you create organization by web_ui, then could touch the `/etc/chef/<short-org-name>-validator.pem` file and copy the RSA private key to it, you can get the key on web_ui by 'Reset Validation Key'.

   ![reset key](https://github.com/youngbetter/pichub/blob/master/notes/1540891184484.png)

6. Compose cookbooks and upload it to server and apply them on client

   ```shell
   cd /opt/chef-data/chef-repo/cookbooks
   # update cookbook
   knife cookbook upload starter
   # check update
   knife cookbook list
   # add cookbook to runlist
   knife node runl_list add teamcity-qa2 starter
   # apply update on client
   ssh 10.3.153.49 'sudo chef-client'
   ```

7. Complete!