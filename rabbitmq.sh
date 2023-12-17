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

#################   INSTALLING RABBITMQ STARTED  ##############################

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

CHECK $? "Downloading RabbitMQ repo" &>> $LOGFILE

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

CHECK $? "configuring RabbitMQ repo" &>> $LOGFILE

dnf install rabbitmq-server -y 

CHECK $? "Installing rabbitMQ server" &>> $LOGFILE

systemctl enable rabbitmq-server 

CHECK $? "enabling rabbitmq" &>> $LOGFILE

systemctl start rabbitmq-server 

CHECK $? "starting rabbitmq" &>> $LOGFILE

rabbitmqctl add_user roboshop roboshop123

CHECK $? "adding user to RabbitMQ" &>> $LOGFILE

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

CHECK $? "setting permissions" &>> $LOGFILE

echo "script ended at $TIMESTAMP"

#################     INSTALLING RABBITMQ COMPLETED  ######################

