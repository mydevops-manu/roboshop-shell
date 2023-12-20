#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-0d13e6a1db95fcf83
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for  i in "${INSTANCES[@]}"
do 
    echo "Instance is $i"
    if [ $i -eq mongodb ] || [ $i -eq mongodb ] || [ $i -eq mongodb ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --count 1 --instance-type $INSTANCE_TYPE --security-group-ids sg-0d13e6a1db95fcf83 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)

    echo "$i : $i"
done

