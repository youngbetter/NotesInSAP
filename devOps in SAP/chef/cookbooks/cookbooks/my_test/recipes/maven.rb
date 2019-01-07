# Cookbook:: my_test
# Recipe:: ant
# Copyright:: 2018, The Authors, All Rights Reserved.

# Define attributes
node.default['chef']['MAVEN_URL']="https://archive.apache.org/dist/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz"
node.default['chef']['MAVEN_VERSION']="apache-maven-3.0.5"

#MAVEN
if !File.directory?("/usr/share/#{node['chef']['MAVEN_VERSION']}")
	execute "setup_maven" do
		command "echo Installing #{node['chef']['MAVEN_VERSION']}
	        curl #{node['chef']['MAVEN_URL']} --output /tmp/maven
	        pushd /usr/share && tar -xzf /tmp/maven
	        [ -d /usr/share/maven ] && unlink /usr/share/maven
	        ln -s #{node['chef']['MAVEN_VERSION']} maven
	        popd
	        rm -rf /tmp/maven
          "
	end
end
