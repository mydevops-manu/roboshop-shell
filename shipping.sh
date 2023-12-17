#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MYSQL_IP=mysql.mydevopss.online

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

#################   INSTALLING SHIPPING STARTED  ##############################

dnf install maven -y &>> $LOGFILE

CHECK $? "Installing maven"  

id roboshop &>> $LOGFILE
### CHECKING USER EXISTS OR NOT & ADDING NEW USER IF NOT EXISTS

if[ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    CHECK $? "creating user"  
else
    echo "user already exists $Y SKIPPNG... $N" &>> $LOGFILE 
fi

mkdir -p /app &>> $LOGFILE

CHECK $? "creating app directory"  

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE

CHECK $? "downloading web application logic"  

cd /app &>> $LOGFILE

CHECK "changing to app directory"  

unzip -o /tmp/shipping.zip &>> $LOGFILE 

CHECK $? "unzipping the web application"  

cd /app &>> $LOGFILE 

CHECK $? "changing to app directory"  

mvn clean package &>> $LOGFILE 

CHECK $? "Installing dependencies"  

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE 

CHECK $? "renaming file"  

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE 

CHECK $? "copying service file"  

systemctl daemon-reload &>> $LOGFILE 

CHECK $? "reloading the daemon"  

systemctl enable shipping &>> $LOGFILE  
 
CHECK $? "enabling shipping"  

systemctl start shipping &>> $LOGFILE  

CHECK $? "starting shipping"  

dnf install mysql -y &>> $LOGFILE 

CHECK $? "Installing MQSQL client"  

mysql -h $MYSQL_IP -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGFILE  

CHECK $? "loading schema" 

systemctl restart shipping &>> $LOGFILE  

CHECK $? "Restarting shipping" 

echo "script ended at $TIMESTAMP" 

#################     INSTALLING SHIPPING COMPLETED  ######################







