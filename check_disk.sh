#!/bin/bash

alert=20

df -H | awk '{print $5 " " $1}' | while read output;
do
  #echo "Disk details: $output"
  usage=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
  file_sys=$(echo $output | awk '{print $2}')
  #echo $usage
  if [ $usage -ge $alert ]
  then
          echo "CRITICAL for $file_sys"
fi	 
done
