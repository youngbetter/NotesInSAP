# Cookbook:: my_test
# Recipe:: ant
# Copyright:: 2018, The Authors, All Rights Reserved.

#Jenkins
execute "setup_jenkins" do
	command "id -u jenkins
	    if [ $? -eq 1 ]; then
	        useradd -m -d /home/jenkins -u 1000 jenkins
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
			"
end
