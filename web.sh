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

#################   INSTALLING WEB STARTED  ##############################

dnf install nginx -y &>> $LOGFILE

CHECK $? "Installing nginx" 

systemctl enable nginx &>> $LOGFILE

CHECK $? "enabling nginx" 

systemctl start nginx &>> $LOGFILE

CHECK $? "starting nginx" 

rm -rf /usr/share/nginx/html/* &>> $LOGFILE

CHECK $? "removing default website" 

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE

CHECK $? "downloading website" 

cd /usr/share/nginx/html &>> $LOGFILE

CHECK $? "changing to /usr/share/nginx/html directory" 

unzip /tmp/web.zip &>> $LOGFILE

CHECK $? "unzipping web application" 

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE

CHECK $? "copying application service" 

systemctl restart nginx &>> $LOGFILE

CHECK $? "restarting nginx" 

echo "script ended at $TIMESTAMP" 

#################     INSTALLING WEB COMPLETED  ######################





