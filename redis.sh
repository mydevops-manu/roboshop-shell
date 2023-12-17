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
    echo -e "$R ERROR $N:: Please run script with root access"  &>> $LOGFILE   
    exit 1
else    
    echo "Root access confirmed"  &>> $LOGFILE   
    echo "Installing..."  &>> $LOGFILE  
fi

#######################   CHECKING ROOT ACCESSS COMPLETED   ################

#################    CHECKING INSTALLATIONS SUCESSS OR FAIL   ##############
CHECK(){

    if [ $1 -ne 0 ]
    then
        echo -e "ERROR:: $2 $R failed $N"  &>> $LOGFILE   
        exit 1
    else
        echo "$2 $G success $N"  &>> $LOGFILE   
    fi
}

#################    CHECKING INSTALLATIONS  COMPLETED  ############## 

#######################   INSTALLING REDIS STARTED   #################


dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>> $LOGFILE

CHECK $? "Installing redis file repo"   

dnf module enable redis:remi-6.2 -y  &>> $LOGFILE

CHECK $? "Enable Redis 6.2 from package streams"   

dnf install redis -y  &>> $LOGFILE

CHECK $? "Installing redis"   

sed -i 's/127.0.0.1/0.0.0.0/g /etc/redis.conf'  &>> $LOGFILE

CHECK $? "Remote access to redis"   

systemctl enable redis  &>> $LOGFILE

CHECK $? "Enabling redis"   

systemctl start redis  &>> $LOGFILE

CHECK $? "Starting redis"   

echo "script ended at $TIMESTAMP"

#################     INSTALLING MONGODB COMPLETED  ######################

