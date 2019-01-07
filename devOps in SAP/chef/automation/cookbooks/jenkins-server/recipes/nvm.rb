# Cookbook:: jenkins-server
# Recipe:: NVM
# Copyright:: 2018, The Authors, All Rights Reserved.


#Jenkins-NVM
execute "setup_nvm" do
	command "
	if [ -d #{node['chef']['NVM_HOME']} ]; then
        rm -rf #{node['chef']['NVM_HOME']}
    fi
    sudo zypper ar --no-gpgcheck #{node['chef']['NVM_URL']}
    sudo zypper install -y nodejs8
    "
end
