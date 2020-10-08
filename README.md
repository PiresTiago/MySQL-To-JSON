# MySQL-To-JSON
Bash script to migrate data from MySQL databases to JSON Files

### Instructions:

#### Make script executable
```
chmod +x ./MySQLToJSON.sh
```

#### Use it!
```
./MySQLToJSON.sh  <database name>  <database user>  <database password>  <path to JSON files>
```
  
 #### Example:
 ```
 ./MySQLToJSON.sh  dbXPTO  user1  123  ~/Documents/dbJSONS/
 ```
 ```
 ./MySQLToJSON.sh  dbXPTO  user1  123  /tmp/dbJSONS/
 ```
