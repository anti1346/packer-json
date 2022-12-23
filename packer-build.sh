#!/bin/bash

#Environment Variables(.env)
if [ -f .env ]; then
	export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

#aws_access_key
AWS_ACCESS_KEY_ID=`aws configure --profile ${AWS_PROFILE:-default} get aws_access_key_id`
AWS_SECRET_ACCESS_KEY=`aws configure --profile ${AWS_PROFILE:-default} get aws_secret_access_key`

packer validate $1
if [ `echo $?` -eq 0 ]
then
	packer build $1
else
	echo "packer validate error"
	echo -e "\nUsage: packer validate $1\n"
	exit 127
fi

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
