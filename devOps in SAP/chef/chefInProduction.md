# CHEF IN PRODUCTION

### Requirements

1. [monsoon3 platform](https://dashboard.eu-de-2.cloud.sap/monsoon3) authentication

### Steps

* Add Node

1. Login to monsoon3 dashboard

2. Choose your project

3. On the left-top tab menu, toggle "Services" and chose "Automation" and then click "Add Node"

   ![1539669303100](C:\Users\i343687\AppData\Roaming\Typora\typora-user-images\1539669303100.png)

4. Select the correct instance and the click "Get instructions"

5. Choose correct OS and the click "Get instructions"

6. Do the operations as the instructions

7. Click "Close" and you will find a new node was added

* Create chef  Automation

1. Switch to "Automation" tab
2. Click "New Automation"
3. Fill the form as [instructions](https://documentation.global.cloud.sap/docs/automation/start/lyra.html#lyra_automation_create_chef)
4. Click "Create" and you will see the automation record
5. Switch back to "Nodes"
6. Click the execute icon to trigger chef command![1539670059730](C:\Users\i343687\AppData\Roaming\Typora\typora-user-images\1539670059730.png)
7. View the logs to debug your automation

### Errors

1. trust key error

   ![1539756548325](C:\Users\i343687\AppData\Roaming\Typora\typora-user-images\1539756548325.png)

   use ` zypper ar --no-gpgcheck <repo-url>`