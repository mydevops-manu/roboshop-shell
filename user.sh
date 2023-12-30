#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
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

dnf module disable nodejs -y &>> $LOGFILE

CHECK $? "DisablIng nodejs module" 

dnf module enable nodejs:18 -y &>> $LOGFILE

CHECK $? "Enabling nodejs:18 module" 

dnf install nodejs -y &>> $LOGFILE

CHECK $? "Installing nodejs" 

id roboshop &>> $LOGFILE

### CHECKING USER EXISTS OR NOT & ADDING NEW USER IF NOT EXISTS
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    CHECK $? "creating roboshop user" 
else   
    echo -e "user already exists $Y SKIPPING... $N" &>> $LOGFILE
done

mkdir -p /app &>> $LOGFILE

CHECK $? "creating app directory" 

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

CHECK $? "Downloading web-application" 

cd /app &>> $LOGFILE

CHECK $? "changing to app/ directory" 

unzip -o /tmp/user.zip &>> $LOGFILE

CHECK $? "unzipping user" 

cd /app &>> $LOGFILE

CHECK $? "changing to app/ directory" 

npm install &>> $LOGFILE

CHECK $? "Installing dependencies" 

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>> $LOGFILE

CHECK $? "copying user service" 

systemctl daemon-reload &>> $LOGFILE

CHECK $? "Reloading daemon" 

systemctl enable user &>> $LOGFILE

CHECK $? "enabling user" 

systemctl start user &>> $LOGFILE

CHECK $? "starting user" 
 
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

CHECK $? "copying mongo repo" 

dnf install mongodb-org-shell -y &>> $LOGFILE

CHECK $? "Installing mongo shell" 

mongo --host $MONGO_HOST </app/schema/user.js &>> $LOGFILE

CHECK $? "Loading schema to mongodb" 

echo "script ended at $TIMESTAMP" &>> $LOGFILE

#################     INSTALLING USER COMPLETED  ######################





