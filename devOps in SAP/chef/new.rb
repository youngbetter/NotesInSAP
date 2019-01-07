# Cookbook:: adaptation
# Recipe:: default
# Copyright:: 2018, The Authors, All Rights Reserved.


# Define attributes
node.default['first']['JVM7_URL']="https://artifactory.successfactors.com/artifactory/sap-local/sapjvm7/REL/7.1.053/sapjvm-7.1.053-linux-x64.tar.gz"
node.default['first']['JVM7_ROOT']="sapjvm_7"
node.default['first']['JVM7_VERSION']="7.1.059"
node.default['first']['JVM8_URL']="https://artifactory.successfactors.com/artifactory/sap-local/sapjvm8/REL/8.1.042/sapjvm-8.1.042-linux-x64.tar.gz"
node.default['first']['JVM8_ROOT']="sapjvm_8"
node.default['first']['JVM8_VERSION']="8.1.042"
node.default['first']['MAVEN_URL']="https://archive.apache.org/dist/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz"
node.default['first']['MAVEN_VERSION']="apache-maven-3.0.5"
node.default['first']['ANT_URL']="https://archive.apache.org/dist/ant/binaries/apache-ant-1.8.4-bin.tar.gz"
node.default['first']['ANT_VERSION']="apache-ant-1.8.4"

#ANT
if !File.directory?('/usr/share/'+node['first']['ANT_VERSION'])
	execute "setup_ant" do
	   	command 'echo Installing '+node['first']['ANT_VERSION']+'
		curl '+ node['first']['ANT_URL']+' --output /tmp/ant
		pushd /usr/share && tar -xzf /tmp/ant
		[ -d /usr/share/ant ] && unlink /usr/share/ant
		ln -s '+node['first']['ANT_VERSION'] +' ant
		popd
		rm -rf /tmp/ant
		'
 	end
end

#MAVEN
if !File.directory?('/usr/share/'+node['first']['MAVEN_VERSION'])
	execute "setup_maven" do
		command 'echo Installing '+node['first']['MAVEN_VERSION']+'
	        curl '+ node['first']['MAVEN_URL']+' --output /tmp/maven
	        pushd /usr/share && tar -xzf /tmp/maven
	        [ -d /usr/share/maven ] && unlink /usr/share/maven
	        ln -s '+node['first']['MAVEN_VERSION']+' maven
	        popd
					'
	end
end


#JVM_7
if !File.directory?('/usr/share/sapjvm_'+node['first']['JVM7_VERSION'])
	execute "setup_JVM7" do
		command 'echo Installing sapjvm_'+node['first']['JVM7_VERSION']+'
				[ -d /usr/java ] || mkdir -p /usr/java
	        curl '+ node['first']['JVM7_URL']+' --output /tmp/jvm7
	        pushd /usr/java
	        tar -xzf /tmp/jvm7 && mv '+node['first']['JVM7_ROOT']+' sapjvm_'+node['first']['JVM7_VERSION']+'
	        [ -d /usr/java/sapjvm_7_latest ] && unlink /usr/java/sapjvm_7_latest
	        ln -s sapjvm_'+node['first']['JVM7_VERSION']+' sapjvm_7_latest
	        popd
	        # rm -rf /tmp/jvm7
					'
	end
end



#JVM_8
if !File.directory?('/usr/share/sapjvm_'+node['first']['JVM8_VERSION'])
	execute "setup_JVM8" do
		command 'echo Installing sapjvm_'+node['first']['JVM8_VERSION']+'
				[ -d /usr/java ] || mkdir -p /usr/java
	        curl '+ node['first']['JVM8_URL']+' --output /tmp/jvm8
	        pushd /usr/java
	        tar -xzf /tmp/jvm8 && mv '+node['first']['JVM8_ROOT']+' sapjvm_'+node['first']['JVM8_VERSION']+'
	        [ -d /usr/java/sapjvm_8_latest ] && unlink /usr/java/sapjvm_8_latest
        	[ -d /usr/java/latest ] && unlink /usr/java/latest
	        ln -s sapjvm_'+node['first']['JVM8_VERSION']+' sapjvm_8_latest
	        ln -s sapjvm_'+node['first']['JVM8_VERSION']+' latest
	        popd
	        # rm -rf /tmp/jvm8
					'
	end
end

#Git
execute "setup_git" do
	command 'git config --global user.name i329599
    	git config --global user.email farrah.gu@sap.com
    	git config --global http.sslVerify false
			'
end

#Jenkins
execute "setup_jenkins" do
	command "id -u jenkins
	    if [ $? -eq 1 ]; then
	        useradd -m -d /home/jenkins -u 1001 jenkins
	    fi
	    if ! [ -d /var/lib/jenkins_home ]; then
	        mkdir -p /var/lib/jenkins_home && chown -R jenkins:users /var/lib/jenkins_home
	    fi
	    su - jenkins -c 'git config --global user.name i329599'
	    su - jenkins -c 'git config --global user.email farrah.gu@sap.com'
	    su - jenkins -c 'git config --global http.sslVerify false'
	    su - jenkins -c 'git config --global core.autocrlf input'
	    su - jenkins -c 'ssh-keygen -t rsa -P \"\" -f /home/jenkins/.ssh/id_rsa'
	    su - jenkins -c 'touch /home/jenkins/.ssh/authorized_keys'
	    su - jenkins -c 'chmod 600 /home/jenkins/.ssh/authorized_keys'
	    #RESET DEFAULT PROFILE
	    su - jenkins -c 'echo \"export JAVA_HOME=/usr/java/sapjvm_7_latest\" > ~/.bashrc'
	    su - jenkins -c 'echo \"export ANT_HOME=/usr/share/ant\" >> ~/.bashrc'
	    su - jenkins -c 'echo \"export MVN_HOME=/usr/share/maven\" >> ~/.bashrc'
	    su - jenkins -c 'echo \"export PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$MVN_HOME/bin:$PATH\" >> ~/.bashrc'
	    #INIT NVM
	    su - jenkins -c 'curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash'
			"
end

# setup_os_lib(){
#     zypper install -y libXcomposite1 libXcursor1 libXi6 \
#       mozilla-nss libXrandr2 libasound2 libatk-1_0-0 \
#       libatk-bridge-2_0-0 xorg-x11-fonts ipa-gothic-fonts libgtk-2_0-0
#     #zypper install -y git
# }