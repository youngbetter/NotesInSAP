# Configure logstash

1. Install Logstash

   * Download and install the Public Signing Key: 

     `wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -`

   * Install the `apt-transport-https` package on Debian before proceeding: 

     ` sudo apt-get install apt-transport-https`

   * Save the repository definition to `/etc/apt/sources.list.d/elastic-6.x.list`: 

     ` echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list`

   * Run `sudo apt-get update` and the repository is ready for use. You can install it with: 

     `sudo apt-get update && sudo apt-get install logstash`

2. Install the FileBeats

   `curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.4.0-amd64.deb`

   `sudo dpkg -i filebeat-6.4.0-amd64.deb`

3. Configure the FileBeats by modifying the filebeat.yml` [/etc/filebeat]`
