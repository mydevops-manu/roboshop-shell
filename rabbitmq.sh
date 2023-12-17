#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stared at $TIMESTAMP" 
echo "script stared at $TIMESTAMP"    

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

#################   INSTALLING RABBITMQ STARTED  ##############################

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

CHECK $? "Downloading RabbitMQ repo"    

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

CHECK $? "configuring RabbitMQ repo"    

dnf install rabbitmq-server -y &>> $LOGFILE

CHECK $? "Installing rabbitMQ server"    

systemctl enable rabbitmq-server &>> $LOGFILE 

CHECK $? "enabling rabbitmq"    

systemctl start rabbitmq-server &>> $LOGFILE 

CHECK $? "starting rabbitmq"    

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE

CHECK $? "adding user to RabbitMQ"    

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE

CHECK $? "setting permissions"    

echo "script ended at $TIMESTAMP" &>> $LOGFILE

#################     INSTALLING RABBITMQ COMPLETED  ######################

