# Kibana 

[kibana user guide](https://www.elastic.co/guide/en/kibana/6.2/index.html)

[TOC]

### Introduction

Kibana is designed to work with Elasticsearch. We use Kibana to search, view, and interact with data stored in Elasticsearch indices. We can easily perform advanced data analysis and visualize our data in a variety of charts, tables, and maps.

### Install and Configure

1. supported platforms

   * Linux
   * Darwin
   * Windows

   Since Kibana runs on Node.js, we include the necessary Node.js binaries for these platforms

2. elasticsearch version

   Kibana should be configured to run against an Elasticsearch node of the same version. This is the officially supported configuration.

3. download link

   [kibana download page](https://www.elastic.co/guide/en/kibana/6.2/install.html)

4. run kibana on docker

   [kibana on docker](https://www.elastic.co/guide/en/kibana/6.2/docker.html)

### normal operation

1. connect kibana to elasticsearch

   create index pattern in kibana management page

2. discover the data and use filters to filter data

3. adjust time range

4. chart types

### some operation tricks

1. how to set data format?

   sometimes we need to customize the data format for our dashboard, to satisfy the requirements of different precision. 

   ![1542769289522](https://github.com/youngbetter/pichub/blob/master/notes/1542769289522.png)

   in "Management"  choose "Advanced Settings"

   ![1542769372587](https://github.com/youngbetter/pichub/blob/master/notes/1542769372587.png)

   and here we can make some changes about default settings.

   ![1542769538050](https://github.com/youngbetter/pichub/blob/master/notes/1542769538050.png)

   edit the number pattern to meet your requirement.

2. how to map x-axis value to a high level?

   for this question and the question below, we need use advanced operations in kibana. In this case, we need to map components to product areas.

   head to your "Visualize", on the left side bar, there is an "Advanced",

   ![1542776740579](https://github.com/youngbetter/pichub/blob/master/notes/1542776740579.png)

   toggle the "Advanced", and there is a "Json input" area, what we need to do is put our mapping script code inside it. 

   ![1542776886038](https://github.com/youngbetter/pichub/blob/master/notes/1542776886038.png)

   the script looks like below:

   ```json
   {
       "script":"if (_value=='bizx/au_V4'){return 'cross pillar';} return 'others';"
   }
   ```

   here we map 'bizx/au-V4' to 'cross pillar'

3. how to calculate the difference between two values as a metric?

   the operation is similar to described in question 2. The difference is script:

   ```json
   { 
       "script":"return ((doc['issue.updated_at'].value.getMillis()-doc['issue.created_at'].value.getMillis())/1000.0/60.0/60.0/24.0)" 
   }
   ```

   the script returns the difference of days of two date.

4. how to add a threshold line?

   sometimes we need to add a constant line as a threshold line so we can compare metrics conveniently. suppose we have had a bar chart like this:

   ![1542779728317](https://github.com/youngbetter/pichub/blob/master/notes/1542779728317.png)

   and now we need add a threshold line on it, make it look like this:

   ![1542779922389](https://github.com/youngbetter/pichub/blob/master/notes/1542779922389.png)

   what we need to do is add a metric and give it a constant value:

   ![1542780110388](https://github.com/youngbetter/pichub/blob/master/notes/1542780110388.png)

5. how to filter duplicate values?

   this is a simple task.

   ![1542780339433](https://github.com/youngbetter/pichub/blob/master/notes/1542780339433.png)

   kibana has provided a "Unique Count" as "Aggregation" method, chose it and it will count only if "Field" value differs.

6. how to make url clickable?

   wow, there are so many urls in our data, how could we make them clickable:

   ![1542780689633](https://github.com/youngbetter/pichub/blob/master/notes/1542780689633.png)

   first, go to "Management"

   ![1542769289522](https://github.com/youngbetter/pichub/blob/master/notes/1542769289522.png)

   then choose "Index Patterns" and choose the correct index on the left top:

   ![1542769372587](https://github.com/youngbetter/pichub/blob/master/notes/1542769372587.png)

   and then choose the field of url and click "pencil" to edit it:

   ![1542781136615](https://github.com/youngbetter/pichub/blob/master/notes/1542781136615.png)

   update the format of this field to 'Url' and click "Update Field" button.

   ![1542781337588](https://github.com/youngbetter/pichub/blob/master/notes/1542781337588.png)

   see! the format has changed to 'Url':

   ![1542781421370](https://github.com/youngbetter/pichub/blob/master/notes/1542781421370.png)

   and it's clickable now:

   ![1542781458480](https://github.com/youngbetter/pichub/blob/master/notes/1542781458480.png)
