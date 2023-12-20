#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-0d13e6a1db95fcf83
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for  i in "${INSTANCES[@]}"
do 
    if [ $i -eq mongodb ] || [ $i -eq mongodb ] || [ $i -eq mongodb ]
        $INSTANCE_TYPE="t3.small";
    else
        $INSTANCE_TYPE="t2.micro";
    fi

    aws ec2 run-instances --image-id ami-03265a0778a880afb --count 1 --instance-type $INSTANCE_TYPE --security-group-ids sg-0d13e6a1db95fcf83 
done

