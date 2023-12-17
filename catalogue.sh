#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
#MONGO_HOST=0.0.0.0

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stared at $TIMESTAMP" 
echo "script stared at $TIMESTAMP" &>> $LOGFILE

echo "checking root access..." &>> $LOGFILE

#######################    CHECKING ROOT ACCESSS   #########################
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR $N:: Please run script with root access" &>> $LOGFILE
    exit 1
else    
    echo "Root access confirmed" &>> $LOGFILE
    echo "Installing..." &>> $LOGFILE
fi

#######################   CHECKING ROOT ACCESSS COMPLETED   ################

#################    CHECKING INSTALLATIONS SUCESSS OR FAIL   ##############
CHECK(){

    if [ $1 -ne 0 ]
    then
        echo -e "ERROR:: $2 $R failed $N" &>> $LOGFILE
        exit 1
    else
        echo "$2 $G success $N" &>> $LOGFILE
    fi
}

#################    CHECKING INSTALLATIONS COMPLETED   ###################

#################   INSTALLING CATALOGUE STARTED  ###########################

dnf module disable nodejs -y

CHECK $? "Disabling nodejs module" &>> $LOGFILE

dnf module enable nodejs:18 -y

CHECK $? "Enabling nodejs:18 module" &>> $LOGFILE

dnf install nodejs -y

CHECK $? "Installing nodejs" &>> $LOGFILE

id roboshop 

### CHECKING USER EXISTS OR NOT & ADDING NEW USER IF NOT EXISTS
if [ $? -ne 0 ]
then 
    useradd roboshop
    CHECK $? "roboshop user creation" &>> $LOGFILE
else
    echo "roboshop user already exist $Y SKIPPING $N" &>> $LOGFILE
fi

mkdir -p /app

CHECK $? "creating directory" &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

CHECK $? "Downloading catalogue application" &>> $LOGFILE

cd /app 

CHECK $? "Changing directory" &>> $LOGFILE

unzip /tmp/catalogue.zip

CHECK $? "Unzipping Catalogue" &>> $LOGFILE

npm install 

CHECK $? "Installing dependencies" &>> $LOGFILE

cp /home/centos/roboshop-shell/catalouge.service /etc/systemd/system/catalogue.service

CHECK $? "Copying catalogue service file" &>> $LOGFILE

systemctl daemon-reload

CHECK $? "Reloading daemon" &>> $LOGFILE

systemctl enable catalogue

CHECK $? "Enabling catalogue" &>> $LOGFILE

systemctl start catalogue

CHECK $? "Starting catalogue" &>> $LOGFILE

cp home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

CHECK $? "Copying mongo repo" &>> $LOGFILE

dnf install mongodb-org-shell -y

CHECK $? "Installing mongo shell" &>> $LOGFILE

mongo --host $MONGO_HOST </app/schema/catalogue.js

CHECK $? "Loading catalogue schema into mongodb" &>> $LOGFILE

echo "script ended at $TIMESTAMP"

#################     INSTALLING MONGODB COMPLETED  ######################





    