# Cookbook:: my_test
# Recipe:: NVM
# Copyright:: 2018, The Authors, All Rights Reserved.

# Define attributes
node.default['chef']['NVM_URL']="http://download.opensuse.org/repositories/devel:/languages:/nodejs/SLE_12_SP3/devel:languages:nodejs.repo"
node.default['chef']['NVM_HOME']="/home/jenkins/.nvm"

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
