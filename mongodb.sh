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

echo "checking root access..."       

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

#################   INSTALLING MONGODB STARTED  ###########################

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE       
 
CHECK $? "copied mongo repo"

dnf install mongodb-org -y &>> $LOGFILE       

CHECK $? "install mongo-org"

systemctl enable mongod &>> $LOGFILE       

CHECK $? "enable mongod"

systemctl start mongod &>> $LOGFILE       

CHECK $? "start mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE       

CHECK $? "Remote access to mongodb" 

systemctl restart mongod &>> $LOGFILE       

CHECK $? "Restart mongo service"

echo "script ended at $TIMESTAMP" &>> $LOGFILE

#################     INSTALLING MONGODB COMPLETED  ######################

