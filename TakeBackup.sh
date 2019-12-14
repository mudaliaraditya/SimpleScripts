#!/bin/bash

#Folder/File to Backup
FILE_TO_BACKUP=$1
FOLDER_TO_PLACE_BACKUP=$2

SCRIPT_NAME=$0


DisplayDots()
{
  A="Working on -- "
  B=0
  while true
  do
   echo -e "\r"
   A=$A"."
   echo -e "\r$A"
   #echo $B
   B=$[$B + 1]
   if [ $B -eq 6 ]
   then
        A="Working on -- "
        B=0
   fi
   sleep 0.5
  done
}

clean_up()
{

exit 0

}



trap clean_up SIGHUP SIGINT SIGTERM

#dt=`date '+%d%m%Y %H:%M:%S'
#dt=`date '+%d%m%Y.%H%M%S'`
dt=`date '+%d%m%Y'`

if [ "$1" == "" ]
then
   echo "no arguments"
   exit 1
fi
OUTPUT_FILE_NAME="${FILE_TO_BACKUP}_${dt}_${$}.tar.gz"

if [ -f $OUTPUT_FILE_NAME ]
then
  dt=`date '+%d%m%Y.%H%M%S'`
  OUTPUT_FILE_NAME="${FILE_TO_BACKUP}_${dt}_${$}.tar.gz"
  #echo "$file_name not exists"
fi

DisplayDots &
DisplayDotsPID=$? 

`tar -zcvf $OUTPUT_FILE_NAME  $FILE_TO_BACKUP >/dev/null`

if [ $? -ne 0 ]
then
    echo "error exiting"
    kill -9 $DisplayDotsPID
    exit -1
fi
echo "completed backup $OUTPUT_FILE_NAME"
kill -s SIGINT $DisplayDotsPID 1>/dev/null 2>&1
exit 0

