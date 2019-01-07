# Cookbook:: jenkins-server
# Recipe:: git
# Copyright:: 2018, The Authors, All Rights Reserved.

#Install Git
if !File::exist?('/usr/bin/git')
	execute "install_git" do
		command "zypper install -y libXcomposite1 libXcursor1 libXi6 mozilla-nss libXrandr2 libasound2 libatk-1_0-0 libatk-bridge-2_0-0 xorg-x11-fonts ipa-gothic-fonts libgtk-2_0-0
		zypper install -y git
		"
	end
end
#Git
execute "setup_git" do
	command "sudo git config --global user.name i329599
    	sudo git config --global user.email farrah.gu@sap.com
    	sudo git config --global http.sslVerify false
			"
end
