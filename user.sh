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

CHECK $? "DisablIng nodejs module"

dnf module enable nodejs:18 -y

CHECK $? "Enabling nodejs:18 module"

dnf install nodejs -y

CHECK $? "Installing nodejs"

id roboshop

### CHECKING USER EXISTS OR NOT & ADDING NEW USER IF NOT EXISTS
if [ $? -ne 0 ]
then
    useradd roboshop
    CHECK $? "creating roboshop user"
else   
    echo "user already exists $Y SKIPPING... $N"
done

mkdir -p /app

CHECK $? "creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

CHECK $? "Downloading web-application"

cd /app 

CHECK $? "changing to app/ directory"

unzip /tmp/user.zip

CHECK $? "unzipping user"

cd /app 

CHECK $? "changing to app/ directory"

npm install

CHECK $? "Installing dependencies"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service

CHECK $? "copying user service"

systemctl daemon-reload

CHECK $? "Reloading daemon"

systemctl enable user 

CHECK $? "enabling user"

systemctl start user

CHECK $? "starting user"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

CHECK $? "copying mongo repo"

dnf install mongodb-org-shell -y

CHECK $? "Installing mongo shell"

mongo --host $MONGO_HOST </app/schema/user.js

CHECK $? "Loading schema to mongodb"

echo "script ended at $TIMESTAMP"

#################     INSTALLING USER COMPLETED  ######################





