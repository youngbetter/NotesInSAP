# COOKBOOK

environment: Ubuntu18.04

[TOC]

### ADAPTATION EXPERIMENT

#### REQUIREMENTS

1. software installed

   * curl

   * git

2. Network

   * sap inner net

#### ERRORS

1. ` pushd:not found`

   ![1538980115742](C:\Users\i343687\AppData\Roaming\Typora\typora-user-images\1538980115742.png)

   this error happens when your Linux command interpreter is dash, change it to bash use ` sudo dpkg-reconfigure dash` and chose <b style="color:red">No</b>

   ![1538980345800](C:\Users\i343687\AppData\Roaming\Typora\typora-user-images\1538980345800.png)

### POINTS

1. the <b>advantages</b> of chef vs shell scripts

   chef provides a set of abstract methods to adapt many kinds of platform, e.g.: what would you do if you want to setup a CentOS and an Ubuntu by scripts?  Maybe you need two types of scripts: ` yum -y install vim` for CentOS and ` apt-get install vim -y` for Ubuntu, however if use chef, you can use 

   ```ruby
   package 'vim' do
     action :install
   end
   ```

   for both CentOS and an Ubuntu, or even other platforms!