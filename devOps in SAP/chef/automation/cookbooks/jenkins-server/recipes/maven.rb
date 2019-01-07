# Cookbook:: jenkins-server
# Recipe:: maven
# Copyright:: 2018, The Authors, All Rights Reserved.


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
