# Cookbook:: my_test
# Recipe:: ant
# Copyright:: 2018, The Authors, All Rights Reserved.


# Define attributes
node.default['chef']['JVM8_URL']="https://artifactory.successfactors.com/artifactory/sap-local/sapjvm8/REL/8.1.042/sapjvm-8.1.042-linux-x64.tar.gz"
node.default['chef']['JVM8_ROOT']="sapjvm_8"
node.default['chef']['JVM8_VERSION']="8.1.042"


#JVM_8
if !File.directory?("/usr/share/sapjvm_#{node['chef']['JVM8_VERSION']}") and !File.directory?("/usr/java/sapjvm_#{node['chef']['JVM8_VERSION']}")
	execute "setup_JVM8" do
		command "echo Installing sapjvm_#{node['chef']['JVM8_VERSION']}
				  [ -d /usr/java ] || mkdir -p /usr/java
	        curl #{node['chef']['JVM8_URL']} --output /tmp/jvm8
	        pushd /usr/java
	        tar -xzf /tmp/jvm8 && mv #{node['chef']['JVM8_ROOT']} sapjvm_#{node['chef']['JVM8_VERSION']}
	        [ -d /usr/java/sapjvm_8_latest ] && unlink /usr/java/sapjvm_8_latest
        	[ -d /usr/java/latest ] && unlink /usr/java/latest
	        ln -s sapjvm_#{node['chef']['JVM8_VERSION']} sapjvm_8_latest
	        ln -s sapjvm_#{node['chef']['JVM8_VERSION']} latest
	        popd
	        # rm -rf /tmp/jvm8
					"
	end
end
