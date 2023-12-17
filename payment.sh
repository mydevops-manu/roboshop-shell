#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
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

dnf install python36 gcc python3-devel -y &>> $LOGFILE

CHECK $? "Installing python 3.6"

id roboshop &>> $LOGFILE

### CHECKING USER EXISTS OR NOT & ADDING NEW USER IF NOT EXISTS
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    CHECK $? "creating roboshop user"     
else   
    echo -e "user already exists $Y SKIPPING... $N" &>> $LOGFILE     
fi

mkdir -p /app &>> $LOGFILE

CHECK $? "CREATING /app directory"     

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE

CHECK $? "downloading code application"     

cd /app &>> $LOGFILE

CHECK $? "changing to app directory"     

unzip -o /tmp/payment.zip &>> $LOGFILE

CHECK $? "unzipping payment"     

cd /app &>> $LOGFILE

CHECK $? "changing to app directory"     

pip3.6 install -r requirements.txt &>> $LOGFILE

CHECK $? "Installing dependencies"     

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>> $LOGFILE

CHECK $? "copying payment service file"     

systemctl daemon-reload &>> $LOGFILE

CHECK $? "reloading daemon"     

systemctl enable payment &>> $LOGFILE 

CHECK $? "enabling payment"     

systemctl start payment &>> $LOGFILE  

CHECK $? "starting payment"     

echo "script ended at $TIMESTAMP" &>> $LOGFILE 

#################     INSTALLING PAYMENT COMPLETED  ######################
