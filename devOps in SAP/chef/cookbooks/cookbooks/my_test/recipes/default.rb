# Cookbook:: my_test
# Recipe:: ant
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'my_test::ant'
include_recipe 'my_test::maven'
include_recipe 'my_test::jvm7'
include_recipe 'my_test::jvm8'
include_recipe 'my_test::git'
include_recipe 'my_test::jenkins'
include_recipe 'my_test::nvm'

# #ANT
# if !File.directory?("/usr/share/#{node['chef']['ANT_VERSION']}")
# 	execute "setup_ant" do
# 	   	command "echo Installing #{node['chef']['ANT_VERSION']}
#   		curl #{node['chef']['ANT_URL']} --output /tmp/ant
#   		pushd /usr/share && tar -xzf /tmp/ant
#   		[ -d /usr/share/ant ] && unlink /usr/share/ant
#   		ln -s #{node['chef']['ANT_VERSION']} ant
#   		popd
#   		rm -rf /tmp/ant
# 		"
#  	end
# end

# #MAVEN
# if !File.directory?("/usr/share/#{node['chef']['MAVEN_VERSION']}")
# 	execute "setup_maven" do
# 		command "echo Installing #{node['chef']['MAVEN_VERSION']}
#     curl #{node['chef']['MAVEN_URL']} --output /tmp/maven
#     pushd /usr/share && tar -xzf /tmp/maven
#     [ -d /usr/share/maven ] && unlink /usr/share/maven
#     ln -s #{node['chef']['MAVEN_VERSION']} maven
#     popd
#     rm -rf /tmp/maven
#     "
# 	end
# end

# #JVM_7
# if !File.directory?("/usr/share/sapjvm_#{node['chef']['JVM7_VERSION']}") and !File.directory?("/usr/java/sapjvm_#{node['chef']['JVM8_VERSION']}")
# 	execute "setup_JVM7" do
# 		command "echo Installing sapjvm_#{node['chef']['JVM7_VERSION']}
# 				  [ -d /usr/java ] || mkdir -p /usr/java
# 	        curl #{node['chef']['JVM7_URL']} --output /tmp/jvm7
# 	        pushd /usr/java
# 	        tar -xzf /tmp/jvm7 && mv #{node['chef']['JVM7_ROOT']} sapjvm_#{node['chef']['JVM7_VERSION']}
# 	        [ -d /usr/java/sapjvm_7_latest ] && unlink /usr/java/sapjvm_7_latest
# 	        ln -s sapjvm_#{node['chef']['JVM7_VERSION']} sapjvm_7_latest
# 	        popd
# 	        # rm -rf /tmp/jvm7
#           "
# 	end
# end

# #JVM_8
# if !File.directory?("/usr/share/sapjvm_#{node['chef']['JVM8_VERSION']}") and !File.directory?("/usr/java/sapjvm_#{node['chef']['JVM8_VERSION']}")
# 	execute "setup_JVM8" do
# 		command "echo Installing sapjvm_#{node['chef']['JVM8_VERSION']}
# 				  [ -d /usr/java ] || mkdir -p /usr/java
# 	        curl #{node['chef']['JVM8_URL']} --output /tmp/jvm8
# 	        pushd /usr/java
# 	        tar -xzf /tmp/jvm8 && mv #{node['chef']['JVM8_ROOT']} sapjvm_#{node['chef']['JVM8_VERSION']}
# 	        [ -d /usr/java/sapjvm_8_latest ] && unlink /usr/java/sapjvm_8_latest
#         	[ -d /usr/java/latest ] && unlink /usr/java/latest
# 	        ln -s sapjvm_#{node['chef']['JVM8_VERSION']} sapjvm_8_latest
# 	        ln -s sapjvm_#{node['chef']['JVM8_VERSION']} latest
# 	        popd
# 	        # rm -rf /tmp/jvm8
# 					"
# 	end
# end

# #Install Git
# if !File::exist?('/usr/bin/git')
# 	execute "install_git" do
# 		command "zypper install -y libXcomposite1 libXcursor1 libXi6 mozilla-nss libXrandr2 libasound2 libatk-1_0-0 libatk-bridge-2_0-0 xorg-x11-fonts ipa-gothic-fonts libgtk-2_0-0
# 		zypper install -y git
# 		"
# 	end
# end

# #Git
# execute "setup_git" do
# 	command "sudo git config --global user.name i329599
#     	sudo git config --global user.email farrah.gu@sap.com
#     	sudo git config --global http.sslVerify false
# 			"
# end

# #Jenkins
# execute "setup_jenkins" do
# 	command "id -u jenkins
# 	    if [ $? -eq 1 ]; then
# 	        useradd -m -d /home/jenkins -u 1000 jenkins
# 	    fi
# 	    if ! [ -d /var/lib/jenkins_home ]; then
# 	        mkdir -p /var/lib/jenkins_home && chown -R jenkins:users /var/lib/jenkins_home
# 	    fi
# 	    su - jenkins -c 'git config --global user.name i329599'
# 	    su - jenkins -c 'git config --global user.email farrah.gu@sap.com'
# 	    su - jenkins -c 'git config --global http.sslVerify false'
# 	    su - jenkins -c 'git config --global core.autocrlf input'
# 	    su - jenkins -c 'ssh-keygen -t rsa -P \"\" -f /home/jenkins/.ssh/id_rsa'
# 	    su - jenkins -c 'touch /home/jenkins/.ssh/authorized_keys'
# 	    su - jenkins -c 'chmod 600 /home/jenkins/.ssh/authorized_keys'
# 	    #RESET DEFAULT PROFILE
# 	    su - jenkins -c 'echo \"export JAVA_HOME=/usr/java/sapjvm_7_latest\" > ~/.bashrc'
# 	    su - jenkins -c 'echo \"export ANT_HOME=/usr/share/ant\" >> ~/.bashrc'
# 	    su - jenkins -c 'echo \"export MVN_HOME=/usr/share/maven\" >> ~/.bashrc'
# 	    su - jenkins -c 'echo \"export PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$MVN_HOME/bin:$PATH\" >> ~/.bashrc'
# 		"
# end

# #Jenkins-NVM
# execute "setup_nvm" do
# 	command "
# 	if [ -d #{node['chef']['NVM_HOME']} ]; then
#         rm -rf #{node['chef']['NVM_HOME']}
#     fi
#     sudo zypper ar --no-gpgcheck #{node['chef']['NVM_URL']}
#     sudo zypper install -y nodejs8
#     "
# end