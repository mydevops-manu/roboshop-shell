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

dnf module disable mysql -y &>> $LOGFILE

CHECK $? "Disabling mysql module"      

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE

CHECK $? "copying mysql repo"      

dnf install mysql-community-server -y &>> $LOGFILE

CHECK $? "Installing mysql community server"      

systemctl enable mysqld &>> $LOGFILE

CHECK $? "enabling mysql"      

systemctl start mysqld &>> $LOGFILE

CHECK $? "starting mysql"      

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

CHECK $? "setting root passwd"      

echo "script ended at $TIMESTAMP" &>> $LOGFILE

#################     INSTALLING MYSQL COMPLETED  ######################


