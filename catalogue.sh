#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGO_HOST=mongodb.mydevopss.online

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

dnf module disable nodejs -y &>> $LOGFILE

CHECK $? "Disabling nodejs module"  

dnf module enable nodejs:18 -y &>> $LOGFILE

CHECK $? "Enabling nodejs:18 module"  

dnf install nodejs -y &>> $LOGFILE

CHECK $? "Installing nodejs"  

id roboshop &>> $LOGFILE 

### CHECKING USER EXISTS OR NOT & ADDING NEW USER IF NOT EXISTS
if [ $? -ne 0 ]
then 
    useradd roboshop &>> $LOGFILE
    CHECK $? "roboshop user creation"  
else
    echo -e "roboshop user already exist $Y SKIPPING $N" &>> $LOGFILE  
fi

mkdir -p /app &>> $LOGFILE

CHECK $? "creating directory"  

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

CHECK $? "Downloading catalogue application"  

cd /app &>> $LOGFILE 

CHECK $? "Changing directory"  

unzip -o /tmp/catalogue.zip &>> $LOGFILE

CHECK $? "Unzipping Catalogue"  

npm install &>> $LOGFILE 

CHECK $? "Installing dependencies"  

cp /home/centos/roboshop-shell/catalouge.service /etc/systemd/system/catalogue.service &>> $LOGFILE

CHECK $? "Copying catalogue service file"  

systemctl daemon-reload &>> $LOGFILE

CHECK $? "Reloading daemon"  

systemctl enable catalogue &>> $LOGFILE

CHECK $? "Enabling catalogue"  

systemctl start catalogue &>> $LOGFILE

CHECK $? "Starting catalogue"  

cp home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

CHECK $? "Copying mongo repo"  

dnf install mongodb-org-shell -y &>> $LOGFILE

CHECK $? "Installing mongo shell"  

mongo --host $MONGO_HOST </app/schema/catalogue.js &>> $LOGFILE

CHECK $? "Loading catalogue schema into mongodb"  

echo "script ended at $TIMESTAMP"

#################     INSTALLING MONGODB COMPLETED  ######################





    