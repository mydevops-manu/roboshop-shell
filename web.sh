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

#################   INSTALLING WEB STARTED  ##############################

dnf install nginx -y

CHECK $? "Installing nginx" &>> $LOGFILE

systemctl enable nginx

CHECK $? "enabling nginx" &>> $LOGFILE

systemctl start nginx

CHECK $? "starting nginx" &>> $LOGFILE

rm -rf /usr/share/nginx/html/*

CHECK $? "removing default website" &>> $LOGFILE

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

CHECK $? "downloading website" &>> $LOGFILE

cd /usr/share/nginx/html

CHECK $? "changing to /usr/share/nginx/html directory" &>> $LOGFILE

unzip /tmp/web.zip

CHECK $? "unzipping web application" &>> $LOGFILE

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf 

CHECK $? "copying application service" &>> $LOGFILE

systemctl restart nginx 

CHECK $? "restarting nginx" &>> $LOGFILE

echo "script ended at $TIMESTAMP" 

#################     INSTALLING WEB COMPLETED  ######################





