#!/bin/bash

USER_ID=$(id -u)
SRC_DIR=$1
DEST_DIR=$2
DAYS=$(3:-14)  #Days are optional. If not given 14 days as an argument in console

#Check running with root user or not
if [ $USER_ID -eq 0 ]
then
    echo "Running with root user..."
else
    echo "Run with root user"
    exit 1
fi

#Check passing 2 args or not
if [ $# -lt 2 ]
then
    echo "Please execute with min 2 args..."
    exit 1
fi

#Check SRC and DEST dirs are exists or not
if [ ! -d $SRC_DIR ]
then
    echo "Source Dir desn't exist..."
    exit 1
fi

if [ ! -d $DEST_DIR ]
then
    echo "Dest Dir doesn't exist...."
    exit 1
fi

#Get the files older than 14 days from SRC DIR
FILES=$(find $SRC_DIR -name "*.log" -mtime +$DAYS)


#Check files are present or not. If present, zip them and store it in Dest_Dir and delete the files
#from SRC
if [ -n $FILES ]   # -n not empty. we can also use -z for empty
then
    echo "Files are present in $SRC_DIR. Proceed to zipping...."
    TIMESTAMP=$(date +"%F-%H-%M-%S")    #In format YYYY-MM-DD HH-MM:SS
    ZIP_FILE=$DEST_DIR/app-logs-$TIMESTAMP.zip  #Creating zip extension file path in Dest DIR

    echo $FILES | zip -@ $ZIP_FILE     #It will zip  and store in dest dir in .zip ext

    if [ -f $ZIP_FILE ]   #Condition to check succesfully zipped or not. -f to check files
    then
        echo "Files are zipped succesfully...."

        while IFS=read -r filepath   #using while loop and IFS read the files and delete them 
        do
            echo "Deleting the log files from src dir..."
            rm -rf $FILES
        done <<< $FILES
        echo "Files are succesfully deleted..."
    else
        echo "Failed to zip.. the files"
        exit 1
    fi
else
    echo "Files are empty...Skipping ....."
fi