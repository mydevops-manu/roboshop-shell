#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
#MYSQL_IP=0.0.0.0

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

#################   INSTALLING SHIPPING STARTED  ##############################

dnf install maven -y

CHECK $? "Installing maven" &>> $LOGFILE

id roboshop
### CHECKING USER EXISTS OR NOT & ADDING NEW USER IF NOT EXISTS

if[ $? -ne 0 ]
then
    useradd roboshop
    CHECK $? "creating user" &>> $LOGFILE
else
    echo "user already exists $Y SKIPPNG... $N" &>> $LOGFILE
fi

mkdir -p /app

CHECK $? "creating app directory" &>> $LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

CHECK $? "downloading web application logic" &>> $LOGFILE

cd /app

CHECK "changing to app directory" &>> $LOGFILE

unzip /tmp/shipping.zip

CHECK $? "unzipping the web application" &>> $LOGFILE

cd /app

CHECK $? "changing to app directory" &>> $LOGFILE

mvn clean package

CHECK $? "Installing dependencies" &>> $LOGFILE

mv target/shipping-1.0.jar shipping.jar

CHECK $? "renaming file" &>> $LOGFILE

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

CHECK $? "copying service file" &>> $LOGFILE

systemctl daemon-reload

CHECK $? "reloading the daemon" &>> $LOGFILE

systemctl enable shipping 
 
CHECK $? "enabling shipping" &>> $LOGFILE

systemctl start shipping 

CHECK $? "starting shipping" &>> $LOGFILE

dnf install mysql -y

CHECK $? "Installing MQSQL client" &>> $LOGFILE

mysql -h $MYSQL_IP -uroot -pRoboShop@1 < /app/schema/shipping.sql 

CHECK $? "loading schema" &>> $LOGFILE

systemctl restart shipping

CHECK $? "Restarting shipping" &>> $LOGFILE

echo "script ended at $TIMESTAMP" 

#################     INSTALLING SHIPPING COMPLETED  ######################







