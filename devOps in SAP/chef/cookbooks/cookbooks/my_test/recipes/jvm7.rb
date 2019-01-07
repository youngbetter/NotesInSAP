# Cookbook:: my_test
# Recipe:: ant
# Copyright:: 2018, The Authors, All Rights Reserved.


# Define attributes
node.default['chef']['JVM7_URL']="https://artifactory.successfactors.com/artifactory/sap-local/sapjvm7/REL/7.1.053/sapjvm-7.1.053-linux-x64.tar.gz"
node.default['chef']['JVM7_ROOT']="sapjvm_7"
node.default['chef']['JVM7_VERSION']="7.1.059"


#JVM_7
if !File.directory?("/usr/share/sapjvm_#{node['chef']['JVM7_VERSION']}") and !File.directory?("/usr/java/sapjvm_#{node['chef']['JVM7_VERSION']}")
	execute "setup_JVM7" do
		command "echo Installing sapjvm_#{node['chef']['JVM7_VERSION']}
			[ -d /usr/java ] || mkdir -p /usr/java
	        curl #{node['chef']['JVM7_URL']} --output /tmp/jvm7
	        pushd /usr/java
	        tar -xzf /tmp/jvm7 && mv #{node['chef']['JVM7_ROOT']} sapjvm_#{node['chef']['JVM7_VERSION']}
	        [ -d /usr/java/sapjvm_7_latest ] && unlink /usr/java/sapjvm_7_latest
	        ln -s sapjvm_#{node['chef']['JVM7_VERSION']} sapjvm_7_latest
	        popd
	        rm -rf /tmp/jvm7
          "
	end
end
