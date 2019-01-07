# Cookbook:: jenkins-server
# Recipe:: jvm7
# Copyright:: 2018, The Authors, All Rights Reserved.


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
