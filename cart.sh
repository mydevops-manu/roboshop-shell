#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"

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

#################   INSTALLING CART STARTED  ##############################

dnf module disable nodejs -y

CHECK $? "disabling nodejs"

dnf module enable nodejs:18 -y

CHECK $? "enabling nodejs:18 module"

dnf install nodejs -y

CHECK $? "installing nodejs"

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

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip

CHECK $? "Downloading web-application"

cd /app

CHECK $? "changing to /app directory"

npm install 

CHECK $? "installing dependencies"

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

CHECK $? "copying cart repo"

systemctl daemon-reload

CHECK $? "Reloading daemon"

echo "script ended at $TIMESTAMP"

#################     INSTALLING MONGODB COMPLETED  ######################










