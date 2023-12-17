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
    echo "Root access confirmed..." &>> $LOGFILE
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
        echo -e "$2 $G Success $N" &>> $LOGFILE       
    fi
}

#################    CHECKING INSTALLATIONS COMPLETED   ###################

#################   INSTALLING USER STARTED  ##############################

dnf module disable nodejs -y

CHECK $? "DisablIng nodejs module" &>> $LOGFILE

dnf module enable nodejs:18 -y

CHECK $? "Enabling nodejs:18 module" &>> $LOGFILE

dnf install nodejs -y

CHECK $? "Installing nodejs" &>> $LOGFILE

id roboshop

### CHECKING USER EXISTS OR NOT & ADDING NEW USER IF NOT EXISTS
if [ $? -ne 0 ]
then
    useradd roboshop
    CHECK $? "creating roboshop user" &>> $LOGFILE
else   
    echo "user already exists $Y SKIPPING... $N" &>> $LOGFILE
done

mkdir -p /app

CHECK $? "creating app directory" &>> $LOGFILE

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

CHECK $? "Downloading web-application" &>> $LOGFILE

cd /app 

CHECK $? "changing to app/ directory" &>> $LOGFILE

unzip /tmp/user.zip

CHECK $? "unzipping user" &>> $LOGFILE

cd /app 

CHECK $? "changing to app/ directory" &>> $LOGFILE

npm install

CHECK $? "Installing dependencies" &>> $LOGFILE

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service

CHECK $? "copying user service" &>> $LOGFILE

systemctl daemon-reload

CHECK $? "Reloading daemon" &>> $LOGFILE

systemctl enable user 

CHECK $? "enabling user" &>> $LOGFILE

systemctl start user

CHECK $? "starting user" &>> $LOGFILE
 
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

CHECK $? "copying mongo repo" &>> $LOGFILE

dnf install mongodb-org-shell -y

CHECK $? "Installing mongo shell" &>> $LOGFILE

mongo --host $MONGO_HOST </app/schema/user.js

CHECK $? "Loading schema to mongodb" &>> $LOGFILE

echo "script ended at $TIMESTAMP" &>> $LOGFILE

#################     INSTALLING USER COMPLETED  ######################





