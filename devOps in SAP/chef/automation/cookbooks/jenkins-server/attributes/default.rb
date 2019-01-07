# Attributes:: jenkins-server
# Copyright:: 2018, The Authors, All Rights Reserved.

# Define attributes
node.default['chef']['ANT_URL']="https://archive.apache.org/dist/ant/binaries/apache-ant-1.8.4-bin.tar.gz"
node.default['chef']['ANT_VERSION']="apache-ant-1.8.4"
node.default['chef']['MAVEN_URL']="https://archive.apache.org/dist/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz"
node.default['chef']['MAVEN_VERSION']="apache-maven-3.0.5"
node.default['chef']['JVM7_URL']="https://artifactory.successfactors.com/artifactory/sap-local/sapjvm7/REL/7.1.053/sapjvm-7.1.053-linux-x64.tar.gz"
node.default['chef']['JVM7_ROOT']="sapjvm_7"
node.default['chef']['JVM7_VERSION']="7.1.059"
node.default['chef']['JVM8_URL']="https://artifactory.successfactors.com/artifactory/sap-local/sapjvm8/REL/8.1.042/sapjvm-8.1.042-linux-x64.tar.gz"
node.default['chef']['JVM8_ROOT']="sapjvm_8"
node.default['chef']['JVM8_VERSION']="8.1.042"
node.default['chef']['NVM_URL']="http://download.opensuse.org/repositories/devel:/languages:/nodejs/SLE_12_SP3/devel:languages:nodejs.repo"
node.default['chef']['NVM_HOME']="/home/jenkins/.nvm"