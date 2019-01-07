#
# Cookbook:: adaptation
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

#Git
execute "setup_git" do
	command 'echo Start configuring git
	git --version > /root/git-version.txt
	git config --global user.name i329599
    git config --global user.email farrah.gu@sap.com
    git config --global http.sslVerify false
       '
end
