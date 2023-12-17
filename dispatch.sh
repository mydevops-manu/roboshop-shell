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

dnf install golang -y &>> $LOGFILE

CHECK $? "Installing golang"  

id roboshop &>> $LOGFILE

### CHECKING USER EXISTS OR NOT & ADDING NEW USER IF NOT EXISTS
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    CHECK $? "creating roboshop user"  
else   
    echo "user already exists $Y SKIPPING... $N" &>> $LOGFILE  
fi

mkdir -p /app &>> $LOGFILE

CHECK $? "creating /app directory"  

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip &>> $LOGFILE

CHECK $? "downloading web-application"  

cd /app &>> $LOGFILE 

CHECK $? "changing directory"  

unzip /tmp/dispatch.zip &>> $LOGFILE

CHECK $? "unzipping web application"  

cd /app &>> $LOGFILE 

CHECK $? "changing directory"  

go mod init dispatch &>> $LOGFILE

CHECK $? "go mod init"  

go get &>> $LOGFILE 

CHECK $? "go get"  

go build &>> $LOGFILE

CHECK $? "go build"  

cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>> $LOGFILE

CHECK $? "copying web application"  

systemctl daemon-reload &>> $LOGFILE

CHECK $? "reloading daemon"  

systemctl enable dispatch &>> $LOGFILE 

CHECK $? "enabling dispatch"  

systemctl start dispatch &>> $LOGFILE

CHECK $? "starting dispatch"  

echo "script ended at $TIMESTAMP" &>> $LOGFILE 

#################     INSTALLING DISPATCH COMPLETED  ######################


