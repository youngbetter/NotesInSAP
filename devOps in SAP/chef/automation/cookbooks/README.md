# jenkins-server

### Steps

- Add Node

1. Login to monsoon3 dashboard
2. Choose your project
3. On the left-top tab menu, toggle "Services" and chose "Automation" and then click "Add Node"
4. Select the correct instance and the click "Get instructions"
5. Choose correct OS and the click "Get instructions"
6. Do the operations as the instructions
7. Click "Close" and you will find a new node was added

- Create chef  Automation

1. Switch to "Automation" tab
2. Click "New Automation"
3. Fill the form following [instructions](https://documentation.global.cloud.sap/docs/automation/start/lyra.html#lyra_automation_create_chef)
4. Click "Create" and you will see the automation record
5. Switch back to "Nodes"
6. Click the execute icon to trigger chef command
7. View the logs to debug your automation