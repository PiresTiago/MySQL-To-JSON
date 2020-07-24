#!/bin/bash

database_name=$1
user=$2
password=$3
output_path=$4
max_group_concat=9999999

# Create dir if it does not exist
if [ ! -d $output_path ]; then
  mkdir $output_path
fi

# Append '/' if not present
if  [ "${output_path: -1}" != "/" ];then
  output_path="${output_path}/"
fi

# Query database and remove the first string(it is useless) 
tables=$(echo $(mysql -u ${user} -p${password} ${database_name} -e "SHOW tables") | cut -d' ' -f 2-)

for table in $tables
do
    columns_query="SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA='${database_name}' AND TABLE_NAME='${table}'"

    # Query database and remove the first string(it is useless) 
    columns=$(echo $(mysql -u ${user} -p${password} ${database_name} -e "${columns_query}")  | cut -d' ' -f 2-)

    set -- $columns
    a=(); for p in "$@"; do a+=("\"$p\" , \`$p\` ,"); done
    set -- "${a[@]}"
    tmp=$(echo "$@")
    
    # Remove last ','
    json_attributes=$(echo ${tmp%?})
 
    table_query="SET GLOBAL group_concat_max_len = ${max_group_concat}; SELECT concat('[', group_concat(JSON_OBJECT( $json_attributes )SEPARATOR
    ',') ,']') from ${table} INTO OUTFILE \"${output_path}${table}.json\""

    # Use this Query if the above fails and add [] to the files after
    #  table_query="SELECT JSON_OBJECT( $json_attributes ) from ${table} INTO OUTFILE \"${output_path}${table}.json\""
    
    mysql -u ${user} -p${password} ${database_name} -e "$table_query"
    echo $table
done