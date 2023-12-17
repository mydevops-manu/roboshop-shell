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

#################   INSTALLING DISPATCH STARTED  ##############################

dnf install golang -y

CHECK $? "Installing golang" &>> $LOGFILE

id roboshop

### CHECKING USER EXISTS OR NOT & ADDING NEW USER IF NOT EXISTS
if [ $? -ne 0 ]
then
    useradd roboshop
    CHECK $? "creating roboshop user" &>> $LOGFILE
else   
    echo "user already exists $Y SKIPPING... $N" &>> $LOGFILE
fi

mkdir -p /app

CHECK $? "creating /app directory" &>> $LOGFILE

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip

CHECK $? "downloading web-application" &>> $LOGFILE

cd /app 

CHECK $? "changing directory" &>> $LOGFILE

unzip /tmp/dispatch.zip

CHECK $? "unzipping web application" &>> $LOGFILE

cd /app 

CHECK $? "changing directory" &>> $LOGFILE

go mod init dispatch

CHECK $? "go mod init" &>> $LOGFILE

go get 

CHECK $? "go get" &>> $LOGFILE

go build

CHECK $? "go build" &>> $LOGFILE

cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service

CHECK $? "copying web application" &>> $LOGFILE

systemctl daemon-reload

CHECK $? "reloading daemon" &>> $LOGFILE

systemctl enable dispatch 

CHECK $? "enabling dispatch" &>> $LOGFILE

systemctl start dispatch

CHECK $? "starting dispatch" &>> $LOGFILE

echo "script ended at $TIMESTAMP" 

#################     INSTALLING DISPATCH COMPLETED  ######################


