# Cookbook:: my_test
# Recipe:: ant
# Copyright:: 2018, The Authors, All Rights Reserved.

#ANT
if !File.directory?("/usr/share/#{node['chef']['ANT_VERSION']}")
	execute "setup_ant" do
	   	command "echo Installing #{node['chef']['ANT_VERSION']}
  		curl #{node['chef']['ANT_URL']} --output /tmp/ant
  		pushd /usr/share && tar -xzf /tmp/ant
  		[ -d /usr/share/ant ] && unlink /usr/share/ant
  		ln -s #{node['chef']['ANT_VERSION']} ant
  		popd
  		rm -rf /tmp/ant
		"
 	end
end
