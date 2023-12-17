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

#################   INSTALLING PAYMENT STARTED  ##############################

dnf install python36 gcc python3-devel -y

CHECK $? "Installing python 3.6"

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

CHECK $? "CREATING /app directory" &>> $LOGFILE

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip

CHECK $? "downloading code application" &>> $LOGFILE

cd /app

CHECK $? "changing to app directory" &>> $LOGFILE

unzip /tmp/payment.zip

CHECK $? "unzipping payment" &>> $LOGFILE

cd /app

CHECK $? "changing to app directory" &>> $LOGFILE

pip3.6 install -r requirements.txt

CHECK $? "Installing dependencies" &>> $LOGFILE

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service

CHECK $? "copying payment service file" &>> $LOGFILE

systemctl daemon-reload

CHECK $? "reloading daemon" &>> $LOGFILE

systemctl enable payment 

CHECK $? "enabling payment" &>> $LOGFILE

systemctl start payment 

CHECK $? "starting payment" &>> $LOGFILE

echo "script ended at $TIMESTAMP" 

#################     INSTALLING PAYMENT COMPLETED  ######################
