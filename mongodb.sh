#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stared at $TIMESTAMP" 
echo "script stared at $TIMESTAMP" &>> $LOGFILE

CHECK(){

    if [ $1 -ne 0 ]
    then
        echo -e "ERROR:: $2 installation $R failed $N" &>> $LOGFILE
        exit 1
    else
        echo -e "$2 $G Success $N"
        #echo -e "$G Successfully $N installed $2" &>> $LOGFILE
    fi
}

echo "checking root access..." &>> $LOGFILE

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR $N:: Please run script with root access" &>> $LOGFILE
    exit 1
else
    echo "Root access confirmed..." &>> $LOGFILE
    echo "Installing Mysql..." &>> $LOGFILE
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

CHECK $? "copied mongo repo"

dnf install mongodb-org -y &>> $LOGFILE

CHECK $? "install mongo-org"

systemctl enable mongod &>> $LOGFILE

CHECK $? "enable mongod"

systemctl start mongod &>> $LOGFILE

CHECK $? "start mongod"

sed -i 's/127.0.0.0/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

CHECK $? "Remote access to mongodb" 

systemctl restart mongod &>> $LOGFILE

CHECK $? "Restart mongo service"

echo "script ended at $TIMESTAMP"
