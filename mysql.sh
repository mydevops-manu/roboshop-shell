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

#################   INSTALLING MYSQL STARTED  ##############################

dnf module disable mysql -y

CHECK $? "DisablIng mysql module" &>> $LOGFILE

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo

CHECK $? "copying mysql repo" &>> $LOGFILE

dnf install mysql-community-server -y

CHECK $? "Installing mysql community server" &>> $LOGFILE

systemctl enable mysqld

CHECK $? "enabling mysql" &>> $LOGFILE

systemctl start mysqld

CHECK $? "starting mysql" &>> $LOGFILE

mysql_secure_installation --set-root-pass RoboShop@1

CHECK $? "setting root passwd" &>> $LOGFILE

mysql -uroot -pRoboShop@1

CHECK $? "checking MYSQL login" &>> $LOGFILE

echo "script ended at $TIMESTAMP"

#################     INSTALLING MYSQL COMPLETED  ######################


